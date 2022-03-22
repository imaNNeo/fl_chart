import 'package:flutter/painting.dart';

/// Extensions on [Gradient]
extension GradientExtension on Gradient {
  /// Returns colorStops
  ///
  /// if [stops] provided, returns it directly,
  /// Otherwise we calculate it using colors list
  List<double> getSafeColorStops() {
    var resultStops = <double>[];
    if (stops == null || stops!.length != colors.length) {
      if (colors.length > 1) {
        /// provided colorStops is invalid and we calculate it here
        colors.asMap().forEach((index, color) {
          final percent = 1.0 / (colors.length - 1);
          resultStops.add(percent * index);
        });
      } else {
        throw ArgumentError('"colors" must have length > 1.');
      }
    } else {
      resultStops = stops!;
    }
    return resultStops;
  }
}
