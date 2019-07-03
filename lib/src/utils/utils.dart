import 'dart:math' as math;

const double degrees2Radians = math.pi / 180.0;
double radians(double degrees) => degrees * degrees2Radians;

const double radians2Degrees = 180.0 / math.pi;
double degrees(double radians) => radians * radians2Degrees;
