// Test script for inventory + Gemini functions
const { readInventory, searchProducts, checkStock } = require('./functions/inventory');
const { processMessage } = require('./functions/gemini');

async function test() {
  console.log('=== TEST 1: readInventory ===');
  const products = await readInventory();
  console.log(`Total productos: ${products.length}`);
  console.log(`En stock: ${products.filter(p => p.inStock).length}`);
  console.log('Primeros 3:', products.slice(0, 3).map(p => `${p.code}: ${p.name} - Bs.${p.price} - ${p.colors.join('/')} - ${p.sizes.join('/')}`));

  console.log('\n=== TEST 2: searchProducts ===');
  const results = await searchProducts('chompa negra');
  console.log(`Resultados para "chompa negra": ${results.length}`);
  results.slice(0, 3).forEach(p => console.log(`  - ${p.code}: ${p.name} - Bs.${p.price} - ${p.colors.join('/')}`));

  console.log('\n=== TEST 3: checkStock ===');
  const stock = await checkStock('CHRYSV2', 'NEGRO', 'ESTANDAR');
  console.log('Stock CHRYSV2 NEGRO ESTANDAR:', stock);

  console.log('\n=== TEST 4: processMessage (mock) ===');
  const testMessages = [
    'Hola',
    '¿Tienen chompa rayas suave negra talla estandar?',
    'Busco polera algodon',
    '¿Cuánto cuesta la chompa boton dorado?',
    'Quiero hacer un fibonacci en python'
  ];

  for (const msg of testMessages) {
    console.log(`\n👤 Usuario: "${msg}"`);
    const result = await processMessage(msg);
    console.log(`🤖 Intent: ${result.intent}`);
    console.log(`🤖 Respuesta: ${result.response}`);
    if (result.data && Array.isArray(result.data)) {
      console.log(`📦 Data: ${result.data.length} productos`);
    }
  }
}

test().catch(console.error);