const { onRequest } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const admin = require("firebase-admin");
const express = require("express");
const cors = require("cors");
const axios = require("axios");
const crypto = require("crypto");
const { getOrderById, completeOrderWithInvoiceOnly, getInvoiceById } = require("@washgo/db-admin");

// Initialize Firebase Admin SDK
if (admin.apps.length === 0) {
  admin.initializeApp();
}

// Define secrets
const paypalClientIdSecret = defineSecret("PAYPAL_CLIENT_ID");
const paypalClientSecretSecret = defineSecret("PAYPAL_CLIENT_SECRET");

const app = express();

// Use CORS middleware
app.use(cors({ origin: true }));
app.use(express.json({ limit: "10mb" })); // Allow larger payloads for base64 PDF

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
    const orderResult = await getOrderById({ id: orderId });
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

// Helper: Generate a unique invoice number FAC-YYYYMMDD-[ENTROPY]
const generateNumeroUnico = () => {
  const dateStr = new Date().toISOString().slice(0, 10).replace(/-/g, "");
  const entropy = crypto.randomBytes(3).toString("hex").toUpperCase();
  return `FAC-${dateStr}-${entropy}`;
};

// 2. Complete PayPal Payment
app.post("/orders/complete-paypal-payment", authenticate, async (req, res) => {
  const { orderId, paypalOrderId, base64Pdf } = req.body;
  if (!orderId || !paypalOrderId || !base64Pdf) {
    return res.status(400).json({ error: "Missing orderId, paypalOrderId, or base64Pdf" });
  }

  try {
    // Fetch order details from database
    const orderResult = await getOrderById({ id: orderId });
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

    // Generate Signed URL (expires in 5 years)
    const [signedUrl] = await file.getSignedUrl({
      action: "read",
      expires: Date.now() + 1000 * 60 * 60 * 24 * 365 * 5,
    });

    // Complete order with mutation using admin SDK
    await completeOrderWithInvoiceOnly({
      orderId,
      observations: "Pago completado a través de PayPal",
      invoiceUrl: signedUrl,
      invoiceId,
      numeroUnico,
      subtotal,
      discount: 0,
      tax,
      total: parseFloat(order.price.toFixed(2)),
      paymentMethod: "PAYPAL",
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
    console.error("Complete PayPal Payment Error:", error.response?.data || error.message);
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
    // Fetch order details from database using user auth context to verify permissions
    const orderResult = await getOrderById({ id: orderId }, { auth: req.user });
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

    // Generate Signed URL (expires in 5 years)
    const [signedUrl] = await file.getSignedUrl({
      action: "read",
      expires: Date.now() + 1000 * 60 * 60 * 24 * 365 * 5,
    });

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

    const [signedUrl] = await file.getSignedUrl({
      action: "read",
      expires: Date.now() + 1000 * 60 * 60 * 2, // 2 hours
    });

    return res.json({
      url: signedUrl,
    });
  } catch (error) {
    console.error("Get Invoice URL Error:", error.message);
    return res.status(500).json({ error: error.message });
  }
});

// Export Express app as a Cloud Function v2
exports.api = onRequest({
  secrets: [paypalClientIdSecret, paypalClientSecretSecret],
}, app);
