// home.js — landing: chrome + novedades dinámicas + rotación de looks
import './index.css';
import './App.css';
import { loadCatalog, cardHTML, openQuickView, getFavs, toggleFav } from './shared/shop.js';
import { mountChrome, patchNavStyles, addToCart, renderBadges, reveal, toast } from './shared/chrome.js';

document.documentElement.classList.add('js');

const LOOKS = [
  { img: 'products/CHRYSV2.jpg', cat: 'Chompa', price: 236 },
  { img: 'products/VESATB1.jpg', cat: 'Vestido', price: 262 },
  { img: 'products/CQJECT1.jpg', cat: 'Chaqueta', price: 199 }
];
let lookIdx = 0;

async function init() {
  let ALL = [], STORE = null, total = 0;
  try {
    const data = await loadCatalog();
    ALL = data.products; STORE = data.store; total = ALL.length;
  } catch { /* novedades will show error */ }

  mountChrome('inicio', STORE || { whatsappNumber: '59170000000' }, total);
  patchNavStyles();
  renderBadges();

  // hero look rotation
  const btns = [...document.querySelectorAll('.k-lookbtn')];
  setInterval(() => {
    lookIdx = (lookIdx + 1) % LOOKS.length;
    btns.forEach((b, i) => b.classList.toggle('on', i === lookIdx));
  }, 7000);
  btns.forEach((b, i) => b.addEventListener('click', () => {
    lookIdx = i;
    btns.forEach((x, j) => x.classList.toggle('on', j === lookIdx));
  }));

  // novedades (10)
  const grid = document.getElementById('newGrid');
  if (!ALL.length) {
    grid.innerHTML = '<p style="color:var(--color-lead)">No se pudo cargar novedades. <a href="catalogo.html" style="text-decoration:underline">Ir al catálogo →</a></p>';
  } else {
    const favs = getFavs();
    grid.innerHTML = ALL.slice(0, 10).map((p) => cardHTML(p, favs.includes(p.id))).join('');
    grid.addEventListener('click', (e) => {
      const card = e.target.closest('.k-card');
      if (!card) return;
      const p = ALL.find((x) => x.id === card.dataset.id);
      if (!p) return;
      const act = e.target.closest('[data-act]')?.dataset.act;
      if (act === 'fav') {
        e.stopPropagation();
        toggleFav(p.id);
        const on = getFavs().includes(p.id);
        const btn = card.querySelector('.k-fav');
        btn.classList.toggle('on', on);
        btn.querySelector('svg').setAttribute('fill', on ? 'currentColor' : 'none');
        renderBadges();
        if (on) toast('Guardado en tu lista de deseos');
      } else if (act === 'add') {
        e.stopPropagation();
        addToCart(p);
      } else {
        openQuickView(p, STORE);
      }
    });
  }
  document.addEventListener('k:add', (e) => {
    const p = ALL.find((x) => x.id === e.detail);
    if (p) addToCart(p);
  });
  document.addEventListener('k:favs', () => renderBadges());

  // hero counters
  const cc = document.getElementById('statCount');
  if (cc && total) cc.textContent = total + '+';
  const cc2 = document.getElementById('statCount2');
  if (cc2 && total) cc2.textContent = total;

  reveal();
}

init();