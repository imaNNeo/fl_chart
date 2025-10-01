'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "43c6084bbc3e7d43c410b95b1a823d73",
"icons/Icon-maskable-512.png": "43c6084bbc3e7d43c410b95b1a823d73",
"icons/Icon-192.png": "5acd6f19374946f901d9d9122ec85264",
"icons/Icon-maskable-192.png": "5acd6f19374946f901d9d9122ec85264",
"manifest.json": "9f7a9b494fee5f8a77f949a486a2dd60",
"main.dart.mjs": "077365f30e4bd3a4bb90362c4d0c565c",
"index.html": "98ee210b7f235d298e2c93a2c31e01df",
"/": "98ee210b7f235d298e2c93a2c31e01df",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "07254e727ecffc174ca403ac546f4750",
"assets/assets/icons/ophthalmology-svgrepo-com.svg": "dc1825936f7cdfb79b91ae482acfe24c",
"assets/assets/icons/ic_line_chart.svg": "8cbf5e811f4752f252c9794b5d0c27ea",
"assets/assets/icons/image_annotation.png": "0e1f4c577f4aaeeb523a0a84d4fa60ec",
"assets/assets/icons/worker-svgrepo-com.svg": "84811d10be79e6828ac41c5434b64a6a",
"assets/assets/icons/ic_radar_chart.svg": "ae4749285f97e57708f0b4af3940ef37",
"assets/assets/icons/librarian-svgrepo-com.svg": "581876df23ecce2c69118d7b225d82ae",
"assets/assets/icons/ic_pie_chart.svg": "169ca97a9cf6dbd6c9841c146b0c6dcd",
"assets/assets/icons/fitness-svgrepo-com.svg": "ed5e699a694199413539ecab61034817",
"assets/assets/icons/ic_scatter_chart.svg": "536f54613d13bce8cb61d038cb4af500",
"assets/assets/icons/fl_chart_logo_icon.png": "ac3a30940645988853b445ae40fc1de1",
"assets/assets/icons/ic_candle_chart.svg": "933235257bd818d7c58087c24025ab82",
"assets/assets/icons/fl_chart_logo_text.svg": "bf1c107ec2a601b929ba771305f59133",
"assets/assets/icons/ic_bar_chart.svg": "3a21a43338892463705d42622d89eac4",
"assets/assets/fonts/digital-7.ttf": "1e670d88b23c7ab956f1829e3828a210",
"assets/assets/data/amsterdam_2024_weather.csv": "ba81ea677cb7d9a883275d92cf284e7c",
"assets/assets/data/bitcoin_2023-01-01_2023-12-31.csv": "c8efc6fd05e4a403c7ac296af9d18a5b",
"assets/assets/data/btc_last_year_price.json": "44cf91021c428b7a7af4adb526508ed5",
"assets/fonts/MaterialIcons-Regular.otf": "27f881d782d64b7a23bdf03b6ef583c4",
"assets/NOTICES": "01eab89d6a4f34fdde5fd4d3d5caa54d",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/FontManifest.json": "40bb76a500a675f26b9e2081f6013c40",
"assets/AssetManifest.bin": "408b8c5b498e056b5bf359e401dfd8ce",
"assets/AssetManifest.json": "9eca07c26a136cf99c5fc147030edcf1",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"favicon.png": "f4ddb6a019f7d58ca45df29a62c3c5c4",
"main.dart.wasm": "97ffc9aa6c289da88233a6e3c1385bca",
"CNAME": "257af4028a89921df61e820d8c71c478",
"flutter_bootstrap.js": "64f14389f2474174ee589c2c1ecd38ad",
"version.json": "badb380442f99c6d7bc6a799ecccb5a7",
"main.dart.js": "3ff897488050069128e6b4a4f0612489"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"main.dart.wasm",
"main.dart.mjs",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
