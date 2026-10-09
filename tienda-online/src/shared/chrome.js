// chrome.js — header, footer, carrito, toast (compartido por todas las páginas)
// El carrito vive en localStorage y funciona entre páginas (routing clásico).

const CKEY = 'karmylis-cart';

export function getCart() {
  try { return JSON.parse(localStorage.getItem(CKEY)) || []; } catch { return []; }
}
function saveCart(items) {
  try { localStorage.setItem(CKEY, JSON.stringify(items)); } catch { /* noop */ }
  document.dispatchEvent(new CustomEvent('k:cart', { detail: items }));
}
export function addToCart(product, size, color) {
  const s = size || (product.sizes && product.sizes[0]) || 'Estándar';
  const c = color || (product.colors && product.colors[0]) || 'Único';
  const key = `${product.id}-${s}-${c}`;
  const items = getCart();
  const ex = items.find((i) => i.key === key);
  if (ex) ex.qty += 1;
  else items.push({ ...product, key, selectedSize: s, selectedColor: c, qty: 1 });
  saveCart(items);
  toast(`Añadido a la bolsa: ${product.name}`);
  openCart();
}
export function cartCount() { return getCart().reduce((s, i) => s + i.qty, 0); }
export function cartTotal() { return getCart().reduce((s, i) => s + i.price * i.qty, 0); }
export function orderCode() {
  const items = getCart();
  if (!items.length) return null;
  const raw = items.map((i) => `${i.code}${i.selectedSize}${i.selectedColor}${i.qty}`).join('|');
  let h = 0;
  for (let k = 0; k < raw.length; k++) h = ((h << 5) - h + raw.charCodeAt(k)) | 0;
  return 'KRM-' + Math.abs(h).toString(36).toUpperCase().padStart(4, '0');
}

export function toast(msg) {
  document.querySelector('.k-toast')?.remove();
  const el = document.createElement('div');
  el.className = 'k-toast';
  el.innerHTML = '<b>✓</b> ' + msg;
  document.body.appendChild(el);
  setTimeout(() => el.remove(), 3000);
}

const NAV = [
  ['index.html', 'inicio', 'Inicio'],
  ['catalogo.html', 'catalogo', 'Catálogo'],
  ['lookbook.html', 'lookbook', 'Lookbook'],
  ['nosotros.html', 'nosotros', 'Nosotros'],
  ['reservas.html', 'reservas', 'Reservas'],
  ['contacto.html', 'contacto', 'Contacto']
];

const ICONS = {
  search: '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>',
  heart: '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>',
  bag: '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"></path><line x1="3" y1="6" x2="21" y2="6"></line><path d="M16 10a4 4 0 0 1-8 0"></path></svg>',
  x: '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>',
  arrow: '<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>',
  pin: '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>',
  wa: '<svg width="27" height="27" viewBox="0 0 24 24" fill="#fff"><path d="M12.031 2C6.496 2 2 6.496 2 12.031c0 1.94.55 3.765 1.516 5.32L2 22l4.805-1.484A9.972 9.972 0 0 0 12.03 22c5.535 0 10.031-4.496 10.031-10.031S17.566 2 12.03 2zm5.797 14.195c-.242.68-1.4 1.305-1.922 1.391-.484.086-1.117.125-3.562-.898-3.133-1.313-5.14-4.508-5.297-4.719-.156-.21-1.273-1.703-1.273-3.25 0-1.547.812-2.313 1.1-2.617.29-.305.633-.383.844-.383.21 0 .422.008.61.016.195.007.453-.07.71.547.266.633.907 2.21.985 2.375.078.164.133.359.023.578-.11.219-.164.359-.328.547-.164.188-.344.422-.492.563-.164.156-.336.328-.149.648.188.32.836 1.375 1.797 2.227 1.234 1.101 2.281 1.445 2.602 1.609.32.164.508.14.695-.078.188-.219.797-.93 1.016-1.25.219-.32.438-.266.734-.156.297.109 1.883.89 2.203 1.055.32.164.531.242.61.375.078.133.078.773-.164 1.453z"/></svg>'
};

export function mountChrome(page, store, totalProducts) {
  const waNum = store.whatsappNumber;
  const waHello = `https://wa.me/${waNum}?text=` + encodeURIComponent('Hola Karmylis, visito su tienda online y deseo consultar disponibilidad.');

  document.body.insertAdjacentHTML('afterbegin',
    `<div class="k-announce"><div class="k-announce-track">` +
    `<span>Envíos a toda Bolivia</span><span>•</span><span>Reserva con 50% de abono</span><span>•</span>` +
    `<span>Atención personalizada por WhatsApp</span><span>•</span>`.repeat(2) +
    `</div></div>` +
    `<header class="k-header"><div class="k-header-in">` +
    `<button class="k-icobtn k-burger" id="kBurger" aria-label="Abrir menú">` +
    `<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="18" x2="21" y2="18"/></svg></button>` +
    `<a class="k-logo" href="index.html"><img src="logo-web.jpg" alt="Karmylis">` +
    `<span class="k-logo-word"><strong>KARMYLIS</strong><small>MODA Y PASIÓN</small></span></a>` +
    `<nav class="k-nav">` + NAV.map(([href, id, label]) =>
      `<a href="${href}" class="${page === id ? 'on' : ''}">${label}` +
      (id === 'catalogo' && totalProducts ? `<span class="k-count">${totalProducts}</span>` : '') + `</a>`
    ).join('') + `</nav>` +
    `<div class="k-acts">` +
    `<a class="k-icobtn" href="catalogo.html" aria-label="Buscar">${ICONS.search}</a>` +
    `<a class="k-icobtn" href="catalogo.html?fav=1" aria-label="Favoritos">${ICONS.heart}<span class="k-badge" id="kFavBadge" hidden>0</span></a>` +
    `<button class="k-icobtn" id="kBagBtn" aria-label="Bolsa">${ICONS.bag}<span class="k-badge" id="kBagBadge">0</span></button>` +
    `</div></div>` +
    `<nav class="k-mobilenav" id="kMobileNav" hidden>` +
    NAV.map(([href, id, label]) => `<a href="${href}" class="${page === id ? 'on' : ''}">${label}</a>`).join('') +
    `</nav></header>`
  );

  document.body.insertAdjacentHTML('beforeend',
    `<div class="k-drawer-bg" id="kDrawerBg"><div class="k-drawer" role="dialog" aria-label="Bolsa de compras">` +
    `<div class="k-drawer-head"><h3>Tu bolsa <span id="kDrawerCount"></span></h3>` +
    `<button class="k-icobtn" id="kDrawerClose" aria-label="Cerrar">${ICONS.x}</button></div>` +
    `<div class="k-drawer-body" id="kDrawerBody"></div>` +
    `<div class="k-drawer-foot" id="kDrawerFoot" hidden></div>` +
    `</div></div>` +
    `<a class="k-wa" href="${waHello}" target="_blank" rel="noreferrer" aria-label="WhatsApp"><span class="k-wa-pulse"></span>${ICONS.wa}</a>` +
    `<footer class="k-footer"><div class="k-foot-grid">` +
    `<div><a class="k-logo" href="index.html" style="margin-bottom:14px"><img src="logo-web.jpg" alt="Karmylis">` +
    `<span class="k-logo-word"><strong style="color:#fff">KARMYLIS</strong><small>MODA Y PASIÓN</small></span></a>` +
    `<p class="k-foot-desc">Siluetas atemporales y confección de punto fino para la mujer boliviana.</p>` +
    `<p class="k-foot-loc">${ICONS.pin} Plaza Real · Calle Comercio (La Paz)</p></div>` +
    `<div><h4>Páginas</h4><ul>` +
    NAV.map(([href, , label]) => `<li><a href="${href}">${label}</a></li>`).join('') +
    `</ul></div>` +
    `<div><h4>Colecciones</h4><ul>` +
    [['Chompa', 'Chompas'], ['Blusa', 'Blusas & Tops'], ['Chaqueta', 'Chaquetas'], ['Vestido', 'Vestidos'], ['Pantalon', 'Pantalones']]
      .map(([c, l]) => `<li><a href="catalogo.html?cat=${encodeURIComponent(c)}">${l}</a></li>`).join('') +
    `</ul></div>` +
    `<div><h4>Mantente al día</h4><p class="k-foot-desc">Nuevas colecciones y preventas.</p>` +
    `<form class="k-news" id="kNews"><input type="email" placeholder="Tu correo..." required><button type="submit">Unirse</button></form></div>` +
    `</div><div class="k-foot-bottom"><p>© ${new Date().getFullYear()} Karmylis Boutique. Todos los derechos reservados.</p>` +
    `<div class="k-foot-links"><a href="reservas.html">Políticas de reserva</a><a href="contacto.html">Sucursal Plaza Real</a></div>` +
    `</div></footer>`
  );

  // adapt: nav uses <a> now — add matching styles via class reuse
  document.querySelectorAll('.k-nav a, .k-mobilenav a, .k-foot-links a, .k-foot-grid ul a').forEach(() => {});

  const burger = document.getElementById('kBurger');
  const mnav = document.getElementById('kMobileNav');
  burger?.addEventListener('click', () => { mnav.hidden = !mnav.hidden; });

  document.getElementById('kNews')?.addEventListener('submit', (e) => {
    e.preventDefault(); e.target.reset(); toast('¡Gracias por suscribirte!');
  });

  // drawer events (delegated, works across pages)
  document.getElementById('kBagBtn')?.addEventListener('click', openCart);
  document.getElementById('kDrawerClose')?.addEventListener('click', closeCart);
  document.getElementById('kDrawerBg')?.addEventListener('click', (e) => {
    if (e.target.id === 'kDrawerBg') closeCart();
  });
  document.getElementById('kDrawerBody')?.addEventListener('click', (e) => {
    const rm = e.target.closest('[data-rm]');
    if (rm) {
      saveCart(getCart().filter((i) => i.key !== rm.dataset.rm));
      renderCart(store);
      return;
    }
    const q = e.target.closest('[data-q]');
    if (q) {
      const items = getCart();
      const it = items.find((i) => i.key === q.dataset.q);
      if (it) {
        it.qty += Number(q.dataset.d);
        if (it.qty <= 0) saveCart(items.filter((i) => i.key !== it.key));
        else saveCart(items);
        renderCart(store);
      }
    }
  });
  document.getElementById('kDrawerFoot')?.addEventListener('click', (e) => {
    if (e.target.closest('[data-checkout]')) checkout(store);
  });

  document.addEventListener('k:cart', () => { renderBadges(); renderCart(store); });
  renderBadges();
}

// nav anchors need button-like styling: reuse .k-nav button rules
export function patchNavStyles() {
  const st = document.createElement('style');
  st.textContent = `.k-nav a{display:flex;align-items:center;gap:7px;font-size:11px;font-weight:600;letter-spacing:var(--tracking-wide);text-transform:uppercase;color:var(--color-lead-dark);padding:10px 14px;border-radius:var(--radius-pill)}.k-nav a:hover{background:var(--color-mustard-light);color:var(--color-black)}.k-nav a.on{background:var(--color-black);color:var(--color-mustard)}.k-mobilenav a{display:block;text-align:left;padding:12px 4px;font-size:13px;font-weight:600;letter-spacing:var(--tracking-wide);text-transform:uppercase;border-bottom:1px solid var(--color-border-on-light)}.k-mobilenav a.on{color:var(--color-mustard)}.k-foot-grid ul a{font-size:13.5px;color:rgba(255,255,255,.6)}.k-foot-grid ul a:hover{color:var(--color-mustard)}.k-foot-links a{font-size:12px;color:rgba(255,255,255,.4)}.k-foot-links a:hover{color:var(--color-mustard)}`;
  document.head.appendChild(st);
}

export function renderBadges() {
  const b = document.getElementById('kBagBadge');
  if (b) b.textContent = cartCount();
  const f = document.getElementById('kFavBadge');
  if (f) {
    try {
      const n = (JSON.parse(localStorage.getItem('karmylis-favs')) || []).length;
      f.hidden = n === 0;
      f.textContent = n;
    } catch { /* noop */ }
  }
  const dc = document.getElementById('kDrawerCount');
  if (dc) dc.textContent = `(${cartCount()})`;
}

export function openCart() {
  document.getElementById('kDrawerBg')?.classList.add('open');
  document.body.style.overflow = 'hidden';
}
export function closeCart() {
  document.getElementById('kDrawerBg')?.classList.remove('open');
  document.body.style.overflow = '';
}

export function renderCart(store) {
  const body = document.getElementById('kDrawerBody');
  const foot = document.getElementById('kDrawerFoot');
  if (!body || !foot) return;
  const items = getCart();
  document.getElementById('kDrawerCount').textContent = `(${cartCount()})`;
  if (!items.length) {
    body.innerHTML = `<div class="k-cart-empty"><p class="t">Bolsa vacía</p>` +
      `<p class="s">Explora el catálogo y añade prendas exclusivas.</p>` +
      `<a class="btn-pill btn-pill-primary" href="catalogo.html">Explorar catálogo</a></div>`;
    foot.hidden = true;
    return;
  }
  body.innerHTML = '<div class="k-cart-list">' + items.map((item) =>
    `<div class="k-cart-row"><img src="${item.image}" alt="${item.name}" onerror="this.style.display='none'">` +
    `<div class="k-cart-info"><div class="k-cart-top"><h4>${item.name}</h4>` +
    `<button data-rm="${item.key}" aria-label="Eliminar">✕</button></div>` +
    `<span class="k-cart-meta">Cód ${item.code} · ${item.selectedSize}</span>` +
    `<div class="k-qty"><button data-q="${item.key}" data-d="-1">−</button><b>${item.qty}</b>` +
    `<button data-q="${item.key}" data-d="1">+</button>` +
    `<span class="k-sub">Bs. ${(item.price * item.qty).toFixed(2)}</span></div></div></div>`
  ).join('') + '</div>';
  const code = orderCode();
  foot.hidden = false;
  foot.innerHTML =
    `<div class="k-total"><span>Total estimado</span><strong>Bs. ${cartTotal().toFixed(2)}</strong></div>` +
    (code ? `<p class="k-order">Código de pedido: <b>${code}</b></p>` : '') +
    `<p class="k-note">Reserva con 50% de abono o pago completo para despacho.</p>` +
    `<button class="btn-pill btn-pill-primary" style="width:100%" data-checkout>Pedir por WhatsApp →</button>`;
}

export function checkout(store) {
  const items = getCart();
  if (!items.length) return;
  let msg = '¡Hola Karmylis! Deseo realizar el siguiente pedido desde su tienda online:\n\n';
  items.forEach((item, i) => {
    msg += `${i + 1}. *${item.name}* (Cód: ${item.code})\n`;
    msg += `   • Talla: ${item.selectedSize} | Color: ${item.selectedColor}\n`;
    msg += `   • Cantidad: ${item.qty} | Subtotal: Bs. ${(item.price * item.qty).toFixed(2)}\n\n`;
  });
  msg += `*TOTAL DEL PEDIDO: Bs. ${cartTotal().toFixed(2)}*\n`;
  const code = orderCode();
  if (code) msg += `Código de pedido: ${code}\n`;
  msg += '\n¿Tienen disponibilidad para coordinar pago/reserva y envío? ¡Muchas gracias!';
  window.open(`https://wa.me/${store.whatsappNumber}?text=${encodeURIComponent(msg)}`, '_blank');
}

// reveal-on-scroll (progressive enhancement: content is visible by default)
export function reveal() {
  if (!('IntersectionObserver' in window)) return;
  const io = new IntersectionObserver((es) => {
    es.forEach((en) => { if (en.isIntersecting) { en.target.classList.add('in'); io.unobserve(en.target); } });
  }, { threshold: 0.08 });
  document.querySelectorAll('.rv:not(.in)').forEach((e) => io.observe(e));
}
