const fs = require('fs');
const path = require('path');
const https = require('https');

const userProfile = process.env.USERPROFILE || 'C:\\Users\\DELL';
const p = path.join(userProfile, '.config', 'configstore', 'firebase-tools.json');

try {
  const data = JSON.parse(fs.readFileSync(p, 'utf8'));
  const accessToken = data.tokens.access_token;
  const bucketName = 'washgov1.firebasestorage.app';
  
  const corsConfig = {
    cors: [
      {
        origin: ['*'],
        method: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS', 'HEAD'],
        responseHeader: ['*'],
        maxAgeSeconds: 3600
      }
    ]
  };

  const payload = JSON.stringify(corsConfig);

  const options = {
    hostname: 'storage.googleapis.com',
    port: 443,
    path: `/storage/v1/b/${bucketName}`,
    method: 'PATCH',
    headers: {
      'Authorization': `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
      'Content-Length': Buffer.byteLength(payload)
    }
  };

  console.log(`Sending PATCH request to configure CORS for bucket: ${bucketName}...`);

  const req = https.request(options, (res) => {
    let responseBody = '';
    res.on('data', (chunk) => {
      responseBody += chunk;
    });

    res.on('end', () => {
      console.log('Status Code:', res.statusCode);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        console.log('CORS configured successfully!');
        console.log('Response:', JSON.stringify(JSON.parse(responseBody), null, 2));
      } else {
        console.error('Failed to configure CORS.');
        console.error('Response:', responseBody);
      }
    });
  });

  req.on('error', (e) => {
    console.error('Request error:', e.message);
  });

  req.write(payload);
  req.end();

} catch (e) {
  console.error('Error:', e.message);
}
