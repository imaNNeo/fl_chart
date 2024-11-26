import 'package:flutter/painting.dart';

/// Extensions on [Gradient]
extension GradientExtension on Gradient {
  /// Returns color stops.
  ///
  /// If [stops] has the same length as [colors], returns it directly.
  /// Otherwise, calculates stops linearly between 0.0 and 1.0.
  ///
  /// Throws [ArgumentError] if [colors] has less than 2 colors.
  List<double> getSafeColorStops() {
    if (stops?.length == colors.length) {
      return stops!;
    }

    if (colors.length <= 1) {
      throw ArgumentError('"colors" must have length > 1.');
    }

    final stopsStep = 1.0 / (colors.length - 1);
    return [
      for (var index = 0; index < colors.length; index++) index * stopsStep,
    ];
  }
}
