import 'dart:math' as math;
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/widgets.dart';

/// [GaugeChart] needs this class to render itself.
///
/// A gauge chart is a set of concentric rings drawn along a shared arc.
/// Each [GaugeRing] is one ring on a scale shared by every ring.
/// Sections are stacked innermost-first in list order — so `rings[0]`
/// is the innermost ring and the last entry is the outermost — separated
/// by [ringsSpace] pixels.
///
/// A ring is one of two shapes:
/// - [GaugeProgressRing] — a ring filled from [minValue] up to its
///   `value`, with an optional `backgroundColor` behind.
/// - [GaugeZonesRing] — a ring divided into fixed colored [GaugeZone]s
///   (threshold bands). Useful for speedometer-style level indicators.
class GaugeChartData extends BaseChartData with EquatableMixin {
  GaugeChartData({
    required List<GaugeRing> rings,
    this.minValue = 0.0,
    this.maxValue = 1.0,
    this.startDegreeOffset = -225.0,
    this.sweepAngle = 270.0,
    this.direction = GaugeDirection.clockwise,
    this.defaultRingWidth = 10.0,
    this.ringsSpace = 0.0,
    this.ticks,
    List<GaugePointer> pointers = const [],
    List<GaugeMarker> markers = const [],
    GaugeTouchData? touchData,
    super.borderData,
  })  : rings = List.unmodifiable(rings),
        pointers = List.unmodifiable(pointers),
        markers = List.unmodifiable(markers),
        gaugeTouchData = touchData ?? GaugeTouchData(),
        assert(maxValue > minValue, 'maxValue must be greater than minValue'),
        assert(
          sweepAngle > 0 && sweepAngle <= 360,
          'sweepAngle must be in (0, 360]',
        ),
        assert(ringsSpace >= 0, 'ringsSpace must be >= 0') {
    for (final ring in rings) {
      switch (ring) {
        case GaugeProgressRing():
          assert(
            ring.value >= minValue && ring.value <= maxValue,
            'GaugeProgressRing.value ${ring.value} is outside '
            '[$minValue, $maxValue]',
          );
        case GaugeZonesRing():
          assert(
            ring.zones.isNotEmpty,
            'GaugeZonesRing.zones must not be empty',
          );
          for (final zone in ring.zones) {
            assert(
              zone.from >= minValue && zone.to <= maxValue,
              'GaugeZone [${zone.from}, ${zone.to}] is outside '
              '[$minValue, $maxValue]',
            );
          }
      }
    }
  }

  /// Convenience factory for the single-ring progress bar use case
  /// (battery meter, loading indicator, etc.). Shorthand for a
  /// [GaugeChartData] with one [GaugeProgressRing].
  factory GaugeChartData.progress({
    required double value,
    required Color color,
    required double width,
    Color? backgroundColor,
    double min = 0.0,
    double max = 1.0,
    StrokeCap strokeCap = StrokeCap.butt,
    double startDegreeOffset = -225.0,
    double sweepAngle = 270.0,
    GaugeDirection direction = GaugeDirection.clockwise,
    GaugeTicks? ticks,
    List<GaugePointer> pointers = const [],
    List<GaugeMarker> markers = const [],
    GaugeTouchData? touchData,
    FlBorderData? borderData,
  }) =>
      GaugeChartData(
        minValue: min,
        maxValue: max,
        rings: [
          GaugeProgressRing(
            value: value.clamp(min, max),
            color: color,
            width: width,
            backgroundColor: backgroundColor,
            strokeCap: strokeCap,
          ),
        ],
        defaultRingWidth: width,
        startDegreeOffset: startDegreeOffset,
        sweepAngle: sweepAngle,
        direction: direction,
        ticks: ticks,
        pointers: pointers,
        markers: markers,
        touchData: touchData,
        borderData: borderData,
      );

  /// The rings drawn by the chart, innermost first.
  final List<GaugeRing> rings;

  /// Lower bound of the gauge scale (inclusive). Shared by every ring.
  /// default is 0.0
  final double minValue;

  /// Upper bound of the gauge scale (inclusive). Shared by every ring.
  /// default is 1.0
  final double maxValue;

  /// Starting angle of the arc, in degrees. 0° points right, matching
  /// [PieChartData.startDegreeOffset] and [Canvas.drawArc].
  final double startDegreeOffset;

  /// Length of the arc, in degrees. Must be in (0, 360].
  final double sweepAngle;

  /// Whether the arc travels clockwise or counter-clockwise from
  /// [startDegreeOffset].
  final GaugeDirection direction;

  /// Width used for rings that don't specify their own
  /// [GaugeRing.width].
  final double defaultRingWidth;

  /// Radial gap in pixels between adjacent rings.
  final double ringsSpace;

  /// Optional tick configuration drawn along the gauge's scale. Ticks
  /// reference the ring stack as a whole (outer edge of the outermost
  /// ring, inner edge of the innermost ring, or radially centered) and
  /// are not owned by any individual ring.
  final GaugeTicks? ticks;

  /// Pointers drawn on top of the rings. Each [GaugePointer] carries
  /// its own `value` on the same scale as the rings; the painter is
  /// pre-transformed so `+x` points radially toward that value. Empty
  /// by default.
  final List<GaugePointer> pointers;

  /// Markers anchored at arbitrary continuous values along the gauge's
  /// scale. Like [ticks] in shape and local frame — but each marker
  /// carries its own `value` on `[minValue, maxValue]` instead of being
  /// constrained to an evenly-spaced index. Use this to highlight
  /// thresholds, targets, or annotations at non-grid positions. Empty
  /// by default.
  final List<GaugeMarker> markers;

  /// Touch configuration and callback.
  final GaugeTouchData gaugeTouchData;

  /// Resolves the width for [ring], falling back to
  /// [defaultRingWidth] when the ring doesn't specify one.
  double resolveRingWidth(GaugeRing ring) => ring.width ?? defaultRingWidth;

  @override
  List<Object?> get props => [
        rings,
        minValue,
        maxValue,
        startDegreeOffset,
        sweepAngle,
        direction,
        defaultRingWidth,
        ringsSpace,
        ticks,
        pointers,
        markers,
        gaugeTouchData,
        borderData,
      ];

  GaugeChartData copyWith({
    List<GaugeRing>? rings,
    double? minValue,
    double? maxValue,
    double? startDegreeOffset,
    double? sweepAngle,
    GaugeDirection? direction,
    double? defaultRingWidth,
    double? ringsSpace,
    GaugeTicks? ticks,
    List<GaugePointer>? pointers,
    List<GaugeMarker>? markers,
    GaugeTouchData? touchData,
    FlBorderData? borderData,
  }) =>
      GaugeChartData(
        rings: rings ?? this.rings,
        minValue: minValue ?? this.minValue,
        maxValue: maxValue ?? this.maxValue,
        startDegreeOffset: startDegreeOffset ?? this.startDegreeOffset,
        sweepAngle: sweepAngle ?? this.sweepAngle,
        direction: direction ?? this.direction,
        defaultRingWidth: defaultRingWidth ?? this.defaultRingWidth,
        ringsSpace: ringsSpace ?? this.ringsSpace,
        ticks: ticks ?? this.ticks,
        pointers: pointers ?? this.pointers,
        markers: markers ?? this.markers,
        touchData: touchData ?? gaugeTouchData,
        borderData: borderData ?? this.borderData,
      );

  @override
  GaugeChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is GaugeChartData && b is GaugeChartData) {
      return GaugeChartData(
        rings: lerpGaugeRingList(a.rings, b.rings, t)!,
        minValue: lerpDouble(a.minValue, b.minValue, t)!,
        maxValue: lerpDouble(a.maxValue, b.maxValue, t)!,
        startDegreeOffset:
            lerpDouble(a.startDegreeOffset, b.startDegreeOffset, t)!,
        sweepAngle: lerpDouble(a.sweepAngle, b.sweepAngle, t)!,
        direction: b.direction,
        defaultRingWidth:
            lerpDouble(a.defaultRingWidth, b.defaultRingWidth, t)!,
        ringsSpace: lerpDouble(a.ringsSpace, b.ringsSpace, t)!,
        ticks: GaugeTicks.lerp(a.ticks, b.ticks, t),
        pointers: lerpGaugePointerList(a.pointers, b.pointers, t)!,
        markers: lerpGaugeMarkerList(a.markers, b.markers, t)!,
        touchData: b.gaugeTouchData,
        borderData: FlBorderData.lerp(a.borderData, b.borderData, t),
      );
    } else {
      throw StateError('Illegal State');
    }
  }
}

/// Base type for a single concentric ring of a [GaugeChartData].
///
/// Sealed hierarchy — a ring is always either a [GaugeProgressRing]
/// (filled up to a value) or a [GaugeZonesRing] (divided into fixed
/// [GaugeZone]s). The [GaugeChartPainter] dispatches on the concrete
/// type; the hierarchy is closed to ensure that never changes silently.
sealed class GaugeRing with EquatableMixin {
  const GaugeRing({this.width});

  /// Stroke width in pixels. If null,
  /// [GaugeChartData.defaultRingWidth] is used.
  final double? width;

  /// Lerps this ring against another. Cross-type lerps snap to [b]
  /// (matches the [FlDotPainter.lerp] fallback pattern).
  static GaugeRing lerp(GaugeRing a, GaugeRing b, double t) {
    if (a is GaugeProgressRing && b is GaugeProgressRing) {
      return GaugeProgressRing.lerp(a, b, t);
    }
    if (a is GaugeZonesRing && b is GaugeZonesRing) {
      return GaugeZonesRing.lerp(a, b, t);
    }
    return b;
  }
}

/// A ring showing progress from [GaugeChartData.minValue] up to [value].
///
/// The unfilled portion of the ring (from [value] to
/// [GaugeChartData.maxValue]) is painted in [backgroundColor] when
/// provided; otherwise it's left empty.
final class GaugeProgressRing extends GaugeRing {
  const GaugeProgressRing({
    required this.value,
    required this.color,
    this.backgroundColor,
    this.strokeCap = StrokeCap.butt,
    super.width,
  }) : assert(width == null || width > 0, 'width must be > 0 when provided');

  /// Current value on the gauge scale. The ring fills from
  /// [GaugeChartData.minValue] up to this value.
  final double value;

  /// Stroke color for the filled portion of the ring.
  final Color color;

  /// Optional stroke color for the unfilled portion. When null, no
  /// background is drawn for this ring.
  final Color? backgroundColor;

  /// Cap style applied to the ends of both the background and filled
  /// arcs of this ring. For the typical battery-meter / progress-bar
  /// look, use [StrokeCap.round].
  final StrokeCap strokeCap;

  GaugeProgressRing copyWith({
    double? value,
    Color? color,
    double? width,
    Color? backgroundColor,
    StrokeCap? strokeCap,
  }) =>
      GaugeProgressRing(
        value: value ?? this.value,
        color: color ?? this.color,
        width: width ?? this.width,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        strokeCap: strokeCap ?? this.strokeCap,
      );

  static GaugeProgressRing lerp(
    GaugeProgressRing a,
    GaugeProgressRing b,
    double t,
  ) =>
      GaugeProgressRing(
        value: lerpDouble(a.value, b.value, t)!,
        color: Color.lerp(a.color, b.color, t)!,
        width: lerpDouble(a.width, b.width, t),
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
        strokeCap: b.strokeCap,
      );

  @override
  List<Object?> get props => [value, color, width, backgroundColor, strokeCap];
}

/// A ring displaying one or more fixed colored [GaugeZone]s along the
/// arc — useful for threshold / level indicators (e.g. a speedometer's
/// red/amber/green bands).
///
/// Zones are bounds-checked against [GaugeChartData.minValue] /
/// [GaugeChartData.maxValue] but not required to be sorted, contiguous,
/// or non-overlapping. They're drawn in list order, so later zones paint
/// on top of overlapping earlier ones.
final class GaugeZonesRing extends GaugeRing {
  const GaugeZonesRing({
    required this.zones,
    this.zonesSpace = 0.0,
    super.width,
  })  : assert(width == null || width > 0, 'width must be > 0 when provided'),
        assert(zonesSpace >= 0, 'zonesSpace must be >= 0');

  /// The colored bands drawn along this ring's arc. Each band controls
  /// its own [GaugeZone.strokeCap].
  final List<GaugeZone> zones;

  /// Visible gap between adjacent zones, in pixels, measured
  /// perpendicular to the ring (so the gap has the same width at the
  /// inner and outer edges regardless of ring thickness).
  ///
  /// Applied only *between* zones (in list order): a [zonesSpace]-wide
  /// rectangular strip is carved at each internal boundary. The first
  /// zone's leading edge and the last zone's trailing edge are not
  /// touched, so zones stay flush to the gauge's angular extremes.
  ///
  /// Per-zone `StrokeCap.round` is preserved: after the strip is
  /// carved, each neighbor's internal end is re-drawn as a filled
  /// circle so zones with rounded caps keep their pill look across
  /// the gap. The visible gap between two rounded neighbors is
  /// `zonesSpace − width`, so set `zonesSpace > width` to keep a
  /// visible separator when caps are rounded.
  final double zonesSpace;

  GaugeZonesRing copyWith({
    List<GaugeZone>? zones,
    double? zonesSpace,
    double? width,
  }) =>
      GaugeZonesRing(
        zones: zones ?? this.zones,
        zonesSpace: zonesSpace ?? this.zonesSpace,
        width: width ?? this.width,
      );

  static GaugeZonesRing lerp(
    GaugeZonesRing a,
    GaugeZonesRing b,
    double t,
  ) =>
      GaugeZonesRing(
        zones: lerpGaugeZoneList(a.zones, b.zones, t)!,
        zonesSpace: lerpDouble(a.zonesSpace, b.zonesSpace, t)!,
        width: lerpDouble(a.width, b.width, t),
      );

  @override
  List<Object?> get props => [zones, zonesSpace, width];
}

/// A single colored band within a [GaugeZonesRing]. [from] and [to]
/// are positions on the shared [GaugeChartData.minValue] /
/// [GaugeChartData.maxValue] scale; [to] must be `>= from`.
@immutable
class GaugeZone with EquatableMixin {
  const GaugeZone({
    required this.from,
    required this.to,
    required this.color,
    this.strokeCap = StrokeCap.butt,
  }) : assert(to >= from, 'to must be >= from');

  final double from;
  final double to;
  final Color color;

  /// Cap style applied to this band's two ends. Independent per zone —
  /// adjacent zones paint in list order, so a later zone's butt start
  /// paints over an earlier zone's rounded end-cap bulge.
  final StrokeCap strokeCap;

  GaugeZone copyWith({
    double? from,
    double? to,
    Color? color,
    StrokeCap? strokeCap,
  }) =>
      GaugeZone(
        from: from ?? this.from,
        to: to ?? this.to,
        color: color ?? this.color,
        strokeCap: strokeCap ?? this.strokeCap,
      );

  static GaugeZone lerp(GaugeZone a, GaugeZone b, double t) => GaugeZone(
        from: lerpDouble(a.from, b.from, t)!,
        to: lerpDouble(a.to, b.to, t)!,
        color: Color.lerp(a.color, b.color, t)!,
        strokeCap: b.strokeCap,
      );

  @override
  List<Object?> get props => [from, to, color, strokeCap];
}

/// It lerps a [GaugeChartData] to another [GaugeChartData] (handles
/// animation for updating values).
class GaugeChartDataTween extends Tween<GaugeChartData> {
  GaugeChartDataTween({
    required GaugeChartData begin,
    required GaugeChartData end,
  }) : super(begin: begin, end: end);

  /// Lerps a [GaugeChartData] based on [t] value, check [Tween.lerp].
  @override
  GaugeChartData lerp(double t) => begin!.lerp(begin!, end!, t);
}

/// Direction the arc travels from [GaugeChartData.startDegreeOffset].
enum GaugeDirection {
  clockwise,
  counterClockwise,
}

/// Where tick marks sit relative to the gauge's ring stack.
enum GaugeTickPosition {
  /// Outside the outermost ring. Reserves radial padding so rings
  /// shrink to fit ticks (and labels, when present).
  outer,

  /// Inside the innermost ring's inner edge, toward the gauge center.
  inner,

  /// Radially centered between the outermost ring's outer edge and
  /// the innermost ring's inner edge.
  center,
}

/// Configuration for tick marks drawn along a [GaugeChartData]'s arc.
///
/// Ticks frame the gauge as a whole — they reference the ring stack's
/// outer / inner envelope, not an individual ring. Evenly spaced along
/// the sweep, with the first tick at [GaugeChartData.startDegreeOffset]
/// and the last at the sweep's end.
///
/// When [labelBuilder] is provided, a text label is painted radially
/// past each tick. Labels stay upright (not tangent-rotated) for
/// readability.
@immutable
class GaugeTicks with EquatableMixin {
  const GaugeTicks({
    this.count = 3,
    this.position = GaugeTickPosition.outer,
    this.offset = 0,
    this.painter = const GaugeTickLinePainter(),
    this.checkToShowTick = showAll,
    this.labelBuilder,
    this.labelStyle,
    this.labelOffset = 0,
  }) : assert(count >= 2, 'count must be >= 2');

  /// Number of ticks drawn, including both sweep endpoints. Minimum 2.
  final int count;

  /// Where ticks sit relative to the gauge's outer / inner bounds.
  final GaugeTickPosition position;

  /// Signed pixel delta from the natural tick anchor, measured along
  /// the [position]'s outward axis (away from center for [outer],
  /// toward center for [inner], toward outer for [center]). Positive
  /// extends the tick farther in that direction; negative pulls it
  /// back toward (or across) the ring stack.
  final double offset;

  /// Renders each tick. The canvas is pre-translated and pre-rotated
  /// so the painter just draws a horizontal, right-facing shape at
  /// the origin — see [GaugeTickPainter.draw].
  final GaugeTickPainter painter;

  /// Predicate deciding whether each tick is drawn. Receives a
  /// [GaugeTickInfo] with the tick's index, the total [count], its
  /// scale value, and the chart's `minValue` / `maxValue`. Returning
  /// `false` skips both the tick mark and its label.
  ///
  /// Defaults to [GaugeTicks.showAll]. Use [GaugeTicks.hideEndpoints]
  /// to skip the first and last ticks — handy when the arc already
  /// visually anchors its extremes (e.g. rounded zone caps). Users
  /// can pass any predicate for custom behaviour.
  ///
  /// Pass a top-level or static function when possible; anonymous
  /// closures compare by identity, which breaks equality across
  /// rebuilds and causes unnecessary tween animations.
  final CheckToShowGaugeTick checkToShowTick;

  /// Default [CheckToShowGaugeTick] — draws every tick.
  static bool showAll(GaugeTickInfo info) => true;

  /// [CheckToShowGaugeTick] that skips the first and last ticks. Equivalent
  /// to `info.index != 0 && info.index != info.count - 1`.
  static bool hideEndpoints(GaugeTickInfo info) =>
      info.index != 0 && info.index != info.count - 1;

  /// Returns the text painted as a label next to each tick. The input
  /// is the tick's scale value on `[minValue, maxValue]`. When `null`,
  /// no labels are drawn. To keep a tick mark but drop its label at a
  /// specific value, return an empty string from this builder.
  final String Function(double value)? labelBuilder;

  /// Style applied to labels, merged with the chart's current theme.
  /// When `null`, the theme's default text style is used.
  final TextStyle? labelStyle;

  /// Signed pixel delta between the tick's far edge and its label,
  /// along the same outward axis as [offset]. Positive pushes the
  /// label further outward; negative pulls it toward (or across) the
  /// tick.
  final double labelOffset;

  static GaugeTicks? lerp(GaugeTicks? a, GaugeTicks? b, double t) {
    if (a == null || b == null) return b;
    return GaugeTicks(
      count: lerpInt(a.count, b.count, t),
      position: b.position,
      offset: lerpDouble(a.offset, b.offset, t)!,
      painter: a.painter.lerp(b.painter, t),
      checkToShowTick: b.checkToShowTick,
      labelBuilder: b.labelBuilder,
      labelStyle: TextStyle.lerp(a.labelStyle, b.labelStyle, t),
      labelOffset: lerpDouble(a.labelOffset, b.labelOffset, t)!,
    );
  }

  @override
  List<Object?> get props => [
        count,
        position,
        offset,
        painter,
        checkToShowTick,
        labelBuilder,
        labelStyle,
        labelOffset,
      ];
}

/// Signature for a predicate that decides whether a gauge tick is
/// drawn. See [GaugeTicks.CheckToShowGaugeTick].
typedef CheckToShowGaugeTick = bool Function(GaugeTickInfo info);

/// Context passed to [CheckToShowGaugeTick] callbacks.
@immutable
class GaugeTickInfo with EquatableMixin {
  const GaugeTickInfo({
    required this.index,
    required this.count,
    required this.value,
    required this.minValue,
    required this.maxValue,
  });

  /// Position of this tick in the sweep, `0` for the first tick and
  /// `count - 1` for the last.
  final int index;

  /// Total number of tick positions, matching [GaugeTicks.count].
  final int count;

  /// Scale value at this tick's position, on `[minValue, maxValue]`.
  final double value;

  /// The gauge's minimum scale value ([GaugeChartData.minValue]).
  final double minValue;

  /// The gauge's maximum scale value ([GaugeChartData.maxValue]).
  final double maxValue;

  @override
  List<Object?> get props => [index, count, value, minValue, maxValue];
}

/// Interface for rendering a single tick mark on a [GaugeChart].
///
/// The gauge painter pre-translates and pre-rotates the canvas for
/// each tick so implementations never touch trig: `(0, 0)` is the
/// tick's anchor point, the `+x` axis points in the tick's outward
/// direction (see [GaugeTicks.position]), and the `+y` axis is
/// tangent to the arc in the sweep direction. Draw a horizontal,
/// right-facing shape at the origin and the gauge handles placing
/// and rotating it for every tick angle.
///
/// Mirrors the [FlDotPainter] pattern. Subclass it to draw custom
/// tick shapes or oriented marks.
abstract class GaugeTickPainter with EquatableMixin {
  const GaugeTickPainter();

  /// Draws a single tick in the pre-transformed local frame described
  /// in the class docstring.
  void draw(Canvas canvas, GaugeTickInfo tickInfo);

  /// Bounding box of the tick in the unrotated local frame.
  ///
  /// `width` is the radial extent (along `+x`) and is used to reserve
  /// outer padding; `height` is the tangential extent (across `+y`).
  Size getSize();

  /// Lerps two painter configurations. Cross-type lerps fall back to
  /// [b], matching [FlDotPainter.lerp].
  GaugeTickPainter lerp(GaugeTickPainter b, double t);
}

/// Default [GaugeTickPainter]: draws a line segment along `+x`, so
/// each tick points radially outward (relative to [GaugeTicks.position]).
class GaugeTickLinePainter extends GaugeTickPainter {
  const GaugeTickLinePainter({
    this.length = 6.0,
    this.thickness = 2.0,
    this.color = const Color(0xFF000000),
  })  : assert(length > 0, 'length must be > 0'),
        assert(thickness > 0, 'thickness must be > 0');

  final double length;
  final double thickness;
  final Color color;

  @override
  void draw(Canvas canvas, GaugeTickInfo tickInfo) {
    canvas.drawLine(
      Offset.zero,
      Offset(length, 0),
      Paint()
        ..color = color
        ..strokeWidth = thickness
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true,
    );
  }

  @override
  Size getSize() => Size(length, thickness);

  @override
  GaugeTickPainter lerp(GaugeTickPainter b, double t) {
    if (b is! GaugeTickLinePainter) {
      return b;
    }
    return GaugeTickLinePainter(
      length: lerpDouble(length, b.length, t)!,
      thickness: lerpDouble(thickness, b.thickness, t)!,
      color: Color.lerp(color, b.color, t)!,
    );
  }

  @override
  List<Object?> get props => [length, thickness, color];
}

/// [GaugeTickPainter] that draws each tick as a filled circle,
/// optionally with a stroked outline. Rotation-invariant by shape, so
/// it looks identical at every angle.
class GaugeTickCirclePainter extends GaugeTickPainter {
  const GaugeTickCirclePainter({
    this.radius = 3.0,
    this.color = const Color(0xFF000000),
    this.strokeWidth = 0.0,
    this.strokeColor = const Color(0xFF000000),
  }) : assert(radius > 0, 'radius must be > 0');

  final double radius;
  final Color color;
  final double strokeWidth;
  final Color strokeColor;

  @override
  void draw(Canvas canvas, GaugeTickInfo tickInfo) {
    if (strokeWidth > 0 && strokeColor.a != 0) {
      canvas.drawCircle(
        Offset.zero,
        radius + strokeWidth / 2,
        Paint()
          ..color = strokeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
      );
    }
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  Size getSize() => Size.fromRadius(radius + strokeWidth);

  @override
  GaugeTickPainter lerp(GaugeTickPainter b, double t) {
    if (b is! GaugeTickCirclePainter) {
      return b;
    }
    return GaugeTickCirclePainter(
      radius: lerpDouble(radius, b.radius, t)!,
      color: Color.lerp(color, b.color, t)!,
      strokeWidth: lerpDouble(strokeWidth, b.strokeWidth, t)!,
      strokeColor: Color.lerp(strokeColor, b.strokeColor, t)!,
    );
  }

  @override
  List<Object?> get props => [radius, color, strokeWidth, strokeColor];
}

/// A single pointer drawn on top of the gauge, indicating a specific
/// [value] on the scale shared by [GaugeChartData.rings].
///
/// Pointers are independent — each carries its own [value]. Sync with
/// a ring's value by passing the same variable to both. To render a
/// "pivot cap" under a needle, stack a small [GaugePointerCirclePainter]
/// on top via a second [GaugePointer] in the same list.
@immutable
class GaugePointer with EquatableMixin {
  const GaugePointer({
    required this.value,
    this.painter = const GaugePointerNeedlePainter(),
  });

  /// Position on the gauge scale the pointer points at. Values outside
  /// `[GaugeChartData.minValue, maxValue]` are not asserted — the
  /// pointer simply extends past the sweep endpoints.
  final double value;

  /// Renders the pointer's shape. The canvas is pre-transformed by
  /// the gauge painter — see [GaugePointerPainter.draw].
  final GaugePointerPainter painter;

  GaugePointer copyWith({double? value, GaugePointerPainter? painter}) =>
      GaugePointer(
        value: value ?? this.value,
        painter: painter ?? this.painter,
      );

  static GaugePointer lerp(GaugePointer a, GaugePointer b, double t) =>
      GaugePointer(
        value: lerpDouble(a.value, b.value, t)!,
        painter: a.painter.lerp(b.painter, t),
      );

  @override
  List<Object?> get props => [value, painter];
}

/// Interface for rendering a single [GaugePointer].
///
/// The gauge painter pre-translates and pre-rotates the canvas so
/// implementations never touch trigonometry:
///
/// - origin `(0, 0)` is the **gauge center**
/// - `+x` axis points **radially outward** toward the pointer's value angle
/// - `+y` axis is **tangent** to the arc in the sweep direction
///
/// Draw a horizontal, right-facing shape at the origin; the gauge
/// rotates and translates the canvas for each pointer's value.
///
/// Mirrors the [GaugeTickPainter] pattern. Subclass to draw custom
/// pointer shapes.
abstract class GaugePointerPainter with EquatableMixin {
  const GaugePointerPainter();

  /// Draws the pointer in the pre-transformed local frame described
  /// in the class docstring.
  void draw(Canvas canvas);

  /// Bounding box of the pointer in the unrotated local frame.
  /// `width` is the radial extent (along `+x`), `height` is the
  /// tangential extent (across `+y`).
  Size getSize();

  /// Lerps two painter configurations. Cross-type lerps fall back to
  /// [b], matching [GaugeTickPainter.lerp].
  GaugePointerPainter lerp(GaugePointerPainter b, double t);
}

/// Default [GaugePointerPainter]: a classic needle shape.
///
/// Draws a tapered triangle anchored at the gauge center, narrowing
/// to a point at `(length, 0)`. An optional [tailLength] extends a
/// short stub behind the pivot (toward `-x`).
class GaugePointerNeedlePainter extends GaugePointerPainter {
  const GaugePointerNeedlePainter({
    this.length = 60.0,
    this.width = 8.0,
    this.tailLength = 0.0,
    this.color = const Color(0xFF000000),
  })  : assert(length > 0, 'length must be > 0'),
        assert(width > 0, 'width must be > 0'),
        assert(tailLength >= 0, 'tailLength must be >= 0');

  /// Distance from the gauge center to the needle's tip, in pixels.
  final double length;

  /// Width of the needle's base (at the pivot), in pixels.
  final double width;

  /// Optional stub that extends behind the pivot toward `-x`, in
  /// pixels. Set to `0` for a tip-only needle.
  final double tailLength;

  /// Fill color of the needle.
  final Color color;

  @override
  void draw(Canvas canvas) {
    final half = width / 2;
    final path = Path()
      ..moveTo(-tailLength, 0)
      ..lineTo(0, -half)
      ..lineTo(length, 0)
      ..lineTo(0, half)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..isAntiAlias = true,
    );
  }

  @override
  Size getSize() => Size(length + tailLength, width);

  @override
  GaugePointerPainter lerp(GaugePointerPainter b, double t) {
    if (b is! GaugePointerNeedlePainter) {
      return b;
    }
    return GaugePointerNeedlePainter(
      length: lerpDouble(length, b.length, t)!,
      width: lerpDouble(width, b.width, t)!,
      tailLength: lerpDouble(tailLength, b.tailLength, t)!,
      color: Color.lerp(color, b.color, t)!,
    );
  }

  @override
  List<Object?> get props => [length, width, tailLength, color];
}

/// [GaugePointerPainter] that draws a filled circle at
/// `(anchorRadius, 0)` in the pre-transformed frame. Useful for
/// marker-style pointers or as a pivot cap (set `anchorRadius: 0`) on
/// top of a needle.
class GaugePointerCirclePainter extends GaugePointerPainter {
  const GaugePointerCirclePainter({
    this.radius = 6.0,
    this.anchorRadius = 0.0,
    this.color = const Color(0xFF000000),
    this.strokeWidth = 0.0,
    this.strokeColor = const Color(0xFF000000),
  })  : assert(radius > 0, 'radius must be > 0'),
        assert(anchorRadius >= 0, 'anchorRadius must be >= 0'),
        assert(strokeWidth >= 0, 'strokeWidth must be >= 0');

  /// Radius of the filled circle, in pixels.
  final double radius;

  /// Distance from the gauge center to the circle's center, along the
  /// radial direction (`+x` in the pre-transformed frame).
  final double anchorRadius;

  /// Fill color of the circle.
  final Color color;

  /// Width of an optional stroked outline. Zero (default) = no outline.
  final double strokeWidth;

  /// Color of the optional stroked outline.
  final Color strokeColor;

  @override
  void draw(Canvas canvas) {
    final centerPoint = Offset(anchorRadius, 0);
    if (strokeWidth > 0 && strokeColor.a != 0) {
      canvas.drawCircle(
        centerPoint,
        radius + strokeWidth / 2,
        Paint()
          ..color = strokeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
      );
    }
    canvas.drawCircle(
      centerPoint,
      radius,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  Size getSize() {
    final extent = radius + strokeWidth;
    return Size(anchorRadius + extent, extent * 2);
  }

  @override
  GaugePointerPainter lerp(GaugePointerPainter b, double t) {
    if (b is! GaugePointerCirclePainter) {
      return b;
    }
    return GaugePointerCirclePainter(
      radius: lerpDouble(radius, b.radius, t)!,
      anchorRadius: lerpDouble(anchorRadius, b.anchorRadius, t)!,
      color: Color.lerp(color, b.color, t)!,
      strokeWidth: lerpDouble(strokeWidth, b.strokeWidth, t)!,
      strokeColor: Color.lerp(strokeColor, b.strokeColor, t)!,
    );
  }

  @override
  List<Object?> get props =>
      [radius, anchorRadius, color, strokeWidth, strokeColor];
}

/// A single marker drawn along the gauge's arc at an arbitrary
/// continuous [value]. Conceptually a continuous-value cousin of
/// [GaugeTicks] — markers reference the ring stack as a whole (outer /
/// inner / center) and use the same arc-anchored local frame as
/// [GaugeTickPainter], but each carries its own `value` instead of
/// being constrained to an evenly-spaced index.
///
/// Use this to highlight thresholds, targets, or annotations that fall
/// at non-grid positions (e.g. a "min" marker at `0.234` or a "target"
/// at `0.71`). For drawing things that emanate from the gauge's center
/// (needles, hands), use [GaugePointer] instead.
@immutable
class GaugeMarker with EquatableMixin {
  const GaugeMarker({
    required this.value,
    this.position = GaugeTickPosition.outer,
    this.offset = 0,
    this.painter = const GaugeMarkerLinePainter(),
  });

  /// Position on the gauge scale where the marker is anchored. Values
  /// outside `[GaugeChartData.minValue, maxValue]` are not asserted —
  /// the marker simply extends past the sweep endpoints.
  final double value;

  /// Where the marker sits relative to the gauge's outer / inner
  /// bounds. Same semantics as [GaugeTicks.position].
  final GaugeTickPosition position;

  /// Signed pixel delta from the natural marker anchor, measured along
  /// the [position]'s outward axis. Same semantics as
  /// [GaugeTicks.offset].
  final double offset;

  /// Renders the marker. The canvas is pre-translated and pre-rotated
  /// so the painter just draws a horizontal, right-facing shape at
  /// the origin — see [GaugeMarkerPainter.draw].
  final GaugeMarkerPainter painter;

  GaugeMarker copyWith({
    double? value,
    GaugeTickPosition? position,
    double? offset,
    GaugeMarkerPainter? painter,
  }) =>
      GaugeMarker(
        value: value ?? this.value,
        position: position ?? this.position,
        offset: offset ?? this.offset,
        painter: painter ?? this.painter,
      );

  static GaugeMarker lerp(GaugeMarker a, GaugeMarker b, double t) =>
      GaugeMarker(
        value: lerpDouble(a.value, b.value, t)!,
        position: b.position,
        offset: lerpDouble(a.offset, b.offset, t)!,
        painter: a.painter.lerp(b.painter, t),
      );

  @override
  List<Object?> get props => [value, position, offset, painter];
}

/// Context passed to [GaugeMarkerPainter.draw].
@immutable
class GaugeMarkerInfo with EquatableMixin {
  const GaugeMarkerInfo({
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.angleDegrees,
  });

  /// Scale value at this marker's position, on `[minValue, maxValue]`.
  final double value;

  /// The gauge's minimum scale value ([GaugeChartData.minValue]).
  final double minValue;

  /// The gauge's maximum scale value ([GaugeChartData.maxValue]).
  final double maxValue;

  /// Angle on the gauge's coordinate system at which this marker is
  /// anchored, in degrees (same convention as
  /// [GaugeChartData.startDegreeOffset]: `0°` points right, increases
  /// clockwise; values may be negative or beyond `360`). Useful for
  /// angle-aware rendering — e.g. flipping a label by 180° on the
  /// gauge's left hemisphere so it stays upright.
  final double angleDegrees;

  @override
  List<Object?> get props => [value, minValue, maxValue, angleDegrees];
}

/// Interface for rendering a single [GaugeMarker].
///
/// Mirrors the [GaugeTickPainter] local-frame convention exactly:
///
/// - origin `(0, 0)` is the **marker's anchor on the arc**
/// - `+x` axis points in the marker's outward direction (per
///   [GaugeMarker.position])
/// - `+y` axis is **tangent** to the arc in the sweep direction
///
/// Draw a horizontal, right-facing shape at the origin and the gauge
/// handles placing and rotating it for every marker's value.
abstract class GaugeMarkerPainter with EquatableMixin {
  const GaugeMarkerPainter();

  /// Draws a single marker in the pre-transformed local frame
  /// described in the class docstring.
  void draw(Canvas canvas, GaugeMarkerInfo markerInfo);

  /// Bounding box of the marker in the unrotated local frame.
  ///
  /// `width` is the radial extent (along `+x`) and is used to reserve
  /// outer padding when [GaugeMarker.position] is
  /// [GaugeTickPosition.outer]; `height` is the tangential extent
  /// (across `+y`).
  Size getSize();

  /// Lerps two painter configurations. Cross-type lerps fall back to
  /// [b], matching [GaugeTickPainter.lerp] / [FlDotPainter.lerp].
  GaugeMarkerPainter lerp(GaugeMarkerPainter b, double t);
}

/// Where the line sits relative to the marker's anchor on the arc.
enum GaugeMarkerLineAlignment {
  /// Line spans `[-length / 2, length / 2]` along `+x` — a symmetric
  /// crossbar centered on the marker's anchor. Reads as a "this point
  /// on the arc" indicator. Default for markers.
  centered,

  /// Line spans `[0, length]` along `+x` — anchored at the marker's
  /// anchor and extending radially outward (tick-style, mirrors
  /// [GaugeTickLinePainter]).
  outward,
}

/// Which side of the line a [GaugeMarkerLinePainter]'s optional label
/// sits on, in the painter's pre-transformed local frame.
enum GaugeMarkerLabelSide {
  /// Label sits radially outward of the line — further from the gauge
  /// center. Default.
  outward,

  /// Label sits radially inward of the line — between the line and the
  /// gauge's center.
  inward,
}

/// [GaugeMarkerPainter] that draws a line segment, optionally with a
/// text label beside it.
///
/// The line is centered on the marker's anchor by default
/// ([GaugeMarkerLineAlignment.centered]) — markers are point
/// indicators, so a symmetric crossbar reads more naturally than a
/// tick-style outward line. Switch to
/// [GaugeMarkerLineAlignment.outward] for tick-style behavior.
///
/// When [label] is non-null and non-empty, the painter renders the
/// text on [labelSide] of the line, [labelOffset] pixels away. The
/// label is **auto-flipped by 180°** when the marker sits on the
/// gauge's left hemisphere (`cos(angleDegrees) < 0`) so it stays
/// upright regardless of where the marker lands on the dial — no
/// per-marker flip flag needed.
///
/// Note: [getSize] reports only the line's outward radial extent. If
/// you place a long label on [GaugeMarkerLabelSide.outward] and want
/// the rings to shrink to make room, add `offset:
/// labelOffset + estimatedLabelWidth` on the [GaugeMarker] itself.
class GaugeMarkerLinePainter extends GaugeMarkerPainter {
  const GaugeMarkerLinePainter({
    this.length = 10.0,
    this.thickness = 2.0,
    this.color = const Color(0xFF000000),
    this.strokeCap = StrokeCap.round,
    this.alignment = GaugeMarkerLineAlignment.centered,
    this.label,
    this.labelStyle,
    this.labelOffset = 6.0,
    this.labelSide = GaugeMarkerLabelSide.outward,
  })  : assert(length > 0, 'length must be > 0'),
        assert(thickness > 0, 'thickness must be > 0'),
        assert(labelOffset >= 0, 'labelOffset must be >= 0');

  final double length;
  final double thickness;
  final Color color;
  final StrokeCap strokeCap;

  /// Where the line sits relative to the marker's anchor.
  final GaugeMarkerLineAlignment alignment;

  /// Optional text drawn alongside the line. Skipped when null, empty,
  /// or [labelStyle] is null.
  final String? label;

  /// Style applied to [label]. If null, no label is drawn even when
  /// [label] is set.
  final TextStyle? labelStyle;

  /// Gap in pixels between the line's end and the label. Measured
  /// along the radial axis on [labelSide].
  final double labelOffset;

  /// Side of the line on which the label sits.
  final GaugeMarkerLabelSide labelSide;

  double get _lineStartX => switch (alignment) {
        GaugeMarkerLineAlignment.centered => -length / 2,
        GaugeMarkerLineAlignment.outward => 0,
      };

  double get _lineEndX => switch (alignment) {
        GaugeMarkerLineAlignment.centered => length / 2,
        GaugeMarkerLineAlignment.outward => length,
      };

  @override
  void draw(Canvas canvas, GaugeMarkerInfo markerInfo) {
    canvas.drawLine(
      Offset(_lineStartX, 0),
      Offset(_lineEndX, 0),
      Paint()
        ..color = color
        ..strokeWidth = thickness
        ..strokeCap = strokeCap
        ..isAntiAlias = true,
    );

    final label = this.label;
    final style = labelStyle;
    if (label == null || label.isEmpty || style == null) return;

    final textPainter = TextPainter(
      text: TextSpan(text: label, style: style),
      textDirection: TextDirection.ltr,
    )..layout();

    // Label position in the painter's logical (un-flipped) frame.
    final labelLeftX = switch (labelSide) {
      GaugeMarkerLabelSide.outward => _lineEndX + labelOffset,
      GaugeMarkerLabelSide.inward =>
        _lineStartX - labelOffset - textPainter.width,
    };

    // Auto-flip the label by 180° when the marker sits on the gauge's
    // left hemisphere so its glyphs stay upright. We rotate around
    // the label's own center so the *position* (which side of the
    // line it sits on) doesn't change — only its orientation.
    final angleRad = markerInfo.angleDegrees * math.pi / 180.0;
    final flipText = math.cos(angleRad) < 0;
    if (flipText) {
      final centerX = labelLeftX + textPainter.width / 2;
      canvas
        ..save()
        ..translate(centerX, 0)
        ..rotate(math.pi);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    } else {
      textPainter.paint(
        canvas,
        Offset(labelLeftX, -textPainter.height / 2),
      );
    }
  }

  /// Outward radial extent of the line, used to reserve outer padding
  /// on the [GaugeChartData]. Does not include the label's extent —
  /// see the class docstring for guidance on outward labels.
  @override
  Size getSize() => Size(_lineEndX, thickness);

  @override
  GaugeMarkerPainter lerp(GaugeMarkerPainter b, double t) {
    if (b is! GaugeMarkerLinePainter) {
      return b;
    }
    return GaugeMarkerLinePainter(
      length: lerpDouble(length, b.length, t)!,
      thickness: lerpDouble(thickness, b.thickness, t)!,
      color: Color.lerp(color, b.color, t)!,
      strokeCap: b.strokeCap,
      alignment: b.alignment,
      label: b.label,
      labelStyle: TextStyle.lerp(labelStyle, b.labelStyle, t),
      labelOffset: lerpDouble(labelOffset, b.labelOffset, t)!,
      labelSide: b.labelSide,
    );
  }

  @override
  List<Object?> get props => [
        length,
        thickness,
        color,
        strokeCap,
        alignment,
        label,
        labelStyle,
        labelOffset,
        labelSide,
      ];
}

class GaugeTouchData extends FlTouchData<GaugeTouchResponse>
    with EquatableMixin {
  GaugeTouchData({
    bool? enabled,
    BaseTouchCallback<GaugeTouchResponse>? touchCallback,
    MouseCursorResolver<GaugeTouchResponse>? mouseCursorResolver,
    Duration? longPressDuration,
  }) : super(
          enabled ?? true,
          touchCallback,
          mouseCursorResolver,
          longPressDuration,
        );

  @override
  List<Object?> get props => [
        enabled,
        touchCallback,
        mouseCursorResolver,
        longPressDuration,
      ];
}

/// Describes the state of a touch on a [GaugeChart].
///
/// A touch inside the arc's angular range always produces a
/// [GaugeTouchedRing] — even when it falls in the gap between rings
/// (`ringsSpace`) or outside every ring's radial band. In those
/// cases [touchedRing] is null and [touchedRingIndex] is -1, but
/// [touchValue] is still filled in. Touches entirely outside the
/// angular range produce null [GaugeTouchResponse.touchedRing].
///
/// When the hit ring is a [GaugeZonesRing], [touchedZone] and
/// [touchedZoneIndex] are populated with the specific band that
/// contains the touch angle. For a [GaugeProgressRing], [isOnValue]
/// tells you whether the touch sits on the filled portion (`touchValue
/// <= ring.value`) or the background.
@immutable
class GaugeTouchedRing with EquatableMixin {
  const GaugeTouchedRing({
    required this.touchedRing,
    required this.touchedRingIndex,
    required this.touchAngle,
    required this.touchRadius,
    required this.touchValue,
    required this.isOnValue,
    this.touchedZone,
    this.touchedZoneIndex = -1,
  });

  /// The ring that was touched, or null if the touch fell between /
  /// outside rings.
  final GaugeRing? touchedRing;

  /// Index of the touched ring in [GaugeChartData.rings], or -1 if
  /// no ring was hit.
  final int touchedRingIndex;

  /// Angle of the touch in degrees, using the same convention as
  /// [GaugeChartData.startDegreeOffset] (0° points right).
  final double touchAngle;

  /// Distance from the gauge's center to the touch, in pixels.
  final double touchRadius;

  /// Touch position interpolated along the shared gauge scale, in
  /// [[GaugeChartData.minValue], [GaugeChartData.maxValue]].
  final double touchValue;

  /// True when a [GaugeProgressRing] was hit AND the touch sits on
  /// its filled portion (`touchValue <= ring.value`). False
  /// otherwise, including for [GaugeZonesRing] hits and misses.
  final bool isOnValue;

  /// The zone that was touched when the hit ring is a
  /// [GaugeZonesRing] and the touch angle falls inside one of its
  /// zones. Null for progress-ring hits and for touches in gaps
  /// between zones.
  final GaugeZone? touchedZone;

  /// Index of [touchedZone] in the hit ring's `zones` list, or -1.
  final int touchedZoneIndex;

  @override
  List<Object?> get props => [
        touchedRing,
        touchedRingIndex,
        touchAngle,
        touchRadius,
        touchValue,
        isOnValue,
        touchedZone,
        touchedZoneIndex,
      ];
}

class GaugeTouchResponse extends BaseTouchResponse {
  GaugeTouchResponse({
    required super.touchLocation,
    required this.touchedRing,
  });

  /// Details of the touch, or null if the touch fell entirely outside
  /// the arc's angular range.
  final GaugeTouchedRing? touchedRing;

  GaugeTouchResponse copyWith({
    Offset? touchLocation,
    GaugeTouchedRing? touchedRing,
  }) =>
      GaugeTouchResponse(
        touchLocation: touchLocation ?? this.touchLocation,
        touchedRing: touchedRing ?? this.touchedRing,
      );
}
