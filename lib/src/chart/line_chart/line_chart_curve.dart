import 'dart:math';
import 'dart:ui';

import 'package:equatable/equatable.dart';

LineChartCurve lerpCurve(LineChartCurve a, LineChartCurve b, double t) {
  a = a._withNoCurveResolved;
  b = b._withNoCurveResolved;

  if (a.runtimeType == b.runtimeType) {
    return a.lerp(b, t) as LineChartCurve;
  }

  return b;
}

abstract class LineChartCurve<T extends LineChartCurve<T>> with EquatableMixin {
  const LineChartCurve();

  static const noCurve = LineChartNoCurve();

  static LineChartCubicTensionCurve cubicTension({
    double smoothness = 0.35,
    bool preventCurveOverShooting = false,
    double preventCurveOvershootingThreshold = 10.0,
  }) =>
      LineChartCubicTensionCurve(
        smoothness: smoothness,
        preventCurveOverShooting: preventCurveOverShooting,
        preventCurveOvershootingThreshold: preventCurveOvershootingThreshold,
      );

  static LineChartCubicMonotoneCurve cubicMonotone({
    double smooth = 0.5,
    SmoothMonotone monotone = SmoothMonotone.none,
    double tinyThresholdSquared = 0.5,
  }) =>
      LineChartCubicMonotoneCurve(
        smooth: smooth,
        monotone: monotone,
        tinyThresholdSquared: tinyThresholdSquared,
      );

  /// Returns a linear-equivalent configuration of this curve for lerping.
  /// When interpolating with a "no curve" (straight line), this should be an
  /// instance of the same curve type configured to behave as a straight line.
  /// If your curve becomes linear at a specific parameter value (e.g. smoothness = 0),
  /// return that configuration; otherwise, return `this`.
  ///
  // ignore: avoid_returning_this
  LineChartCurve<T> get noCurveCase => this;

  /// Appends the segment from [previous] to [current] into the [path].
  /// Implementations may use [next] to compute control points for smoothing.
  ///
  /// Note: Iteration starts from the second data point. The first point is
  /// already handled internally (e.g. moved to the path), so this method is
  /// called beginning at index 1. When [current] is the last point, [next]
  /// is `null`.
  void appendToPath(Path path, Offset previous, Offset current, Offset? next);

  T lerp(covariant T other, double t);

  LineChartCurve get _withNoCurveResolved =>
      this is LineChartNoCurve ? noCurveCase : this;
}

class LineChartNoCurve extends LineChartCurve<LineChartNoCurve> {
  const LineChartNoCurve();

  @override
  void appendToPath(Path path, Offset previous, Offset current, Offset? next) {
    path.lineTo(current.dx, current.dy);
  }

  @override
  LineChartNoCurve lerp(LineChartNoCurve other, double t) => other;

  @override
  List<Object?> get props => const [];
}

class LineChartCubicTensionCurve
    extends LineChartCurve<LineChartCubicTensionCurve> with EquatableMixin {
  const LineChartCubicTensionCurve({
    this.smoothness = 0.35,
    this.preventCurveOverShooting = false,
    this.preventCurveOvershootingThreshold = 10.0,
  });

  /// It determines smoothness of the curved edges.
  final double smoothness;

  /// Prevent overshooting when draw curve line with high value changes.
  /// check this [issue](https://github.com/imaNNeo/fl_chart/issues/25)
  final double preventCurveOvershootingThreshold;

  /// Applies threshold for [preventCurveOverShooting] algorithm.
  final bool preventCurveOverShooting;

  @override
  LineChartCubicTensionCurve get noCurveCase => LineChartCubicTensionCurve(
        smoothness: 0,
        preventCurveOverShooting: preventCurveOverShooting,
        preventCurveOvershootingThreshold: preventCurveOvershootingThreshold,
      );

  static Offset _flag = Offset.zero;

  @override
  void appendToPath(Path path, Offset previous, Offset current, Offset? next) {
    final resolvedNext = next ?? current;

    final controlPoint1 = previous + _flag;

    _flag = ((resolvedNext - previous) / 2) * smoothness;

    if (preventCurveOverShooting) {
      if ((resolvedNext - current).dy <= preventCurveOvershootingThreshold ||
          (current - previous).dy <= preventCurveOvershootingThreshold) {
        _flag = Offset(_flag.dx, 0);
      }

      if ((resolvedNext - current).dx <= preventCurveOvershootingThreshold ||
          (current - previous).dx <= preventCurveOvershootingThreshold) {
        _flag = Offset(0, _flag.dy);
      }
    }

    final controlPoint2 = current - _flag;

    path.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      current.dx,
      current.dy,
    );

    // reset flag when have no next point
    if (next == null) {
      _flag = Offset.zero;
    }
  }

  @override
  LineChartCubicTensionCurve lerp(LineChartCubicTensionCurve other, double t) =>
      LineChartCubicTensionCurve(
        smoothness: lerpDouble(smoothness, other.smoothness, t)!,
        preventCurveOverShooting: other.preventCurveOverShooting,
        preventCurveOvershootingThreshold: lerpDouble(
          preventCurveOvershootingThreshold,
          other.preventCurveOvershootingThreshold,
          t,
        )!,
      );

  LineChartCubicTensionCurve copyWith({
    double? smoothness,
    bool? preventCurveOverShooting,
    double? preventCurveOvershootingThreshold,
  }) =>
      LineChartCubicTensionCurve(
        smoothness: smoothness ?? this.smoothness,
        preventCurveOverShooting:
            preventCurveOverShooting ?? this.preventCurveOverShooting,
        preventCurveOvershootingThreshold: preventCurveOvershootingThreshold ??
            this.preventCurveOvershootingThreshold,
      );

  @override
  List<Object?> get props => [
        smoothness,
        preventCurveOverShooting,
        preventCurveOvershootingThreshold,
      ];
}

enum SmoothMonotone { none, x, y }

/// Source:
/// https://github.com/apache/echarts/blob/513918064ac2a0866433d434dc969220f12b9c1a/src/chart/line/poly.ts#L39
/// Copied from the ECharts implementation.
class LineChartCubicMonotoneCurve
    extends LineChartCurve<LineChartCubicMonotoneCurve> {
  const LineChartCubicMonotoneCurve({
    this.smooth = 0.5,
    this.monotone = SmoothMonotone.none,
    this.tinyThresholdSquared = 0.5,
  });

  /// Smoothing factor controlling how rounded the curve is.
  /// 0 draws straight segments; 1 yields the roundest result.
  /// Used to scale cubic control points between data vertices.
  final double smooth;

  /// Optional monotonicity constraint along a single axis.
  /// Keeps the curve from overshooting in the selected axis (`x` or `y`).
  /// `none` uses the general length-weighted method without constraints.
  final SmoothMonotone monotone;

  /// Squared distance threshold to treat adjacent points as identical.
  /// If (dx^2 + dy^2) is below this, a straight line is drawn to avoid jitter.
  /// Unit: logical pixels squared.
  final double tinyThresholdSquared;

  @override
  LineChartCubicMonotoneCurve get noCurveCase => LineChartCubicMonotoneCurve(
        smooth: 0,
        monotone: monotone,
        tinyThresholdSquared: tinyThresholdSquared,
      );

  static Offset? _flag;

  @override
  void appendToPath(Path path, Offset previous, Offset current, Offset? next) {
    if (smooth <= 0) {
      path.lineTo(current.dx, current.dy);
      _flag = current;
      return;
    }

    final cp0Init = _flag ?? previous;
    final cpx0 = cp0Init.dx;
    final cpy0 = cp0Init.dy;

    final dx = current.dx - previous.dx;
    final dy = current.dy - previous.dy;
    if (dx * dx + dy * dy < tinyThresholdSquared) {
      path.lineTo(current.dx, current.dy);
      return;
    }

    double cpx1;
    double cpy1;
    double nextCpx0;
    double nextCpy0;

    if (next == null) {
      cpx1 = current.dx;
      cpy1 = current.dy;
      nextCpx0 = current.dx;
      nextCpy0 = current.dy;
    } else {
      var vx = next.dx - previous.dx;
      var vy = next.dy - previous.dy;
      final dx0 = current.dx - previous.dx;
      final dy0 = current.dy - previous.dy;
      final dx1 = next.dx - current.dx;
      final dy1 = next.dy - current.dy;

      if (monotone == SmoothMonotone.x) {
        final lenPrevSeg = dx0.abs();
        final lenNextSeg = dx1.abs();
        final dir = vx > 0 ? 1.0 : -1.0;
        cpx1 = current.dx - dir * lenPrevSeg * smooth;
        cpy1 = current.dy;
        nextCpx0 = current.dx + dir * lenNextSeg * smooth;
        nextCpy0 = current.dy;
      } else if (monotone == SmoothMonotone.y) {
        final lenPrevSeg = dy0.abs();
        final lenNextSeg = dy1.abs();
        final dir = vy > 0 ? 1.0 : -1.0;
        cpx1 = current.dx;
        cpy1 = current.dy - dir * lenPrevSeg * smooth;
        nextCpx0 = current.dx;
        nextCpy0 = current.dy + dir * lenNextSeg * smooth;
      } else {
        final lenPrevSeg = sqrt(dx0 * dx0 + dy0 * dy0);
        final lenNextSeg = sqrt(dx1 * dx1 + dy1 * dy1);
        if (lenPrevSeg == 0 || lenNextSeg == 0) {
          path.lineTo(current.dx, current.dy);
          _flag = current;
          return;
        }

        final ratioNextSeg = lenNextSeg / (lenNextSeg + lenPrevSeg);

        cpx1 = current.dx - vx * smooth * (1 - ratioNextSeg);
        cpy1 = current.dy - vy * smooth * (1 - ratioNextSeg);

        nextCpx0 = current.dx + vx * smooth * ratioNextSeg;
        nextCpy0 = current.dy + vy * smooth * ratioNextSeg;

        final double minX = min(next.dx, current.dx);
        final double maxX = max(next.dx, current.dx);
        final double minY = min(next.dy, current.dy);
        final double maxY = max(next.dy, current.dy);
        nextCpx0 = min(nextCpx0, maxX);
        nextCpx0 = max(nextCpx0, minX);
        nextCpy0 = min(nextCpy0, maxY);
        nextCpy0 = max(nextCpy0, minY);

        vx = nextCpx0 - current.dx;
        vy = nextCpy0 - current.dy;
        cpx1 = current.dx - vx * lenPrevSeg / lenNextSeg;
        cpy1 = current.dy - vy * lenPrevSeg / lenNextSeg;

        final double minPX = min(previous.dx, current.dx);
        final double maxPX = max(previous.dx, current.dx);
        final double minPY = min(previous.dy, current.dy);
        final double maxPY = max(previous.dy, current.dy);
        cpx1 = min(cpx1, maxPX);
        cpx1 = max(cpx1, minPX);
        cpy1 = min(cpy1, maxPY);
        cpy1 = max(cpy1, minPY);

        final ax = current.dx - cpx1;
        final ay = current.dy - cpy1;
        nextCpx0 = current.dx + ax * lenNextSeg / lenPrevSeg;
        nextCpy0 = current.dy + ay * lenNextSeg / lenPrevSeg;
      }
    }

    path.cubicTo(cpx0, cpy0, cpx1, cpy1, current.dx, current.dy);

    // reset flag when have no next point
    if (next == null) {
      _flag = null;
    } else {
      _flag = Offset(nextCpx0, nextCpy0);
    }
  }

  @override
  LineChartCubicMonotoneCurve lerp(
          covariant LineChartCubicMonotoneCurve other, double t) =>
      LineChartCubicMonotoneCurve(
        smooth: lerpDouble(smooth, other.smooth, t)!,
        monotone: other.monotone,
        tinyThresholdSquared:
            lerpDouble(tinyThresholdSquared, other.tinyThresholdSquared, t)!,
      );

  @override
  List<Object?> get props => [
        smooth,
        monotone,
        tinyThresholdSquared,
      ];
}
