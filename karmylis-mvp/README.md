# Karmylis MVP - Flujo WhatsApp → n8n → Gemini → Google Sheets

## ✅ Qué funciona ya (local, sin API keys externas)

### 1. Inventario real desde Google Sheets
- Lee la hoja `INVENTARIO` (197 productos, 190 en stock)
- Agrupa por `CODIGO GENERAL` (ej: CHRYSV2)
- Calcula precios por categoría (determinístico por código)
- Expone: stock, tallas, colores, precios reales

### 2. Motor de búsqueda inteligente
- `searchProducts(query)` - busca por nombre, código, marca, categoría, color, talla
- Maneja aliases de color: "negra" → "NEGRO", "café" → "CAFE", etc.
- Match flexible: cada palabra debe coincidir en algún campo

### 3. Verificación de stock exacta
- `checkStock(code, color, size)` - verifica variante específica
- Usa datos reales de la hoja (items con ESTADO ≠ VENDIDO)

### 4. Clasificador de intención (mock, listo para Gemini real)
- `SALUDO` - "Hola" → respuesta de bienvenida
- `CONSULTAR_STOCK` - "¿Tienen chompa negra talla M?"
- `CONSULTAR_PRODUCTO` - "Busco polera algodon"
- `CONSULTAR_PRECIO` - "¿Cuánto cuesta la chompa boton dorado?"
- `FUERA_DE_ALCANCE` - "Quiero fibonacci en python" → rechazo educado

### 5. API HTTP local (Express en puerto 3000)
```
POST /process              → Procesa mensaje completo (clasifica + herramientas)
GET  /inventory            → Catálogo completo
GET  /inventory/search?q=  → Buscar productos
GET  /inventory/:code      → Ficha de producto
GET  /inventory/:code/stock?color=&size= → Stock variante
```

---

## 📁 Estructura del proyecto

```
karmylis-mvp/
├── service-account.json          # Credenciales Google (NO commitear)
├── .env.example                  # Variables de entorno
├── package.json
├── Dockerfile.gemini             # Para contenedor Gemini proxy
├── functions/
│   ├── inventory.js              # Lectura Google Sheets + precios
│   ├── gemini.js                 # Clasificación + tools (mock + real)
│   └── server.js                 # API Express
├── n8n/
│   ├── docker-compose.yml        # Levanta n8n + Gemini proxy
│   └── workflows/
│       └── whatsapp-inventory.json  # Workflow n8n (importar en UI)
└── test*.js                      # Scripts de prueba
```

---

## 🚀 Cómo probar localmente

### 1. Instalar dependencias
```bash
cd karmylis-mvp
npm install
```

### 2. Levantar servidor Gemini proxy
```bash
node functions/server.js
# Corre en http://localhost:3000
```

### 3. Probar endpoints
```bash
# Salud
curl http://localhost:3000/health

# Procesar mensaje (flujo completo mock)
curl -X POST http://localhost:3000/process \
  -H "Content-Type: application/json" \
  -d '{"text": "¿Tienen chompa rayas suave negra talla estandar?"}'

# Buscar productos
curl "http://localhost:3000/inventory/search?q=chompa negra"

# Ver stock específico
curl "http://localhost:3000/inventory/CHRYSV2/stock?color=NEGRO&size=ESTANDAR"
```

### 4. Levantar n8n (opcional, para probar webhook)
```bash
cd n8n
docker-compose up -d
# UI en http://localhost:5678 (admin / karmylis2026)
# Importar workflow: workflows/whatsapp-inventory.json
# Webhook URL: http://localhost:5678/webhook/whatsapp
```

---

## 🔑 Próximos pasos para producción

### 1. Configurar Gemini API Key
```bash
# En .env
GEMINI_API_KEY=tu_key_de_aistudio_google_com
```
- En `functions/gemini.js`, cambiar `genAI` para usar la key real
- El modelo recomendado: `gemini-1.5-flash-8b` (barato, rápido)

### 2. Conectar n8n al Gemini proxy
En el workflow n8n, reemplazar el nodo "Gemini Classify" (Function) por **HTTP Request**:
- URL: `http://host.docker.internal:3000/process` (desde contenedor n8n)
- Method: POST
- Body: `{ "text": "{{$json.text}}" }`

### 3. Configurar WhatsApp Cloud API (Meta)
En `docker-compose.yml` o `.env`:
```
WHATSAPP_ACCESS_TOKEN=...
WHATSAPP_PHONE_NUMBER_ID=...
WHATSAPP_VERIFY_TOKEN=...
```
En Meta Developer Console:
- Webhook URL: `https://tu-dominio.com/webhook/whatsapp`
- Verify token: el mismo de arriba
- Subscribe to: `messages`

### 4. Exponer webhook públicamente (para testing real)
```bash
# Opción A: ngrok (gratis)
ngrok http 5678
# Usa la URL https://xxx.ngrok-free.app/webhook/whatsapp en Meta

# Opción B: Cloudflare Tunnel (gratis, más estable)
cloudflared tunnel run --url http://localhost:5678
```

### 5. Añadir columna PRECIO a Google Sheets (opcional)
Actualmente los precios se generan por código. Para precios reales:
1. En hoja INVENTARIO, añadir columna K = PRECIO
2. En `inventory.js`, leer esa columna en lugar de `getPrice()`

---

## 💰 Estimación de costos (MVP FIPAZ)

| Componente | Costo estimado |
|------------|----------------|
| Gemini 1.5 Flash-8b | ~$0.001 - 0.01/día (pocos tokens, clasificación simple) |
| Google Sheets API | Gratis (cuota generosa) |
| n8n self-hosted | Gratis (tu servidor) |
| WhatsApp Cloud API | ~$0.005 - 0.03/conversación (categoría utility) |
| Servidor (VPS pequeño) | ~$5-10/mes |

---

## 🔒 Seguridad

- **NO** commitear `service-account.json` ni `.env`
- Service Account solo con rol **Viewer** en el Sheet
- Gemini solo tiene tools definidas (no acceso libre a Sheets)
- n8n con Basic Auth activado
- WhatsApp webhook verifica signature (implementar en n8n)

---

## 📝 Notas importantes

1. **El mock classifier** en `gemini.js` funciona sin API key para desarrollo
2. **Precios** son determinísticos por código (mismo código = mismo precio siempre)
3. **Stock** viene de `ESTADO` ≠ 'VENDIDO' en la hoja INVENTARIO
4. **Imágenes** no están en Sheets - usar las de tu web (`/products/{CODE}.jpg`)
5. **Reservas/pedidos** - siguiente fase (requiere escribir en Sheets)