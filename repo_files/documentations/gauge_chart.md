### How to use
```dart
GaugeChart(
  GaugeChartData(
    // read about it in the GaugeChartData ring
  ),
  duration: Duration(milliseconds: 150), // Optional
  curve: Curves.linear, // Optional
);
```

A gauge is drawn as a set of **concentric rings** along a shared arc. All rings share the same `minValue`/`maxValue` scale and stack **innermost-first** in list order — so `rings[0]` is the innermost ring, the last entry is the outermost — with an optional `ringsSpace` radial gap between them.

Each ring is one of two shapes:

- **[GaugeProgressRing](#GaugeProgressRing)** — a ring that fills from `minValue` up to its own `value`, with an optional faded `backgroundColor` behind. Use this for measurements (battery level, goal progress, live reading).
- **[GaugeZonesRing](#GaugeZonesRing)** — a ring divided into fixed colored [GaugeZone](#GaugeZone) bands. Use this for threshold/level indicators (speedometer red-amber-green zones, status bands).

You can mix both kinds freely — a common pattern is an inner progress ring showing the current reading plus an outer zones ring showing threshold bands.

### Implicit Animations
When you change the chart's state, it animates to the new state internally (using [implicit animations](https://flutter.dev/docs/development/ui/animations/implicit-animations)). You can control the animation [duration](https://api.flutter.dev/flutter/dart-core/Duration-class.html) and [curve](https://api.flutter.dev/flutter/animation/Curves-class.html) using optional `duration` and `curve` properties. Lerping a ring to a different shape (`GaugeProgressRing` ↔ `GaugeZonesRing`) snaps to the target — same-shape transitions interpolate smoothly.

### Progress gauge shortcut
For the common "single ring filling from 0 to a value" case, use `GaugeChartData.progress`:

```dart
GaugeChart(
  GaugeChartData.progress(
    value: 0.73,
    color: Colors.blue,
    width: 30,
    backgroundColor: Colors.black12,
    // defaults: min=0, max=1, startDegreeOffset=-225, sweepAngle=270
  ),
);
```

### Multi-ring ("Apple Watch") gauge

```dart
GaugeChart(
  GaugeChartData(
    minValue: 0,
    maxValue: 100,
    startDegreeOffset: -225,
    sweepAngle: 270,
    defaultRingWidth: 22,
    ringsSpace: 4,
    rings: [
      // innermost
      GaugeProgressRing(
        value: 72,
        color: Colors.red,
        backgroundColor: Colors.red.withValues(alpha: 0.2),
      ),
      GaugeProgressRing(
        value: 48,
        color: Colors.green,
        backgroundColor: Colors.green.withValues(alpha: 0.2),
      ),
      // outermost
      GaugeProgressRing(
        value: 90,
        color: Colors.blue,
        backgroundColor: Colors.blue.withValues(alpha: 0.2),
      ),
    ],
  ),
);
```

### Speedometer with threshold zones

```dart
GaugeChart(
  GaugeChartData(
    minValue: 350,
    maxValue: 850,
    startDegreeOffset: 180,
    sweepAngle: 180,
    ringsSpace: 4,
    rings: [
      // inner ring — current measurement
      GaugeProgressRing(
        value: 370,
        color: Colors.green,
        backgroundColor: Colors.grey,
        width: 30,
      ),
      // outer ring — colored threshold bands, with a visible pixel
      // gap between neighbors
      GaugeZonesRing(
        width: 10,
        zonesSpace: 4,
        zones: [
          GaugeZone(from: 350, to: 600, color: Colors.redAccent),
          GaugeZone(from: 600, to: 700, color: Colors.amber),
          GaugeZone(from: 700, to: 800, color: Colors.lightGreen),
          GaugeZone(from: 800, to: 850, color: Colors.green),
        ],
      ),
    ],
  ),
);
```

### GaugeChartData
|PropName|Description|default value|
|:-------|:----------|:------------|
|rings| list of [GaugeRing](#GaugeRing) rings, innermost first. All rings share the same `minValue`/`maxValue` scale|required|
|minValue| lower bound of the gauge scale (inclusive), shared by every ring|0.0|
|maxValue| upper bound of the gauge scale (inclusive), shared by every ring|1.0|
|startDegreeOffset| starting angle of the arc, in degrees. `0°` points right, same convention as [PieChartData.startDegreeOffset](pie_chart.md#PieChartData)|-225.0|
|sweepAngle| length of the arc in degrees, must be in `(0, 360]`|270.0|
|direction| whether the arc travels clockwise or counter-clockwise from `startDegreeOffset` — see [GaugeDirection](#GaugeDirection)|GaugeDirection.clockwise|
|defaultRingWidth| width used for rings that don't specify their own `width`|10.0|
|ringsSpace| radial pixel gap between adjacent rings|0.0|
|ticks| optional tick configuration; see [GaugeTicks](#GaugeTicks)|null|
|pointers| list of [GaugePointer](#GaugePointer)s drawn on top of the rings and ticks. Empty by default; each pointer carries its own `value` on the shared scale|`[]`|
|markers| list of [GaugeMarker](#GaugeMarker)s anchored at arbitrary continuous values along the gauge's scale. Empty by default|`[]`|
|touchData| [GaugeTouchData](#GaugeTouchData) holds the touch interactivity details|GaugeTouchData()|
|borderData| shows a border around the chart, see [FlBorderData](base_chart.md#FlBorderData)|FlBorderData()|

### GaugeRing
`GaugeRing` is a sealed base type — every ring is one of the two concrete shapes below. You can pattern-match on the concrete type in touch callbacks. All rings share:

|PropName|Description|default value|
|:-------|:----------|:------------|
|width| stroke width in pixels. If null, `GaugeChartData.defaultRingWidth` is used|null|

### GaugeProgressRing
A ring filled from `GaugeChartData.minValue` up to `value`. The unfilled portion (`value..maxValue`) is painted in `backgroundColor` when provided. Its two arcs (background + filled) share one `strokeCap`.

|PropName|Description|default value|
|:-------|:----------|:------------|
|value| current progress on the gauge scale|required|
|color| stroke color of the filled portion|required|
|backgroundColor| optional stroke color for the unfilled portion. If null, no background is drawn|null|
|strokeCap| cap style for both the background and filled arcs of this ring. Use `StrokeCap.round` for a rounded "tip" where the value ends|StrokeCap.butt|
|width| inherited from [GaugeRing](#GaugeRing)|null|

### GaugeZonesRing
A ring divided into fixed colored [GaugeZone](#GaugeZone) bands. Zones are bounds-checked against the chart's `minValue`/`maxValue` but are not required to be sorted, contiguous, or non-overlapping — they're drawn in list order, so later zones paint on top of overlapping earlier ones. Cap style is configured **per zone** via [GaugeZone.strokeCap](#GaugeZone), not at the ring level.

|PropName|Description|default value|
|:-------|:----------|:------------|
|zones| list of [GaugeZone](#GaugeZone) bands painted along this ring's arc|required|
|zonesSpace| visible gap between adjacent zones, in pixels, measured **perpendicular to the ring** — so the gap has the same width at the ring's inner and outer edges regardless of how thick the ring is. Applied **only between zones** (in list order) by carving a rectangular strip at each internal boundary. The first zone's leading edge and the last zone's trailing edge are left flush to the gauge's angular extremes. Per-zone `StrokeCap.round` is preserved: rounded neighbors keep a pill look across the gap (effective visible gap = `zonesSpace − width`), so set `zonesSpace > width` to keep a visible separator when caps are rounded.|0.0|
|width| inherited from [GaugeRing](#GaugeRing)|null|

### GaugeZone
A single colored band within a [GaugeZonesRing](#GaugeZonesRing).

|PropName|Description|default value|
|:-------|:----------|:------------|
|from| lower bound of the zone on the gauge scale (inclusive)|required|
|to| upper bound of the zone on the gauge scale (inclusive); must be `>= from`|required|
|color| fill color of this band|required|
|strokeCap| cap style for this band's two ends. Adjacent zones paint in list order, so a later zone's `butt` start paints over an earlier zone's rounded end-cap bulge — useful for getting rounded outer extremes with clean internal boundaries|StrokeCap.butt|

### GaugeDirection
|Value|Behavior|
|:----|:-------|
|`clockwise`| arc travels clockwise from `startDegreeOffset`.|
|`counterClockwise`| arc travels counter-clockwise from `startDegreeOffset`.|

### GaugeTicks
Tick marks drawn along the gauge's scale. Ticks frame the gauge as a whole — they reference the ring stack's outer edge, inner edge, or radial center — and are not owned by any individual ring. Ticks are evenly spaced from `startDegreeOffset` across the sweep (endpoints included).

|PropName|Description|default value|
|:-------|:----------|:------------|
|count| number of ticks drawn, including both sweep endpoints; must be `>= 2`|3|
|position| where ticks sit — see [GaugeTickPosition](#GaugeTickPosition)|GaugeTickPosition.outer|
|offset| **signed** pixel delta from the natural tick anchor, measured along the `position`'s outward axis (away from center for `outer`, toward center for `inner`, toward outer for `center`). Positive extends the tick farther in that direction; negative pulls it back toward / across the ring stack.|0|
|painter| [GaugeTickPainter](#GaugeTickPainter) that renders each tick|GaugeTickLinePainter()|
|CheckToShowGaugeTick| `bool Function(CheckToShowGaugeTickInfo info)` — predicate called per tick. Returning `false` skips both the tick mark and its label. Receives the tick's `index`, the total `count`, its scale `value`, and the chart's `minValue` / `maxValue`. Two predefined predicates ship on `GaugeTicks`: `GaugeTicks.showAll` (the default) and `GaugeTicks.hideEndpoints` (skip the first and last tick — handy when the arc already visually anchors its extremes via rounded zone caps). Use top-level / static references rather than anonymous closures so equality holds across rebuilds.|GaugeTicks.showAll|
|labelBuilder| optional `String Function(double value)` returning the label for each tick's scale value. `null` means no labels.|null|
|labelStyle| style applied to labels, merged with the current theme via `getThemeAwareTextStyle`. `null` inherits the theme's default text style.|null|
|labelOffset| **signed** pixel delta between the tick's far edge and the label center, along the same outward axis as `offset`. Positive pushes the label further outward; negative pulls it toward / across the tick.|0|

### GaugeTickPosition
|Value|Behavior|
|:----|:-------|
|`outer`| ticks sit outside the outermost ring; reserves radial padding so the ring stack fits inside the widget bounds.|
|`inner`| ticks sit inside the innermost ring's inner edge, toward the gauge center.|
|`center`| ticks are radially centered between the outermost and innermost ring edges.|

### GaugeTickPainter
Interface for rendering a single tick mark. Subclass it to draw custom tick shapes. Mirrors the [FlDotPainter](line_chart.md) pattern.

**Pre-transformed canvas** — the gauge painter translates and rotates the canvas around each tick's anchor before calling `draw`, so implementations never touch trigonometry:

- origin `(0, 0)` is the tick's anchor on the gauge
- `+x` axis points in the tick's outward direction (per `GaugeTicks.position`)
- `+y` axis is tangent to the arc in the sweep direction

Draw a horizontal, right-facing shape at the origin; the gauge handles placing and rotating it for every tick angle. `getSize()` reports the bounding box in this unrotated local frame — `width` is the radial extent (used for outer padding), `height` is the tangential extent.

Built-in implementations:
- **GaugeTickLinePainter** — draws a line from the origin to `(length, 0)`; the canonical tick shape. Properties: `length` (default 6), `thickness` (default 2), `color` (default black). This is the default.
- **GaugeTickCirclePainter** — rotation-invariant filled circle, optionally with a stroked outline. Properties: `radius` (default 3), `color` (default black), `strokeWidth` (default 0), `strokeColor` (default black).

### GaugePointer
A single pointer rendered on top of the rings and ticks, indicating a value on the gauge's scale. Each pointer carries its own `value` — independent from any ring — so you can stack multiple pointers (clock hands, dual readings, a needle plus a pivot cap) by adding more entries to `GaugeChartData.pointers`.

|PropName|Description|default value|
|:-------|:----------|:------------|
|value| position on the gauge scale the pointer points at. Values outside `[minValue, maxValue]` simply extend past the sweep endpoints|required|
|painter| [GaugePointerPainter](#GaugePointerPainter) that renders the pointer's shape|GaugePointerNeedlePainter()|

### GaugePointerPainter
Interface for rendering a single [GaugePointer](#GaugePointer). Subclass it to draw custom pointer shapes. Mirrors the [GaugeTickPainter](#GaugeTickPainter) pattern.

**Pre-transformed canvas** — the gauge painter translates and rotates the canvas around the gauge's center before calling `draw`, so implementations never touch trigonometry:

- origin `(0, 0)` is the **gauge center**
- `+x` axis points **radially outward** toward the pointer's value angle
- `+y` axis is **tangent** to the arc in the sweep direction

Draw a horizontal, right-facing shape at the origin; the gauge rotates and translates the canvas for every pointer's value. `getSize()` reports the bounding box in this unrotated local frame — `width` is the radial extent, `height` is the tangential extent.

Built-in implementations:
- **GaugePointerNeedlePainter** — classic triangular needle anchored at the gauge center, tapering to a point at `(length, 0)`. Properties: `length` (default 60), `width` (default 8), `tailLength` (default 0 — optional stub behind the pivot), `color` (default black). This is the default.
- **GaugePointerCirclePainter** — filled circle at `(anchorRadius, 0)`. Useful for marker-style pointers or as a pivot cap (`anchorRadius: 0`). Properties: `radius` (default 6), `anchorRadius` (default 0), `color` (default black), `strokeWidth` (default 0), `strokeColor` (default black).

A classic speedometer needle with a pivot cap is just two pointers with the same value:

```dart
pointers: const [
  GaugePointer(
    value: 0.65,
    painter: GaugePointerNeedlePainter(length: 70, width: 8, tailLength: 14),
  ),
  GaugePointer(
    value: 0.65,
    painter: GaugePointerCirclePainter(radius: 8, color: Colors.black),
  ),
],
```

### GaugeMarker
A marker anchored at an arbitrary continuous value along the gauge's scale. Conceptually a continuous-value cousin of [GaugeTicks](#GaugeTicks): markers reference the ring stack as a whole (outer / inner / center) and use the same arc-anchored local frame as [GaugeTickPainter](#GaugeTickPainter), but each carries its own `value` instead of being constrained to an evenly-spaced index.

Use markers for thresholds, targets, or annotations that fall at non-grid positions (e.g. a "min" marker at `0.234` or a "target" at `0.71`). For things that emanate from the gauge's center (needles, hands), use [GaugePointer](#GaugePointer) instead.

|PropName|Description|default value|
|:-------|:----------|:------------|
|value| position on the gauge scale where the marker is anchored. Values outside `[minValue, maxValue]` simply extend past the sweep endpoints|required|
|position| where the marker sits relative to the gauge's outer / inner bounds — same semantics as [GaugeTickPosition](#GaugeTickPosition)|GaugeTickPosition.outer|
|offset| signed pixel delta from the natural marker anchor, along the position's outward axis — same semantics as `GaugeTicks.offset`|0|
|painter| [GaugeMarkerPainter](#GaugeMarkerPainter) that renders the marker's shape|GaugeMarkerLinePainter()|

When `position: outer`, the gauge reserves padding so the rings shrink to keep the marker on canvas (the same way it does for outer ticks). The reserved padding is the **max** outward extent across all outer overlays, since they sit at different angles.

```dart
markers: [
  GaugeMarker(
    value: 0.234,
    position: GaugeTickPosition.center,
    painter: GaugeMarkerLinePainter(
      length: 40,
      thickness: 4,
      color: Colors.green,
      label: 'Min',
      labelStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      labelSide: GaugeMarkerLabelSide.inward,
    ),
  ),
  GaugeMarker(
    value: 0.71,
    position: GaugeTickPosition.center,
    painter: GaugeMarkerLinePainter(
      length: 40,
      thickness: 4,
      color: Colors.red,
      label: 'Max',
      labelStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      labelSide: GaugeMarkerLabelSide.inward,
    ),
  ),
],
```

### GaugeMarkerPainter
Interface for rendering a single [GaugeMarker](#GaugeMarker). Subclass it to draw custom marker shapes. Mirrors the [GaugeTickPainter](#GaugeTickPainter) pattern — the local frame is identical, so visually-similar tick painters can be ported in a couple of lines.

**Pre-transformed canvas** — the gauge painter translates and rotates the canvas around each marker's anchor on the arc before calling `draw`, so implementations never touch trigonometry:

- origin `(0, 0)` is the **marker's anchor on the arc**
- `+x` axis points in the marker's outward direction (per `GaugeMarker.position`)
- `+y` axis is **tangent** to the arc in the sweep direction

Draw a horizontal, right-facing shape at the origin; the gauge handles placing and rotating it for every marker's value. `getSize()` reports the bounding box in this unrotated local frame — `width` is the radial extent (used for outer-position padding), `height` is the tangential extent.

Built-in implementations:
- **GaugeMarkerLinePainter** — line segment, optionally with a text label beside it. Centered on the marker's anchor by default (markers are point indicators, so a symmetric crossbar reads more naturally than a tick-style outward line). This is the default. Properties:
  - `length` (default 10), `thickness` (default 2), `color` (default black), `strokeCap` (default `StrokeCap.round`).
  - `alignment` — `GaugeMarkerLineAlignment.centered` (default) draws the line spanning `[-length/2, +length/2]`; `.outward` matches the tick-style line `[0, length]`.
  - `label` (optional) — text drawn alongside the line. When set together with `labelStyle`, the painter renders the text on `labelSide` of the line, `labelOffset` pixels away. The label is **auto-flipped by 180°** when the marker sits on the gauge's left hemisphere (`cos(angleDegrees) < 0`) so it stays upright regardless of where it lands on the dial — no per-marker flip flag needed.
  - `labelStyle` — applied to the label; required for the label to render.
  - `labelOffset` (default 6) — gap in pixels between the line's end and the label.
  - `labelSide` — `GaugeMarkerLabelSide.outward` (default) sits the label radially outward of the line; `.inward` sits it between the line and the gauge center.

`getSize()` reports only the line's outward extent. If you place a long label on `GaugeMarkerLabelSide.outward` and want the rings to shrink to make room, add `offset: labelOffset + estimatedLabelWidth` on the [GaugeMarker](#GaugeMarker) itself.

### GaugeTouchData ([read about touch handling](handle_touches.md))
|PropName|Description|default value|
|:-------|:----------|:------------|
|enabled|determines whether to enable or disable touch behaviors|true|
|mouseCursorResolver|you can change the mouse cursor based on the provided [FlTouchEvent](base_chart.md#fltouchevent) and [GaugeTouchResponse](#GaugeTouchResponse)|MouseCursor.defer|
|touchCallback| listen to this callback to retrieve touch/pointer events and responses|null|
|longPressDuration| allows you to customize the duration of the longPress gesture. If null, the duration is [kLongPressTimeout](https://api.flutter.dev/flutter/gestures/kLongPressTimeout-constant.html)|null|

### GaugeTouchResponse
|PropName|Description|default value|
|:-------|:----------|:------------|
|touchLocation|the location of the touch event in device pixel coordinates|required|
|touchedRing|Instance of [GaugeTouchedRing](#GaugeTouchedRing) describing what the touch hit, or null when the touch fell entirely outside the arc's angular range|null|

### GaugeTouchedRing
A touch inside the arc's angular range always produces a `GaugeTouchedRing` — even when it falls in the gap between rings (`ringsSpace`) or outside every ring's radial band. In those cases `touchedRing` is null and `touchedRingIndex` is `-1`, but `touchValue` is still filled in.

When the hit ring is a [GaugeProgressRing](#GaugeProgressRing), `isOnValue` is `true` if the touch sits on the filled portion (`touchValue <= ring.value`).

When the hit ring is a [GaugeZonesRing](#GaugeZonesRing), `touchedZone` / `touchedZoneIndex` report the specific band the touch angle falls into (or null when it's in a gap between zones).

|PropName|Description|default value|
|:-------|:----------|:------------|
|touchedRing|the [GaugeRing](#GaugeRing) (ring) that was hit, or null if the touch missed all rings|null|
|touchedRingIndex| index of the hit ring, or `-1` when no ring was hit|required|
|touchAngle| angle of the touch in degrees (same convention as `startDegreeOffset`: 0° points right)|required|
|touchRadius| distance from the gauge's center to the touch in pixels|required|
|touchValue| touch position interpolated along the gauge's scale, in `[minValue, maxValue]`|required|
|isOnValue| true when a [GaugeProgressRing](#GaugeProgressRing) was hit AND the touch sits on its filled portion; false otherwise (including zones-ring hits and misses)|required|
|touchedZone| the [GaugeZone](#GaugeZone) hit when the touched ring is a [GaugeZonesRing](#GaugeZonesRing) and the touch falls inside one of its bands|null|
|touchedZoneIndex| index of `touchedZone` in the hit ring's `zones` list, or `-1`|-1|
