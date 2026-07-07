const fs = require('fs');
const path = require('path');
const https = require('https');

const userProfile = process.env.USERPROFILE || 'C:\\Users\\DELL';
const p = path.join(userProfile, '.config', 'configstore', 'firebase-tools.json');

try {
  const data = JSON.parse(fs.readFileSync(p, 'utf8'));
  const accessToken = data.tokens.access_token;
  const projectId = 'washgo-app-8392';
  const bucketName = 'washgo-app-8392.firebasestorage.app'; // Or washgo-app-8392.appspot.com
  
  const payload = JSON.stringify({
    name: bucketName,
    location: 'us-central1'
  });

  const options = {
    hostname: 'storage.googleapis.com',
    port: 443,
    path: `/storage/v1/b?project=${projectId}`,
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
      'Content-Length': Buffer.byteLength(payload)
    }
  };

  console.log(`Creating bucket: ${bucketName} in project: ${projectId}...`);

  const req = https.request(options, (res) => {
    let responseBody = '';
    res.on('data', (chunk) => {
      responseBody += chunk;
    });

    res.on('end', () => {
      console.log('Status Code:', res.statusCode);
      console.log('Response:', responseBody);
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
