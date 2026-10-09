require('dotenv').config();
const { GoogleGenerativeAI } = require('@google/generative-ai');

const GEMINI_API_KEY = process.env.GEMINI_API_KEY;
const genAI = new GoogleGenerativeAI(GEMINI_API_KEY);

async function listModels() {
  try {
    const models = await genAI.listModels();
    console.log('Available models:');
    for (const model of models.models) {
      console.log(`  - ${model.name}: ${model.supportedGenerationMethods?.join(', ')}`);
    }
  } catch (err) {
    console.error('Error listing models:', err.message);
  }
}

listModels();