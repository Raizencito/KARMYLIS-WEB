import os
import shutil
import zipfile
import json
import random
import xml.etree.ElementTree as ET

# Paths
BASE_DIR = os.path.abspath(r'c:\Users\ALAN\PROTOTIPO PAG WEB')
EXCEL_PATH = os.path.join(BASE_DIR, 'CONTEXTO', 'INVENTARIO K4 NEW PROYECT (2).xlsx')
APP_DIR = os.path.join(BASE_DIR, 'tienda-online')
PUBLIC_PRODUCTS_DIR = os.path.join(APP_DIR, 'public', 'products')
PUBLIC_BANNERS_DIR = os.path.join(APP_DIR, 'public', 'banners')
SRC_DATA_DIR = os.path.join(APP_DIR, 'src', 'data')
REF_DIR = os.path.join(BASE_DIR, 'ref')

os.makedirs(PUBLIC_PRODUCTS_DIR, exist_ok=True)
os.makedirs(PUBLIC_BANNERS_DIR, exist_ok=True)
os.makedirs(SRC_DATA_DIR, exist_ok=True)

print("Iniciando extracción desde el Excel...")

with zipfile.ZipFile(EXCEL_PATH, 'r') as z:
    # 1. Shared Strings
    sst_tree = ET.fromstring(z.read('xl/sharedStrings.xml'))
    ns_s = {'s': 'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}
    sst = []
    for si in sst_tree.findall('s:si', ns_s):
        texts = [t.text for t in si.findall('.//s:t', ns_s) if t.text]
        sst.append("".join(texts))

    def get_cell_val(cell):
        val_el = cell.find('s:v', ns_s)
        if val_el is None or val_el.text is None:
            return ""
        raw = val_el.text
        if cell.attrib.get('t') == 's':
            try:
                return sst[int(raw)]
            except:
                return raw
        return raw

    # 2. Parse Sheet 2 (ARTICULOS)
    s2_tree = ET.fromstring(z.read('xl/worksheets/sheet2.xml'))
    code_by_row = {}
    brand_by_code = {}
    group_by_code = {}

    for r in s2_tree.findall('.//s:row', ns_s):
        row_idx = int(r.attrib['r']) - 1 # 0-indexed anchor row
        row_num = r.attrib['r']
        cells = {}
        for c in r.findall('s:c', ns_s):
            col_letter = ''.join(filter(str.isalpha, c.attrib['r']))
            cells[col_letter] = get_cell_val(c)
        
        # Col A = CODIGO, B = GRUPO, C = FOTO, D = PROVEEDOR, E = MARCA
        code = cells.get('A', '').strip()
        grupo = cells.get('B', '').strip()
        marca = cells.get('E', '').strip()

        if code and code != 'CODIGO':
            code_by_row[row_idx] = code
            brand_by_code[code] = marca
            group_by_code[code] = grupo

    print(f"Códigos encontrados en ARTICULOS: {len(code_by_row)}")

    # 3. Parse Drawings in Sheet 2 to extract photos
    d2_rels = ET.fromstring(z.read('xl/drawings/_rels/drawing2.xml.rels'))
    rel_map = {r.attrib['Id']: r.attrib['Target'] for r in d2_rels.findall('{http://schemas.openxmlformats.org/package/2006/relationships}Relationship')}

    d2_tree = ET.fromstring(z.read('xl/drawings/drawing2.xml'))
    ns_draw = {
        'xdr': 'http://schemas.openxmlformats.org/drawingml/2006/spreadsheetDrawing',
        'a': 'http://schemas.openxmlformats.org/drawingml/2006/main'
    }

    anchors = d2_tree.findall('xdr:twoCellAnchor', ns_draw) + d2_tree.findall('xdr:oneCellAnchor', ns_draw)
    print(f"Total anclajes de imagen en drawing2: {len(anchors)}")

    code_to_image = {}
    extracted_count = 0

    for anchor in anchors:
        from_el = anchor.find('xdr:from', ns_draw)
        if from_el is None:
            continue
        row = int(from_el.find('xdr:row', ns_draw).text)
        pic = anchor.find('xdr:pic', ns_draw)
        if pic is not None:
            blip = pic.find('.//a:blip', ns_draw)
            if blip is not None:
                embed_id = blip.attrib.get('{http://schemas.openxmlformats.org/officeDocument/2006/relationships}embed')
                target = rel_map.get(embed_id)
                if target:
                    # Target is like '../media/image18.jpg'
                    media_path = target.replace('../', 'xl/')
                    code = code_by_row.get(row)
                    if code:
                        ext = os.path.splitext(media_path)[1] or '.jpg'
                        clean_code = "".join(c for c in code if c.isalnum() or c in ('-', '_')).upper()
                        out_filename = f"{clean_code}{ext}"
                        out_file_path = os.path.join(PUBLIC_PRODUCTS_DIR, out_filename)
                        
                        # Extract file
                        with open(out_file_path, 'wb') as f_out:
                            f_out.write(z.read(media_path))
                        
                        code_to_image[code] = f"/products/{out_filename}"
                        extracted_count += 1

    print(f"Imágenes extraídas con éxito y vinculadas a códigos: {extracted_count}")

    # 4. Parse Sheet 1 (INVENTARIO)
    s1_tree = ET.fromstring(z.read('xl/worksheets/sheet1.xml'))
    inventory_by_general_code = {}

    for r in s1_tree.findall('.//s:row', ns_s):
        row_num = r.attrib['r']
        cells = {}
        for c in r.findall('s:c', ns_s):
            col_letter = ''.join(filter(str.isalpha, c.attrib['r']))
            cells[col_letter] = get_cell_val(c)

        # Cols:
        # A: ESCANEADO
        # B: CODIGO (barcode)
        # C: CODIGO GENERAL
        # D: MODELO
        # E: MARCA
        # F: GRUPO
        # G: TALLA
        # H: COLOR
        # I: OBSERVACION
        # J: ESTADO
        barcode = cells.get('B', '').strip()
        general_code = cells.get('C', '').strip()
        modelo = cells.get('D', '').strip()
        marca = cells.get('E', '').strip()
        grupo = cells.get('F', '').strip()
        talla = cells.get('G', '').strip()
        color = cells.get('H', '').strip()
        estado = cells.get('J', '').strip()

        if not general_code or general_code == 'CODIGO GENERAL':
            continue

        if general_code not in inventory_by_general_code:
            inventory_by_general_code[general_code] = {
                'code': general_code,
                'name': modelo if modelo else general_code,
                'brand': marca if marca else brand_by_code.get(general_code, 'Karmylis'),
                'category': grupo if grupo else group_by_code.get(general_code, 'General'),
                'items': [],
                'sizes': set(),
                'colors': set(),
            }

        item_in_stock = (estado.upper() != 'VENDIDO')
        if talla:
            inventory_by_general_code[general_code]['sizes'].add(talla)
        if color:
            inventory_by_general_code[general_code]['colors'].add(color)

        inventory_by_general_code[general_code]['items'].append({
            'barcode': barcode,
            'size': talla or 'Estándar',
            'color': color or 'Único',
            'inStock': item_in_stock
        })

print(f"Total productos únicos en INVENTARIO: {len(inventory_by_general_code)}")

# Price ranges by category
def get_realistic_price(cat, code):
    random.seed(code)
    cat_upper = cat.upper()
    if 'CHOMPA' in cat_upper or 'ABRIGO' in cat_upper:
        return random.randint(180, 260)
    elif 'BLUSA' in cat_upper or 'POLERA' in cat_upper or 'TOP' in cat_upper:
        return random.randint(110, 190)
    elif 'VESTIDO' in cat_upper or 'CONJUNTO' in cat_upper:
        return random.randint(220, 340)
    elif 'PANTALON' in cat_upper or 'PALAZO' in cat_upper:
        return random.randint(150, 230)
    else:
        return random.randint(120, 220)

# Build final product list
products = []
categories_set = set()

# Normalize text nicely
def title_case(s):
    return " ".join(w.capitalize() for w in s.split())

for code, data in inventory_by_general_code.items():
    available_stock = sum(1 for it in data['items'] if it['inStock'])
    is_in_stock = available_stock > 0
    img_url = code_to_image.get(code)
    
    # Si no tiene imagen directa, buscar si el código normalizado coincide
    if not img_url:
        clean = "".join(c for c in code if c.isalnum() or c in ('-', '_')).upper()
        potential_path = os.path.join(PUBLIC_PRODUCTS_DIR, f"{clean}.jpg")
        if os.path.exists(potential_path):
            img_url = f"/products/{clean}.jpg"

    # Solo agregamos al catálogo principal o marcamos si tiene imagen o stock
    category_title = title_case(data['category'])
    categories_set.add(category_title)

    products.append({
        'id': code,
        'code': code,
        'name': title_case(data['name']),
        'brand': title_case(data['brand']) if data['brand'] else 'Karmylis',
        'category': category_title,
        'price': get_realistic_price(data['category'], code),
        'image': img_url if img_url else '/products/default_knit.jpg',
        'hasRealPhoto': bool(img_url),
        'inStock': is_in_stock,
        'stockCount': available_stock,
        'totalItems': len(data['items']),
        'sizes': sorted(list(data['sizes'])) if data['sizes'] else ['Estándar'],
        'colors': sorted(list(data['colors'])) if data['colors'] else ['Único'],
        'description': f"Exclusivo diseño {title_case(data['name'])} confeccionado por {title_case(data['brand']) if data['brand'] else 'Karmylis'}. Tejido premium con acabados de alta costura.",
        'featured': (img_url is not None and is_in_stock and random.random() < 0.35)
    })

# Sort so that products with real photos and stock appear first!
products.sort(key=lambda p: (not p['hasRealPhoto'], not p['inStock'], not p['featured']))

print(f"Productos listos: {len(products)} (con foto real: {sum(1 for p in products if p['hasRealPhoto'])})")

# 5. Copy reference banners from ref
ref_files = [f for f in os.listdir(REF_DIR) if f.lower().endswith(('.jpg', '.jpeg', '.png'))]
if ref_files:
    # Use selected high-impact images for hero and editorial
    hero_src = os.path.join(REF_DIR, ref_files[0])
    for f in ref_files:
        if 'kkz00Yhtby6y8DsElIEcJzWRVJHVXKAfJB3HqlWvhFGu3MAz2usBXJnIDbh0UnYCuMwoZfK_W7cXB31cMv2Q5V9pfJYalMa95sRnrDLQosbWkXu745ifRp1tvcKqhVmrOPZgw78Ask3ad0dFOS9FFNM-xJ4jfv89qKdvn2wsuhY0cCNVG_z2sUZ_I2yjIntE' in f:
            hero_src = os.path.join(REF_DIR, f)
            break
    
    editorial_src = os.path.join(REF_DIR, ref_files[1] if len(ref_files) > 1 else ref_files[0])
    for f in ref_files:
        if '5t45COlF3LIHnKyItm9BumgxHOxxqT_OD298tK15Qn2HkN8TCCm1UJbsfohqIO7SdSsVUHocSyk6oucdAdmOdbQ3tJrSs0QFmPgEx7jy_GW1sx4V11hHJVhwaROuRY7tzDGMTCFI3MfrHZyHBeHu8Sg1viR3SuW9TQr1R_6J8jv8AkqweBan_c3KnEx9D9YS' in f:
            editorial_src = os.path.join(REF_DIR, f)
            break

    shutil.copy2(hero_src, os.path.join(PUBLIC_BANNERS_DIR, 'hero-banner.jpg'))
    shutil.copy2(editorial_src, os.path.join(PUBLIC_BANNERS_DIR, 'editorial-story.jpg'))
    print("Banners de referencia copiados a public/banners/")

# 6. Generate JS File
categories_list = ['Todas'] + sorted(list(categories_set))

js_content = f"""// Catálogo y Datos de Inventario Karmylis
// Generado automáticamente desde el Excel de Inventario

export const categories = {json.dumps(categories_list, ensure_ascii=False, indent=2)};

export const products = {json.dumps(products, ensure_ascii=False, indent=2)};

export const storeInfo = {{
  name: "Karmylis",
  slogan: "Siluetas Atemporales & Moda Exclusiva",
  whatsappNumber: "59170000000", // Actualizable por el usuario
  currency: "Bs.",
  shippingNotice: "Envíos asegurados a toda Bolivia • Atención personalizada",
  editorialStory: {{
    subtitle: "THE KARMYLIS EDIT",
    title: "Prendas Diseñadas para Perdurar",
    description: "Cada pieza en nuestro catálogo es seleccionada por su calidad de tejido, textura envolvente y diseño atemporal. Prendas versátiles que elevan tu estilo diario con elegancia y confort.",
    cta: "Descubrir Colección",
    image: "/banners/editorial-story.jpg"
  }}
}};
"""

with open(os.path.join(SRC_DATA_DIR, 'productsData.js'), 'w', encoding='utf-8') as f:
    f.write(js_content)

print("¡Archivo productsData.js generado con éxito!")
