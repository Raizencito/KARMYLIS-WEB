const XLSX = require('xlsx');
const fs = require('fs');
const path = require('path');

const excelFilePath = path.join(__dirname, '..', 'CONTEXTO', 'INVENTARIO K4 NEW PROYECT (2).xlsx');
const outputPath = path.join(__dirname, 'src', 'mockData.js');

try {
  console.log('Leyendo el archivo Excel...');
  const workbook = XLSX.readFile(excelFilePath, { sheetRows: 200 }); 
  
  const sheetName = workbook.SheetNames[0]; 
  const worksheet = workbook.Sheets[sheetName];
  
  const rawData = XLSX.utils.sheet_to_json(worksheet, { header: 1 });
  
  const headerRowIndex = 0;
  
  const products = [];
  const categories = new Set();
  
  // Nombres de columnas observadas en consola
  const nameIdx = 3; // 'MODELO'
  const catIdx = 5; // 'GRUPO'
  const brandIdx = 4; // 'MARCA'
  const stateIdx = 9; // 'ESTADO'
  const codeIdx = 1; // 'CODIGO'
  
  for (let i = headerRowIndex + 1; i < rawData.length && products.length < 50; i++) {
    const row = rawData[i];
    if (!row || row.length === 0) continue;
    
    const name = String(row[nameIdx] || `Producto ${products.length + 1}`);
    const category = String(row[catIdx] || 'General');
    const brand = String(row[brandIdx] || 'Sin Marca');
    const state = String(row[stateIdx] || '');
    const code = String(row[codeIdx] || '');
    
    const inStock = state.trim().toUpperCase() !== 'VENDIDO';
    
    // Generar precio aleatorio entre 50 y 300
    const price = Math.floor(Math.random() * 250) + 50;
    
    if (name.length > 2 && name !== 'undefined') {
       categories.add(category);
       products.push({
         id: products.length + 1,
         code: code,
         name: `${name} - ${brand}`,
         price: price,
         category: category,
         image: `https://via.placeholder.com/300x400?text=${encodeURIComponent(name.substring(0, 15))}`,
         description: `Lindo modelo ${name} de la marca ${brand}.`,
         inStock: inStock
       });
    }
  }
  
  const mockCategories = [{ id: 1, name: "Todas" }];
  let catId = 2;
  categories.forEach(c => {
    mockCategories.push({ id: catId++, name: c });
  });

  const outputContent = `// Autogenerado desde el Excel\nexport const mockProducts = ${JSON.stringify(products, null, 2)};\n\nexport const mockCategories = ${JSON.stringify(mockCategories, null, 2)};\n`;

  fs.writeFileSync(outputPath, outputContent, 'utf-8');
  console.log('mockData.js generado correctamente con ' + products.length + ' productos reales del Excel.');

} catch (error) {
  console.error('Error procesando el Excel:', error.message);
}
