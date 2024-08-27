import 'package:flutter/material.dart';

class FLConnectorLineSettings {
  const FLConnectorLineSettings({
    this.length,
    double? width,
    this.color,
  })  : width = width ?? 1.0;
  final String? length;
  final double width;
  final Color? color;
}
