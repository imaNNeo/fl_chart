import React, {memo, useEffect, useRef, useState} from 'react';
import clsx from 'clsx';

import {
  arcPath,
  centroid,
  circleShape,
  easeInOutCubic,
  flCurve,
  lerp,
  lerpColor,
  lerpShape,
  lerpWedge,
  rectShape,
  shapePath,
  smoothstep,
  wedgeShape,
} from './shapes';
import styles from './styles.module.css';

/*
 * The chart of the homepage: the same seven values drawn as each chart type
 * of fl_chart, morphing from one to the next.
 */

const VALUES = [3.4, 4.8, 3.9, 5.6, 4.4, 6.3, 5.1];
const MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];
const OPEN = [2.9, 3.4, 4.8, 3.9, 5.6, 4.4, 6.3];
const HIGH = VALUES.map(
  (close, i) => Math.max(close, OPEN[i]) + [0.5, 0.4, 0.7, 0.5, 0.6, 0.4, 0.6][i],
);
const LOW = VALUES.map(
  (close, i) => Math.min(close, OPEN[i]) - [0.4, 0.6, 0.3, 0.5, 0.4, 0.7, 0.5][i],
);
const SUM = VALUES.reduce((a, b) => a + b, 0);
const BEFORE = VALUES.map((_, i) => VALUES.slice(0, i).reduce((a, b) => a + b, 0));

// The plot area of the cartesian charts, and the center of the round ones.
const L = 44;
const R = 548;
const T = 16;
const B = 372;
const MAX_Y = 7;
const CX = 296;
const CY = 196;
const xAt = (i) => L + ((i + 0.5) * (R - L)) / VALUES.length;
const yAt = (value) => B - (value / MAX_Y) * (B - T);

const C = {
  cyan: '#50e4ff',
  violet: '#8a87f0',
  orchid: '#cf8fff',
  amber: '#ffc300',
  coral: '#ff683b',
  background: '#1b2339',
};
function ramp(t) {
  const stops = [C.cyan, C.violet, C.orchid, C.coral];
  const s = t * (stops.length - 1);
  const i = Math.min(stops.length - 2, Math.floor(s));
  return lerpColor(stops[i], stops[i + 1], s - i);
}

// A radar starting at the top, with the data starting at the bottom, so each
// dot sits inside its own pie slice and gauge zone (the morphs between them
// stay in place).
const radarAngle = (i) => 90 + ((i + 0.5) * 360) / VALUES.length;
const radarPoint = (angle, radius) => [
  CX + radius * Math.cos((angle * Math.PI) / 180),
  CY + radius * Math.sin((angle * Math.PI) / 180),
];

const mark = (points, fill, extra) => ({
  points,
  fill,
  opacity: 1,
  stroke: 0,
  polar: null,
  ...extra,
});

const TYPES = [
  {
    name: 'LineChart',
    label: 'Line',
    overlays: ['grid', 'line'],
    mark: (i) => mark(circleShape(xAt(i), yAt(VALUES[i]), 5.5), C.cyan, {stroke: 2.5}),
  },
  {
    name: 'BarChart',
    label: 'Bar',
    overlays: ['grid'],
    mark: (i) =>
      mark(
        rectShape(xAt(i) - 17, yAt(VALUES[i]), xAt(i) + 17, B, 8),
        lerpColor(C.violet, C.cyan, i / (VALUES.length - 1)),
      ),
  },
  {
    name: 'CandlestickChart',
    label: 'Candlestick',
    overlays: ['grid', 'wicks'],
    mark: (i) =>
      mark(
        rectShape(
          xAt(i) - 10,
          yAt(Math.max(VALUES[i], OPEN[i])),
          xAt(i) + 10,
          yAt(Math.min(VALUES[i], OPEN[i])),
          2,
        ),
        VALUES[i] >= OPEN[i] ? C.cyan : C.coral,
      ),
  },
  {
    name: 'ScatterChart',
    label: 'Scatter',
    overlays: ['grid'],
    mark: (i) => {
      const x = [0.55, 1.5, 2.65, 3.3, 4.55, 5.25, 6.4][i];
      const y = [2.1, 4.9, 3.2, 6.0, 1.7, 4.3, 5.6][i];
      const radius = [11, 17, 9, 21, 13, 10, 15][i];
      const fill = [C.cyan, C.violet, C.orchid, C.amber, C.coral, C.cyan, C.orchid][i];
      return mark(circleShape(L + (x * (R - L)) / MAX_Y, yAt(y), radius), fill, {
        opacity: 0.88,
      });
    },
  },
  {
    name: 'RadarChart',
    label: 'Radar',
    overlays: ['web', 'radar'],
    mark: (i) =>
      mark(
        circleShape(...radarPoint(radarAngle(i), (VALUES[i] / MAX_Y) * 168), 5.5),
        C.orchid,
        {stroke: 2.5},
      ),
  },
  {
    name: 'PieChart',
    label: 'Pie',
    overlays: [],
    mark: (i) => {
      const polar = {
        cx: CX,
        cy: CY,
        r0: 64,
        r1: 172,
        a0: 90 + (BEFORE[i] / SUM) * 360 + 1.2,
        a1: 90 + ((BEFORE[i] + VALUES[i]) / SUM) * 360 - 1.2,
      };
      const fill = [C.cyan, C.violet, C.orchid, C.amber, C.coral, '#2aa8c9', '#6b68e0'][i];
      return mark(wedgeShape(polar), fill, {polar});
    },
  },
  {
    name: 'GaugeChart',
    label: 'Gauge',
    overlays: ['gauge'],
    mark: (i) => {
      const polar = {
        cx: CX,
        cy: CY + 22,
        r0: 150,
        r1: 170,
        a0: 150 + (BEFORE[i] / SUM) * 240 + 0.9,
        a1: 150 + ((BEFORE[i] + VALUES[i]) / SUM) * 240 - 0.9,
      };
      return mark(wedgeShape(polar), ramp(i / (VALUES.length - 1)), {polar});
    },
  },
];
const STATES = TYPES.map((type) => VALUES.map((_, i) => type.mark(i)));
const OVERLAYS = ['grid', 'web', 'radar', 'line', 'wicks', 'gauge'];

// How long each chart type stays, and how long a morph takes.
const HOLD = 2400;
const MORPH = 1100;

const LINE_POINTS = VALUES.map((value, i) => [xAt(i), yAt(value)]);
const LINE_CURVE = flCurve(LINE_POINTS);

// The parts of each chart type around its marks, faded in and out by the
// morph. They never change, so they render once.
const Layers = memo(function Layers({layers}) {
  const layerRef = (name) => (node) => {
    layers.current[name] = node;
  };
  const initial = (name) => (TYPES[0].overlays.includes(name) ? 1 : 0);
  return (
    <>
      <defs>
        <linearGradient id="chartMorphLine" x1="0" x2="1" y1="0" y2="0">
          <stop offset="0" stopColor={C.cyan} />
          <stop offset="1" stopColor={C.violet} />
        </linearGradient>
        <linearGradient id="chartMorphArea" x1="0" x2="0" y1="0" y2="1">
          <stop offset="0" stopColor={C.cyan} stopOpacity="0.25" />
          <stop offset="1" stopColor={C.cyan} stopOpacity="0" />
        </linearGradient>
      </defs>
      {/* FlGridData and FlTitlesData of the cartesian charts */}
      <g ref={layerRef('grid')} opacity={initial('grid')}>
        {Array.from({length: MAX_Y}, (_, k) => k + 1).map((y) => (
          <line
            key={y}
            x1={L}
            x2={R}
            y1={yAt(y)}
            y2={yAt(y)}
            className={styles.gridLine}
            strokeDasharray={y % 2 ? '3 5' : undefined}
          />
        ))}
        <line x1={L} x2={R} y1={B} y2={B} className={styles.axisLine} />
        {[0, 2, 4, 6].map((y) => (
          <text key={y} x={L - 12} y={yAt(y) + 4} textAnchor="end" className={styles.axisLabel}>
            {y}
          </text>
        ))}
        {MONTHS.map((month, i) => (
          <text key={month} x={xAt(i)} y={B + 24} textAnchor="middle" className={styles.axisLabel}>
            {month}
          </text>
        ))}
      </g>
      {/* The web of the radar chart */}
      <g ref={layerRef('web')} opacity={initial('web')}>
        {[1, 2, 3, 4].map((k) => (
          <polygon
            key={k}
            className={styles.gridLine}
            fill="none"
            points={VALUES.map((_, i) => radarPoint(radarAngle(i), (k / 4) * 168).join(',')).join(' ')}
          />
        ))}
        {VALUES.map((_, i) => {
          const [x, y] = radarPoint(radarAngle(i), 168);
          return <line key={i} x1={CX} y1={CY} x2={x} y2={y} className={styles.gridLine} />;
        })}
      </g>
      <g ref={layerRef('radar')} opacity={initial('radar')}>
        <polygon
          points={STATES[4].map((m) => centroid(m.points).join(',')).join(' ')}
          fill="rgba(207, 143, 255, 0.18)"
          stroke={C.orchid}
          strokeWidth="2.5"
          strokeLinejoin="round"
        />
      </g>
      {/* LineChartBarData(isCurved: true) with its belowBarData */}
      <g ref={layerRef('line')} opacity={initial('line')}>
        <path
          d={`${LINE_CURVE} L${LINE_POINTS[6][0]},${B} L${LINE_POINTS[0][0]},${B} Z`}
          fill="url(#chartMorphArea)"
        />
        <path
          d={LINE_CURVE}
          fill="none"
          stroke="url(#chartMorphLine)"
          strokeWidth="4"
          strokeLinecap="round"
        />
      </g>
      <g ref={layerRef('wicks')} opacity={initial('wicks')}>
        {VALUES.map((close, i) => (
          <line
            key={i}
            x1={xAt(i)}
            x2={xAt(i)}
            y1={yAt(HIGH[i])}
            y2={yAt(LOW[i])}
            stroke={close >= OPEN[i] ? C.cyan : C.coral}
            strokeWidth="2"
            strokeLinecap="round"
          />
        ))}
      </g>
      {/* GaugeChartData.progress(value: 0.73) over a zones ring */}
      <g ref={layerRef('gauge')} opacity={initial('gauge')}>
        <path
          d={arcPath(CX, CY + 22, 122, 150, 390)}
          fill="none"
          stroke="rgba(255, 255, 255, 0.08)"
          strokeWidth="16"
          strokeLinecap="round"
        />
        <path
          d={arcPath(CX, CY + 22, 122, 150, 150 + 240 * 0.73)}
          fill="none"
          stroke={C.cyan}
          strokeWidth="16"
          strokeLinecap="round"
        />
        <text x={CX} y={CY + 36} textAnchor="middle" className={styles.gaugeValue}>
          73%
        </text>
        <text x={CX} y={CY + 66} textAnchor="middle" className={styles.gaugeLabel}>
          value: 0.73
        </text>
      </g>
    </>
  );
});

function prefersReducedMotion() {
  return (
    typeof window !== 'undefined' &&
    window.matchMedia('(prefers-reduced-motion: reduce)').matches
  );
}

export default function ChartMorph({className}) {
  const [current, setCurrent] = useState(0);
  const [paused, setPaused] = useState(false);
  const [reducedMotion, setReducedMotion] = useState(false);
  const [tick, setTick] = useState(0);
  const markRefs = useRef([]);
  const typesRef = useRef(null);
  const layers = useRef({});
  // What is painted now, to start the next morph from there.
  const painted = useRef({
    marks: STATES[0],
    overlays: Object.fromEntries(
      OVERLAYS.map((name) => [name, TYPES[0].overlays.includes(name) ? 1 : 0]),
    ),
  });
  const shown = useRef(0);
  const frame = useRef(0);

  useEffect(() => setReducedMotion(prefersReducedMotion()), []);

  // Morph from what is painted to the current chart type.
  useEffect(() => {
    if (shown.current === current) return undefined;
    shown.current = current;
    const from = painted.current;
    const to = STATES[current];
    const visible = TYPES[current].overlays;
    const paint = (t) => {
      const e = easeInOutCubic(t);
      const marks = to.map((target, i) => {
        const source = from.marks[i];
        const polar =
          source.polar && target.polar ? lerpWedge(source.polar, target.polar, e) : null;
        const next = {
          points: polar ? wedgeShape(polar) : lerpShape(source.points, target.points, e),
          fill: lerpColor(source.fill, target.fill, e),
          opacity: lerp(source.opacity, target.opacity, e),
          stroke: lerp(source.stroke, target.stroke, e),
          polar,
        };
        const node = markRefs.current[i];
        if (node) {
          node.setAttribute('d', shapePath(next.points));
          node.setAttribute('fill', next.fill);
          node.setAttribute('fill-opacity', next.opacity.toFixed(3));
          node.setAttribute('stroke-width', next.stroke.toFixed(2));
        }
        return next;
      });
      const overlays = {};
      for (const name of OVERLAYS) {
        const start = from.overlays[name];
        const end = visible.includes(name) ? 1 : 0;
        // Leaving layers fade out first, arriving ones fade in at the end.
        const value =
          end > start
            ? lerp(start, end, smoothstep(0.6, 1, t))
            : lerp(start, end, smoothstep(0, 0.35, t));
        overlays[name] = value;
        layers.current[name]?.setAttribute('opacity', value.toFixed(3));
      }
      painted.current = {marks, overlays};
    };
    cancelAnimationFrame(frame.current);
    if (reducedMotion) {
      paint(1);
      return undefined;
    }
    const start = performance.now();
    const step = (now) => {
      const t = Math.min(1, (now - start) / MORPH);
      paint(t);
      if (t < 1) frame.current = requestAnimationFrame(step);
    };
    frame.current = requestAnimationFrame(step);
    return () => cancelAnimationFrame(frame.current);
  }, [current, reducedMotion]);

  // Where the types scroll sideways (small screens), keep the current one in
  // view. Only the row scrolls, never the page.
  useEffect(() => {
    const row = typesRef.current;
    const button = row?.children[current];
    if (!button || row.scrollWidth <= row.clientWidth) return;
    row.scrollTo({
      left: button.offsetLeft - (row.clientWidth - button.offsetWidth) / 2,
      behavior: reducedMotion ? 'auto' : 'smooth',
    });
  }, [current, reducedMotion]);

  // Play the next chart type, unless the pointer rests on the chart.
  useEffect(() => {
    if (paused || reducedMotion) return undefined;
    const timer = setTimeout(() => {
      if (document.hidden) setTick((n) => n + 1);
      else setCurrent((n) => (n + 1) % TYPES.length);
    }, HOLD + MORPH);
    return () => clearTimeout(timer);
  }, [current, paused, reducedMotion, tick]);

  const type = TYPES[current];
  const playing = !paused && !reducedMotion;

  return (
    <div
      className={clsx(styles.widget, className)}
      onPointerEnter={(event) => event.pointerType === 'mouse' && setPaused(true)}
      onPointerLeave={(event) => event.pointerType === 'mouse' && setPaused(false)}>
      <div className={styles.code} aria-hidden="true">
        <span className={styles.roller} style={{width: `${type.name.length}ch`}}>
          <span
            className={styles.rollerList}
            style={{transform: `translateY(${-current * 1.25}em)`}}>
            {TYPES.map((t) => (
              <span key={t.name}>{t.name}</span>
            ))}
          </span>
        </span>
        (
      </div>
      <div className={styles.chart}>
        <svg
          viewBox="0 0 560 420"
          role="img"
          aria-label={`A ${type.label.toLowerCase()} chart of seven sample values`}>
          <Layers layers={layers} />
          <g>
            {STATES[0].map((m, i) => (
              <path
                key={i}
                ref={(node) => {
                  markRefs.current[i] = node;
                }}
                d={shapePath(m.points)}
                fill={m.fill}
                fillOpacity={m.opacity}
                stroke={C.background}
                strokeWidth={m.stroke}
              />
            ))}
          </g>
        </svg>
      </div>
      <div className={styles.close}>
        <span className={styles.code} aria-hidden="true">
          )
        </span>
        <div
          ref={typesRef}
          className={clsx(styles.types, playing && styles.playing)}
          style={{'--chart-morph-cycle': `${HOLD + MORPH}ms`}}
          role="group"
          aria-label="Chart type">
          {TYPES.map((t, i) => (
            <button
              key={t.name}
              type="button"
              aria-pressed={i === current}
              onClick={() => setCurrent(i)}>
              {t.label}
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}
