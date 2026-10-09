const { google } = require('googleapis');
const fs = require('fs');
const path = require('path');

// Config
const SHEET_ID = '1XbxDpw62hyxbQr7qxOI5N8ULuSygujfkB2BRyTPm3LM';
const SERVICE_ACCOUNT_PATH = path.join(__dirname, 'service-account.json');

async function main() {
  try {
    const auth = new google.auth.GoogleAuth({
      keyFile: SERVICE_ACCOUNT_PATH,
      scopes: ['https://www.googleapis.com/auth/spreadsheets.readonly'],
    });

    const sheets = google.sheets({ version: 'v4', auth });

    // 1. List all sheet names
    const meta = await sheets.spreadsheets.get({ spreadsheetId: SHEET_ID });
    console.log('=== HOJAS DISPONIBLES ===');
    meta.data.sheets.forEach(s => console.log(`- ${s.properties.title} (gid: ${s.properties.sheetId})`));

    // 2. Read first few rows of each sheet to understand structure
    for (const sheet of meta.data.sheets) {
      const title = sheet.properties.title;
      console.log(`\n=== PRIMERAS 5 FILAS DE: ${title} ===`);
      const res = await sheets.spreadsheets.values.get({
        spreadsheetId: SHEET_ID,
        range: `'${title}'!A1:Z5`,
      });
      console.table(res.data.values || []);
    }

    // 3. Read INVENTARIO sheet fully (first 20 rows)
    console.log('\n=== INVENTARIO - PRIMERAS 20 FILAS ===');
    const inv = await sheets.spreadsheets.values.get({
      spreadsheetId: SHEET_ID,
      range: `'INVENTARIO'!A1:Z20`,
    });
    console.table(inv.data.values || []);

  } catch (err) {
    console.error('Error:', err.message);
    if (err.response) console.error(err.response.data);
  }
}

main();