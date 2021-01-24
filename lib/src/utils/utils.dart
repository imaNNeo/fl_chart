import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';

const double _degrees2Radians = math.pi / 180.0;

/// Converts degrees to radians
double radians(double degrees) => degrees * _degrees2Radians;

const double _radians2Degrees = 180.0 / math.pi;

/// Converts radians to degrees
double degrees(double radians) => radians * _radians2Degrees;

/// Returns a default size based on the screen size
/// that is a 70% scaled square based on the screen.
Size getDefaultSize(Size screenSize) {
  Size resultSize;
  if (screenSize.width < screenSize.height) {
    resultSize = Size(screenSize.width, screenSize.width);
  } else if (screenSize.height < screenSize.width) {
    resultSize = Size(screenSize.height, screenSize.height);
  } else {
    resultSize = Size(screenSize.width, screenSize.height);
  }
  return resultSize * 0.7;
}

/// Forward the view base on its degree
double translateRotatedPosition(double size, double degree) {
  return (size / 4) * math.sin(radians(degree.abs()));
}

/// Decreases [borderRadius] to <= width / 2
BorderRadius normalizeBorderRadius(BorderRadius borderRadius, double width) {
  if (borderRadius == null) {
    return null;
  }

  Radius topLeft;
  if (borderRadius.topLeft != null &&
      (borderRadius.topLeft.x > width / 2 || borderRadius.topLeft.y > width / 2)) {
    topLeft = Radius.circular(width / 2);
  } else {
    topLeft = borderRadius.topLeft;
  }

  Radius topRight;
  if ((borderRadius.topRight != null) &&
      (borderRadius.topRight.x > width / 2 || borderRadius.topRight.y > width / 2)) {
    topRight = Radius.circular(width / 2);
  } else {
    topRight = borderRadius.topRight;
  }

  Radius bottomLeft;
  if ((borderRadius.bottomLeft != null) &&
      (borderRadius.bottomLeft.x > width / 2 || borderRadius.bottomLeft.y > width / 2)) {
    bottomLeft = Radius.circular(width / 2);
  } else {
    bottomLeft = borderRadius.bottomLeft;
  }

  Radius bottomRight;
  if ((borderRadius.bottomRight != null) &&
      (borderRadius.bottomRight.x > width / 2 || borderRadius.bottomRight.y > width / 2)) {
    bottomRight = Radius.circular(width / 2);
  } else {
    bottomRight = borderRadius.bottomRight;
  }

  return BorderRadius.only(
    topLeft: topLeft,
    topRight: topRight,
    bottomLeft: bottomLeft,
    bottomRight: bottomRight,
  );
}

/// Lerps between a [LinearGradient] colors, based on [t]
Color lerpGradient(List<Color> colors, List<double> stops, double t) {
  final length = colors.length;
  if (stops == null || stops.length != length) {
    /// provided gradientColorStops is invalid and we calculate it here
    stops = List.generate(length, (i) => (i + 1) / length);
  }

  for (var s = 0; s < stops.length - 1; s++) {
    final leftStop = stops[s], rightStop = stops[s + 1];
    final leftColor = colors[s], rightColor = colors[s + 1];
    if (t <= leftStop) {
      return leftColor;
    } else if (t < rightStop) {
      final sectionT = (t - leftStop) / (rightStop - leftStop);
      return Color.lerp(leftColor, rightColor, sectionT);
    }
  }
  return colors.last;
}

/// Returns an efficient interval for showing axis titles, or grid lines or ...
///
/// If there isn't any provided interval, we use this function to calculate an interval to apply,
/// using [axisViewSize] / [pixelPerInterval], we calculate the allowedCount lines in the axis,
/// then using  [diffInYAxis] / allowedCount, we can find out how much interval we need,
/// then we round that number by finding nearest number in this pattern:
/// 1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 5000, 10000,...
double getEfficientInterval(double axisViewSize, double diffInYAxis,
    {double pixelPerInterval = 10}) {
  final allowedCount = axisViewSize ~/ pixelPerInterval;
  final accurateInterval = diffInYAxis / allowedCount;
  return _roundInterval(accurateInterval).toDouble();
}

int _roundInterval(double input) {
  var count = 0;

  if (input >= 10) {
    count++;
  }

  while (input ~/ 100 != 0) {
    input /= 10;
    count++;
  }

  final scaled = input >= 10 ? input.round() / 10 : input;

  if (scaled >= 2.6) {
    return 5 * pow(10, count);
  } else if (scaled >= 1.6) {
    return 2 * pow(10, count);
  } else {
    return pow(10, count);
  }
}

/// billion number
const double billion = 1000000000;

/// million number
const double million = 1000000;

/// kilo (thousands) number
const double kilo = 1000;

/// Formats and add symbols (K, M, B) at the end of number.
///
/// if number is larger than [billion], it returns a short number like 13.3B,
/// if number is larger than [million], it returns a short number line 43M,
/// if number is larger than [kilo], it returns a short number like 4K,
/// otherwise it returns number itself.
/// also it removes .0, at the end of number for simplicity.
String formatNumber(double number) {
  final isNegative = number < 0;

  if (isNegative) {
    number = number.abs();
  }

  String resultNumber;
  String symbol;
  if (number >= billion) {
    resultNumber = (number / billion).toStringAsFixed(1);
    symbol = 'B';
  } else if (number >= million) {
    resultNumber = (number / million).toStringAsFixed(1);
    symbol = 'M';
  } else if (number >= kilo) {
    resultNumber = (number / kilo).toStringAsFixed(1);
    symbol = 'K';
  } else {
    resultNumber = number.toStringAsFixed(1);
    symbol = '';
  }

  if (resultNumber.endsWith('.0')) {
    resultNumber = resultNumber.substring(0, resultNumber.length - 2);
  }

  if (isNegative) {
    resultNumber = '-$resultNumber';
  }

  return resultNumber + symbol;
}
