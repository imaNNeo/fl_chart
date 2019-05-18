
import 'package:flutter/material.dart';

class FlChartData {
  final FlBorderData borderData;

  FlChartData({
    this.borderData = const FlBorderData(),
  });
}

// Border Data
class FlBorderData {
  final bool show;

  final Color borderColor;
  final double borderWidth;

  const FlBorderData({
    this.show = true,
    this.borderColor = Colors.black,
    this.borderWidth = 1.0,
  });
}