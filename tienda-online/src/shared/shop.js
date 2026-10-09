// shop.js — carga dinámica del catálogo + helpers + cards + quick view
// Sin frameworks: fetch a /data/*.json (generados por scripts/export-json.cjs)

const COLOR_HEX = {
  'PALO DE ROSA': '#E3B7B0', 'ROSA': '#E6A8A4', 'NEGRO': '#222222',
  'BEIGE': '#E2D5C3', 'CAFE CLARO': '#C9AE8C', 'BLANCO': '#FAF8F5',
  'CREMA': '#F3EAD8', 'AZUL': '#3F5368', 'AZUL MARINO': '#2B3A55',
  'AZUL OXIDO': '#4A5D6B', 'CELESTE': '#A9CCE3', 'CELESTE OSCURO': '#6FA8C9',
  'VERDE': '#5C7461', 'VERDE CLARO': '#9DB89A', 'VERDE OLIVA': '#7A7A4D',
  'VERDE OSCURO': '#3E5C43', 'ROJO': '#A93B3B', 'GUINDO': '#6E1423',
  'LILA': '#C4A8D0', 'VIOLETA': '#7C5CBF', 'MORADO': '#6D4AA0',
  'PLOMO': '#9C9893', 'PLOMO CLARO': '#C4C1BC', 'GRIS': '#9C9893',
  'AMARILLO': '#F2BA1D', 'MOSTAZA': '#E6AA18', 'NARANJA': '#E07B39',
  'TURQUESA': '#4FB0A8', 'CAFÉ': '#6F5141', 'CAFE': '#6F5141',
  'MARRON': '#6F5141', 'CAMEL': '#C59556', 'NUDE': '#D9BFA6', 'CORAL': '#EE847B'
};
const COLOR_KEYS = Object.keys(COLOR_HEX).sort((a, b) => b.length - a.length);

export function colorHex(name) {
  if (!name) return '#D8CEBF';
  const c = String(name).trim().toUpperCase();
  for (const k of COLOR_KEYS) if (c.includes(k)) return COLOR_HEX[k];
  return '#D8CEBF';
}

export const money = (n) => 'Bs. ' + Number(n).toFixed(2);

export const IMG_PLACEHOLDER =
  'data:image/svg+xml;utf8,' + encodeURIComponent(
    '<svg xmlns="http://www.w3.org/2000/svg" width="600" height="800" viewBox="0 0 600 800">' +
    '<rect width="600" height="800" fill="#F5F3ED"/>' +
    '<circle cx="300" cy="330" r="72" fill="none" stroke="#E8B930" stroke-width="3"/>' +
    '<text x="300" y="352" font-family="Georgia,serif" font-size="56" font-weight="600" fill="#0A0A0A" text-anchor="middle">K</text>' +
    '<text x="300" y="450" font-family="Arial,sans-serif" font-size="22" letter-spacing="6" fill="#0A0A0A" text-anchor="middle">KARMYLIS</text>' +
    '<text x="300" y="482" font-family="Arial,sans-serif" font-size="16" letter-spacing="3" fill="#6B6760" text-anchor="middle">FOTO PROXIMAMENTE</text></svg>'
  );

export function imgFallback(el) {
  if (el.dataset.fb) return;
  el.dataset.fb = '1';
  el.src = IMG_PLACEHOLDER;
}
window.kImgFallback = function (el) { imgFallback(el); };

// ---------- data ----------
let _cache = null;
export async function loadCatalog() {
  if (_cache) return _cache;
  const [p, c, s] = await Promise.all([
    fetch('data/products.json').then((r) => { if (!r.ok) throw new Error('products'); return r.json(); }),
    fetch('data/categories.json').then((r) => { if (!r.ok) throw new Error('cats'); return r.json(); }),
    fetch('data/store.json').then((r) => { if (!r.ok) throw new Error('store'); return r.json(); })
  ]);
  _cache = { products: p, categories: c, store: s };
  return _cache;
}

export function filterProducts(products, { cat = 'Todas', q = '', stock = false, favs = null, sort = 'featured' }) {
  const query = q.trim().toLowerCase();
  const out = products.filter((p) => {
    if (cat !== 'Todas' && String(p.category).toLowerCase() !== String(cat).toLowerCase()) return false;
    if (query && !(p.name.toLowerCase().includes(query) || p.brand.toLowerCase().includes(query) || p.code.toLowerCase().includes(query))) return false;
    if (stock && !p.inStock) return false;
    if (favs && !favs.includes(p.id)) return false;
    return true;
  });
  if (sort === 'price-asc') out.sort((a, b) => a.price - b.price);
  else if (sort === 'price-desc') out.sort((a, b) => b.price - a.price);
  else if (sort === 'name') out.sort((a, b) => a.name.localeCompare(b.name));
  else out.sort((a, b) => (b.featured ? 1 : 0) - (a.featured ? 1 : 0));
  return out;
}

// ---------- favorites (localStorage) ----------
const FKEY = 'karmylis-favs';
export function getFavs() {
  try { return JSON.parse(localStorage.getItem(FKEY)) || []; } catch { return []; }
}
export function toggleFav(id) {
  const f = getFavs();
  const next = f.includes(id) ? f.filter((x) => x !== id) : [...f, id];
  try { localStorage.setItem(FKEY, JSON.stringify(next)); } catch { /* noop */ }
  document.dispatchEvent(new CustomEvent('k:favs', { detail: next }));
  return next;
}

// ---------- card HTML ----------
export function cardHTML(p, isFav) {
  const flag = !p.inStock
    ? '<span class="k-flag sold">Agotado</span>'
    : (p.stockCount <= 2 ? `<span class="k-flag low">Últimas ${p.stockCount}</span>` : '');
  const dots = (p.colors || []).slice(0, 4)
    .map((c) => `<span class="k-dot" style="background-color:${colorHex(c)}" title="${c}"></span>`).join('');
  return (
    `<div class="k-card" data-id="${p.id}">` +
    `<div class="k-card-media" data-act="view" role="button" tabindex="0" aria-label="Ver ${p.name}">` +
    `<img src="${p.image}" alt="${p.name}" loading="lazy" onerror="kImgFallback(this)">` +
    flag +
    `<button class="k-fav${isFav ? ' on' : ''}" data-act="fav" aria-label="Guardar en favoritos">` +
    `<svg width="16" height="16" viewBox="0 0 24 24" fill="${isFav ? 'currentColor' : 'none'}" stroke="currentColor" stroke-width="1.8"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>` +
    `</button>` +
    `<button class="k-quick" data-act="add"${p.inStock ? '' : ' disabled'}>${p.inStock ? '+ Añadir' : 'Agotado'}</button>` +
    `</div>` +
    `<div class="k-card-body">` +
    `<div class="k-card-brand"><span>${p.brand}</span><span>${p.code}</span></div>` +
    `<h3 class="k-card-title" data-act="view">${p.name}</h3>` +
    `<p class="k-card-price">${money(p.price)}</p>` +
    `<div class="k-dots">${dots}</div>` +
    `</div></div>`
  );
}

// ---------- quick view modal ----------
export function openQuickView(p, store) {
  closeQuickView();
  const sizes = (p.sizes || []).map((s) => `<em>${s}</em>`).join('');
  const colors = (p.colors || []).map((c) =>
    `<em><i class="k-mini" style="background-color:${colorHex(c)}"></i>${c}</em>`).join('');
  const wa = `https://wa.me/${store.whatsappNumber}?text=` + encodeURIComponent(
    `Hola Karmylis, consulto por ${p.name} (Cód: ${p.code}) de Bs. ${Number(p.price).toFixed(2)}.`);
  const ov = document.createElement('div');
  ov.className = 'k-modal-ov';
  ov.id = 'kQuick';
  ov.innerHTML =
    `<div class="k-modal" role="dialog" aria-modal="true" aria-label="${p.name}">` +
    `<button class="k-modal-x" data-close aria-label="Cerrar">✕</button>` +
    `<div class="k-modal-grid">` +
    `<div class="k-modal-img"><img src="${p.image}" alt="${p.name}" onerror="kImgFallback(this)"></div>` +
    `<div class="k-modal-body">` +
    `<span class="k-eyebrow">${p.brand} · Cód ${p.code}</span>` +
    `<h2>${p.name}</h2>` +
    `<p class="k-modal-price">${money(p.price)}</p>` +
    `<p class="k-stock${p.inStock ? '' : ' out'}">${p.inStock ? `● Disponible (${p.stockCount} en inventario)` : '● Agotada temporalmente'}</p>` +
    `<p class="k-modal-desc">${p.description || ''}</p>` +
    `<div class="k-attr"><span>Tallas</span><div class="k-attr-tags">${sizes}</div></div>` +
    `<div class="k-attr"><span>Colores</span><div class="k-attr-tags">${colors}</div></div>` +
    `<div class="k-modal-acts">` +
    `<button class="btn-pill btn-pill-primary" data-add${p.inStock ? '' : ' disabled'}>${p.inStock ? 'Añadir a la bolsa' : 'Agotada'}</button>` +
    `<a class="btn-pill btn-pill-ghostl" href="${wa}" target="_blank" rel="noreferrer">Consultar por WhatsApp</a>` +
    `</div></div></div></div>`;
  ov.addEventListener('click', (e) => {
    if (e.target.closest('[data-close]') || e.target === ov) closeQuickView();
    const add = e.target.closest('[data-add]');
    if (add && !add.disabled) {
      document.dispatchEvent(new CustomEvent('k:add', { detail: p.id }));
      closeQuickView();
    }
  });
  document.body.appendChild(ov);
  document.body.style.overflow = 'hidden';
}
export function closeQuickView() {
  const ov = document.getElementById('kQuick');
  if (ov) ov.remove();
  document.body.style.overflow = '';
}
