/**
 * The geometry of the homepage chart. Each mark of a chart is a closed
 * outline of K points in four equal runs: the left side going up, the top,
 * the right side going down and the bottom. Two outlines sampled this way
 * morph into each other point by point (a bar into a dot, a dot into a pie
 * slice and so on).
 */
export const K = 64;
const RUN = K / 4;

export const lerp = (a, b, t) => a + (b - a) * t;
export const easeInOutCubic = (t) =>
  t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2;
export const smoothstep = (e0, e1, x) => {
  const t = Math.min(1, Math.max(0, (x - e0) / (e1 - e0)));
  return t * t * (3 - 2 * t);
};

function hexToRgb(hex) {
  const h = hex.replace('#', '');
  return [0, 2, 4].map((i) => parseInt(h.slice(i, i + 2), 16));
}

export function lerpColor(a, b, t) {
  const ca = hexToRgb(a);
  const cb = hexToRgb(b);
  return `#${ca
    .map((v, i) => Math.round(lerp(v, cb[i], t)).toString(16).padStart(2, '0'))
    .join('')}`;
}

function run(points, from, to) {
  for (let i = 0; i < RUN; i++) {
    const t = i / RUN;
    points.push([lerp(from[0], to[0], t), lerp(from[1], to[1], t)]);
  }
}

/** A rectangle from (x0, y0) at the top left, with rounded top corners. */
export function rectShape(x0, y0, x1, y1, radius = 0) {
  const w = Math.max(0, x1 - x0);
  const h = Math.max(0, y1 - y0);
  const r = Math.min(radius, w / 2, h);
  const points = [];
  run(points, [x0, y1], [x0, y0 + r]);
  // The top: a corner arc, the straight part and the other arc, by length.
  const arc = (Math.PI / 2) * r;
  const straight = w - 2 * r;
  const total = 2 * arc + straight || 1;
  for (let i = 0; i < RUN; i++) {
    const s = (i / RUN) * total;
    if (s < arc && r > 0) {
      const a = Math.PI + (s / arc) * (Math.PI / 2);
      points.push([x0 + r + r * Math.cos(a), y0 + r + r * Math.sin(a)]);
    } else if (s < arc + straight) {
      points.push([x0 + r + (s - arc), y0]);
    } else {
      const a = -Math.PI / 2 + ((s - arc - straight) / (arc || 1)) * (Math.PI / 2);
      points.push([x1 - r + r * Math.cos(a), y0 + r + r * Math.sin(a)]);
    }
  }
  run(points, [x1, y0 + r], [x1, y1]);
  run(points, [x1, y1], [x0, y1]);
  return points;
}

export function circleShape(cx, cy, r) {
  const points = [];
  for (let i = 0; i < K; i++) {
    const a = ((135 + (360 * i) / K) * Math.PI) / 180;
    points.push([cx + r * Math.cos(a), cy + r * Math.sin(a)]);
  }
  return points;
}

/** A ring slice. Angles in degrees, clockwise on screen, 0 = 3 o'clock. */
export function wedgeShape({cx, cy, r0, r1, a0, a1}) {
  const at = (r, a) => [
    cx + r * Math.cos((a * Math.PI) / 180),
    cy + r * Math.sin((a * Math.PI) / 180),
  ];
  const points = [];
  run(points, at(r0, a0), at(r1, a0));
  for (let i = 0; i < RUN; i++) points.push(at(r1, lerp(a0, a1, i / RUN)));
  run(points, at(r1, a1), at(r0, a1));
  for (let i = 0; i < RUN; i++) points.push(at(r0, lerp(a1, a0, i / RUN)));
  return points;
}

export function lerpShape(a, b, t) {
  return a.map((p, i) => [lerp(p[0], b[i][0], t), lerp(p[1], b[i][1], t)]);
}

export function lerpWedge(a, b, t) {
  const out = {};
  for (const key of ['cx', 'cy', 'r0', 'r1', 'a0', 'a1']) {
    out[key] = lerp(a[key], b[key], t);
  }
  return out;
}

export function shapePath(points) {
  return `M${points
    .map(([x, y]) => `${x.toFixed(2)},${y.toFixed(2)}`)
    .join('L')}Z`;
}

export function centroid(points) {
  const sum = points.reduce((acc, [x, y]) => [acc[0] + x, acc[1] + y], [0, 0]);
  return [sum[0] / points.length, sum[1] / points.length];
}

/**
 * The curve of `LineChartBarData(isCurved: true)` with its default
 * curveSmoothness of 0.35 (see LineChartPainter.generateNormalBarPath).
 */
export function flCurve(points, smoothness = 0.35) {
  let d = `M${points[0][0]},${points[0][1]}`;
  let temp = [0, 0];
  for (let i = 1; i < points.length; i++) {
    const current = points[i];
    const previous = points[i - 1];
    const next = points[i + 1 < points.length ? i + 1 : i];
    const c1 = [previous[0] + temp[0], previous[1] + temp[1]];
    temp = [
      ((next[0] - previous[0]) / 2) * smoothness,
      ((next[1] - previous[1]) / 2) * smoothness,
    ];
    const c2 = [current[0] - temp[0], current[1] - temp[1]];
    d += ` C${c1.map((v) => v.toFixed(2))} ${c2.map((v) => v.toFixed(2))} ${current}`;
  }
  return d;
}

export function arcPath(cx, cy, r, a0, a1) {
  const at = (a) => [
    (cx + r * Math.cos((a * Math.PI) / 180)).toFixed(2),
    (cy + r * Math.sin((a * Math.PI) / 180)).toFixed(2),
  ];
  return `M${at(a0)} A${r},${r} 0 ${a1 - a0 > 180 ? 1 : 0} 1 ${at(a1)}`;
}
