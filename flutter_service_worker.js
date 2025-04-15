'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"main.dart.mjs": "d338c7b0df4781a291eb732c56e6c8ce",
"index.html": "98ee210b7f235d298e2c93a2c31e01df",
"/": "98ee210b7f235d298e2c93a2c31e01df",
"assets/NOTICES": "eb29ac100f910402ae49d35e1d2ff95d",
"assets/assets/icons/ic_radar_chart.svg": "ae4749285f97e57708f0b4af3940ef37",
"assets/assets/icons/fl_chart_logo_icon.png": "ac3a30940645988853b445ae40fc1de1",
"assets/assets/icons/fitness-svgrepo-com.svg": "ed5e699a694199413539ecab61034817",
"assets/assets/icons/worker-svgrepo-com.svg": "84811d10be79e6828ac41c5434b64a6a",
"assets/assets/icons/ic_bar_chart.svg": "3a21a43338892463705d42622d89eac4",
"assets/assets/icons/ic_pie_chart.svg": "169ca97a9cf6dbd6c9841c146b0c6dcd",
"assets/assets/icons/ic_scatter_chart.svg": "536f54613d13bce8cb61d038cb4af500",
"assets/assets/icons/fl_chart_logo_text.svg": "bf1c107ec2a601b929ba771305f59133",
"assets/assets/icons/ic_line_chart.svg": "8cbf5e811f4752f252c9794b5d0c27ea",
"assets/assets/icons/image_annotation.png": "0e1f4c577f4aaeeb523a0a84d4fa60ec",
"assets/assets/icons/ophthalmology-svgrepo-com.svg": "dc1825936f7cdfb79b91ae482acfe24c",
"assets/assets/icons/librarian-svgrepo-com.svg": "581876df23ecce2c69118d7b225d82ae",
"assets/assets/fonts/digital-7.ttf": "1e670d88b23c7ab956f1829e3828a210",
"assets/assets/data/btc_last_year_price.json": "44cf91021c428b7a7af4adb526508ed5",
"assets/assets/data/amsterdam_2024_weather.csv": "ba81ea677cb7d9a883275d92cf284e7c",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "3b87e6013105a80d09de47e2b689342b",
"assets/fonts/MaterialIcons-Regular.otf": "1f13048e962c67966779a94747ce9c27",
"assets/FontManifest.json": "40bb76a500a675f26b9e2081f6013c40",
"assets/AssetManifest.bin.json": "7c15e8aef5702f63af6286977075729b",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/AssetManifest.json": "d660645660ca07accc272c1a2e4c56b3",
"version.json": "2b2ca39b5b3bf64057da0ba73b86e839",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js": "c484d316b3e2785dfb974888bfa6a48c",
"CNAME": "257af4028a89921df61e820d8c71c478",
"icons/Icon-192.png": "5acd6f19374946f901d9d9122ec85264",
"icons/Icon-512.png": "43c6084bbc3e7d43c410b95b1a823d73",
"manifest.json": "9f7a9b494fee5f8a77f949a486a2dd60",
"favicon.png": "f4ddb6a019f7d58ca45df29a62c3c5c4",
"main.dart.wasm": "9e8e075b49decf30e0a692d178aa2c05",
"flutter_bootstrap.js": "acb959ece15515ed41b209e415de31d4"};
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
