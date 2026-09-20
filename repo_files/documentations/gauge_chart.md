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
<!-- api:GaugeChartData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|rings|`List<GaugeRing>`|required|The rings drawn by the chart, innermost first.|
|minValue|`double`|`0.0`|Lower bound of the gauge scale (inclusive). Shared by every ring. default is 0.0|
|maxValue|`double`|`1.0`|Upper bound of the gauge scale (inclusive). Shared by every ring. default is 1.0|
|startDegreeOffset|`double`|`-225.0`|Starting angle of the arc, in degrees. 0° points right, matching [`PieChartData.startDegreeOffset`](pie_chart.md#piechartdata) and [`Canvas.drawArc`](https://api.flutter.dev/flutter/dart-ui/Canvas-class.html).|
|sweepAngle|`double`|`270.0`|Length of the arc, in degrees. Must be in (0, 360].|
|direction|`GaugeDirection`|`GaugeDirection.clockwise`|Whether the arc travels clockwise or counter-clockwise from `startDegreeOffset`.|
|defaultRingWidth|`double`|`10.0`|Width used for rings that don't specify their own [`GaugeRing.width`](#gaugering).|
|ringsSpace|`double`|`0.0`|Radial gap in pixels between adjacent rings.|
|ticks|`GaugeTicks?`|`null`|Optional tick configuration drawn along the gauge's scale. Ticks reference the ring stack as a whole (outer edge of the outermost ring, inner edge of the innermost ring, or radially centered) and are not owned by any individual ring.|
|pointers|`List<GaugePointer>`|`const []`|Pointers drawn on top of the rings. Each [`GaugePointer`](#gaugepointer) carries its own `value` on the same scale as the rings; the painter is pre-transformed so `+x` points radially toward that value. Empty by default.|
|markers|`List<GaugeMarker>`|`const []`|Markers anchored at arbitrary continuous values along the gauge's scale. Like `ticks` in shape and local frame — but each marker carries its own `value` on `[minValue, maxValue]` instead of being constrained to an evenly-spaced index. Use this to highlight thresholds, targets, or annotations at non-grid positions. Empty by default.|
|touchData|`GaugeTouchData?`|`GaugeTouchData()`|Touch configuration and callback.|
|borderData|`FlBorderData?`|`FlBorderData()`|Holds data to draw the border around the chart, see [`FlBorderData`](base_chart.md#flborderdata).|
<!-- /api -->

### GaugeRing
`GaugeRing` is a sealed base type — every ring is one of the two concrete shapes below. You can pattern-match on the concrete type in touch callbacks. All rings share:

<!-- api:GaugeRing fields -->
|Property|Type|Description|
|:-------|:---|:----------|
|width|`double?`|Stroke width in pixels. If null, [`GaugeChartData.defaultRingWidth`](#gaugechartdata) is used.|
<!-- /api -->

### GaugeProgressRing
A ring filled from `GaugeChartData.minValue` up to `value`. The unfilled portion (`value..maxValue`) is painted in `backgroundColor` when provided. Its two arcs (background + filled) share one `strokeCap`.

<!-- api:GaugeProgressRing -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|value|`double`|required|Current value on the gauge scale. The ring fills from [`GaugeChartData.minValue`](#gaugechartdata) up to this value.|
|color|`Color`|required|Stroke color for the filled portion of the ring.|
|backgroundColor|`Color?`|`null`|Optional stroke color for the unfilled portion. When null, no background is drawn for this ring.|
|strokeCap|`StrokeCap`|`StrokeCap.butt`|Cap style applied to the ends of both the background and filled arcs of this ring. For the typical battery-meter / progress-bar look, use [`StrokeCap.round`](https://api.flutter.dev/flutter/dart-ui/StrokeCap.html).|
|width|`double?`|`null`|Stroke width in pixels. If null, [`GaugeChartData.defaultRingWidth`](#gaugechartdata) is used.|
<!-- /api -->

### GaugeZonesRing
A ring divided into fixed colored [GaugeZone](#GaugeZone) bands. Zones are bounds-checked against the chart's `minValue`/`maxValue` but are not required to be sorted, contiguous, or non-overlapping — they're drawn in list order, so later zones paint on top of overlapping earlier ones. Cap style is configured **per zone** via [GaugeZone.strokeCap](#GaugeZone), not at the ring level.

<!-- api:GaugeZonesRing -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|zones|`List<GaugeZone>`|required|The colored bands drawn along this ring's arc. Each band controls its own [`GaugeZone.strokeCap`](#gaugezone).|
|zonesSpace|`double`|`0.0`|Visible gap between adjacent zones, in pixels, measured perpendicular to the ring (so the gap has the same width at the inner and outer edges regardless of ring thickness).<br><br>Applied only *between* zones (in list order): a `zonesSpace`-wide rectangular strip is carved at each internal boundary. The first zone's leading edge and the last zone's trailing edge are not touched, so zones stay flush to the gauge's angular extremes.<br><br>Per-zone `StrokeCap.round` is preserved: after the strip is carved, each neighbor's internal end is re-drawn as a filled circle so zones with rounded caps keep their pill look across the gap. The visible gap between two rounded neighbors is `zonesSpace − width`, so set `zonesSpace > width` to keep a visible separator when caps are rounded.|
|width|`double?`|`null`|Stroke width in pixels. If null, [`GaugeChartData.defaultRingWidth`](#gaugechartdata) is used.|
<!-- /api -->

### GaugeZone
A single colored band within a [GaugeZonesRing](#GaugeZonesRing).

<!-- api:GaugeZone -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|from|`double`|required|Lower bound of the zone on the gauge's scale (inclusive).|
|to|`double`|required|Upper bound of the zone on the gauge's scale (inclusive), it must be `>= from`.|
|color|`Color`|required|Fill color of this band.|
|strokeCap|`StrokeCap`|`StrokeCap.butt`|Cap style applied to this band's two ends. Independent per zone — adjacent zones paint in list order, so a later zone's butt start paints over an earlier zone's rounded end-cap bulge.|
<!-- /api -->

### GaugeDirection
<!-- api:GaugeDirection -->
|Value|Description|
|:----|:----------|
|clockwise|The arc travels clockwise from [`GaugeChartData.startDegreeOffset`](#gaugechartdata).|
|counterClockwise|The arc travels counter-clockwise from [`GaugeChartData.startDegreeOffset`](#gaugechartdata).|
<!-- /api -->

### GaugeTicks
Tick marks drawn along the gauge's scale. Ticks frame the gauge as a whole — they reference the ring stack's outer edge, inner edge, or radial center — and are not owned by any individual ring. Ticks are evenly spaced from `startDegreeOffset` across the sweep (endpoints included).

<!-- api:GaugeTicks -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|count|`int`|`3`|Number of ticks drawn, including both sweep endpoints. Minimum 2.|
|position|`GaugeTickPosition`|`GaugeTickPosition.outer`|Where ticks sit relative to the gauge's outer / inner bounds.|
|offset|`double`|`0`|Signed pixel delta from the natural tick anchor, measured along the `position`'s outward axis (away from center for [`GaugeTickPosition.outer`](#gaugetickposition), toward center for [`GaugeTickPosition.inner`](#gaugetickposition), toward outer for [`GaugeTickPosition.center`](#gaugetickposition)). Positive extends the tick farther in that direction; negative pulls it back toward (or across) the ring stack.|
|painter|`GaugeTickPainter`|`const GaugeTickLinePainter()`|Renders each tick. The canvas is pre-translated and pre-rotated so the painter just draws a horizontal, right-facing shape at the origin — see [`GaugeTickPainter.draw`](#gaugetickpainter).|
|checkToShowTick|`bool Function(GaugeTickInfo)`|`GaugeTicks.showAll`|Predicate deciding whether each tick is drawn. Receives a [`GaugeTickInfo`](https://pub.dev/documentation/fl_chart/latest/fl_chart/GaugeTickInfo-class.html) with the tick's index, the total `count`, its scale value, and the chart's `minValue` / `maxValue`. Returning `false` skips both the tick mark and its label.<br><br>Defaults to [`GaugeTicks.showAll`](#gaugeticks). Use [`GaugeTicks.hideEndpoints`](#gaugeticks) to skip the first and last ticks — handy when the arc already visually anchors its extremes (e.g. rounded zone caps). Users can pass any predicate for custom behaviour.<br><br>Pass a top-level or static function when possible; anonymous closures compare by identity, which breaks equality across rebuilds and causes unnecessary tween animations.|
|labelBuilder|`String Function(double)?`|`null`|Returns the text painted as a label next to each tick. The input is the tick's scale value on `[minValue, maxValue]`. When `null`, no labels are drawn. To keep a tick mark but drop its label at a specific value, return an empty string from this builder.|
|labelStyle|`TextStyle?`|`null`|Style applied to labels, merged with the chart's current theme. When `null`, the theme's default text style is used.|
|labelOffset|`double`|`0`|Signed pixel delta between the tick's far edge and its label, along the same outward axis as `offset`. Positive pushes the label further outward; negative pulls it toward (or across) the tick.|
<!-- /api -->

### GaugeTickPosition
<!-- api:GaugeTickPosition -->
|Value|Description|
|:----|:----------|
|outer|Outside the outermost ring. Reserves radial padding so rings shrink to fit ticks (and labels, when present).|
|inner|Inside the innermost ring's inner edge, toward the gauge center.|
|center|Radially centered between the outermost ring's outer edge and the innermost ring's inner edge.|
<!-- /api -->

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

<!-- api:GaugePointer -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|value|`double`|required|Position on the gauge scale the pointer points at. Values outside `[GaugeChartData.minValue, maxValue]` are not asserted — the pointer simply extends past the sweep endpoints.|
|painter|`GaugePointerPainter`|`const GaugePointerNeedlePainter()`|Renders the pointer's shape. The canvas is pre-transformed by the gauge painter — see [`GaugePointerPainter.draw`](#gaugepointerpainter).|
<!-- /api -->

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

<!-- api:GaugeMarker -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|value|`double`|required|Position on the gauge scale where the marker is anchored. Values outside `[GaugeChartData.minValue, maxValue]` are not asserted — the marker simply extends past the sweep endpoints.|
|position|`GaugeTickPosition`|`GaugeTickPosition.outer`|Where the marker sits relative to the gauge's outer / inner bounds. Same semantics as [`GaugeTicks.position`](#gaugeticks).|
|offset|`double`|`0`|Signed pixel delta from the natural marker anchor, measured along the `position`'s outward axis. Same semantics as [`GaugeTicks.offset`](#gaugeticks).|
|painter|`GaugeMarkerPainter`|`const GaugeMarkerLinePainter()`|Renders the marker. The canvas is pre-translated and pre-rotated so the painter just draws a horizontal, right-facing shape at the origin — see [`GaugeMarkerPainter.draw`](#gaugemarkerpainter).|
<!-- /api -->

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
<!-- api:GaugeTouchData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|enabled|`bool?`|`true`|Determines whether to enable or disable touch behaviors.|
|touchCallback|`void Function(FlTouchEvent, GaugeTouchResponse?)?`|`null`|`touchCallback` notifies you about the happened touch/pointer events. It gives you a [`FlTouchEvent`](base_chart.md#fltouchevent) which is the happened event such as [`FlPointerHoverEvent`](https://pub.dev/documentation/fl_chart/latest/fl_chart/FlPointerHoverEvent-class.html), [`FlTapUpEvent`](https://pub.dev/documentation/fl_chart/latest/fl_chart/FlTapUpEvent-class.html), ... It also gives you a [`BaseTouchResponse`](https://pub.dev/documentation/fl_chart/latest/fl_chart/BaseTouchResponse-class.html) which is the chart specific type and contains information about the elements that has touched.|
|mouseCursorResolver|`MouseCursor Function(FlTouchEvent, GaugeTouchResponse?)?`|`null`|Using `mouseCursorResolver` you can change the mouse cursor based on the provided [`FlTouchEvent`](base_chart.md#fltouchevent) and [`BaseTouchResponse`](https://pub.dev/documentation/fl_chart/latest/fl_chart/BaseTouchResponse-class.html)|
|longPressDuration|`Duration?`|`null`|This property that allows to customize the duration of the longPress gesture. If null, it uses [kLongPressTimeout](https://api.flutter.dev/flutter/gestures/kLongPressTimeout-constant.html) (500 milliseconds).|
<!-- /api -->

### GaugeTouchResponse
<!-- api:GaugeTouchResponse fields -->
|Property|Type|Description|
|:-------|:---|:----------|
|touchLocation|`Offset`|The location of the touch in pixels on the screen.|
|touchedRing|`GaugeTouchedRing?`|Details of the touch, or null if the touch fell entirely outside the arc's angular range.|
<!-- /api -->

### GaugeTouchedRing
A touch inside the arc's angular range always produces a `GaugeTouchedRing` — even when it falls in the gap between rings (`ringsSpace`) or outside every ring's radial band. In those cases `touchedRing` is null and `touchedRingIndex` is `-1`, but `touchValue` is still filled in.

When the hit ring is a [GaugeProgressRing](#GaugeProgressRing), `isOnValue` is `true` if the touch sits on the filled portion (`touchValue <= ring.value`).

When the hit ring is a [GaugeZonesRing](#GaugeZonesRing), `touchedZone` / `touchedZoneIndex` report the specific band the touch angle falls into (or null when it's in a gap between zones).

<!-- api:GaugeTouchedRing fields -->
|Property|Type|Description|
|:-------|:---|:----------|
|touchedRing|`GaugeRing?`|The ring that was touched, or null if the touch fell between / outside rings.|
|touchedRingIndex|`int`|Index of the touched ring in [`GaugeChartData.rings`](#gaugechartdata), or -1 if no ring was hit.|
|touchAngle|`double`|Angle of the touch in degrees, using the same convention as [`GaugeChartData.startDegreeOffset`](#gaugechartdata) (0° points right).|
|touchRadius|`double`|Distance from the gauge's center to the touch, in pixels.|
|touchValue|`double`|Touch position interpolated along the shared gauge scale, in [[`GaugeChartData.minValue`](#gaugechartdata), [`GaugeChartData.maxValue`](#gaugechartdata)].|
|isOnValue|`bool`|True when a [`GaugeProgressRing`](#gaugeprogressring) was hit AND the touch sits on its filled portion (`touchValue <= ring.value`). False otherwise, including for [`GaugeZonesRing`](#gaugezonesring) hits and misses.|
|touchedZone|`GaugeZone?`|The zone that was touched when the hit ring is a [`GaugeZonesRing`](#gaugezonesring) and the touch angle falls inside one of its zones. Null for progress-ring hits and for touches in gaps between zones.|
|touchedZoneIndex|`int`|Index of `touchedZone` in the hit ring's `zones` list, or -1.|
<!-- /api -->
