import 'bar_chart_data.dart';

/// Extensions on [BackgroundBarChartRodData]
extension BackgroundBarChartRodDataExtension on BackgroundBarChartRodData {
  /// Returns colorStops
  ///
  /// if [colorStops] provided, returns it directly,
  /// Otherwise we calculate it using colors list
  List<double> getSafeColorStops() {
    var stops = <double>[];
    if (colorStops == null || colorStops!.length != colors.length) {
      if (colors.length > 1) {
        /// provided colorStops is invalid and we calculate it here
        colors.asMap().forEach((index, color) {
          final percent = 1.0 / (colors.length - 1);
          stops.add(percent * index);
        });
      } else {
        throw ArgumentError('"colors" must have length > 1.');
      }
    } else {
      stops = colorStops!;
    }
    return stops;
  }
}

/// Extensions on [BarChartRodData]
extension BarChartRodDataExtension on BarChartRodData {
  /// Returns colorStops
  ///
  /// if [colorStops] provided, returns it directly,
  /// Otherwise we calculate it using colors list
  List<double> getSafeColorStops() {
    var stops = <double>[];
    if (colorStops == null || colorStops!.length != colors.length) {
      if (colors.length > 1) {
        /// provided colorStops is invalid and we calculate it here
        colors.asMap().forEach((index, color) {
          final percent = 1.0 / (colors.length - 1);
          stops.add(percent * index);
        });
      } else {
        throw ArgumentError('"colors" must have length > 1.');
      }
    } else {
      stops = colorStops!;
    }
    return stops;
  }
}
