import 'package:fl_chart/src/utils/utils.dart';

class AxisChartHelper {
  static final _singleton = AxisChartHelper._internal();

  factory AxisChartHelper() {
    return _singleton;
  }

  AxisChartHelper._internal();

  /// Iterates over an axis from [min] to [max].
  ///
  /// [interval] determines each step
  ///
  /// If [minIncluded] is true, it starts from [min] value,
  /// otherwise it starts from [min] + [interval]
  ///
  /// If [maxIncluded] is true, it ends at [max] value,
  /// otherwise it ends at [max] - [interval]
  Iterable<double> iterateThroughAxis({
    required double min,
    bool minIncluded = true,
    required double max,
    bool maxIncluded = true,
    required double baseLine,
    required double interval,
  }) sync* {
    final initialValue = Utils()
        .getBestInitialIntervalValue(min, max, interval, baseline: baseLine);
    var axisSeek = initialValue;
    final firstPositionOverlapsWithMin = axisSeek == min;
    if (!minIncluded && firstPositionOverlapsWithMin) {
      axisSeek += interval;
    }
    final diff = max - min;
    final count = diff ~/ interval;
    final lastPosition = initialValue + (count * interval);
    final lastPositionOverlapsWithMax = lastPosition == max;
    final end =
        !maxIncluded && lastPositionOverlapsWithMax ? max - interval : max;

    final epsilon = interval / 100000;
    if (minIncluded && !firstPositionOverlapsWithMin) {
      yield min;
    }
    while (axisSeek <= end + epsilon) {
      yield axisSeek;
      axisSeek += interval;
    }
    if (maxIncluded && !lastPositionOverlapsWithMax) {
      yield max;
    }
  }
}
