const { onRequest } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const express = require("express");
const cors = require("cors");
const axios = require("axios");
const crypto = require("crypto");
const { getOrderById, serverGetOrderById, completeOrderWithInvoiceOnly, getInvoiceById, getInvoiceByIdAdmin, getInvoiceByOrderId, getPaymentProof, getExpiredPendingTransferOrders, getPendingElectronicOrders, createPaymentProof, serverUpdatePaymentProof, serverUpdatePaymentProofStatus, serverUpdateOrderStatus, createSystemNotification, completeOrderWithTransferAndInvoice, completeOrderWithPrepaidAndUpdateMetric, completeOrderWithPrepaidAndCreateMetric, getPrepaidServiceMetricByServiceName, getPrepaidHistoryByOrderId, updateInvoicePdf, updateOrderCompletion } = require("@washgo/db-admin");
const { FieldValue } = require("firebase-admin/firestore");
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
          return_url: `https://washgov1.web.app/paypal-callback/success?orderId=${orderId}`,
          cancel_url: `https://washgov1.web.app/paypal-callback/cancel?orderId=${orderId}`,
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

// 1a-1. Get PayPal Order Status
app.get("/paypal/order-status/:paypalOrderId", authenticate, async (req, res) => {
  const { paypalOrderId } = req.params;
  if (!paypalOrderId) {
    return res.status(400).json({ error: "Missing paypalOrderId" });
  }
  try {
    const accessToken = await getPaypalAccessToken();
    const baseUrl = getPaypalBaseUrl();
    const response = await axios({
      url: `${baseUrl}/v2/checkout/orders/${paypalOrderId}`,
      method: "get",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${accessToken}`,
      },
    });
    return res.json({ status: response.data.status });
  } catch (error) {
    console.error("Get PayPal Order Status Error:", error.response?.data || error.message);
    return res.status(500).json({ error: error.response?.data || error.message });
  }
});

// 1a-2. Capture PayPal Order
app.post("/paypal/capture-order", authenticate, async (req, res) => {
  const { paypalOrderId } = req.body;
  if (!paypalOrderId) {
    return res.status(400).json({ error: "Missing paypalOrderId" });
  }
  try {
    const accessToken = await getPaypalAccessToken();
    const baseUrl = getPaypalBaseUrl();
    const response = await axios({
      url: `${baseUrl}/v2/checkout/orders/${paypalOrderId}/capture`,
      method: "post",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${accessToken}`,
      },
    });
    return res.json(response.data);
  } catch (error) {
    console.error("Capture PayPal Order Error:", error.response?.data || error.message);
    return res.status(500).json(error.response?.data || { error: error.message });
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
      const origin = req.get("origin") || "https://washgov1.web.app";
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

    // PayPhone's clientTransactionId has a max length of 15 chars.
    // We use the first 15 chars of the orderId as the short key and store
    // a mapping in Firestore so the callback can recover the full orderId.
    const shortTxId = orderId.substring(0, 15);
    await admin.firestore().collection("payphone_transactions").doc(shortTxId).set({
      fullOrderId: orderId,
      createdAt: FieldValue.serverTimestamp(),
    }, { merge: true });

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
        clientTransactionId: shortTxId,
        storeId: storeId,
        reference: `Orden WashGo #${orderId.substring(0, 8)}`,
        currency: "USD",
        responseUrl: "https://us-central1-washgov1.cloudfunctions.net/api/payphone-callback/success",
      },
    });

    const paymentUrl = typeof response.data === "string"
      ? response.data.trim()
      : response.data?.url || response.data?.link || response.data?.payWithCardUrl;

    if (!paymentUrl) {
      throw new Error(`PayPhone Links API no devolvió URL de pago. Response: ${JSON.stringify(response.data)}`);
    }

    await admin.firestore().collection("payphone_transactions").doc(shortTxId).set({
      fullOrderId: orderId,
      payWithCardUrl: paymentUrl,
      createdAt: FieldValue.serverTimestamp(),
    }, { merge: true });

    console.log(`[PayPhone Links] URL de pago generada para orden ${orderId}: ${paymentUrl}`);

    return res.json({
      payWithCardUrl: paymentUrl,
      isSimulated: false,
    });
  } catch (error) {
    console.error("Prepare PayPhone Payment Error:", error.response?.data || error.message);
    return res.status(500).json({ error: error.response?.data || error.message });
  }
});

// 1b-1. PayPhone Callback — redirect target after successful payment
// PayPhone's Links API redirects the user's browser here (GET) with ?id=TRANSACTION_ID&clientTransactionId=SHORT_TX_ID
// ONLY on successful payment — cancelled/failed payments do NOT trigger this URL.
// We trust the redirect as proof of payment (Confirm API requires a different app type).
// shortTxId (15 chars) is mapped to fullOrderId via the payphone_transactions Firestore collection.
// 1b-1. PayPhone Callback & Webhook (handles both GET and POST from PayPhone or browser redirect)
const handlePayphoneCallback = async (req, res) => {
  const params = { ...req.query, ...req.body };
  console.log(`[PayPhone-callback] Raw params:`, JSON.stringify(params));

  // Case-insensitive param lookup helper
  const getParam = (obj, ...keys) => {
    if (!obj) return "";
    const lowerObj = {};
    for (const k of Object.keys(obj)) {
      lowerObj[k.toLowerCase()] = obj[k];
    }
    for (const key of keys) {
      const val = lowerObj[key.toLowerCase()];
      if (val !== undefined && val !== null && val !== "") return String(val).trim();
    }
    return "";
  };

  const transactionId = getParam(params, "id", "transactionId", "txId", "paymentId");
  let shortTxId = getParam(params, "clientTransactionId", "clientTxId", "orderId", "shortTxId");

  console.log(`[PayPhone-callback] Extracted — shortTxId="${shortTxId}", transactionId="${transactionId}"`);

  let fullOrderId = null;

  // Fallback: If shortTxId is missing but transactionId exists, recover the most recent pending payphone transaction from Firestore
  if (!shortTxId && transactionId) {
    try {
      const pendingSnap = await admin.firestore().collection("payphone_transactions")
        .orderBy("createdAt", "desc")
        .limit(1)
        .get();
      if (!pendingSnap.empty) {
        const doc = pendingSnap.docs[0];
        shortTxId = doc.id;
        fullOrderId = doc.data().fullOrderId || shortTxId;
        console.log(`[PayPhone-callback] Auto-recovered pending transaction doc "${shortTxId}" for transactionId="${transactionId}"`);
      }
    } catch (recoverErr) {
      console.error(`[PayPhone-callback] Failed to auto-recover pending doc: ${recoverErr.message}`);
    }
  }

  if (shortTxId) {
    if (!fullOrderId) {
      try {
        const txDoc = await admin.firestore().collection("payphone_transactions").doc(shortTxId).get();
        if (txDoc.exists) {
          fullOrderId = txDoc.data().fullOrderId || shortTxId;
        } else {
          fullOrderId = shortTxId;
        }
      } catch (err) {
        console.error(`[PayPhone-callback] Error reading tx mapping: ${err.message}`);
        fullOrderId = shortTxId;
      }
    }

    // Strict Payphone API Approval Check
    const token = process.env.PAYPHONE_TOKEN;
    let isApproved = false;
    let verifiedTxId = transactionId;
    let saleDetails = null;

    if (token) {
      try {
        const saleRes = await axios({
          url: `https://pay.payphonetodoesposible.com/api/Sale/Client/${shortTxId}`,
          method: "get",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`,
          },
        });

        const foundData = Array.isArray(saleRes.data) && saleRes.data.length > 0
          ? saleRes.data[0]
          : saleRes.data;

        if (foundData && (foundData.transactionStatus === "Approved" || foundData.statusCode === 3)) {
          isApproved = true;
          verifiedTxId = String(foundData.transactionId || foundData.id || transactionId);
          saleDetails = foundData;
        } else {
          console.warn(`[PayPhone-callback] Transaction ${shortTxId} was NOT approved: status=${foundData?.transactionStatus}, code=${foundData?.statusCode}`);
        }
      } catch (checkErr) {
        console.error(`[PayPhone-callback] Error verifying sale with Payphone: ${checkErr.message}`);
      }
    }

    if (isApproved) {
      try {
        await admin.firestore().collection("payphone_transactions").doc(shortTxId).set({
          transactionId: verifiedTxId,
          fullOrderId,
          confirmedAt: FieldValue.serverTimestamp(),
          payphoneDetails: saleDetails || params,
        }, { merge: true });
        console.log(`[PayPhone-callback] SUCCESSFULLY STORED transactionId=${verifiedTxId} for fullOrderId=${fullOrderId} (shortTxId=${shortTxId})`);
      } catch (err) {
        console.error(`[PayPhone-callback] Error storing transactionId: ${err.message}`);
      }

      try {
        const orderResult = await serverGetOrderById({ id: fullOrderId });
        const order = orderResult?.data?.order;
        if (order && order.status === "PENDIENTE_PAGO") {
          await serverUpdateOrderStatus({ orderId: fullOrderId, status: "EN_COLA" });
          console.log(`[PayPhone-callback] Order ${fullOrderId} successfully updated to EN_COLA`);
        }
      } catch (completionErr) {
        console.error(`[PayPhone-callback] Error updating order ${fullOrderId}: ${completionErr.message}`);
      }
    }
  }

  // If HTTP request accepts HTML or is browser GET, redirect to Web App success page if approved, or cancel page if rejected
  if (req.method === "GET" || (req.headers.accept && req.headers.accept.includes("text/html"))) {
    const redirectUrl = `https://washgov1.web.app/#/payphone-callback/success?id=${transactionId}&clientTransactionId=${shortTxId}`;
    return res.redirect(redirectUrl);
  }

  return res.status(200).json({ success: true, transactionId, shortTxId });
};

app.all("/payphone-callback/success", handlePayphoneCallback);
app.all("/payphone-notification", handlePayphoneCallback);

// Public helper endpoint called by Flutter PayphoneSuccessPage
app.post("/payphone/store-transaction", async (req, res) => {
  const { orderId, transactionId } = req.body;
  if (!orderId || !transactionId) {
    return res.status(400).json({ error: "Missing orderId or transactionId" });
  }

  try {
    const shortTxId = orderId.substring(0, 15);
    await admin.firestore().collection("payphone_transactions").doc(shortTxId).set({
      fullOrderId: orderId,
      transactionId: String(transactionId),
      confirmedAt: FieldValue.serverTimestamp(),
    }, { merge: true });

    try {
      const orderResult = await serverGetOrderById({ id: orderId });
      const order = orderResult?.data?.order;
      if (order && order.status === "PENDIENTE_PAGO") {
        await serverUpdateOrderStatus({ orderId, status: "EN_COLA" });
      }
    } catch (err) {
      console.error("Store Transaction Order Update Error:", err.message);
    }

    return res.json({ success: true });
  } catch (error) {
    console.error("Store Transaction Error:", error.message);
    return res.status(500).json({ error: error.message });
  }
});

// 1b-2. Verify PayPhone Payment — checks order status in Firestore
// The callback already updates the order to EN_COLA on successful payment.
// This endpoint simply reads the current order status so Flutter can poll it.
app.get("/payphone/:transactionId/verify", authenticate, async (req, res) => {
  const { transactionId } = req.params;
  const orderId = req.query.orderId || "";

  if (!transactionId) {
    return res.status(400).json({ error: "Missing transactionId" });
  }

  try {
    // Mock/simulated mode
    if (!orderId && (transactionId.startsWith("mock-") || transactionId.startsWith("sim-"))) {
      return res.json({ verified: true, status: "Approved", simulated: true });
    }

    // If orderId is provided, check the order status directly
    if (orderId) {
      const orderResult = await serverGetOrderById({ id: orderId });
      const order = orderResult.data.order;

      if (!order) {
        return res.status(404).json({ error: "Order not found" });
      }

      const isConfirmed = order.status !== "PENDIENTE_PAGO";
      console.log(`[PayPhone-verify] Order ${orderId} status: ${order.status} — verified: ${isConfirmed}`);

      if (isConfirmed) {
        return res.json({ verified: true, status: "Approved", orderStatus: order.status });
      }

      // Order still PENDIENTE_PAGO — callback hasn't run yet.
      // Check Firestore payphone_transactions to see if transactionId was stored (callback fired but order update failed)
      const shortTxId = transactionId.substring(0, 15);
      const txDoc = await admin.firestore().collection("payphone_transactions").doc(shortTxId).get();
      if (txDoc.exists && txDoc.data().confirmedAt) {
        // Callback ran but order update may have failed — retry the update
        console.log(`[PayPhone-verify] Callback previously ran for ${shortTxId}, retrying order update`);
        await serverUpdateOrderStatus({ orderId, status: "EN_COLA" });
        return res.json({ verified: true, status: "Approved", orderStatus: "EN_COLA", recovered: true });
      }

      return res.json({ verified: false, status: "Pending", orderStatus: order.status });
    }

    // No orderId provided — can only check Firestore transaction record
    const shortTxId = transactionId.substring(0, 15);
    const txDoc = await admin.firestore().collection("payphone_transactions").doc(shortTxId).get();
    if (txDoc.exists && txDoc.data().confirmedAt) {
      return res.json({ verified: true, status: "Approved" });
    }

    return res.json({ verified: false, status: "Pending" });

  } catch (error) {
    console.error("PayPhone Verify Error:", error.message);
    return res.status(500).json({ error: error.message });
  }
});

// 1b-3. Get Stored PayPhone Transaction ID for an Order (with active Payphone API query fallback)
app.get("/orders/:orderId/payphone-transaction", authenticate, async (req, res) => {
  const { orderId } = req.params;
  if (!orderId) {
    return res.status(400).json({ error: "Missing orderId" });
  }

  try {
    const shortTxId = orderId.substring(0, 15);
    console.log(`[PayPhone-lookup] Verification request for orderId=${orderId}, shortTxId=${shortTxId}`);

    // Check by shortTxId doc
    let txDoc = await admin.firestore().collection("payphone_transactions").doc(shortTxId).get();

    // Fallback: check by full orderId doc
    if (!txDoc.exists) {
      txDoc = await admin.firestore().collection("payphone_transactions").doc(orderId).get();
    }

    // Fallback: query by fullOrderId field
    if (!txDoc.exists) {
      const q = await admin.firestore().collection("payphone_transactions")
        .where("fullOrderId", "==", orderId)
        .limit(1)
        .get();
      if (!q.empty) {
        txDoc = q.docs[0];
      }
    }

    console.log(`[PayPhone-lookup] Firestore txDoc found=${txDoc.exists}, data=`, txDoc.exists ? JSON.stringify(txDoc.data()) : "NULL");

    if (txDoc.exists && txDoc.data().transactionId) {
      console.log(`[PayPhone-lookup] RETURNING transactionId=${txDoc.data().transactionId} for orderId=${orderId}`);
      return res.json({ transactionId: String(txDoc.data().transactionId) });
    }

    // Active Payphone API Verification Fallback:
    // Query Payphone Sale Client API (GET /api/Sale/Client/{clientTransactionId})
    const token = process.env.PAYPHONE_TOKEN;
    if (token) {
      try {
        console.log(`[PayPhone-lookup] Querying Payphone Sale API GET /api/Sale/Client/${shortTxId}...`);

        let foundData = null;
        try {
          const saleRes = await axios({
            url: `https://pay.payphonetodoesposible.com/api/Sale/Client/${shortTxId}`,
            method: "get",
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${token}`,
            },
          });

          if (Array.isArray(saleRes.data) && saleRes.data.length > 0) {
            foundData = saleRes.data[0];
          } else if (saleRes.data && typeof saleRes.data === "object") {
            foundData = saleRes.data;
          }
        } catch (saleErr) {
          console.warn(`[PayPhone-lookup] GET /api/Sale/Client/${shortTxId} failed: ${saleErr.response?.data?.message || saleErr.message}`);
        }

        console.log(`[PayPhone-lookup] Payphone API response for ${shortTxId}:`, JSON.stringify(foundData));

        const isApproved = foundData && (foundData.transactionStatus === "Approved" || foundData.statusCode === 3);

        if (isApproved) {
          const foundTxId = String(foundData.transactionId || foundData.id || shortTxId);

          await admin.firestore().collection("payphone_transactions").doc(shortTxId).set({
            fullOrderId: orderId,
            transactionId: foundTxId,
            confirmedAt: FieldValue.serverTimestamp(),
            payphoneDetails: foundData,
          }, { merge: true });

          try {
            await serverUpdateOrderStatus({ orderId, status: "EN_COLA" });
            console.log(`[PayPhone-lookup] Order ${orderId} successfully updated to EN_COLA via Payphone Sale API`);
          } catch (updateErr) {
            console.error(`[PayPhone-lookup] Order update error: ${updateErr.message}`);
          }

          return res.json({ transactionId: foundTxId, recovered: true });
        } else {
          console.warn(`[PayPhone-lookup] Transaction ${shortTxId} was rejected or canceled: status=${foundData?.transactionStatus}, code=${foundData?.statusCode}`);
        }
      } catch (payphoneApiErr) {
        const errMsg = payphoneApiErr.response?.data?.message || payphoneApiErr.message;
        console.warn(`[PayPhone-lookup] Payphone API check failed: ${errMsg}`);
      }
    }

    return res.status(404).json({ error: "El pago aún no ha sido procesado en Payphone. Completa la transacción en el enlace." });
  } catch (error) {
    console.error("Get Stored PayPhone Transaction Error:", error.message);
    return res.status(500).json({ error: error.message });
  }
});

// 1b-4. Complete PayPhone Payment (Proactive Client Verification)
app.post("/orders/complete-payphone-payment", authenticate, async (req, res) => {
  const { orderId, transactionId } = req.body;
  if (!orderId) {
    return res.status(400).json({ error: "Missing orderId" });
  }

  try {
    const orderResult = await serverGetOrderById({ id: orderId });
    const order = orderResult.data.order;
    if (!order) {
      return res.status(404).json({ error: "Order not found" });
    }

    // Save/merge transaction info in Firestore audit collection
    if (transactionId) {
      const shortTxId = orderId.substring(0, 15);
      await admin.firestore().collection("payphone_transactions").doc(shortTxId).set({
        fullOrderId: orderId,
        transactionId: transactionId,
        confirmedAt: FieldValue.serverTimestamp(),
      }, { merge: true });
    }

    // Update order status to EN_COLA if it's currently PENDIENTE_PAGO
    if (order.status === "PENDIENTE_PAGO") {
      await serverUpdateOrderStatus({ orderId, status: "EN_COLA" });
      console.log(`[Complete-PayPhone] Order ${orderId} successfully updated to EN_COLA`);
    } else {
      console.log(`[Complete-PayPhone] Order ${orderId} already in status ${order.status}`);
    }

    return res.json({ success: true, orderId: orderId, status: "EN_COLA" });
  } catch (error) {
    console.error("Complete PayPhone Payment Error:", error.message);
    return res.status(500).json({ error: error.message });
  }
});

// 1c. Cancel Pending Order (Client-Driven Cancellation with Safety Shield)
app.delete("/orders/:orderId/cancel-pending", authenticate, async (req, res) => {
  const { orderId } = req.params;
  try {
    const orderResult = await serverGetOrderById({ id: orderId });
    const order = orderResult?.data?.order;
    if (!order) return res.status(404).json({ error: "Order not found" });
    if (order.clientId !== req.user.uid) {
      return res.status(403).json({ error: "Forbidden: You do not own this order" });
    }
    if (order.status !== "PENDIENTE_PAGO") {
      return res.status(400).json({ error: "Order is not in PENDIENTE_PAGO status" });
    }

    // Safety Shield: Before canceling, query Payphone Sale API to ensure payment was not already approved
    const shortTxId = orderId.substring(0, 15);
    const token = process.env.PAYPHONE_TOKEN;
    if (token) {
      try {
        const saleRes = await axios({
          url: `https://pay.payphonetodoesposible.com/api/Sale/Client/${shortTxId}`,
          method: "get",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`,
          },
        });

        const foundData = Array.isArray(saleRes.data) && saleRes.data.length > 0
          ? saleRes.data[0]
          : saleRes.data;

        const isApproved = foundData && (foundData.transactionStatus === "Approved" || foundData.statusCode === 3);

        if (isApproved) {
          const foundTxId = String(foundData.transactionId || foundData.id || shortTxId);

          // Payment WAS ALREADY approved! Recover order to EN_COLA and save transactionId in Firestore
          await admin.firestore().collection("payphone_transactions").doc(shortTxId).set({
            fullOrderId: orderId,
            transactionId: foundTxId,
            confirmedAt: FieldValue.serverTimestamp(),
            payphoneDetails: foundData,
          }, { merge: true });

          await serverUpdateOrderStatus({ orderId, status: "EN_COLA" });
          console.log(`[Cancel-Safety-Shield] Blocked cancellation for order ${orderId} because payment was approved (txId=${foundTxId})`);

          return res.status(409).json({
            error: "Payment already approved",
            isAlreadyPaid: true,
            transactionId: foundTxId,
            message: "Tu pago ya fue aprobado por Payphone. Tu reserva ha sido confirmada con éxito.",
          });
        }
      } catch (payphoneCheckErr) {
        console.warn(`[Cancel-Safety-Shield] Payphone check during cancel returned: ${payphoneCheckErr.message}`);
      }
    }

    // Safe to cancel the order
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
  const { orderId, paypalOrderId } = req.body;
  if (!orderId || !paypalOrderId) {
    return res.status(400).json({ error: "Missing orderId or paypalOrderId" });
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

    // Payment captured — set order to EN_COLA so it enters the employee service queue
    await serverUpdateOrderStatus({ orderId, status: "EN_COLA" });

    return res.json({
      success: true,
      orderStatus: "EN_COLA",
    });
  } catch (error) {
    console.error("Complete PayPal Payment Error:", error.response?.data || error.message);
    return res.status(500).json({ error: error.response?.data || error.message });
  }
});

// 2b. Complete PayPhone Payment
app.post("/orders/complete-payphone-payment", authenticate, async (req, res) => {
  const { orderId, transactionId } = req.body;
  if (!orderId || !transactionId) {
    return res.status(400).json({ error: "Missing orderId or transactionId" });
  }

  try {
    // Fetch order details
    let order = null;
    try {
      const orderResult = await serverGetOrderById({ id: orderId });
      order = orderResult.data.order;
    } catch (dataConnectError) {
      console.error(`[complete-payphone-payment] Data Connect lookup failed: ${dataConnectError.message}`);
      return res.status(503).json({
        error: "DATA_CONNECT_UNAVAILABLE",
        message: "No se pudo acceder a la base de datos. Por favor intenta de nuevo en unos segundos.",
      });
    }

    if (!order) {
      return res.status(404).json({ error: "Order not found" });
    }

    if (order.clientId !== req.user.uid) {
      return res.status(403).json({ error: "Forbidden: You do not own this order" });
    }

    // Idempotent: if order already confirmed, return success
    if (order.status === "EN_COLA" || order.status === "COMPLETADO") {
      console.log(`[complete-payphone-payment] Order ${orderId} already ${order.status}. Returning success (idempotent).`);
      return res.json({ success: true, orderStatus: order.status });
    }

    if (order.status !== "PENDIENTE_PAGO") {
      return res.status(400).json({ error: `Order is not pending payment. Current status: ${order.status}` });
    }

    // Verify the transactionId was stored by the PayPhone callback (proof of payment).
    // The callback only runs on successful payment, so a stored record = approved payment.
    const shortTxId = transactionId.substring(0, 15);
    const isMock = transactionId.startsWith("mock-") || transactionId.startsWith("sim-") || !process.env.PAYPHONE_TOKEN || process.env.PAYPHONE_TOKEN === "mock";

    if (!isMock) {
      const txDoc = await admin.firestore().collection("payphone_transactions").doc(shortTxId).get();
      if (!txDoc.exists) {
        console.warn(`[complete-payphone-payment] No Firestore record for shortTxId=${shortTxId}. Payment may not have been confirmed by PayPhone yet.`);
        return res.status(400).json({
          error: "PayPhone payment not confirmed yet. Please wait a moment and try again.",
        });
      }
      console.log(`[complete-payphone-payment] Verified Firestore record for shortTxId=${shortTxId}. Proceeding with order update.`);
    } else {
      console.log("[complete-payphone-payment] Completing simulated/mock transaction:", transactionId);
    }

    // Payment confirmed — set order to EN_COLA
    await serverUpdateOrderStatus({ orderId, status: "EN_COLA" });

    return res.json({ success: true, orderStatus: "EN_COLA" });

  } catch (error) {
    console.error("Complete PayPhone Payment Error:", error.message);
    return res.status(500).json({ error: error.message });
  }
});


// 2bb. Get stored PayPhone Transaction ID (Authenticated)
app.get("/orders/:orderId/payphone-transaction", authenticate, async (req, res) => {
  // Double-guard: if the authenticate middleware failed but Express v2 still entered
  // this handler (known Firebase Functions v2 behavior), bail out early.
  if (!req.user) {
    return res.status(401).json({ error: "Missing or invalid authorization token" });
  }
  const { orderId } = req.params;
  try {
    // Try to verify order ownership via Data Connect, but don't fail if it throws NOT_FOUND.
    // The user is already authenticated via Firebase Auth token, which is sufficient security.
    try {
      const orderResult = await serverGetOrderById({ id: orderId });
      const order = orderResult.data.order;
      if (order && order.clientId !== req.user.uid) {
        return res.status(403).json({ error: "Forbidden: You do not own this order" });
      }
    } catch (dataConnectError) {
      // Data Connect may return NOT_FOUND (gRPC code 5) if the order was auto-cancelled
      // or if the emulator lost state. We still allow the lookup since auth is verified.
      console.warn(`[payphone-transaction] serverGetOrderById failed for ${orderId}: ${dataConnectError.message}. Falling back to Firestore lookup.`);
    }

    const doc = await admin.firestore().collection("payphone_transactions").doc(orderId).get();
    if (!doc.exists) {
      // When running on the emulator, proxy to production Firestore via the public endpoint.
      // This ensures the local dev flow works when the production callback (success.html)
      // already stored the transactionId in the production Firestore.
      if (process.env.FIRESTORE_EMULATOR_HOST) {
        try {
          const prodResponse = await axios.get(
            `https://us-central1-washgov1.cloudfunctions.net/api/payphone/transaction/${encodeURIComponent(orderId)}`,
            { timeout: 5000 }
          );
          if (prodResponse.data?.transactionId) {
            console.log(`[payphone-transaction] Production fallback returned transactionId for ${orderId}`);
            return res.json({ transactionId: prodResponse.data.transactionId });
          }
        } catch (proxyError) {
          console.warn(`[payphone-transaction] Production fallback failed for ${orderId}: ${proxyError.message}`);
        }
      }
      return res.json({ transactionId: null });
    }

    return res.json({ transactionId: doc.data().transactionId });
  } catch (error) {
    console.error("Get Stored PayPhone Transaction Error:", error.message);
    return res.status(500).json({ error: error.message });
  }
});

// 2bc. Store PayPhone Transaction ID (Public — no auth required, called from browser callback page)
// This is the safety net: saves the transactionId so the Flutter app can recover it later via the
// authenticated GET /orders/:orderId/payphone-transaction endpoint.
app.post("/payphone/store-transaction", async (req, res) => {
  const { orderId, transactionId } = req.body;
  if (!orderId || !transactionId) {
    return res.status(400).json({ error: "Missing orderId or transactionId" });
  }
  try {
    await admin.firestore().collection("payphone_transactions").doc(orderId).set({
      transactionId,
      storedAt: FieldValue.serverTimestamp(),
    }, { merge: true });
    console.log(`[PayPhone] Stored transactionId for order ${orderId}: ${transactionId}`);
    return res.json({ success: true });
  } catch (error) {
    console.error("Store PayPhone Transaction Error:", error.message);
    return res.status(500).json({ error: error.message });
  }
});

// 2bd. Get stored PayPhone Transaction ID (Public — no auth required, for cross-environment reads)
// Used when the local emulator needs to reach production Firestore, or for browser callback polling.
app.get("/payphone/transaction/:orderId", async (req, res) => {
  const { orderId } = req.params;
  if (!orderId) return res.status(400).json({ error: "Missing orderId" });
  try {
    const doc = await admin.firestore().collection("payphone_transactions").doc(orderId).get();
    if (!doc.exists) return res.json({ transactionId: null });
    return res.json({ transactionId: doc.data().transactionId });
  } catch (error) {
    console.error("Query PayPhone Transaction Error:", error.message);
    return res.status(500).json({ error: error.message });
  }
});

// 2be. PayPhone Notificación Externa / Webhook
// Called by PayPhone's servers when a payment is approved.
// PayPhone only fires this for APPROVED transactions.
// Register this URL in PayPhone Developer → Notificación Externa:
//   https://api-bbftupbjja-uc.a.run.app/payphone-webhook
app.post("/payphone-webhook", async (req, res) => {
  console.log("[PayPhone-Webhook] Received webhook payload:", JSON.stringify(req.body));

  // Extract fields — handle PascalCase and camelCase variants from PayPhone docs
  const transactionId = req.body.TransactionId || req.body.transactionId || req.body.id || req.body.transaction_id;
  const shortTxId     = req.body.ClientTransactionId || req.body.clientTransactionId || req.body.clientTxId || req.body.client_transaction_id;
  const status        = req.body.TransactionStatus || req.body.transactionStatus || req.body.status || req.body.state;

  if (!shortTxId || !transactionId) {
    console.warn("[PayPhone-Webhook] Missing shortTxId or transactionId in payload");
    return res.status(400).json({ Response: false, ErrorCode: "444" });
  }

  const shortTxIdStr    = shortTxId.toString();
  const transactionIdStr = transactionId.toString();

  try {
    // 1. Resolve shortTxId → fullOrderId from Firestore mapping
    let fullOrderId = shortTxIdStr;
    const txDoc = await admin.firestore().collection("payphone_transactions").doc(shortTxIdStr).get();
    if (txDoc.exists && txDoc.data().fullOrderId) {
      fullOrderId = txDoc.data().fullOrderId;
      console.log(`[PayPhone-Webhook] Resolved shortTxId=${shortTxIdStr} → fullOrderId=${fullOrderId}`);
    } else {
      console.warn(`[PayPhone-Webhook] No mapping for shortTxId=${shortTxIdStr}, using as-is`);
    }

    // 2. Store transactionId + webhook payload in Firestore for audit
    await admin.firestore().collection("payphone_transactions").doc(shortTxIdStr).set({
      transactionId: transactionIdStr,
      fullOrderId,
      webhookStatus: status,
      webhookPayload: req.body,
      webhookReceivedAt: FieldValue.serverTimestamp(),
    }, { merge: true });
    console.log(`[PayPhone-Webhook] Stored transactionId=${transactionIdStr} for fullOrderId=${fullOrderId}`);

    // 3. Update order to EN_COLA
    // PayPhone only fires this webhook for approved transactions.
    if (status === "Approved" || status === "COMPLETED" || status === "approved" || !status) {
      const orderResult = await serverGetOrderById({ id: fullOrderId });
      const order = orderResult.data.order;
      if (order && order.status === "PENDIENTE_PAGO") {
        await serverUpdateOrderStatus({ orderId: fullOrderId, status: "EN_COLA" });
        console.log(`[PayPhone-Webhook] Order ${fullOrderId} updated to EN_COLA`);
      } else if (order) {
        console.log(`[PayPhone-Webhook] Order ${fullOrderId} already in status ${order.status}`);
      } else {
        console.warn(`[PayPhone-Webhook] Order ${fullOrderId} not found`);
      }
    } else {
      console.warn(`[PayPhone-Webhook] Transaction status not approved: ${status}`);
    }

    // PayPhone expects this exact response format
    return res.status(200).json({ Response: true, ErrorCode: "000" });
  } catch (error) {
    console.error(`[PayPhone-Webhook] Error: ${error.message}`);
    return res.status(500).json({ Response: false, ErrorCode: "222" });
  }
});

// 3. Complete Cash Payment (PDF generation disabled — digital invoice only)
app.post("/orders/complete-cash-payment", authenticate, async (req, res) => {
  const { orderId } = req.body;
  if (!orderId) {
    return res.status(400).json({ error: "Missing orderId" });
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

    // PDF generation is disabled — no PDF uploaded to Storage
    // Invoice is created with digital data only (no pdfUrl)

    // Complete order with mutation using admin SDK
    await completeOrderWithInvoiceOnly({
      orderId,
      observations: "Pago en efectivo completado",
      invoiceUrl: null,
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
      invoiceUrl: null,
      orderStatus: "COMPLETADO",
    });
  } catch (error) {
    console.error("Complete Cash Payment Error:", error.message);
    return res.status(500).json({ error: error.message });
  }
});

// 4b. Complete Prepaid Payment (PayPhone, PayPal, Transferencia — employee completion, PDF disabled)
app.post("/orders/complete-prepaid-payment", authenticate, async (req, res) => {
  const { orderId, paymentMethod, observations } = req.body;
  if (!orderId || !paymentMethod) {
    return res.status(400).json({ error: "Missing required fields: orderId, paymentMethod" });
  }

  try {
    // Fetch order details using server/admin context
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

    // Ensure order is in a valid status for employee completion
    if (order.status !== "EN_COLA" && order.status !== "ACEPTADO" && order.status !== "EN_SERVICIO") {
      return res.status(400).json({ error: `Order cannot be completed. Current status: ${order.status}. Expected EN_COLA, ACEPTADO or EN_SERVICIO.` });
    }

    // Generate invoice database details
    const invoiceId = crypto.randomUUID();
    const numeroUnico = generateNumeroUnico();

    // Secure calculation on backend (18% VAT for non-cash payments)
    const subtotal = parseFloat((order.price / 1.18).toFixed(2));
    const tax = parseFloat((order.price - subtotal).toFixed(2));

    // PDF generation is disabled — no PDF uploaded to Storage
    // Invoice is created with digital data only (no pdfUrl)

    // Complete order with prepaid helper (handles NO_ACCESS mutations via admin SDK)
    await completeOrderWithPrepaid({
      req,
      order,
      invoiceParams: {
        signedUrl: null,
        invoiceId,
        numeroUnico,
        subtotal,
        tax,
      },
      paymentMethod,
      observations: observations || "Pago completado",
    });

    return res.json({
      success: true,
      invoiceId,
      numeroUnico,
      invoiceUrl: null,
      orderStatus: "COMPLETADO",
    });
  } catch (error) {
    console.error("Complete Prepaid Payment Error:", error.message);
    return res.status(500).json({ error: error.message });
  }
});

// 5. Get Invoice Signed URL
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

// 6. Regenerate Invoice PDF
app.post("/invoices/:invoiceId/regenerate-pdf", authenticate, async (req, res) => {
  const { invoiceId } = req.params;
  const { base64Pdf } = req.body;

  if (!invoiceId || !base64Pdf) {
    return res.status(400).json({ error: "Missing invoiceId or base64Pdf" });
  }

  try {
    // Fetch invoice using admin-safe query (bypasses @auth gates, no auth.uid dependency)
    const invoiceResult = await getInvoiceByIdAdmin({ id: invoiceId });
    const invoice = invoiceResult.data.invoice;
    if (!invoice) {
      return res.status(404).json({ error: "Invoice not found" });


    }

    // Permission check: allow if the caller is the client, the assigned employee,
    // the business owner, or a SUPER_ADMIN
    const isClient = invoice.order?.clientId === req.user.uid;
    const isEmployee = invoice.order?.employeeId === req.user.uid;
    const isOwner = invoice.order?.business?.owner?.id === req.user.uid;
    const isSuperAdmin = req.user.token?.roles?.includes("SUPER_ADMIN");

    if (!isClient && !isEmployee && !isOwner && !isSuperAdmin) {
      return res.status(403).json({ error: "Forbidden: You do not have permission to regenerate this invoice" });
    }

    const orderId = invoice.order?.id;
    if (!orderId) {
      return res.status(400).json({ error: "Invoice has no associated order" });
    }

    // Upload PDF to Storage via admin SDK (bypasses storage.rules)
    const bucket = admin.storage().bucket();
    const file = bucket.file(`invoices/${invoiceId}.pdf`);
    const buffer = Buffer.from(base64Pdf, "base64");
    await file.save(buffer, {
      metadata: {
        contentType: "application/pdf",
      },
    });

    // Get downloadable URL (resilient to emulator environment)
    const pdfUrl = await getDownloadUrlSafe(file);

    // Update invoice record with pdfUrl and GENERATED status
    await updateInvoicePdf({
      id: invoiceId,
      pdfUrl,
      invoiceStatus: "GENERATED",
    });

    // Update order with invoice URL
    await updateOrderCompletion({
      orderId,
      invoiceUrl: pdfUrl,
    });

    return res.json({
      success: true,
      pdfUrl,
      invoiceStatus: "GENERATED",
    });
  } catch (error) {
    console.error("Regenerate Invoice PDF Error:", error.message);
    return res.status(500).json({ error: error.message });
  }
});

// 7. Serve Invoice PDF (proxy that bypasses storage.rules)
app.get("/invoices/:invoiceId/pdf", authenticate, async (req, res) => {
  const { invoiceId } = req.params;

  if (!invoiceId) {
    return res.status(400).json({ error: "Missing invoiceId" });
  }

  try {
    // Fetch invoice using admin-safe query (bypasses @auth gates, no auth.uid dependency)
    const invoiceResult = await getInvoiceByIdAdmin({ id: invoiceId });
    const invoice = invoiceResult.data.invoice;
    if (!invoice) {
      return res.status(404).json({ error: "Invoice not found" });
    }

    // Permission check: same as regenerate-pdf
    const isClient = invoice.order?.clientId === req.user.uid;
    const isEmployee = invoice.order?.employeeId === req.user.uid;
    const isOwner = invoice.order?.business?.owner?.id === req.user.uid;
    const isSuperAdmin = req.user.token?.roles?.includes("SUPER_ADMIN");

    if (!isClient && !isEmployee && !isOwner && !isSuperAdmin) {
      return res.status(403).json({ error: "Forbidden" });
    }

    // Read PDF from Storage via Admin SDK (bypasses storage.rules)
    const bucket = admin.storage().bucket();
    const file = bucket.file(`invoices/${invoiceId}.pdf`);

    const [exists] = await file.exists();
    if (!exists) {
      return res.status(404).json({ error: "PDF file not found in storage" });
    }

    const [buffer] = await file.download();

    res.setHeader("Content-Type", "application/pdf");
    res.setHeader("Content-Disposition", `inline; filename="Factura_${invoice.numeroUnico || invoiceId}.pdf"`);
    res.setHeader("Content-Length", buffer.length.toString());
    return res.send(buffer);
  } catch (error) {
    console.error("Serve Invoice PDF Error:", error.message);
    return res.status(500).json({ error: error.message });
  }
});

// 7b. Serve Invoice PDF by Order ID (for callers without invoiceId — uses orderId → invoice resolution)
app.get("/orders/:orderId/invoice-pdf", authenticate, async (req, res) => {
  const { orderId } = req.params;

  if (!orderId) {
    return res.status(400).json({ error: "Missing orderId" });
  }

  try {
    // Resolve orderId → invoiceId via admin SDK (bypasses @auth gates)
    const invoiceResult = await getInvoiceByOrderId({ orderId });
    const invoices = invoiceResult.data.invoices;
    if (!invoices || invoices.length === 0) {
      return res.status(404).json({ error: "No invoice found for this order" });
    }

    const invoice = invoices[0];
    const invoiceId = invoice.id;

    // Fetch full invoice using admin-safe query (bypasses @auth gates, no auth.uid dependency)
    const fullInvoiceResult = await getInvoiceByIdAdmin({ id: invoiceId });
    const fullInvoice = fullInvoiceResult.data.invoice;
    if (!fullInvoice) {
      return res.status(404).json({ error: "Invoice not found" });
    }

    // Permission check: same as in /invoices/:invoiceId/pdf
    const isClient = fullInvoice.order?.clientId === req.user.uid;
    const isEmployee = fullInvoice.order?.employeeId === req.user.uid;
    const isOwner = fullInvoice.order?.business?.owner?.id === req.user.uid;
    const isSuperAdmin = req.user.token?.roles?.includes("SUPER_ADMIN");

    if (!isClient && !isEmployee && !isOwner && !isSuperAdmin) {
      return res.status(403).json({ error: "Forbidden" });
    }

    // Read PDF from Storage via Admin SDK (bypasses storage.rules)
    const bucket = admin.storage().bucket();
    const file = bucket.file(`invoices/${invoiceId}.pdf`);

    const [exists] = await file.exists();
    if (!exists) {
      return res.status(404).json({ error: "PDF file not found in storage" });
    }

    const [buffer] = await file.download();

    res.setHeader("Content-Type", "application/pdf");
    res.setHeader("Content-Disposition", `inline; filename="Factura_${fullInvoice.numeroUnico || invoiceId}.pdf"`);
    res.setHeader("Content-Length", buffer.length.toString());
    return res.send(buffer);
  } catch (error) {
    console.error("Serve Invoice PDF by OrderId Error:", error.message);
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
    if (buffer.length > 5 * 1024 * 1024) {
      return res.status(400).json({ error: "La imagen excede el límite de 5 MB." });
    }
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

// Scheduled cleanup: every 15 minutes, cancel pending bank transfer orders older than 30 minutes without proof
exports.cleanupPendingTransfers = onSchedule({
  schedule: "*/15 * * * *",
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
    const THIRTY_MINUTES_MS = 30 * 60 * 1000;
    let cancelledCount = 0;

    for (const order of orders) {
      // If a payment proof has already been uploaded, do not cancel
      if (order.paymentProof_on_order) {
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
          titulo: "Pago por transferencia cancelado",
          mensaje: `Tu orden de "${order.serviceName}" con pago por transferencia ha sido cancelada automáticamente por exceder los 30 minutos de espera sin subir el comprobante. Si deseas continuar, puedes realizar una nueva orden.`,
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

