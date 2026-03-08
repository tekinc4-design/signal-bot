const CACHE = ‘signal-bot-v1’;

self.addEventListener(‘install’, e => {
e.waitUntil(
caches.open(CACHE).then(c => c.addAll([’./’, ‘./index.html’, ‘./manifest.json’]))
);
self.skipWaiting();
});

self.addEventListener(‘activate’, e => {
e.waitUntil(caches.keys().then(keys =>
Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))
));
self.clients.claim();
});

self.addEventListener(‘fetch’, e => {
e.respondWith(
caches.match(e.request).then(r => r || fetch(e.request))
);
});

// Bildirim göster
self.addEventListener(‘message’, e => {
if (e.data && e.data.type === ‘SIGNAL_ALERT’) {
const { coin, signal, price } = e.data;
const emoji = signal.includes(‘AL’) ? ‘🟢’ : ‘🔴’;
self.registration.showNotification(`${emoji} ${signal} — ${coin}`, {
body: `Fiyat: $${price}`,
icon: ‘./icon.png’,
badge: ‘./icon.png’,
tag: coin,
renotify: true,
vibrate: [200, 100, 200]
});
}
});
