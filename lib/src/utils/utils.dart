import 'dart:math' as math;
import 'dart:math';

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

Offset rotateTextCanvas(Canvas canvas, TextPainter textPainter, double degreeAngle) {
  final double radiansAngle = radians(degreeAngle);
  final double r = sqrt(textPainter.width * textPainter.width + textPainter.height * textPainter.height) / 2;
  final alpha = atan(textPainter.height / textPainter.width);
  final beta = alpha + radiansAngle;
  final shiftY = r * sin(beta);
  final shiftX = r * cos(beta);
  final translateX = textPainter.width / 2 - shiftX;
  final translateY = textPainter.height / 2 - shiftY;
  print("${textPainter.width}, ${textPainter.height}");
  canvas.translate(translateX, translateY);
  canvas.rotate(radiansAngle);
  return Offset(translateX, translateY);
}

Canvas rotateCanvas(Canvas canvas, double degreeAngle) {
  final double radiansAngle = radians(degreeAngle);
  canvas.rotate(radiansAngle);
  return canvas;
}


