const express = require('express');
const { processMessage } = require('./gemini');
const { readInventory, searchProducts, checkStock, getProductByCode } = require('./inventory');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'karmylis-gemini-proxy' });
});

// Process message through Gemini + tools
app.post('/process', async (req, res) => {
  try {
    const { text, from } = req.body;
    if (!text) {
      return res.status(400).json({ error: 'text is required' });
    }

    const result = await processMessage(text);
    res.json({ success: true, ...result });
  } catch (err) {
    console.error('Process error:', err);
    res.status(500).json({ error: err.message });
  }
});

// Direct inventory endpoints (bypass Gemini for testing)
app.get('/inventory', async (req, res) => {
  try {
    const products = await readInventory();
    res.json({ success: true, count: products.length, products });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get('/inventory/search', async (req, res) => {
  try {
    const { q } = req.query;
    if (!q) return res.status(400).json({ error: 'q parameter required' });
    const products = await searchProducts(q);
    res.json({ success: true, count: products.length, products });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get('/inventory/:code', async (req, res) => {
  try {
    const product = await getProductByCode(req.params.code);
    if (!product) return res.status(404).json({ error: 'Not found' });
    res.json({ success: true, product });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get('/inventory/:code/stock', async (req, res) => {
  try {
    const { color, size } = req.query;
    const result = await checkStock(req.params.code, color, size);
    res.json({ success: true, ...result });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Karmylis Gemini Proxy listening on port ${PORT}`);
});