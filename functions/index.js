const { onRequest } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const express = require("express");
const cors = require("cors");
const axios = require("axios");
const crypto = require("crypto");
const { getOrderById, serverGetOrderById, completeOrderWithInvoiceOnly, getInvoiceById, getPaymentProof, getExpiredPendingTransferOrders, getPendingElectronicOrders, createPaymentProof, serverUpdatePaymentProof, serverUpdatePaymentProofStatus, serverUpdateOrderStatus, createSystemNotification, completeOrderWithTransferAndInvoice, completeOrderWithPrepaidAndUpdateMetric, completeOrderWithPrepaidAndCreateMetric, getPrepaidServiceMetricByServiceName, getPrepaidHistoryByOrderId } = require("@washgo/db-admin");
const { onSchedule } = require("firebase-functions/v2/scheduler");

// Initialize Firebase Admin SDK
if (admin.apps.length === 0) {
  admin.initializeApp();
}

const { getDownloadURL } = require("firebase-admin/storage");

/**
 * Gets a download URL for a file in a way that works in both emulator and production.
 */
async function getDownloadUrlSafe(file) {
  try {
    return await getDownloadURL(file);
  } catch (error) {
    console.warn("getDownloadURL failed, trying fallback:", error.message);
    const bucketName = file.bucket.name;
    const encodedPath = encodeURIComponent(file.name);
    if (process.env.FIREBASE_STORAGE_EMULATOR_HOST) {
      return `http://${process.env.FIREBASE_STORAGE_EMULATOR_HOST}/v0/b/${bucketName}/o/${encodedPath}?alt=media`;
    }
    // Last resort: try signed URL (will throw if no service account)
    const [url] = await file.getSignedUrl({
      action: "read",
      expires: Date.now() + 1000 * 60 * 60 * 24 * 365 * 5,
    });
    return url;
  }
}
// Environment variables are loaded automatically from .env in production
// and from .env.local during emulation.

const app = express();

app.use(cors({ origin: true }));
app.use(express.json({ limit: "10mb" }));

// Helper to check secrets
const checkSecrets = () => {
  const clientId = process.env.PAYPAL_CLIENT_ID;
  const clientSecret = process.env.PAYPAL_CLIENT_SECRET;
  if (!clientId || !clientSecret) {
    throw new Error("Missing PAYPAL_CLIENT_ID or PAYPAL_CLIENT_SECRET environment variable.");
  }
};

// Helper to get PayPal access token
const getPaypalAccessToken = async () => {
  checkSecrets();
  const clientId = process.env.PAYPAL_CLIENT_ID;
  const clientSecret = process.env.PAYPAL_CLIENT_SECRET;
  const auth = Buffer.from(`${clientId}:${clientSecret}`).toString("base64");
  const isProduction = process.env.PAYPAL_MODE === "live";
  const url = isProduction
    ? "https://api-m.paypal.com/v1/oauth2/token"
    : "https://api-m.sandbox.paypal.com/v1/oauth2/token";

  const response = await axios({
    url,
    method: "post",
    headers: {
      Accept: "application/json",
      "Accept-Language": "en_US",
      Authorization: `Basic ${auth}`,
      "Content-Type": "application/x-www-form-urlencoded",
    },
    data: "grant_type=client_credentials",
  });
  return response.data.access_token;
};

// Helper to get PayPal API base URL
const getPaypalBaseUrl = () => {
  return process.env.PAYPAL_MODE === "live"
    ? "https://api-m.paypal.com"
    : "https://api-m.sandbox.paypal.com";
};

// Authentication Middleware
const authenticate = async (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ error: "Missing or invalid authorization token" });
  }
  const token = authHeader.split("Bearer ")[1];
  try {
    const decodedToken = await admin.auth().verifyIdToken(token);
    req.user = { uid: decodedToken.uid, email: decodedToken.email, token: decodedToken };
    next();
  } catch (error) {
    console.error("Auth Error:", error);
    return res.status(401).json({ error: "Unauthorized" });
  }
};

// 1. Create PayPal Order
app.post("/paypal/create-order", authenticate, async (req, res) => {
  const { orderId } = req.body;
  if (!orderId) {
    return res.status(400).json({ error: "Missing orderId" });
  }

  try {
    // Fetch order details from database
    const orderResult = await serverGetOrderById({ id: orderId });
    const order = orderResult.data.order;
    if (!order) {
      return res.status(404).json({ error: "Order not found" });
    }

    // Verify order client is the logged-in user
    if (order.clientId !== req.user.uid) {
      return res.status(403).json({ error: "Forbidden: You do not own this order" });
    }

    if (order.status !== "PENDIENTE_PAGO") {
      return res.status(400).json({ error: `Order is not pending payment. Current status: ${order.status}` });
    }

    // Initialize PayPal Order
    const accessToken = await getPaypalAccessToken();
    const baseUrl = getPaypalBaseUrl();

    const paypalResponse = await axios({
      url: `${baseUrl}/v2/checkout/orders`,
      method: "post",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${accessToken}`,
      },
      data: {
        intent: "CAPTURE",
        purchase_units: [
          {
            reference_id: orderId,
            amount: {
              currency_code: "USD",
              value: order.price.toFixed(2),
            },
          },
        ],
        application_context: {
          return_url: `https://washgo-app-8392.web.app/paypal-callback/success?orderId=${orderId}`,
          cancel_url: `https://washgo-app-8392.web.app/paypal-callback/cancel?orderId=${orderId}`,
          user_action: "PAY_NOW",
          shipping_preference: "NO_SHIPPING",
        },
      },
    });

    const approveLink = paypalResponse.data.links.find((l) => l.rel === "approve");
    return res.json({
      paypalOrderId: paypalResponse.data.id,
      approveUrl: approveLink ? approveLink.href : null,
    });
  } catch (error) {
    console.error("Create PayPal Order Error:", error.response?.data || error.message);
    return res.status(500).json({ error: error.response?.data || error.message });
  }
});

// 1b. Prepare PayPhone Payment
app.post("/payphone/prepare", authenticate, async (req, res) => {
  const { orderId } = req.body;
  if (!orderId) {
    return res.status(400).json({ error: "Missing orderId" });
  }

  try {
    // Fetch order details from database
    const orderResult = await serverGetOrderById({ id: orderId });
    const order = orderResult.data.order;
    if (!order) {
      return res.status(404).json({ error: "Order not found" });
    }

    // Verify order client is the logged-in user
    if (order.clientId !== req.user.uid) {
      return res.status(403).json({ error: "Forbidden: You do not own this order" });
    }

    if (order.status !== "PENDIENTE_PAGO") {
      return res.status(400).json({ error: `Order is not pending payment. Current status: ${order.status}` });
    }

    const token = process.env.PAYPHONE_TOKEN;
    const storeId = process.env.PAYPHONE_STORE_ID;

    // Check if we should use mock simulation
    if (!token || !storeId || token === "mock") {
      console.log("[PayPhone] Using simulated prepare flow for order:", orderId);
      const origin = req.get("origin") || "https://washgo-app-8392.web.app";
      const baseUrl = origin.endsWith("/") ? origin.slice(0, -1) : origin;
      
      // If running locally, use hash routing format to avoid local dev server 404s
      const redirectPath = baseUrl.includes("localhost") || baseUrl.includes("127.0.0.1")
        ? "/#/payphone-callback/success"
        : "/payphone-callback/success";

      return res.json({
        payWithCardUrl: `${baseUrl}${redirectPath}?id=mock-payphone-tx-${Date.now()}&clientTransactionId=${orderId}`,
        transactionId: `mock-payphone-tx-${Date.now()}`,
        isSimulated: true
      });
    }

    // Cálculo de montos en centavos (IVA 15% Ecuador)
    // INVARIANTE: amount === amountWithTax + tax
    const totalCents = Math.round(order.price * 100);
    const subtotalCents = Math.round((order.price / 1.15) * 100);
    const taxCents = totalCents - subtotalCents;

    const response = await axios({
      url: "https://pay.payphonetodoesposible.com/api/Links",
      method: "post",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      data: {
        amount: totalCents,
        amountWithTax: subtotalCents,
        tax: taxCents,
        tip: 0,
        clientTransactionId: orderId,
        storeId: storeId,
        reference: `Orden WashGo #${orderId.substring(0, 8)}`,
        currency: "USD",
      },
    });

    // La Links API devuelve una string directa con la URL, no un objeto JSON
    const paymentUrl = typeof response.data === "string"
      ? response.data.trim()
      : response.data?.url || response.data?.link || response.data?.payWithCardUrl;

    if (!paymentUrl) {
      throw new Error(`PayPhone Links API no devolvió URL. Response: ${JSON.stringify(response.data)}`);
    }

    console.log(`[PayPhone Links] URL generada para orden ${orderId}: ${paymentUrl}`);

    return res.json({
      payWithCardUrl: paymentUrl,   // mismo nombre de campo → Flutter no cambia
      isSimulated: false,
    });
  } catch (error) {
    console.error("Prepare PayPhone Payment Error:", error.response?.data || error.message);
    return res.status(500).json({ error: error.response?.data || error.message });
  }
});

// 1c. Cancel Pending Order (Client-Driven Cancellation)
app.delete("/orders/:orderId/cancel-pending", authenticate, async (req, res) => {
  const { orderId } = req.params;
  try {
    const orderResult = await serverGetOrderById({ id: orderId });
    const order = orderResult.data.order;
    if (!order) return res.status(404).json({ error: "Order not found" });
    if (order.clientId !== req.user.uid) {
      return res.status(403).json({ error: "Forbidden: You do not own this order" });
    }
    if (order.status !== "PENDIENTE_PAGO") {
      return res.status(400).json({ error: "Order is not in PENDIENTE_PAGO status" });
    }

    // Cancel the order (update to CANCELADO status)
    await serverUpdateOrderStatus({ orderId, status: "CANCELADO" });
    return res.json({ success: true });
  } catch (error) {
    console.error("Cancel Pending Order Error:", error.message);
    return res.status(500).json({ error: error.message });
  }
});


// Helper: Generate a unique invoice number FAC-YYYYMMDD-[ENTROPY]
const generateNumeroUnico = () => {
  const dateStr = new Date().toISOString().slice(0, 10).replace(/-/g, "");
  const entropy = crypto.randomBytes(3).toString("hex").toUpperCase();
  return `FAC-${dateStr}-${entropy}`;
};

// Helper: Complete order and consume prepaid balance
async function completeOrderWithPrepaid({ req, order, invoiceParams, paymentMethod, observations }) {
  const orderId = order.id;
  const businessId = order.business.id;
  const serviceName = order.serviceName || "Servicio Desconocido";
  const costo = order.price;

  // 1. Check idempotency: check if prepaid history already exists for this order
  const historyResponse = await getPrepaidHistoryByOrderId({ orderId });
  if (historyResponse.data && historyResponse.data.prepaidHistories && historyResponse.data.prepaidHistories.length > 0) {
    console.log(`[PrepaidConsumption] Prepaid balance already consumed for order ${orderId}. Completing with invoice only.`);
    return await completeOrderWithInvoiceOnly({
      orderId,
      observations,
      invoiceUrl: invoiceParams.signedUrl,
      invoiceId: invoiceParams.invoiceId,
      numeroUnico: invoiceParams.numeroUnico,
      subtotal: invoiceParams.subtotal,
      discount: 0,
      tax: invoiceParams.tax,
      total: parseFloat(costo.toFixed(2)),
      paymentMethod,
      invoiceStatus: "GENERATED",
    }, { auth: req.user });
  }

  // 2. Calculate balance details
  const saldoPrepagoInicial = order.business.saldoPrepagoInicial;
  const saldoPrepagoConsumido = order.business.saldoPrepagoConsumido;
  const newSaldoConsumido = saldoPrepagoConsumido + costo;
  const saldoResultante = saldoPrepagoInicial - newSaldoConsumido;

  const historyId = crypto.randomUUID();

  // 3. Query existing metrics
  const metricResponse = await getPrepaidServiceMetricByServiceName({
    businessId,
    serviceName,
  });

  if (metricResponse.data && metricResponse.data.prepaidServiceMetrics && metricResponse.data.prepaidServiceMetrics.length > 0) {
    const existingMetric = metricResponse.data.prepaidServiceMetrics[0];
    const newCantidad = existingMetric.cantidad + 1;
    const newTotalConsumido = existingMetric.totalConsumido + costo;

    console.log(`[PrepaidConsumption] Executing CompleteOrderWithPrepaidAndUpdateMetric for order: ${orderId}`);
    return await completeOrderWithPrepaidAndUpdateMetric({
      orderId,
      orderIdStr: orderId,
      observations,
      invoiceUrl: invoiceParams.signedUrl,
      invoiceId: invoiceParams.invoiceId,
      numeroUnico: invoiceParams.numeroUnico,
      subtotal: invoiceParams.subtotal,
      discount: 0,
      tax: invoiceParams.tax,
      total: parseFloat(costo.toFixed(2)),
      paymentMethod,
      invoiceStatus: "GENERATED",
      businessId,
      saldoPrepagoInicial,
      saldoPrepagoConsumido: newSaldoConsumido,
      historyId,
      serviceName,
      costoConsumido: costo,
      saldoResultante,
      metricId: existingMetric.id,
      metricCantidad: newCantidad,
      metricTotalConsumido: newTotalConsumido,
    }, { auth: req.user });
  } else {
    const newMetricId = crypto.randomUUID();

    console.log(`[PrepaidConsumption] Executing CompleteOrderWithPrepaidAndCreateMetric for order: ${orderId}`);
    return await completeOrderWithPrepaidAndCreateMetric({
      orderId,
      orderIdStr: orderId,
      observations,
      invoiceUrl: invoiceParams.signedUrl,
      invoiceId: invoiceParams.invoiceId,
      numeroUnico: invoiceParams.numeroUnico,
      subtotal: invoiceParams.subtotal,
      discount: 0,
      tax: invoiceParams.tax,
      total: parseFloat(costo.toFixed(2)),
      paymentMethod,
      invoiceStatus: "GENERATED",
      businessId,
      saldoPrepagoInicial,
      saldoPrepagoConsumido: newSaldoConsumido,
      historyId,
      serviceName,
      costoConsumido: costo,
      saldoResultante,
      metricId: newMetricId,
      metricCostoUnitario: costo,
    }, { auth: req.user });
  }
}

// 2. Complete PayPal Payment
app.post("/orders/complete-paypal-payment", authenticate, async (req, res) => {
  const { orderId, paypalOrderId, base64Pdf } = req.body;
  if (!orderId || !paypalOrderId || !base64Pdf) {
    return res.status(400).json({ error: "Missing orderId, paypalOrderId, or base64Pdf" });
  }

  try {
    // Fetch order details from database
    const orderResult = await serverGetOrderById({ id: orderId });
    const order = orderResult.data.order;
    if (!order) {
      return res.status(404).json({ error: "Order not found" });
    }

    if (order.clientId !== req.user.uid) {
      return res.status(403).json({ error: "Forbidden: You do not own this order" });
    }

    if (order.status !== "PENDIENTE_PAGO") {
      return res.status(400).json({ error: `Order is not pending payment. Current status: ${order.status}` });
    }

    // Capture PayPal Payment
    const accessToken = await getPaypalAccessToken();
    const baseUrl = getPaypalBaseUrl();

    const captureResponse = await axios({
      url: `${baseUrl}/v2/checkout/orders/${paypalOrderId}/capture`,
      method: "post",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${accessToken}`,
      },
    });

    if (captureResponse.data.status !== "COMPLETED") {
      return res.status(400).json({ error: `PayPal capture not completed. Status: ${captureResponse.data.status}` });
    }

    // Generate invoice database details
    const invoiceId = crypto.randomUUID();
    const numeroUnico = generateNumeroUnico();

    // Secure calculation on backend (15% VAT)
    const subtotal = parseFloat((order.price / 1.15).toFixed(2));
    const tax = parseFloat((order.price - subtotal).toFixed(2));

    // Upload PDF to Storage
    const bucket = admin.storage().bucket();
    const file = bucket.file(`invoices/${invoiceId}.pdf`);
    const buffer = Buffer.from(base64Pdf, "base64");
    await file.save(buffer, {
      metadata: {
        contentType: "application/pdf",
      },
    });

    // Generate Signed URL / Download URL (resilient to emulator environment)
    const signedUrl = await getDownloadUrlSafe(file);

    // Complete order and deduct business prepaid balance
    await completeOrderWithPrepaid({
      req,
      order,
      invoiceParams: {
        signedUrl,
        invoiceId,
        numeroUnico,
        subtotal,
        tax,
      },
      paymentMethod: "PAYPAL",
      observations: "Pago completado a través de PayPal",
    });

    return res.json({
      success: true,
      invoiceId,
      numeroUnico,
      invoiceUrl: signedUrl,
      orderStatus: "COMPLETADO",
    });
  } catch (error) {
    console.error("Complete PayPal Payment Error:", error.response?.data || error.message);
    return res.status(500).json({ error: error.response?.data || error.message });
  }
});

// 2b. Complete PayPhone Payment
app.post("/orders/complete-payphone-payment", authenticate, async (req, res) => {
  const { orderId, transactionId, base64Pdf } = req.body;
  if (!orderId || !transactionId || !base64Pdf) {
    return res.status(400).json({ error: "Missing orderId, transactionId, or base64Pdf" });
  }

  try {
    // Fetch order details from database
    const orderResult = await serverGetOrderById({ id: orderId });
    const order = orderResult.data.order;
    if (!order) {
      return res.status(404).json({ error: "Order not found" });
    }

    if (order.clientId !== req.user.uid) {
      return res.status(403).json({ error: "Forbidden: You do not own this order" });
    }

    if (order.status !== "PENDIENTE_PAGO") {
      return res.status(400).json({ error: `Order is not pending payment. Current status: ${order.status}` });
    }

    const token = process.env.PAYPHONE_TOKEN;

    // Check if simulated
    if (!token || token === "mock" || (typeof transactionId === "string" && transactionId.startsWith("mock-"))) {
      console.log("[PayPhone] Completing simulated transaction:", transactionId);
    } else {
      // Real API Confirmation
      const response = await axios({
        url: "https://pay.payphonetodoesposible.com/api/button/V2/Confirm",
        method: "post",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        data: {
          id: parseInt(transactionId) || transactionId,
          clientTxId: orderId,
        },
      });

      const data = response.data;
      if (data.transactionStatus !== "Approved") {
        return res.status(400).json({
          error: `PayPhone transaction not approved. Status: ${data.transactionStatus || JSON.stringify(data)}`,
        });
      }
    }

    // Generate invoice database details
    const invoiceId = crypto.randomUUID();
    const numeroUnico = generateNumeroUnico();

    // Secure calculation on backend (15% VAT Ecuador)
    const subtotal = parseFloat((order.price / 1.15).toFixed(2));
    const tax = parseFloat((order.price - subtotal).toFixed(2));

    // Upload PDF to Storage
    const bucket = admin.storage().bucket();
    const file = bucket.file(`invoices/${invoiceId}.pdf`);
    const buffer = Buffer.from(base64Pdf, "base64");
    await file.save(buffer, {
      metadata: {
        contentType: "application/pdf",
      },
    });

    // Generate Signed URL / Download URL (resilient to emulator environment)
    const signedUrl = await getDownloadUrlSafe(file);

    // Complete order and deduct business prepaid balance
    await completeOrderWithPrepaid({
      req,
      order,
      invoiceParams: {
        signedUrl,
        invoiceId,
        numeroUnico,
        subtotal,
        tax,
      },
      paymentMethod: "PAYPHONE",
      observations: "Pago completado a través de PayPhone",
    });

    return res.json({
      success: true,
      invoiceId,
      numeroUnico,
      invoiceUrl: signedUrl,
      orderStatus: "COMPLETADO",
    });
  } catch (error) {
    console.error("Complete PayPhone Payment Error:", error.response?.data || error.message);
    return res.status(500).json({ error: error.response?.data || error.message });
  }
});

// 3. Complete Cash Payment
app.post("/orders/complete-cash-payment", authenticate, async (req, res) => {
  const { orderId, base64Pdf } = req.body;
  if (!orderId || !base64Pdf) {
    return res.status(400).json({ error: "Missing orderId or base64Pdf" });
  }

  try {
    // Fetch order details from database using server/admin context
    const orderResult = await serverGetOrderById({ id: orderId });
    const order = orderResult.data.order;
    if (!order) {
      return res.status(404).json({ error: "Order not found or unauthorized to access" });
    }

    // Verify that the caller is either the employee assigned to the order or the business owner
    const isEmployee = order.employeeId === req.user.uid;
    const isOwner = order.business?.owner?.id === req.user.uid;
    const isSuperAdmin = req.user.token?.roles?.includes("SUPER_ADMIN");

    if (!isEmployee && !isOwner && !isSuperAdmin) {
      return res.status(403).json({ error: "Forbidden: You are not authorized to complete this order" });
    }

    if (order.status !== "PENDIENTE_PAGO") {
      return res.status(400).json({ error: `Order is not pending payment. Current status: ${order.status}` });
    }

    // Generate invoice database details
    const invoiceId = crypto.randomUUID();
    const numeroUnico = generateNumeroUnico();

    // Secure calculation on backend (15% VAT)
    const subtotal = parseFloat((order.price / 1.15).toFixed(2));
    const tax = parseFloat((order.price - subtotal).toFixed(2));

    // Upload PDF to Storage
    const bucket = admin.storage().bucket();
    const file = bucket.file(`invoices/${invoiceId}.pdf`);
    const buffer = Buffer.from(base64Pdf, "base64");
    await file.save(buffer, {
      metadata: {
        contentType: "application/pdf",
      },
    });

    // Generate Signed URL / Download URL (resilient to emulator environment)
    const signedUrl = await getDownloadUrlSafe(file);

    // Complete order with mutation using admin SDK
    await completeOrderWithInvoiceOnly({
      orderId,
      observations: "Pago en efectivo completado",
      invoiceUrl: signedUrl,
      invoiceId,
      numeroUnico,
      subtotal,
      discount: 0,
      tax,
      total: parseFloat(order.price.toFixed(2)),
      paymentMethod: "CASH",
      invoiceStatus: "GENERATED",
    }, { auth: req.user });

    return res.json({
      success: true,
      invoiceId,
      numeroUnico,
      invoiceUrl: signedUrl,
      orderStatus: "COMPLETADO",
    });
  } catch (error) {
    console.error("Complete Cash Payment Error:", error.message);
    return res.status(500).json({ error: error.message });
  }
});

// 4. Get Invoice Signed URL
app.get("/invoices/:invoiceId/url", authenticate, async (req, res) => {
  const { invoiceId } = req.params;
  if (!invoiceId) {
    return res.status(400).json({ error: "Missing invoiceId" });
  }

  try {
    // Verify that the user has permission to see the invoice
    const invoiceResult = await getInvoiceById({ id: invoiceId }, { auth: req.user });
    const invoice = invoiceResult.data.invoice;
    if (!invoice) {
      return res.status(404).json({ error: "Invoice not found or unauthorized" });
    }

    // Generate Signed URL
    const bucket = admin.storage().bucket();
    const file = bucket.file(`invoices/${invoiceId}.pdf`);

    const exists = await file.exists();
    if (!exists[0]) {
      return res.status(404).json({ error: "Invoice PDF file not found in storage" });
    }

    const signedUrl = await getDownloadUrlSafe(file);

    return res.json({
      url: signedUrl,
    });
  } catch (error) {
    console.error("Get Invoice URL Error:", error.message);
    return res.status(500).json({ error: error.message });
  }
});

// ─────────────────────────────────────────────
// Bank Transfer Endpoints
// ─────────────────────────────────────────────

// 5. Upload transfer payment proof
app.post("/payments/upload-proof", authenticate, async (req, res) => {
  const { orderId, imageBase64, imageExt, declaredAmount, paymentAccountType, referenceNumber, observations } = req.body;
  if (!orderId || !imageBase64 || !imageExt || !declaredAmount || !paymentAccountType) {
    return res.status(400).json({ error: "Missing required fields: orderId, imageBase64, imageExt, declaredAmount, paymentAccountType" });
  }

  try {
    // Fetch order
    const orderResult = await serverGetOrderById({ id: orderId });
    const order = orderResult.data.order;
    if (!order) {
      return res.status(404).json({ error: "Order not found" });
    }

    // Verify the client owns this order
    if (order.clientId !== req.user.uid) {
      return res.status(403).json({ error: "Forbidden: You do not own this order" });
    }

    // Verify order is pending payment and uses bank transfer
    if (order.status !== "PENDIENTE_PAGO") {
      return res.status(400).json({ error: `Order is not pending payment. Current status: ${order.status}` });
    }
    if (order.paymentMethod !== "TRANSFERENCIA_BANCARIA") {
      return res.status(400).json({ error: "Order does not use bank transfer payment method" });
    }

    // Check if a proof was already submitted
    let existingProofId = null;
    const existingProof = await getPaymentProof({ orderId });
    if (existingProof.data.paymentProofs && existingProof.data.paymentProofs.length > 0) {
      const currentStatus = existingProof.data.paymentProofs[0].status;
      if (currentStatus === "PENDING") {
        return res.status(409).json({ error: "A payment proof is already pending review. Please wait for the business to review it." });
      }
      if (currentStatus === "APPROVED") {
        return res.status(409).json({ error: "Payment proof was already approved for this order." });
      }
      // If REJECTED, allow re-upload — store the existing proof ID so we update it later
      existingProofId = existingProof.data.paymentProofs[0].id;
    }

    // Validate image extension
    const validExts = ["jpg", "jpeg", "png", "webp", "heic", "heif"];
    const ext = imageExt.toLowerCase().replace(/^\./, "");
    if (!validExts.includes(ext)) {
      return res.status(400).json({ error: `Invalid image extension. Allowed: ${validExts.join(", ")}` });
    }

    // Upload image to Storage
    const bucket = admin.storage().bucket();
    const fileName = `transfers/${orderId}.${ext}`;
    const file = bucket.file(fileName);
    const buffer = Buffer.from(imageBase64, "base64");
    await file.save(buffer, {
      metadata: { contentType: `image/${ext === "jpg" ? "jpeg" : ext}` },
    });

    // Generate signed URL / Download URL (resilient to emulator environment)
    const imageUrl = await getDownloadUrlSafe(file);

    const commonData = {
      imageUrl,
      declaredAmount: parseFloat(declaredAmount),
      paymentAccountType,
      referenceNumber: referenceNumber || null,
      observations: observations || null,
    };

    if (existingProofId) {
      // Re-upload after rejection: update the existing record
      await serverUpdatePaymentProof({
        id: existingProofId,
        ...commonData,
      });
    } else {
      // First-time upload: create a new record
      await createPaymentProof({
        orderId,
        ...commonData,
      });
    }

    return res.json({
      success: true,
      message: "Payment proof uploaded successfully. Waiting for business review.",
    });
  } catch (error) {
    console.error("Upload Proof Error:", error.message);
    return res.status(500).json({ error: error.message });
  }
});

// 6. Review (approve/reject) payment proof
app.post("/payments/review-proof", authenticate, async (req, res) => {
  const { orderId, status, observations } = req.body;
  if (!orderId || !status) {
    return res.status(400).json({ error: "Missing required fields: orderId, status" });
  }
  if (status !== "APPROVED" && status !== "REJECTED") {
    return res.status(400).json({ error: "Status must be APPROVED or REJECTED" });
  }

  try {
    // Fetch order with server/admin context
    const orderResult = await serverGetOrderById({ id: orderId });
    const order = orderResult.data.order;
    if (!order) {
      return res.status(404).json({ error: "Order not found or unauthorized" });
    }

    // Verify caller is SUPER_ADMIN
    const isSuperAdmin = req.user.token?.roles?.includes("SUPER_ADMIN");
    if (!isSuperAdmin) {
      return res.status(403).json({ error: "Forbidden: Only a super admin can review payment proofs" });
    }

    if (order.paymentMethod !== "TRANSFERENCIA_BANCARIA") {
      return res.status(400).json({ error: "Order does not use bank transfer payment method" });
    }

    if (order.status !== "PENDIENTE_PAGO") {
      return res.status(400).json({ error: `Order is not pending payment. Current status: ${order.status}` });
    }

    // Fetch payment proof to get its id
    const proofResult = await getPaymentProof({ orderId });
    const proof = proofResult.data?.paymentProofs?.[0];
    if (!proof) {
      return res.status(404).json({ error: "Payment proof not found for this order" });
    }

    // Update payment proof status (using the proof's own id)
    await serverUpdatePaymentProofStatus({
      id: proof.id,
      status,
      reviewedBy: req.user.uid,
      observations: observations || null,
    });

    if (status === "APPROVED") {
      // Update order to EN_COLA
      await serverUpdateOrderStatus({ orderId, status: "EN_COLA" });

      // Notify client
      await createSystemNotification({
        userId: order.clientId,
        titulo: "Pago por transferencia aprobado",
        mensaje: `Tu pago por transferencia para "${order.serviceName || "el servicio"}" ha sido aprobado. Tu orden está ahora en cola.`,
      });

      return res.json({
        success: true,
        message: "Payment proof approved. Order moved to queue.",
        orderStatus: "EN_COLA",
      });
    } else {
      // REJECTED — keep order at PENDIENTE_PAGO so client can re-upload
      // Notify client
      await createSystemNotification({
        userId: order.clientId,
        titulo: "Pago por transferencia rechazado",
        mensaje: `Tu pago por transferencia para "${order.serviceName || "el servicio"}" ha sido rechazado. Motivo: ${observations || "No especificado"}. Puedes subir un nuevo comprobante.`,
      });

      return res.json({
        success: true,
        message: "Payment proof rejected. Client can re-upload.",
        orderStatus: "PENDIENTE_PAGO",
      });
    }
  } catch (error) {
    console.error("Review Proof Error:", error);
    return res.status(500).json({ error: error.message, stack: error.stack });
  }
});

// 7. Get proof image signed URL (no auth — for status page)
app.get("/payments/proof-image/:orderId", async (req, res) => {
  const { orderId } = req.params;
  if (!orderId) {
    return res.status(400).json({ error: "Missing orderId" });
  }

  try {
    const proofResult = await getPaymentProof({ orderId });
    const proofs = proofResult.data.paymentProofs;
    if (!proofs || proofs.length === 0) {
      return res.status(404).json({ error: "No payment proof found for this order" });
    }

    // Extract the stored imageUrl (it's a signed URL, but it may have expired)
    // Regenerate a fresh signed URL from the stored bucket path
    const proof = proofs[0];
    const bucket = admin.storage().bucket();

    // Try to find the image by listing files in the transfers/ folder matching the orderId
    const [files] = await bucket.getFiles({ prefix: `transfers/${orderId}.` });
    if (!files || files.length === 0) {
      // Fallback: return the stored imageUrl — it may still be valid
      if (proof.imageUrl) {
        return res.json({ imageUrl: proof.imageUrl });
      }
      return res.status(404).json({ error: "Proof image file not found in storage" });
    }

    const signedUrl = await getDownloadUrlSafe(files[0]);

    return res.json({ imageUrl: signedUrl });
  } catch (error) {
    console.error("Get Proof Image Error:", error.message);
    return res.status(500).json({ error: error.message });
  }
});

// 8. Get payment proof status (no auth — for guest booking flow)
app.get("/payments/proof-status/:orderId", async (req, res) => {
  const { orderId } = req.params;
  if (!orderId) {
    return res.status(400).json({ error: "Missing orderId" });
  }

  try {
    const orderResult = await serverGetOrderById({ id: orderId });
    const order = orderResult.data.order;
    if (!order) {
      return res.status(404).json({ error: "Order not found" });
    }

    let proofStatus = null;
    try {
      const proofResult = await getPaymentProof({ orderId });
      const proofs = proofResult.data.paymentProofs;
      if (proofs && proofs.length > 0) {
        proofStatus = {
          id: proofs[0].id,
          status: proofs[0].status,
          declaredAmount: proofs[0].declaredAmount,
          paymentAccountType: proofs[0].paymentAccountType,
          referenceNumber: proofs[0].referenceNumber,
          observations: proofs[0].observations,
          createdAt: proofs[0].createdAt,
          reviewedAt: proofs[0].reviewedAt,
          reviewedBy: proofs[0].reviewedBy,
        };
      }
    } catch (_) {
      // Payment proof may not exist yet — that's OK
    }

    return res.json({
      orderId: order.id,
      status: order.status,
      paymentMethod: order.paymentMethod,
      serviceName: order.serviceName,
      price: order.price,
      client: {
        nombreCompleto: order.client?.nombreCompleto,
        telefono: order.client?.telefono,
      },
      proof: proofStatus,
    });
  } catch (error) {
    console.error("Get Proof Status Error:", error.message);
    return res.status(500).json({ error: error.message });
  }
});

// Export Express app as a Cloud Function v2
exports.api = onRequest({}, app);

// Scheduled cleanup: every 6 hours, cancel pending bank transfer orders older than 24h
exports.cleanupPendingTransfers = onSchedule({
  schedule: "0 */6 * * *",
  timeZone: "America/Guayaquil",
  retryCount: 2,
  maxRetrySeconds: 120,
}, async () => {
  console.log("[Cleanup] Starting pending transfer cleanup...");
  try {
    const result = await getExpiredPendingTransferOrders();
    const orders = result.data.orders || [];
    console.log(`[Cleanup] Found ${orders.length} pending transfer orders`);

    const now = Date.now();
    const TWENTY_FOUR_HOURS_MS = 24 * 60 * 60 * 1000;
    let cancelledCount = 0;

    for (const order of orders) {
      const createdAt = new Date(order.createdAt).getTime();
      if (now - createdAt < TWENTY_FOUR_HOURS_MS) {
        continue; // Skip orders younger than 24h
      }

      try {
        // Cancel the order
        await serverUpdateOrderStatus({ orderId: order.id, status: "CANCELADO" });

        // Notify the client
        await createSystemNotification({
          userId: order.clientId,
          titulo: "Pago por transferencia cancelado",
          mensaje: `Tu orden de "${order.serviceName}" con pago por transferencia ha sido cancelada automáticamente por exceder las 24 horas de espera. Si deseas continuar, puedes realizar una nueva orden.`,
        });

        cancelledCount++;
        console.log(`[Cleanup] Cancelled order ${order.id}`);
      } catch (err) {
        console.error(`[Cleanup] Failed to cancel order ${order.id}:`, err.message);
      }
    }

    console.log(`[Cleanup] Cleanup complete. Cancelled ${cancelledCount} of ${orders.length} eligible orders.`);
  } catch (error) {
    console.error("[Cleanup] Error:", error.message);
  }
});

// Scheduled cleanup: every 15 minutes, cancel pending electronic (PayPhone/PayPal) orders older than 30 minutes
exports.cleanupStalePendingPayments = onSchedule({
  schedule: "*/15 * * * *",
  timeZone: "America/Guayaquil",
  retryCount: 2,
  maxRetrySeconds: 120,
}, async () => {
  console.log("[Cleanup] Starting pending electronic payment cleanup...");
  try {
    const result = await getPendingElectronicOrders();
    const orders = result.data.orders || [];
    console.log(`[Cleanup] Found ${orders.length} pending electronic orders in total`);

    const now = Date.now();
    const THIRTY_MINUTES_MS = 30 * 60 * 1000;
    let cancelledCount = 0;

    for (const order of orders) {
      // Only process electronic methods (PAYPHONE, PAYPAL)
      if (order.paymentMethod !== "PAYPHONE" && order.paymentMethod !== "PAYPAL") {
        continue;
      }

      const createdAt = new Date(order.createdAt).getTime();
      if (now - createdAt < THIRTY_MINUTES_MS) {
        continue; // Skip orders younger than 30 minutes
      }

      try {
        // Cancel the order
        await serverUpdateOrderStatus({ orderId: order.id, status: "CANCELADO" });

        // Notify the client
        await createSystemNotification({
          userId: order.clientId,
          titulo: "Pago pendiente cancelado",
          mensaje: `Tu orden de "${order.serviceName}" con pago electrónico ha sido cancelada automáticamente por inactividad. Si deseas continuar, puedes realizar una nueva orden.`,
        });

        cancelledCount++;
        console.log(`[Cleanup] Cancelled stale electronic order ${order.id}`);
      } catch (err) {
        console.error(`[Cleanup] Failed to cancel electronic order ${order.id}:`, err.message);
      }
    }

    console.log(`[Cleanup] Cleanup complete. Cancelled ${cancelledCount} electronic orders.`);
  } catch (error) {
    console.error("[Cleanup] Error in cleanupStalePendingPayments:", error.message);
  }
});

