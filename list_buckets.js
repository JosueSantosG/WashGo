const fs = require('fs');
const path = require('path');
const https = require('https');

const userProfile = process.env.USERPROFILE || 'C:\\Users\\DELL';
const p = path.join(userProfile, '.config', 'configstore', 'firebase-tools.json');

try {
  const data = JSON.parse(fs.readFileSync(p, 'utf8'));
  const accessToken = data.tokens.access_token;
  const projectId = 'washgo-app-8392';
  
  const options = {
    hostname: 'storage.googleapis.com',
    port: 443,
    path: `/storage/v1/b?project=${projectId}`,
    method: 'GET',
    headers: {
      'Authorization': `Bearer ${accessToken}`,
      'Content-Type': 'application/json'
    }
  };

  console.log(`Listing buckets for project: ${projectId}...`);

  const req = https.request(options, (res) => {
    let responseBody = '';
    res.on('data', (chunk) => {
      responseBody += chunk;
    });

    res.on('end', () => {
      console.log('Status Code:', res.statusCode);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        const result = JSON.parse(responseBody);
        console.log('Buckets:');
        if (result.items) {
          result.items.forEach(b => console.log(` - ${b.name}`));
        } else {
          console.log('No buckets found.');
        }
      } else {
        console.error('Failed to list buckets.');
        console.error('Response:', responseBody);
      }
    });
  });

  req.on('error', (e) => {
    console.error('Request error:', e.message);
  });

  req.end();

} catch (e) {
  console.error('Error:', e.message);
}
