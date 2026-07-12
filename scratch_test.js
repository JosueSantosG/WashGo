const admin = require("firebase-admin");
const axios = require("axios");

// Point to the local emulators
process.env.FIREBASE_AUTH_EMULATOR_HOST = "127.0.0.1:9099";

admin.initializeApp({
  projectId: "washgo-app-8392"
});

async function run() {
  const uid = "Na839SmSxEC9K928hZ0zB2310KrP";
  const email = "root@washgo.com";

  console.log("Checking if super admin user exists in Auth Emulator...");
  let authUser;
  try {
    authUser = await admin.auth().getUser(uid);
    console.log("Super admin user already exists.");
  } catch (error) {
    if (error.code === "auth/user-not-found") {
      console.log("Creating super admin user in Auth Emulator...");
      authUser = await admin.auth().createUser({
        uid: uid,
        email: email,
        emailVerified: true,
        displayName: "Super Admin",
      });
      console.log("Super admin user created.");
    } else {
      throw error;
    }
  }

  console.log("Setting custom claims { roles: ['SUPER_ADMIN'] }...");
  await admin.auth().setCustomUserClaims(uid, { roles: ["SUPER_ADMIN"] });
  console.log("Claims set successfully.");

  console.log("Generating custom token...");
  const customToken = await admin.auth().createCustomToken(uid);

  console.log("Exchanging custom token for ID token...");
  const exchangeRes = await axios.post(
    `http://127.0.0.1:9099/www.googleapis.com/identitytoolkit/v3/relyingparty/verifyCustomToken?key=fake-api-key`,
    {
      token: customToken,
      returnSecureToken: true,
    }
  );
  const idToken = exchangeRes.data.idToken;
  console.log("ID Token generated successfully.");

  const orderId = "dcaa504198994285930fb377ecdbe46c";
  console.log(`Sending REJECTED review request for order ${orderId}...`);
  try {
    const reviewRes = await axios.post(
      "http://127.0.0.1:5001/washgo-app-8392/us-central1/api/payments/review-proof",
      {
        orderId: orderId,
        status: "REJECTED",
        observations: "El comprobante no es legible."
      },
      {
        headers: {
          Authorization: `Bearer ${idToken}`
        }
      }
    );
    console.log("Response:", reviewRes.data);
  } catch (error) {
    console.error("Request Failed!");
    if (error.response) {
      console.error("Status:", error.response.status);
      console.error("Data:", JSON.stringify(error.response.data, null, 2));
    } else {
      console.error(error.message);
    }
  }
}

run().catch(console.error);
