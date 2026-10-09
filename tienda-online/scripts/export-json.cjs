// Exporta productsData.js -> public/data/*.json (fuente dinámica del catálogo)
const fs = require('fs');
const path = require('path');

const src = fs.readFileSync(path.join(__dirname, '..', 'src', 'data', 'productsData.js'), 'utf8');
const pick = (name) => {
  const m = src.match(new RegExp('export const ' + name + ' = (\\{[\\s\\S]*?\\}|\\[[\\s\\S]*?\\]);'));
  if (!m) throw new Error('No se encontró ' + name);
  return JSON.parse(m[1]);
};

const out = path.join(__dirname, '..', 'public', 'data');
fs.mkdirSync(out, { recursive: true });

const products = pick('products');
const categories = pick('categories');
// storeInfo es un literal JS (claves sin comillas, comentarios) -> evaluar
const storeM = src.match(/export const storeInfo = (\{[\s\S]*?\});/);
const storeInfo = new Function('return (' + storeM[1] + ')')();

fs.writeFileSync(path.join(out, 'products.json'), JSON.stringify(products));
fs.writeFileSync(path.join(out, 'categories.json'), JSON.stringify(categories));
fs.writeFileSync(path.join(out, 'store.json'), JSON.stringify(storeInfo));
console.log('OK:', products.length, 'productos,', categories.length, 'categorías -> public/data/');
