require('dotenv').config();
const { GoogleGenerativeAI } = require('@google/generative-ai');
const { checkStock, searchProducts, getProductByCode } = require('./inventory');

// Load API key from env
const GEMINI_API_KEY = process.env.GEMINI_API_KEY;
if (!GEMINI_API_KEY) {
  console.warn('GEMINI_API_KEY no configurada. Usando mock.');
}

const genAI = GEMINI_API_KEY ? new GoogleGenerativeAI(GEMINI_API_KEY) : null;

// Model: gemini-3.5-flash (supports function calling)
const MODEL_NAME = 'gemini-3.5-flash';
// System prompt with strict tool definitions
const SYSTEM_PROMPT = `
Eres el asistente comercial de Karmylis, una tienda de ropa en Bolivia.
SOLO puedes ayudar con: productos, tallas, colores, precios, stock, reservas, pedidos, pagos, ubicación, horarios, asesor humano.
NO respondas preguntas fuera de ese alcance (programación, trivia, etc.).

Tienes estas herramientas (usa SOLO estas):
1. checkStock(code, color, size) - Verifica disponibilidad exacta
2. searchProducts(query) - Busca productos por texto libre
3. getProductByCode(code) - Obtiene ficha completa de un producto

REGLAS:
- NUNCA inventes precios, stock, tallas, colores.
- SIEMPRE usa las herramientas para obtener datos reales.
- Si el usuario pregunta algo fuera de alcance → responde: "Puedo ayudarte con productos, tallas, precios, disponibilidad, reservas y compras de Karmylis. ¿Qué prenda buscas?"
- Clasifica la intención del usuario en una de estas:
  CONSULTAR_PRODUCTO, CONSULTAR_STOCK, CONSULTAR_PRECIO, CONSULTAR_TALLAS,
  RESERVAR_PRODUCTO, CANCELAR_RESERVA, CONSULTAR_RESERVA,
  CREAR_PEDIDO, CONSULTAR_PEDIDO, METODOS_DE_PAGO, UBICACION, HORARIOS,
  HABLAR_CON_ASESOR, FUERA_DE_ALCANCE

Responde en JSON con esta estructura:
{
  "intent": "INTENCION",
  "parameters": { ... },
  "needsTool": true/false,
  "tool": "nombre_herramienta",
  "toolParams": { ... },
  "response": "respuesta natural para el cliente (si no needsTool)"
}
`;

// Tool definitions for Gemini function calling
const TOOLS = [{
  functionDeclarations: [
    {
      name: 'checkStock',
      description: 'Verifica disponibilidad exacta de un producto por código, color y talla',
      parameters: {
        type: 'OBJECT',
        properties: {
          code: { type: 'STRING', description: 'Código general del producto (ej: CHRYSV2)' },
          color: { type: 'STRING', description: 'Color buscado (ej: NEGRO)' },
          size: { type: 'STRING', description: 'Talla buscada (ej: ESTANDAR, M, L)' }
        },
        required: ['code']
      }
    },
    {
      name: 'searchProducts',
      description: 'Busca productos por nombre, categoría, marca, color o talla',
      parameters: {
        type: 'OBJECT',
        properties: {
          query: { type: 'STRING', description: 'Texto de búsqueda libre' }
        },
        required: ['query']
      }
    },
    {
      name: 'getProductByCode',
      description: 'Obtiene ficha completa de un producto por su código',
      parameters: {
        type: 'OBJECT',
        properties: {
          code: { type: 'STRING', description: 'Código general del producto (ej: CHRYSV2)' }
        },
        required: ['code']
      }
    }
  ]
}];

async function classifyIntent(userMessage) {
  if (!genAI) {
    return mockClassify(userMessage);
  }

  const model = genAI.getGenerativeModel({
    model: MODEL_NAME,
    systemInstruction: SYSTEM_PROMPT,
    tools: TOOLS,
    toolConfig: { functionCallingConfig: { mode: 'AUTO' } }
  });

  const chat = model.startChat();
  const result = await chat.sendMessage(userMessage);
  const response = result.response;

  const functionCalls = response.functionCalls();
  if (functionCalls && functionCalls.length > 0) {
    const call = functionCalls[0];
    let toolResult;

    switch (call.name) {
      case 'checkStock':
        toolResult = await checkStock(call.args.code, call.args.color, call.args.size);
        break;
      case 'searchProducts':
        toolResult = await searchProducts(call.args.query);
        break;
      case 'getProductByCode':
        toolResult = await getProductByCode(call.args.code);
        break;
      default:
        toolResult = { error: 'Herramienta desconocida' };
    }

    // Send tool result back to model for natural response
    const result2 = await chat.sendMessage([
      { functionResponse: { name: call.name, response: { result: toolResult } } }
    ]);
    const finalResponse = result2.response.text();

    return {
      intent: call.name.toUpperCase().replace('GETPRODUCTBYCODE', 'CONSULTAR_PRODUCTO')
        .replace('CHECKSTOCK', 'CONSULTAR_STOCK')
        .replace('SEARCHPRODUCTS', 'CONSULTAR_PRODUCTO'),
      parameters: call.args,
      needsTool: true,
      tool: call.name,
      toolParams: call.args,
      toolResult,
      response: finalResponse
    };
  }

  // No tool needed, direct response
  const text = response.text();
  try {
    return JSON.parse(text);
  } catch {
    return {
      intent: 'CONSULTAR_PRODUCTO',
      parameters: {},
      needsTool: false,
      response: text
    };
  }
}

// Mock classifier for testing without API key
function mockClassify(msg) {
  const lower = msg.toLowerCase();

  // Greeting
  if (lower.match(/^(hola|buenos|buenas|hey|holi)/)) {
    return {
      intent: 'SALUDO',
      parameters: {},
      needsTool: false,
      response: '¡Hola! Bienvenida a Karmylis. ¿En qué podemos ayudarte hoy? ¿Buscas alguna prenda en especial?'
    };
  }

  // Out of scope - CHECK FIRST before generic patterns
  if (lower.includes('fibonacci') || lower.includes('python') || lower.includes('program') || lower.includes('código') || lower.includes('code')) {
    return {
      intent: 'FUERA_DE_ALCANCE',
      parameters: {},
      needsTool: false,
      response: 'Puedo ayudarte con productos, tallas, precios, disponibilidad, reservas y compras de Karmylis. ¿Qué prenda estás buscando?'
    };
  }

  // Stock query patterns
  const stockPatterns = [
    /tienen\s+(.+?)\s+(talla|size)\s+(\w+)/i,
    /stock\s+(de\s+)?(.+)/i,
    /disponible\s+(.+)/i,
    /hay\s+(.+?)\s+en\s+(\w+)/i,
    /quedan\s+(.+)/i
  ];

  for (const pattern of stockPatterns) {
    const match = msg.match(pattern);
    if (match) {
      const product = match[1] || match[2] || '';
      return {
        intent: 'CONSULTAR_STOCK',
        parameters: { query: product.trim() },
        needsTool: true,
        tool: 'searchProducts',
        toolParams: { query: product.trim() },
        response: null
      };
    }
  }

  // Price query - extract product name
  if (lower.includes('precio') || lower.includes('cuánto') || lower.includes('cuanto') || lower.includes('vale')) {
    // Extract product name: remove question marks, price words, articles
    let query = msg
      .replace(/[¿?]/g, '')  // Remove question marks
      .replace(/cuánto\s+cuesta|cuanto\s+cuesta|precio\s+de|cuál\s+es\s+el\s+precio|cuanto\s+vale|cuánto\s+vale/gi, '')
      .replace(/precio/gi, '')
      .replace(/^(la|el|una|un)\s+/gi, '')
      .replace(/^\W+/, '')  // Remove leading non-word chars
      .trim();
    console.log('[DEBUG] Price query extracted:', query);
    return {
      intent: 'CONSULTAR_PRECIO',
      parameters: { query },
      needsTool: true,
      tool: 'searchProducts',
      toolParams: { query },
      response: null
    };
  }

  // Product search
  if (lower.includes('busco') || lower.includes('quiero') || lower.includes('buscar')) {
    const query = msg.replace(/busco|quiero|buscar/gi, '').trim();
    return {
      intent: 'CONSULTAR_PRODUCTO',
      parameters: { query },
      needsTool: true,
      tool: 'searchProducts',
      toolParams: { query },
      response: null
    };
  }

  // Default
  return {
    intent: 'CONSULTAR_PRODUCTO',
    parameters: { query: msg },
    needsTool: true,
    tool: 'searchProducts',
    toolParams: { query: msg },
    response: null
  };
}

async function processMessage(userMessage) {
  const classification = await classifyIntent(userMessage);

  if (classification.needsTool && classification.toolResult) {
    // Tool already executed, return the natural response
    return {
      intent: classification.intent,
      response: classification.response,
      data: classification.toolResult
    };
  }

  if (!classification.needsTool) {
    return {
      intent: classification.intent,
      response: classification.response,
      data: null
    };
  }

  // Execute tool manually (for mock mode)
  let toolResult;
  switch (classification.tool) {
    case 'checkStock':
      toolResult = await checkStock(classification.toolParams.code, classification.toolParams.color, classification.toolParams.size);
      break;
    case 'searchProducts':
      toolResult = await searchProducts(classification.toolParams.query);
      break;
    case 'getProductByCode':
      toolResult = await getProductByCode(classification.toolParams.code);
      break;
    default:
      toolResult = { error: 'Herramienta no implementada' };
  }

  // Generate natural response from tool result
  const response = generateResponse(classification.intent, toolResult, classification.toolParams);

  return {
    intent: classification.intent,
    response,
    data: toolResult
  };
}

function generateResponse(intent, data, params) {
  if (!data) return 'Disculpa, no pude obtener la información.';

  switch (intent) {
    case 'CONSULTAR_STOCK':
    case 'CONSULTAR_PRODUCTO':
      if (Array.isArray(data)) {
        if (data.length === 0) return 'No encontramos productos que coincidan con tu búsqueda.';
        if (data.length === 1) {
          const p = data[0];
          return `Tenemos **${p.name}** (${p.brand}) en ${p.category}. Precio: **Bs. ${p.price}**. Colores: ${p.colors.join(', ')}. Tallas: ${p.sizes.join(', ')}. ${p.inStock ? `Stock: ${p.stockCount} disponibles.` : 'Agotado temporalmente.'}`;
        }
        return `Encontré **${data.length} productos** que coinciden:\n` +
          data.slice(0, 5).map(p => `• **${p.name}** (${p.code}) - Bs. ${p.price} - ${p.colors.join('/')} - ${p.sizes.join('/')}`).join('\n') +
          (data.length > 5 ? `\n... y ${data.length - 5} más.` : '');
      }
      if (data.found && data.available) {
        return `✅ **Sí hay stock**. ${data.message}`;
      }
      if (data.found && !data.available) {
        return `❌ **No hay stock** para esa combinación. ${data.message}`;
      }
      return data.message || 'Consulta procesada.';

    case 'CONSULTAR_PRECIO':
      if (Array.isArray(data) && data.length > 0) {
        const p = data[0];
        return `El precio de **${p.name}** es **Bs. ${p.price}**.`;
      }
      return 'No pude encontrar el precio.';

    case 'FUERA_DE_ALCANCE':
      return data;

    case 'SALUDO':
      return data;

    default:
      return '¿En qué más puedo ayudarte?';
  }
}

module.exports = { processMessage, classifyIntent };