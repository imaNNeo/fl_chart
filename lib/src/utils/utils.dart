import 'dart:math' as math;

import 'package:flutter/material.dart';

const double degrees2Radians = math.pi / 180.0;

double radians(double degrees) => degrees * degrees2Radians;

const double radians2Degrees = 180.0 / math.pi;

double degrees(double radians) => radians * radians2Degrees;

/// returns a default size based on the screen size
/// that is a 70% scaled square based on the screen.
Size getDefaultSize(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  if (size.width < size.height) {
    size = Size(size.width, size.width);
  } else if (size.height < size.width) {
    size = Size(size.height, size.height);
  }
  size *= 0.7;
  return size;
}
