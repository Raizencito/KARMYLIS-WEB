const http = require('http');

const postData = JSON.stringify({ text: '¿Tienen chompa rayas suave negra talla estandar?' });

const options = {
  hostname: 'localhost',
  port: 3000,
  path: '/process',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Content-Length': Buffer.byteLength(postData)
  }
};

const req = http.request(options, (res) => {
  let data = '';
  res.on('data', chunk => data += chunk);
  res.on('end', () => {
    console.log('Status:', res.statusCode);
    console.log('Response:', JSON.parse(data));
  });
});

req.on('error', (err) => console.error('Error:', err.message));
req.write(postData);
req.end();