
import 'package:flutter/material.dart';

extension ColorExtension on Color {

  /// Convert the color to a darken color based on the [percent]
  Color darken([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return Color.fromARGB(
      alpha,
      (red * f).round(),
      (green  * f).round(),
      (blue * f).round()
    );
  }

}