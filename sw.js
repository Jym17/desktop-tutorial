/**
 * Service worker de Cuentas Claras.
 *
 * Objetivo: que la app abra al instante y siga funcionando sin señal.
 * Los datos financieros NO pasan por aquí — viven en el almacenamiento
 * del navegador (localStorage). Esto solo cachea el "envoltorio": el
 * HTML, el manifiesto, los iconos y las tipografías.
 *
 * Estrategias:
 *   - Navegación (abrir la app): red primero, caché como respaldo. Así
 *     una versión nueva se ve en cuanto hay conexión, pero sin señal
 *     sigue abriendo la última que funcionó.
 *   - Recursos estáticos: caché primero y refresco en segundo plano.
 */

// Subir este número invalida la caché anterior. Hay que hacerlo cada vez que
// cambie el "envoltorio" (íconos, manifiesto), o el dispositivo seguiría
// sirviendo los archivos viejos que ya tiene guardados.
var VERSION = 'cuentas-claras-v4';
var SHELL = [
  './',
  './index.html',
  './manifest.json',
  './favicon.ico',
  './icons/icon-192-v2.png',
  './icons/icon-512-v2.png',
  './icons/icon-maskable-512-v2.png',
  './icons/apple-touch-icon-v2.png'
];

self.addEventListener('install', function (event) {
  event.waitUntil(
    caches.open(VERSION).then(function (cache) {
      // addAll falla entero si un solo archivo falla; se piden uno a uno
      // para que un icono ausente no deje la app sin modo offline.
      return Promise.all(SHELL.map(function (url) {
        return cache.add(new Request(url, { cache: 'reload' })).catch(function () { return null; });
      }));
    }).then(function () { return self.skipWaiting(); })
  );
});

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (keys) {
      return Promise.all(keys.map(function (k) {
        return k === VERSION ? null : caches.delete(k);
      }));
    }).then(function () { return self.clients.claim(); })
  );
});

self.addEventListener('fetch', function (event) {
  var req = event.request;
  if (req.method !== 'GET') return;

  var url;
  try { url = new URL(req.url); } catch (e) { return; }
  if (url.protocol !== 'http:' && url.protocol !== 'https:') return;

  // Abrir la app: red primero para recibir actualizaciones.
  if (req.mode === 'navigate') {
    event.respondWith(
      fetch(req).then(function (res) {
        var copy = res.clone();
        caches.open(VERSION).then(function (c) { c.put('./index.html', copy); });
        return res;
      }).catch(function () {
        return caches.match('./index.html').then(function (hit) {
          return hit || caches.match('./');
        });
      })
    );
    return;
  }

  // Los íconos y el manifiesto NUNCA pasan por aquí: si el service worker
  // fallara al servirlos, el sistema operativo se queda sin ícono y dibuja su
  // comodín genérico. Van siempre directos a la red.
  if (/(^|\/)(icons\/|apple-touch-icon|favicon\.ico|manifest\.json)/.test(url.pathname)) return;

  var mismoOrigen = url.origin === self.location.origin;
  var esFuente = url.hostname === 'fonts.googleapis.com' || url.hostname === 'fonts.gstatic.com';
  if (!mismoOrigen && !esFuente) return;

  // Estáticos: caché primero, y se refresca en segundo plano.
  event.respondWith(
    caches.match(req).then(function (hit) {
      var red = fetch(req).then(function (res) {
        if (res && (res.ok || res.type === 'opaque')) {
          var copy = res.clone();
          caches.open(VERSION).then(function (c) { c.put(req, copy); });
        }
        return res;
      }).catch(function () { return hit; });
      return hit || red;
    })
  );
});
