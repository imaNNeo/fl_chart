import 'dart:math' as math;

import 'package:flutter/material.dart';

const double _degrees2Radians = math.pi / 180.0;

double radians(double degrees) => degrees * _degrees2Radians;

const double _radians2Degrees = 180.0 / math.pi;

double degrees(double radians) => radians * _radians2Degrees;

/// returns a default size based on the screen size
/// that is a 70% scaled square based on the screen.
Size getDefaultSize(Size screenSize) {
  Size resultSize;
  if (screenSize.width < screenSize.height) {
    resultSize = Size(screenSize.width, screenSize.width);
  } else if (screenSize.height < screenSize.width) {
    resultSize = Size(screenSize.height, screenSize.height);
  }
  return resultSize * 0.7;
}

/// forward the view base on its degree
double translateRotatedPosition(double size, double degree) {
  return (size / 4) * math.sin(radians(degree.abs()));
}
