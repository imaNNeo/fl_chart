import 'dart:math' as math;

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
  if (stops == null || stops.length != colors.length) {
    stops = [];

    /// provided gradientColorStops is invalid and we calculate it here
    colors.asMap().forEach((index, color) {
      final percent = 1.0 / colors.length;
      stops.add(percent * (index + 1));
    });
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
