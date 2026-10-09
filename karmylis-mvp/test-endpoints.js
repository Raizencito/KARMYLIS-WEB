const http = require('http');

const tests = [
  { path: '/inventory/search?q=polera algodon', name: 'Search polera algodon' },
  { path: '/inventory/CHRYSV2', name: 'Get product CHRYSV2' },
  { path: '/inventory/CHRYSV2/stock?color=NEGRO&size=ESTANDAR', name: 'Check stock CHRYSV2 NEGRO ESTANDAR' },
];

async function runTests() {
  for (const test of tests) {
    await new Promise(resolve => {
      const req = http.get(`http://localhost:3000${test.path}`, (res) => {
        let data = '';
        res.on('data', chunk => data += chunk);
        res.on('end', () => {
          console.log(`\n=== ${test.name} ===`);
          console.log('Status:', res.statusCode);
          const parsed = JSON.parse(data);
          if (parsed.products) {
            console.log(`Found ${parsed.products.length} products`);
            parsed.products.slice(0, 2).forEach(p => console.log(`  - ${p.code}: ${p.name} - Bs.${p.price}`));
          } else if (parsed.product) {
            console.log(`  ${parsed.product.code}: ${parsed.product.name} - Bs.${parsed.product.price}`);
          } else if (parsed.found !== undefined) {
            console.log(`  Found: ${parsed.found}, Available: ${parsed.available}, Message: ${parsed.message}`);
          }
          resolve();
        });
      });
      req.on('error', err => { console.error('Error:', err.message); resolve(); });
    });
  }
}

runTests();