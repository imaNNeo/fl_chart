import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

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

/// forward the view base on its degree
double translateRotatedPosition(double size, double degree) {
  return (size / 4) * math.sin(radians(degree.abs()));
}

/// takes in a path and returns a dathed path
/// data.dashArray is provided
/// dynamic because dart has no union types
Path pathDasher(Path path, Paint painter, dynamic data) {
  if (path != null && data.dashArray != null) {
    return dashPath(path, dashArray: data.dashArray);
  } else {
    return path;
  }
}
