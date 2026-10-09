const { google } = require('googleapis');
const fs = require('fs');
const path = require('path');

const SHEET_ID = '1XbxDpw62hyxbQr7qxOI5N8ULuSygujfkB2BRyTPm3LM';
const SERVICE_ACCOUNT_PATH = path.join(__dirname, '..', 'service-account.json');

// Price ranges by category (from your Python script)
const PRICE_RANGES = {
  'CHOMPA': [180, 260],
  'ABRIGO': [180, 260],
  'BLUSA': [110, 190],
  'POLERA': [110, 190],
  'TOP': [110, 190],
  'BASICA': [110, 190],
  'VESTIDO': [220, 340],
  'PANTALON': [150, 230],
  'PALAZO': [150, 230],
  'CHAQUETA': [150, 250],
  'CHAMARRA': [150, 250],
  'BLAZER': [150, 250],
  'FALDA': [150, 230],
  'SHORT': [120, 200],
  'CAMISA': [130, 200],
  'KROP': [120, 200],
  'KROPTOP': [120, 200],
  'SUDADERA': [150, 220],
  'CROP': [120, 200],
  'CROPT': [120, 200],
};

function getPrice(category, code) {
  const catUpper = (category || '').toUpperCase();
  let range = [120, 220];
  for (const [key, val] of Object.entries(PRICE_RANGES)) {
    if (catUpper.includes(key)) {
      range = val;
      break;
    }
  }
  // Deterministic pseudo-random based on code
  let hash = 0;
  for (let i = 0; i < code.length; i++) hash = ((hash << 5) - hash) + code.charCodeAt(i);
  hash = Math.abs(hash);
  return range[0] + (hash % (range[1] - range[0] + 1));
}

async function getAuth() {
  const auth = new google.auth.GoogleAuth({
    keyFile: SERVICE_ACCOUNT_PATH,
    scopes: ['https://www.googleapis.com/auth/spreadsheets.readonly'],
  });
  return auth.getClient();
}

async function readInventory() {
  const auth = await getAuth();
  const sheets = google.sheets({ version: 'v4', auth });

  // Read all INVENTARIO rows
  const res = await sheets.spreadsheets.values.get({
    spreadsheetId: SHEET_ID,
    range: `'INVENTARIO'!A:J`,
  });

  const rows = res.data.values || [];
  if (rows.length < 2) return [];

  const headers = rows[0];
  const data = rows.slice(1);

  // Group by CODIGO GENERAL
  const productsMap = new Map();

  for (const row of data) {
    const [escaneado, codigo, codigoGeneral, modelo, marca, grupo, talla, color, observacion, estado] = row;
    if (!codigoGeneral) continue;

    const inStock = (estado || '').toUpperCase() !== 'VENDIDO';

    if (!productsMap.has(codigoGeneral)) {
      productsMap.set(codigoGeneral, {
        code: codigoGeneral,
        name: modelo,
        brand: marca,
        category: grupo,
        sizes: new Set(),
        colors: new Set(),
        totalItems: 0,
        availableCount: 0,
        items: []
      });
    }

    const prod = productsMap.get(codigoGeneral);
    prod.totalItems++;
    if (talla) prod.sizes.add(talla);
    if (color) prod.colors.add(color);
    if (inStock) prod.availableCount++;

    prod.items.push({
      barcode: codigo,
      size: talla || 'ESTANDAR',
      color: color || 'ÚNICO',
      inStock
    });
  }

  // Convert to array with prices
  const products = [];
  for (const [code, data] of productsMap) {
    products.push({
      id: code,
      code,
      name: data.name,
      brand: data.brand,
      category: data.category,
      price: getPrice(data.category, code),
      inStock: data.availableCount > 0,
      stockCount: data.availableCount,
      totalItems: data.totalItems,
      sizes: Array.from(data.sizes).sort(),
      colors: Array.from(data.colors).sort(),
      items: data.items,  // Keep items for variant checking
      description: `Exclusivo diseño ${data.name} confeccionado por ${data.brand}. Tejido premium con acabados de alta costura.`,
      featured: data.availableCount > 0 && Math.random() < 0.3
    });
  }

  // Sort: in stock first, then featured
  products.sort((a, b) => (b.inStock - a.inStock) || (b.featured - a.featured));

  return products;
}

async function searchProducts(query) {
  const products = await readInventory();
  const q = query.toLowerCase();

  // Color aliases for better matching
  const colorAliases = {
    'negra': 'NEGRO', 'negro': 'NEGRO',
    'blanca': 'BLANCO', 'blanco': 'BLANCO',
    'roja': 'ROJO', 'rojo': 'ROJO',
    'azul': 'AZUL', 'verde': 'VERDE',
    'rosa': 'ROSA', 'beige': 'BEIGE',
    'café': 'CAFE', 'cafe': 'CAFE',
    'celeste': 'CELESTE', 'morado': 'MORADO',
    'violeta': 'VIOLETA', 'amarilla': 'AMARILLO',
    'amarillo': 'AMARILLO', 'naranja': 'NARANJA',
    'plomo': 'PLOMO', 'gris': 'GRIS',
    'crema': 'CREMA', 'camel': 'CAMEL',
    'mostaza': 'MOSTAZA', 'turquesa': 'TURQUESA',
    'guindo': 'GUINDO', 'palo de rosa': 'PALO DE ROSA',
  };

  // Split query into words for flexible matching
  const words = q.split(/\s+/).filter(w => w.length > 1);

  return products.filter(p => {
    const name = p.name.toLowerCase();
    const code = p.code.toLowerCase();
    const brand = p.brand.toLowerCase();
    const category = p.category.toLowerCase();
    const colors = p.colors.map(c => c.toLowerCase());
    const sizes = p.sizes.map(s => s.toLowerCase());

    // Match: each word must match somewhere (name, code, brand, category, colors, sizes)
    // For colors, also check aliases
    return words.every(word => {
      const directMatch =
        name.includes(word) ||
        code.includes(word) ||
        brand.includes(word) ||
        category.includes(word) ||
        sizes.some(s => s.includes(word));

      // Check colors with aliases
      const colorMatch = colors.some(c => {
        if (c.includes(word)) return true;
        // Check if word is an alias for this color
        for (const [alias, canonical] of Object.entries(colorAliases)) {
          if (word === alias && c === canonical.toLowerCase()) return true;
        }
        return false;
      });

      return directMatch || colorMatch;
    });
  });
}

async function getProductByCode(code) {
  const products = await readInventory();
  return products.find(p => p.code === code.toUpperCase());
}

async function checkStock(code, color, size) {
  const product = await getProductByCode(code);
  if (!product) return { found: false, message: 'Producto no encontrado' };

  const hasColor = !color || product.colors.some(c => c.toLowerCase() === color.toLowerCase());
  const hasSize = !size || product.sizes.some(s => s.toLowerCase() === size.toLowerCase());

  if (!hasColor || !hasSize) {
    return {
      found: true,
      product,
      available: false,
      message: `No hay stock para ${color || 'ese color'} / ${size || 'esa talla'}`
    };
  }

  // Check specific variant stock
  const variant = product.items.find(i =>
    i.inStock &&
    (!color || i.color.toLowerCase() === color.toLowerCase()) &&
    (!size || i.size.toLowerCase() === size.toLowerCase())
  );

  return {
    found: true,
    product,
    available: !!variant,
    stockCount: variant ? 1 : 0,
    message: variant
      ? `Disponible: ${product.name} ${color ? `(${color})` : ''} ${size ? `(${size})` : ''} - Bs. ${product.price}`
      : `Sin stock para esa combinación`
  };
}

module.exports = {
  readInventory,
  searchProducts,
  getProductByCode,
  checkStock,
  getPrice
};