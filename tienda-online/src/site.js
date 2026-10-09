// site.js — páginas estáticas: chrome + formularios
import './index.css';
import './App.css';
import { loadCatalog } from './shared/shop.js';
import { mountChrome, patchNavStyles, renderBadges, reveal, toast } from './shared/chrome.js';

document.documentElement.classList.add('js');

async function init() {
  const page = document.body.dataset.page || 'inicio';
  let store = { whatsappNumber: '59170000000' };
  let total = 0;
  try {
    const data = await loadCatalog();
    store = data.store; total = data.products.length;
  } catch { /* chrome with fallback */ }
  mountChrome(page, store, total);
  patchNavStyles();
  renderBadges();

  document.getElementById('contactForm')?.addEventListener('submit', (e) => {
    e.preventDefault(); e.target.reset();
    toast('¡Mensaje recibido! Te contactaremos pronto.');
  });

  reveal();
}

init();