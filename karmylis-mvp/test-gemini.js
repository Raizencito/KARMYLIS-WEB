require('dotenv').config();
const { GoogleGenerativeAI } = require('@google/generative-ai');

const GEMINI_API_KEY = process.env.GEMINI_API_KEY;
console.log('Key present:', !!GEMINI_API_KEY);
console.log('Key prefix:', GEMINI_API_KEY?.substring(0, 20));

if (!GEMINI_API_KEY) {
  console.log('No key');
  process.exit(1);
}

const genAI = new GoogleGenerativeAI(GEMINI_API_KEY);
const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });

async function test() {
  try {
    const result = await model.generateContent('Di solo "OK" si funcionas');
    const response = result.response;
    console.log('Gemini response:', response.text());
  } catch (err) {
    console.error('Gemini error:', err.message);
    if (err.response) console.error('Details:', err.response);
  }
}

test();