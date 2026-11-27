// Compiles a dart2wasm-generated main module from `source` which can then
// be instantiated via the `instantiate` method.
//
// `source` needs to be a `Response` object (or promise thereof) e.g. created
// via the `fetch()` JS API.
export async function compileStreaming(source) {
  const builtins = {builtins: ['js-string'], importedStringConstants: ''};
  return new CompiledApp(
      await _compileStreaming(source, builtins), builtins);
}

// Compiles a dart2wasm-generated wasm module from `bytes` which is then
// instantiable via the `instantiate` method.
export async function compile(bytes) {
  const builtins = {builtins: ['js-string'], importedStringConstants: ''};
  return new CompiledApp(await WebAssembly.compile(bytes, builtins), builtins);
}

let _isCompileStreamingSupported;
async function _compileStreaming(source, builtins) {
  _isCompileStreamingSupported ??= WebAssembly.compileStreaming(
    new Response(
      new Uint8Array([0,97,115,109,1,0,0,0,1,4,1,96,0,0,2,23,1,14,119,97,115,109,58,106,115,45,115,116,114,105,110,103,4,99,97,115,116,0,0]),
      {headers: {'Content-Type': 'application/wasm'}},
    ),
    builtins,
  ).then(() => false, (e) => e instanceof WebAssembly.CompileError);
  if (await _isCompileStreamingSupported) {
    return WebAssembly.compileStreaming(source, builtins);
  }
  return WebAssembly.compile(await (await source).arrayBuffer(), builtins);
}

class CompiledApp {
  constructor(module, builtins) {
    this.module = module;
    this.builtins = builtins;
  }

  // The second argument is an options object containing:
  // `loadDeferredModules` is a JS function that takes an array of module names
  //   matching wasm files produced by the dart2wasm compiler. It also takes a
  //   callback that should be invoked for each loaded module with 2 arguments:
  //   (1) the module name, (2) the loaded module in a format supported by
  //   `WebAssembly.compile` or `WebAssembly.compileStreaming`. The callback
  //   returns a Promise that resolves when the module is instantiated.
  //   loadDeferredModules should return a Promise that resolves when all the
  //   modules have been loaded and the callback promises have resolved.
  // `loadDeferredId` is a JS function that takes load ID produced by the
  //   compiler when the `use-load-ids` option is passed. Each load ID maps to
  //   one or more wasm files as specified in the emitted JSON file. It also
  //   takes a callback that should be invoked for each loaded module with 2
  //   arguments: (1) the module name, (2) the loaded module in a format
  //   supported by `WebAssembly.compile` or `WebAssembly.compileStreaming`.
  //   The callback returns a Promise that resolves when the module is
  //   instantiated.
  //   loadDeferredId should return a Promise that resolves when all the
  //   modules have been loaded and the callback promises have resolved.
  async instantiate(additionalImports, {loadDeferredModules, loadDeferredId} = {}) {
    let dartInstance;

    // Prints to the console
    function printToConsole(value) {
      if (typeof dartPrint == "function") {
        dartPrint(value);
        return;
      }
      if (typeof console == "object" && typeof console.log != "undefined") {
        console.log(value);
        return;
      }
      if (typeof print == "function") {
        print(value);
        return;
      }

      throw "Unable to print message: " + value;
    }

    // A special symbol attached to functions that wrap Dart functions.
    const jsWrappedDartFunctionSymbol = Symbol("JSWrappedDartFunction");

    function finalizeWrapper(dartFunction, wrapped) {
      wrapped.dartFunction = dartFunction;
      wrapped[jsWrappedDartFunctionSymbol] = true;
      return wrapped;
    }

    // Imports
    const dart2wasm = {
            AB: x0 => new Int16Array(x0),
      AC: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      AD: x0 => x0.screen,
      AE: (o, p) => p in o,
      AF: x0 => x0.key,
      AG: x0 => x0.state,
      AH: x0 => x0.readText(),
      AI: x0 => x0.deref(),
      AJ: x0 => x0.signal,
      AK: x0 => x0.assetBase,
      B: s => printToConsole(s),
      BB: x0 => new Uint16Array(x0),
      BC: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      BD: o => {
        if (o === null || o === undefined) return 0;
        if (typeof(o) === 'string') return 1;
        return 2;
      },
      BE: (x0,x1) => { x0.textContent = x1 },
      BF: x0 => x0.identifier,
      BG: (x0,x1) => x0.go(x1),
      BH: x0 => x0.clipboard,
      BI: () => globalThis.WeakRef,
      BJ: (x0,x1,x2) => x0.insertBefore(x1,x2),
      BK: x0 => x0.loader,
      C: Function.prototype.call.bind(Number.prototype.toString),
      CB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI16ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      CC: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      CD: x0 => x0.tabIndex,
      CE: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      CF: x0 => x0.touches,
      CG: (x0,x1) => x0.querySelectorAll(x1),
      CH: (x0,x1) => x0.writeText(x1),
      CI: (o, offsetInBytes, lengthInBytes) => {
        var dst = new ArrayBuffer(lengthInBytes);
        new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
        return new DataView(dst);
      },
      CJ: x0 => x0.id,
      CK: () => globalThis._flutter,
      D: Function.prototype.call.bind(BigInt.prototype.toString),
      DB: x0 => new Int32Array(x0),
      DC: (x0,x1) => x0.querySelector(x1),
      DD: (x0,x1) => x0.contains(x1),
      DE: x0 => x0.matches,
      DF: x0 => x0.pressure,
      DG: (x0,x1) => x0.requestAnimationFrame(x1),
      DH: x0 => x0.unlock(),
      DI: (a, s, e) => a.slice(s, e),
      DJ: x0 => x0.offsetHeight,
      E: (exn) => {
        let stackString = exn.toString();
        let frames = stackString.split('\n');
        let drop = 4;
        if (frames[0].startsWith('Error')) {
            drop += 1;
        }
        return frames.slice(drop).join('\n');
      },
      EB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      EC: (x0,x1) => x0.item(x1),
      ED: x0 => x0.activeElement,
      EE: (x0,x1) => x0.matchMedia(x1),
      EF: x0 => x0.tiltY,
      EG: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      EH: (x0,x1) => x0.lock(x1),
      EI: x0 => x0.close(),
      EJ: x0 => x0.offsetWidth,
      F: () => new Error().stack,
      FB: x0 => new Uint32Array(x0),
      FC: x0 => x0.length,
      FD: x0 => x0.parentNode,
      FE: x0 => x0.matches,
      FF: x0 => x0.tiltX,
      FG: x0 => x0.now(),
      FH: x0 => x0.orientation,
      FI: x0 => x0.height,
      FJ: x0 => x0.stopPropagation(),
      G: s => JSON.stringify(s),
      GB: x0 => new Float32Array(x0),
      GC: (x0,x1) => x0.querySelectorAll(x1),
      GD: x0 => x0.tagName,
      GE: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      GF: x0 => x0.pointerType,
      GG: x0 => x0.performance,
      GH: (x0,x1) => x0.querySelector(x1),
      GI: x0 => x0.width,
      GJ: x0 => x0.disabled,
      H: Function.prototype.call.bind(Number.prototype.toString),
      HB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      HC: (x0,x1) => x0.getAttribute(x1),
      HD: x0 => x0.target,
      HE: f => f.dartFunction,
      HF: x0 => x0.pointerId,
      HG: (d, digits) => d.toFixed(digits),
      HH: (x0,x1) => { x0.title = x1 },
      HI: (x0,x1,x2,x3,x4,x5) => x0.createImageBitmap(x1,x2,x3,x4,x5),
      HJ: (x0,x1) => { x0.min = x1 },
      I: Function.prototype.call.bind(String.prototype.indexOf),
      IB: x0 => new Float64Array(x0),
      IC: x0 => x0.remove(),
      ID: x0 => x0.clientY,
      IE: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      IF: x0 => x0.getCoalescedEvents(),
      IG: x0 => x0.maxHeight,
      IH: (x0,x1) => x0.vibrate(x1),
      II: (x0,x1) => x0.createImageBitmap(x1),
      IJ: (x0,x1) => { x0.max = x1 },
      J: (s, p, i) => s.lastIndexOf(p, i),
      JB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF64ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      JC: (x0,x1) => x0.appendChild(x1),
      JD: x0 => x0.clientX,
      JE: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      JF: s => s.trimLeft(),
      JG: x0 => x0.maxWidth,
      JH: x0 => x0.arrayBuffer(),
      JI: x0 => new Blob(x0),
      JJ: (x0,x1) => { x0.disabled = x1 },
      K: (exn) => {
        if (exn instanceof Error) {
          return exn.stack;
        } else {
          return null;
        }
      },
      KB: x0 => new ArrayBuffer(x0),
      KC: (x0,x1) => x0.append(x1),
      KD: (x0,x1,x2) => x0.addEventListener(x1,x2),
      KE: (p, s, f) => p.then(s, (e) => f(e, e === undefined)),
      KF: (x0,x1) => x0[x1],
      KG: x0 => x0.minHeight,
      KH: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof ArrayBuffer) return 1;
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
          return 2;
        }
        return 3;
      },
      KI: x0 => x0.close(),
      KJ: (x0,x1) => { x0.scrollLeft = x1 },
      L: o => o === undefined,
      LB: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      LC: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
      LD: (x0,x1,x2) => x0.setAttribute(x1,x2),
      LE: (o, i) => o[i],
      LF: x0 => x0.index,
      LG: x0 => x0.minWidth,
      LH: x0 => x0.status,
      LI: x0 => x0.naturalHeight,
      LJ: (x0,x1) => { x0.spellcheck = x1 },
      M: o => String(o),
      MB: (x0,x1,x2) => new DataView(x0,x1,x2),
      MC: x0 => x0.style,
      MD: (x0,x1) => x0.closest(x1),
      ME: o => o.length,
      MF: s => s.toUpperCase(),
      MG: (x0,x1) => x0.removeProperty(x1),
      MH: (x0,x1) => x0.fetch(x1),
      MI: x0 => x0.naturalWidth,
      MJ: (x0,x1) => { x0.disabled = x1 },
      N: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      NB: (o, p) => o[p],
      NC: x0 => x0.debugShowSemanticsNodes,
      ND: (ms, c) =>
      setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
      NE: o => {
        if (o === undefined) return 1;
        var type = typeof o;
        if (type === 'boolean') return 2;
        if (type === 'number') return 3;
        if (type === 'string') return 4;
        if (o instanceof Array) return 5;
        if (ArrayBuffer.isView(o)) {
          if (o instanceof Int8Array) return 6;
          if (o instanceof Uint8Array) return 7;
          if (o instanceof Uint8ClampedArray) return 8;
          if (o instanceof Int16Array) return 9;
          if (o instanceof Uint16Array) return 10;
          if (o instanceof Int32Array) return 11;
          if (o instanceof Uint32Array) return 12;
          if (o instanceof Float32Array) return 13;
          if (o instanceof Float64Array) return 14;
          if (o instanceof DataView) return 15;
        }
        if (o instanceof ArrayBuffer) return 16;
        // Feature check for `SharedArrayBuffer` before doing a type-check.
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
            return 17;
        }
        if (o instanceof Promise) return 18;
        return 19;
      },
      NF: x0 => x0.pop(),
      NG: (x0,x1) => x0.add(x1),
      NH: x0 => x0.content,
      NI: (x0,x1) => { x0.src = x1 },
      NJ: (x0,x1,x2,x3,x4,x5,x6,x7,x8,x9) => x0.drawImage(x1,x2,x3,x4,x5,x6,x7,x8,x9),
      O: (x0,x1) => x0.didCreateEngineInitializer(x1),
      OB: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      OC: o => o,
      OD: (handle) => clearTimeout(handle),
      OE: x0 => x0.language,
      OF: x0 => x0.flags,
      OG: x0 => x0.data,
      OH: x0 => x0.document,
      OI: x0 => x0.displayHeight,
      OJ: (x0,x1) => x0.getContext(x1),
      P: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      PB: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      PC: o => {
        if (o === undefined || o === null) return 0;
        if (typeof o === 'boolean') return 1;
        return 2;
      },
      PD: x0 => x0.maxTouchPoints,
      PE: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      PF: (a, s) => a.join(s),
      PG: (x0,x1) => x0.removeAttribute(x1),
      PH: () => typeof dartUseDateNowForTicks !== "undefined",
      PI: x0 => x0.displayWidth,
      PJ: (x0,x1) => { x0.height = x1 },
      Q: (wasmFunction,f) => finalizeWrapper(f, function() { return wasmFunction(f,arguments.length) }),
      QB: o => o.byteOffset,
      QC: (x0,x1) => x0.warn(x1),
      QD: x0 => x0.platform,
      QE: () => globalThis.window.FinalizationRegistry,
      QF: (x0,x1) => x0.error(x1),
      QG: (x0,x1) => { x0.value = x1 },
      QH: () => Date.now(),
      QI: x0 => x0.duration,
      QJ: (x0,x1) => { x0.width = x1 },
      R: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
      RB: o => o.buffer,
      RC: x0 => x0.console,
      RD: s => new Date(s * 1000).getTimezoneOffset() * 60,
      RE: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      RF: () => globalThis.console,
      RG: (x0,x1) => { x0.value = x1 },
      RH: () => 1000 * performance.now(),
      RI: (x0,x1) => ({frameIndex: x0,completeFramesOnly: x1}),
      RJ: (x0,x1) => x0.transferFromImageBitmap(x1),
      S: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      SB: Function.prototype.call.bind(DataView.prototype.getUint8),
      SC: () => globalThis.window,
      SD: Date.now,
      SE: x0 => new window.FinalizationRegistry(x0),
      SF: s => s.trimRight(),
      SG: x0 => x0.value,
      SH: x0 => new Uint8Array(x0),
      SI: (x0,x1) => x0.decode(x1),
      SJ: x0 => x0.rasterEndMilliseconds,
      T: x0 => new Promise(x0),
      TB: (b, o) => new DataView(b, o),
      TC: (o, c) => o instanceof c,
      TD: (x0,x1) => x0.contains(x1),
      TE: (x0,x1) => x0.unregister(x1),
      TF: x0 => x0.blur(),
      TG: x0 => x0.selectionDirection,
      TH: (x0,x1,x2) => x0.slice(x1,x2),
      TI: x0 => x0.image,
      TJ: x0 => x0.rasterStartMilliseconds,
      U: (x0,x1,x2) => x0.call(x1,x2),
      UB: (b, o, l) => new DataView(b, o, l),
      UC: (x0,x1) => x0.exec(x1),
      UD: (decoder, codeUnits) => decoder.decode(codeUnits),
      UE: x0 => x0.preventDefault(),
      UF: x0 => x0.button,
      UG: x0 => x0.selectionStart,
      UH: (x0,x1) => x0.decode(x1),
      UI: x0 => x0.close(),
      UJ: x0 => x0.imageBitmaps,
      V: (constructor, args) => {
        const factoryFunction = constructor.bind.apply(
            constructor, [null, ...args]);
        return new factoryFunction();
      },
      VB: Function.prototype.call.bind(DataView.prototype.getFloat64),
      VC: x0 => x0.length,
      VD: () => new TextDecoder("utf-8", {fatal: true}),
      VE: x0 => x0.parent,
      VF: (x0,x1) => x0.prepend(x1),
      VG: x0 => x0.selectionEnd,
      VH: (x0,x1) => x0.adoptText(x1),
      VI: (x0,x1,x2,x3,x4) => ({type: x0,data: x1,premultiplyAlpha: x2,colorSpaceConversion: x3,preferAnimation: x4}),
      VJ: x0 => x0.canvasKitMaximumSurfaces,
      W: x0 => new Array(x0),
      WB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float64Array) return 1;
        return 2;
      },
      WC: (x0,x1) => { x0.lastIndex = x1 },
      WD: () => new TextDecoder("utf-8", {fatal: false}),
      WE: x0 => x0.timeStamp,
      WF: x0 => x0.parentElement,
      WG: x0 => x0.value,
      WH: x0 => x0.first(),
      WI: x0 => new window.ImageDecoder(x0),
      WJ: x0 => x0.hostElement,
      X: o => [o],
      XB: Function.prototype.call.bind(DataView.prototype.setFloat64),
      XC: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      XD: (a, i, v) => a[i] = v,
      XE: (x0,x1) => x0.hasAttribute(x1),
      XF: x0 => x0.innerHeight,
      XG: x0 => x0.selectionDirection,
      XH: x0 => x0.next(),
      XI: x0 => x0.name,
      XJ: x0 => x0.location,
      Y: (o0, o1) => [o0, o1],
      YB: (t, s) => t.set(s),
      YC: o => o instanceof RegExp,
      YD: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI8ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      YE: x0 => x0.type,
      YF: x0 => x0.innerWidth,
      YG: x0 => x0.selectionStart,
      YH: x0 => x0.current(),
      YI: x0 => x0.repetitionCount,
      YJ: (x0,x1) => x0.getModifierState(x1),
      Z: (o0, o1, o2) => [o0, o1, o2],
      ZB: Function.prototype.call.bind(DataView.prototype.setFloat32),
      ZC: (string, times) => string.repeat(times),
      ZD: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI16ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      ZE: (x0,x1) => x0.getModifierState(x1),
      ZF: x0 => x0.height,
      ZG: x0 => x0.selectionEnd,
      ZH: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
      ZI: x0 => x0.frameCount,
      ZJ: x0 => x0.metaKey,
      a: (o0, o1, o2, o3) => [o0, o1, o2, o3],
      aB: Function.prototype.call.bind(DataView.prototype.getFloat32),
      aC: x0 => x0.dotAll,
      aD: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      aE: x0 => x0.buttons,
      aF: x0 => x0.width,
      aG: (x0,x1) => { x0.name = x1 },
      aH: x0 => x0.v8BreakIterator,
      aI: x0 => x0.selectedTrack,
      aJ: x0 => x0.altKey,
      b: (x0,x1,x2) => { x0[x1] = x2 },
      bB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float32Array) return 1;
        return 2;
      },
      bC: x0 => x0.unicode,
      bD: (s) => +s,
      bE: x0 => x0.ctrlKey,
      bF: x0 => x0.clientHeight,
      bG: (x0,x1) => { x0.placeholder = x1 },
      bH: () => globalThis.Intl,
      bI: x0 => x0.completed,
      bJ: x0 => x0.ctrlKey,
      c: o => o,
      cB: Function.prototype.call.bind(DataView.prototype.getUint32),
      cC: x0 => x0.ignoreCase,
      cD: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      cE: x0 => x0.getBoundingClientRect(),
      cF: x0 => x0.clientWidth,
      cG: (x0,x1) => { x0.autocomplete = x1 },
      cH: (x0,x1) => x0.segment(x1),
      cI: x0 => x0.ready,
      cJ: x0 => x0.isComposing,
      d: (o, p) => o[p],
      dB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint32Array) return 1;
        return 2;
      },
      dC: x0 => x0.multiline,
      dD: s => s.trim(),
      dE: x0 => x0.y,
      dF: x0 => x0.isConnected,
      dG: (x0,x1) => { x0.type = x1 },
      dH: x0 => x0.index,
      dI: x0 => x0.tracks,
      dJ: x0 => x0.code,
      e: () => globalThis,
      eB: Function.prototype.call.bind(DataView.prototype.getInt32),
      eC: (string, token) => string.split(token),
      eD: x0 => x0.classList,
      eE: x0 => x0.x,
      eF: x0 => x0.head,
      eG: (x0,x1) => { x0.name = x1 },
      eH: x0 => x0.next(),
      eI: () => globalThis.window.ImageDecoder,
      eJ: x0 => x0.repeat,
      f: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      fB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int32Array) return 1;
        return 2;
      },
      fC: o => o instanceof Array,
      fD: x0 => x0.relatedTarget,
      fE: x0 => x0.top,
      fF: (x0,x1) => { x0.content = x1 },
      fG: (x0,x1) => { x0.placeholder = x1 },
      fH: x0 => x0.value,
      fI: (o, p) => p in o,
      fJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      g: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      gB: o => o instanceof Uint16Array,
      gC: (a, i) => a[i],
      gD: x0 => x0.hasFocus(),
      gE: x0 => x0.left,
      gF: (x0,x1) => { x0.name = x1 },
      gG: (x0,x1) => { x0.scrollTop = x1 },
      gH: x0 => x0.done,
      gI: x0 => x0.groups,
      gJ: x0 => x0.userAgent,
      h: (x0,x1) => ({addView: x0,removeView: x1}),
      hB: Function.prototype.call.bind(DataView.prototype.getUint16),
      hC: a => a.length,
      hD: x0 => x0.shiftKey,
      hE: x0 => x0.scrollTop,
      hF: (x0,x1) => x0.removeChild(x1),
      hG: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      hH: (o, m, a) => o[m].apply(o, a),
      hI: (a, i) => a.splice(i, 1),
      hJ: x0 => x0.navigator,
      i: (l, r) => l === r,
      iB: o => o instanceof Int16Array,
      iC: (x0,x1) => x0.test(x1),
      iD: x0 => x0.body,
      iE: x0 => x0.offsetTop,
      iF: x0 => x0.firstChild,
      iG: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      iH: x0 => x0.iterator,
      iI: a => a.pop(),
      iJ: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      j: x0 => x0.random(),
      jB: Function.prototype.call.bind(DataView.prototype.getInt16),
      jC: x0 => x0.userAgent,
      jD: x0 => x0.visibilityState,
      jE: x0 => x0.scrollLeft,
      jF: x0 => x0.viewConstraints,
      jG: s => {
        if (/[[\]{}()*+?.\\^$|]/.test(s)) {
            s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
        }
        return s;
      },
      jH: () => globalThis.Symbol,
      jI: () => new AbortController(),
      jJ: () => globalThis.window,
      k: o => o,
      kB: o => o instanceof Uint8ClampedArray,
      kC: x0 => x0.navigator,
      kD: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      kE: x0 => x0.offsetLeft,
      kF: x0 => x0.hostElement,
      kG: x0 => x0.keyCode,
      kH: (x0,x1) => new Intl.Segmenter(x0,x1),
      kI: (x0,x1,x2,x3,x4,x5) => ({method: x0,headers: x1,body: x2,credentials: x3,redirect: x4,signal: x5}),
      kJ: x0 => x0.baseURI,
      l: o => {
        if (o === undefined || o === null) return 0;
        if (typeof o === 'number') return 1;
        return 2;
      },
      lB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint8Array) return 1;
        return 2;
      },
      lC: Function.prototype.call.bind(String.prototype.toLowerCase),
      lD: x0 => x0.disconnect(),
      lE: x0 => x0.offsetParent,
      lF: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      lG: (x0,x1) => x0.scrollIntoView(x1),
      lH: x0 => x0.Segmenter,
      lI: (x0,x1) => globalThis.fetch(x0,x1),
      lJ: x0 => x0.document,
      m: () => globalThis.Math,
      mB: Function.prototype.call.bind(DataView.prototype.setInt32),
      mC: Object.is,
      mD: x0 => new Intl.Locale(x0),
      mE: x0 => x0.offsetY,
      mF: x0 => ({runApp: x0}),
      mG: x0 => x0.multiViewEnabled,
      mH: x0 => x0.buffer,
      mI: (x0,x1) => x0.get(x1),
      mJ: () => {
        return typeof process != "undefined" &&
               Object.prototype.toString.call(process) == "[object process]" &&
               process.platform == "win32"
      },
      n: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      nB: Function.prototype.call.bind(DataView.prototype.setUint32),
      nC: x0 => x0.vendor,
      nD: x0 => x0.region,
      nE: x0 => x0.offsetX,
      nF: Function.prototype.call.bind(DataView.prototype.getBigInt64),
      nG: (x0,x1) => x0.replaceWith(x1),
      nH: x0 => x0.wasmMemory,
      nI: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1,x2) { return wasmFunction(f,arguments.length,x0,x1,x2) }),
      nJ: () => {
        // On browsers return `globalThis.location.href`
        if (globalThis.location != null) {
          return globalThis.location.href;
        }
        return null;
      },
      o: b => !!b,
      oB: Function.prototype.call.bind(DataView.prototype.setInt16),
      oC: (x0,x1) => x0.createTextNode(x1),
      oD: x0 => x0.script,
      oE: (o, p, r) => o.replace(p, () => r),
      oF: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      oG: (x0,x1) => { x0.className = x1 },
      oH: () => globalThis.window._flutter_skwasmInstance,
      oI: (x0,x1) => x0.forEach(x1),
      oJ: x0 => x0.abort(),
      p: () => globalThis.document,
      pB: Function.prototype.call.bind(DataView.prototype.setUint16),
      pC: (x0,x1) => { x0.id = x1 },
      pD: x0 => x0.language,
      pE: (o, p, r) => o.replaceAll(p, () => r),
      pF: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
      pG: (x0,x1) => { x0.tabIndex = x1 },
      pH: () => new TextDecoder(),
      pI: x0 => x0.name,
      pJ: x0 => x0.extraAssets,
      q: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      qB: Function.prototype.call.bind(DataView.prototype.setUint8),
      qC: (x0,x1) => { x0.nonce = x1 },
      qD: x0 => x0.languages,
      qE: x0 => x0.deltaMode,
      qF: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
      qG: (x0,x1) => { x0.action = x1 },
      qH: (map, o, v) => map.set(o, v),
      qI: x0 => x0.statusText,
      qJ: x0 => x0.fontManifest,
      r: (x0,x1) => x0.focus(x1),
      rB: Function.prototype.call.bind(DataView.prototype.setInt8),
      rC: x0 => x0.nonce,
      rD: (x0,x1) => x0.observe(x1),
      rE: x0 => x0.deltaY,
      rF: x0 => x0.history,
      rG: (x0,x1) => { x0.method = x1 },
      rH: (map, o) => map.get(o),
      rI: x0 => x0.url,
      rJ: x0 => x0.assetManifest,
      s: () => ({}),
      sB: Function.prototype.call.bind(DataView.prototype.getInt8),
      sC: () => globalThis.window.flutterConfiguration,
      sD: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      sE: x0 => x0.deltaX,
      sF: x0 => x0.search,
      sG: (x0,x1) => { x0.noValidate = x1 },
      sH: () => new WeakMap(),
      sI: x0 => x0.status,
      sJ: x0 => x0.buildConfig,
      t: (o, p, v) => o[p] = v,
      tB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int8Array) return 1;
        return 2;
      },
      tC: (x0,x1) => x0.attachShadow(x1),
      tD: x0 => new ResizeObserver(x0),
      tE: x0 => x0.wheelDeltaY,
      tF: x0 => x0.location,
      tG: x0 => x0.click(),
      tH: (handle) => clearInterval(handle),
      tI: x0 => x0.cancel(),
      tJ: x0 => x0.length,
      u: () => [],
      uB: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      uC: (x0,x1) => x0.createElement(x1),
      uD: (x0,x1) => x0.getPropertyValue(x1),
      uE: x0 => x0.wheelDeltaX,
      uF: x0 => x0.pathname,
      uG: (x0,x1) => x0.getElementsByClassName(x1),
      uH: (ms, c) =>
      setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
      uI: x0 => x0.getReader(),
      uJ: x0 => x0.getReader(),
      v: (a, i) => a.push(i),
      vB: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      vC: x0 => x0.scale,
      vD: x0 => globalThis.parseFloat(x0),
      vE: x0 => x0.bottom,
      vF: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      vG: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      vH: () => Date.now(),
      vI: x0 => x0.read(),
      vJ: x0 => x0.value,
      w: x0 => new Int8Array(x0),
      wB: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      wC: x0 => x0.visualViewport,
      wD: (x0,x1) => x0.getComputedStyle(x1),
      wE: x0 => x0.right,
      wF: o => {
        const proto = Object.getPrototypeOf(o);
        return proto === Object.prototype || proto === null;
      },
      wG: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF64ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      wH: x0 => x0.debugSkipFontRetryDelay,
      wI: x0 => x0.value,
      wJ: x0 => x0.done,
      x: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI8ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      xB: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      xC: x0 => x0.devicePixelRatio,
      xD: x0 => x0.documentElement,
      xE: x0 => x0.clientY,
      xF: o => Object.keys(o),
      xG: (x0,x1) => x0.dispatchEvent(x1),
      xH: (x0,x1,x2) => x0.set(x1,x2),
      xI: x0 => x0.done,
      xJ: x0 => x0.read(),
      y: x0 => new Uint8Array(x0),
      yB: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      yC: x0 => x0.height,
      yD: x0 => x0.computedStyleMap(),
      yE: x0 => x0.clientX,
      yF: x0 => x0.state,
      yG: (x0,x1) => x0.createEvent(x1),
      yH: x0 => x0.fontFallbackBaseUrl,
      yI: x0 => x0.body,
      yJ: x0 => x0.body,
      z: x0 => new Uint8ClampedArray(x0),
      zB: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      zC: x0 => x0.width,
      zD: (x0,x1) => x0.get(x1),
      zE: x0 => x0.changedTouches,
      zF: x0 => x0.hash,
      zG: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      zH: x0 => new WeakRef(x0),
      zI: x0 => x0.headers,
      zJ: (x0,x1) => new OffscreenCanvas(x0,x1),

    };

    const baseImports = {
      _: dart2wasm,
      Math: Math,
      Date: Date,
      Object: Object,
      Array: Array,
      Reflect: Reflect,
      WebAssembly: {
        JSTag: WebAssembly.JSTag,
      },
      "": new Proxy({}, { get(_, prop) { return prop; } }),

    };

    

    dartInstance = await WebAssembly.instantiate(this.module, {
      ...baseImports,
      ...additionalImports,
      
    });

    return new InstantiatedApp(this, dartInstance);
  }
}

class InstantiatedApp {
  constructor(compiledApp, instantiatedModule) {
    this.compiledApp = compiledApp;
    this.instantiatedModule = instantiatedModule;
  }

  // Call the main function with the given arguments.
  invokeMain(...args) {
    this.instantiatedModule.exports.$invokeMain(args);
  }
}
