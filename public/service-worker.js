const CACHE_NAME = "flow-v3";

// Receive messages from the app
self.addEventListener("message", (event) => {
  if (event.data && event.data.type === "SKIP_WAITING") {
    self.skipWaiting();
  }
});

// Install immediately
self.addEventListener("install", (event) => {
  self.skipWaiting();

  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll([
        "/",
        "/icons/flogo.png"
      ]);
    })
  );
});

// Activate immediately and remove old caches
self.addEventListener("activate", (event) => {
  event.waitUntil(
    Promise.all([
      self.clients.claim(),

      caches.keys().then((cacheNames) => {
        return Promise.all(
          cacheNames.map((cacheName) => {
            if (cacheName !== CACHE_NAME) {
              return caches.delete(cacheName);
            }
          })
        );
      })
    ])
  );
});

// Network First Strategy
self.addEventListener("fetch", (event) => {
  if (event.request.method !== "GET") return;

  // Ignore browser extensions
  if (!event.request.url.startsWith(self.location.origin)) return;

  event.respondWith(
    fetch(event.request)
      .then((networkResponse) => {

        if (
          networkResponse &&
          networkResponse.status === 200 &&
          networkResponse.type === "basic"
        ) {
          const responseClone = networkResponse.clone();

          caches.open(CACHE_NAME).then((cache) => {
            cache.put(event.request, responseClone);
          });
        }

        return networkResponse;
      })
      .catch(async () => {
        const cached = await caches.match(event.request);

        if (cached) {
          return cached;
        }

        // Optional offline page
        if (event.request.mode === "navigate") {
          return caches.match("/");
        }

        return Response.error();
      })
  );
});