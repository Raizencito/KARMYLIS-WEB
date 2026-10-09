// catalogo.js — catálogo dinámico: fetch JSON + filtros + paginación
import './index.css';
import './App.css';
import { loadCatalog, filterProducts, cardHTML, openQuickView, getFavs, toggleFav } from './shared/shop.js';
import { mountChrome, patchNavStyles, addToCart, renderBadges, reveal, toast } from './shared/chrome.js';

document.documentElement.classList.add('js');

const PAGE_SIZE = 36;
let ALL = [];
let CATS = [];
let STORE = null;
let state = { cat: 'Todas', q: '', stock: false, favsOnly: false, sort: 'featured' };
let visible = PAGE_SIZE;

const grid = () => document.getElementById('grid');
const statusEl = () => document.getElementById('statusbar');

function currentList() {
  return filterProducts(ALL, {
    cat: state.cat, q: state.q, stock: state.stock,
    favs: state.favsOnly ? getFavs() : null, sort: state.sort
  });
}

function renderChips() {
  const box = document.getElementById('chips');
  box.innerHTML = CATS.map((c) =>
    `<button class="k-chip${state.cat === c ? ' on' : ''}" data-cat="${c}">${c}</button>`).join('');
}

function renderStatus(n) {
  const filtered = state.cat !== 'Todas' || state.q || state.stock || state.favsOnly;
  statusEl().innerHTML =
    `<span><strong>${n}</strong> prendas encontradas</span>` +
    (filtered ? `<button id="clearFilters">Quitar filtros ✕</button>` : '');
  document.getElementById('clearFilters')?.addEventListener('click', () => {
    Object.assign(state, { cat: 'Todas', q: '', stock: false, favsOnly: false, sort: 'featured' });
    document.getElementById('q').value = '';
    document.getElementById('stock').checked = false;
    document.getElementById('sort').value = 'featured';
    visible = PAGE_SIZE;
    renderAll();
  });
}

function renderGrid() {
  const list = currentList();
  const favs = getFavs();
  renderStatus(list.length);
  if (!list.length) {
    grid().innerHTML =
      `<div class="k-empty" style="grid-column:1/-1"><p style="font-size:40px">🔍</p>` +
      `<h3>Sin resultados</h3><p>Prueba con otra categoría o borra la búsqueda.</p></div>`;
    document.getElementById('moreWrap').hidden = true;
    return;
  }
  const slice = list.slice(0, visible);
  grid().innerHTML = slice.map((p) => cardHTML(p, favs.includes(p.id))).join('');
  const more = document.getElementById('moreWrap');
  more.hidden = list.length <= visible;
  document.getElementById('moreCount').textContent =
    `Mostrando ${slice.length} de ${list.length}`;
}

function renderAll() { renderChips(); renderGrid(); reveal(); }

function skeleton() {
  grid().innerHTML = Array.from({ length: 12 })
    .map(() => '<div class="k-card"><div class="k-card-media" style="background:linear-gradient(100deg,#eceae4 40%,#f5f3ed 50%,#eceae4 60%);background-size:200% 100%;animation:kShimmer 1.2s infinite"></div><div style="height:14px;background:#eceae4;border-radius:7px;margin-top:12px"></div><div style="height:14px;width:60%;background:#eceae4;border-radius:7px;margin-top:8px"></div></div>')
    .join('');
  const st = document.createElement('style');
  st.textContent = '@keyframes kShimmer{to{background-position:-200% 0}}';
  document.head.appendChild(st);
}

async function init() {
  const params = new URLSearchParams(location.search);
  if (params.get('cat')) state.cat = params.get('cat');
  if (params.get('q')) state.q = params.get('q');
  if (params.get('fav') === '1') state.favsOnly = true;
  if (params.get('stock') === '1') state.stock = true;

  skeleton();
  try {
    const data = await loadCatalog();
    ALL = data.products; CATS = data.categories; STORE = data.store;
  } catch {
    grid().innerHTML =
      `<div class="k-empty" style="grid-column:1/-1"><p style="font-size:40px">⚠️</p>` +
      `<h3>No se pudo cargar el catálogo</h3><p>Revisa tu conexión e inténtalo de nuevo.</p>` +
      `<button class="btn-pill btn-pill-primary" onclick="location.reload()">Reintentar</button></div>`;
    document.getElementById('moreWrap').hidden = true;
    return;
  }

  mountChrome('catalogo', STORE, ALL.length);
  patchNavStyles();
  renderBadges();
  document.getElementById('q').value = state.q;
  document.getElementById('stock').checked = state.stock;
  renderAll();

  // events
  document.getElementById('q').addEventListener('input', (e) => {
    state.q = e.target.value; visible = PAGE_SIZE; renderGrid(); reveal();
  });
  document.getElementById('stock').addEventListener('change', (e) => {
    state.stock = e.target.checked; visible = PAGE_SIZE; renderGrid(); reveal();
  });
  document.getElementById('sort').addEventListener('change', (e) => {
    state.sort = e.target.value; renderGrid(); reveal();
  });
  document.getElementById('chips').addEventListener('click', (e) => {
    const b = e.target.closest('[data-cat]');
    if (!b) return;
    state.cat = b.dataset.cat; state.favsOnly = false; visible = PAGE_SIZE;
    renderAll();
  });
  document.getElementById('moreBtn').addEventListener('click', () => {
    visible += PAGE_SIZE; renderGrid(); reveal();
  });

  // card actions (delegated)
  grid().addEventListener('click', (e) => {
    const card = e.target.closest('.k-card');
    if (!card) return;
    const p = ALL.find((x) => x.id === card.dataset.id);
    if (!p) return;
    const act = e.target.closest('[data-act]')?.dataset.act;
    if (act === 'fav') {
      e.stopPropagation();
      toggleFav(p.id);
      const btn = card.querySelector('.k-fav');
      const on = getFavs().includes(p.id);
      btn.classList.toggle('on', on);
      btn.querySelector('svg').setAttribute('fill', on ? 'currentColor' : 'none');
      renderBadges();
      if (!on) toast('Guardado en tu lista de deseos');
      if (state.favsOnly) renderGrid();
    } else if (act === 'add') {
      e.stopPropagation();
      addToCart(p);
    } else {
      openQuickView(p, STORE);
    }
  });
  grid().addEventListener('keydown', (e) => {
    if (e.key !== 'Enter') return;
    const media = e.target.closest('[data-act="view"]');
    if (!media) return;
    const p = ALL.find((x) => x.id === media.closest('.k-card').dataset.id);
    if (p) openQuickView(p, STORE);
  });

  document.addEventListener('k:add', (e) => {
    const p = ALL.find((x) => x.id === e.detail);
    if (p) addToCart(p);
  });
  document.addEventListener('k:favs', () => renderBadges());
}

init();
