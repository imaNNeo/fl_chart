import 'package:flutter/material.dart';

/// Type of connector line.
enum FLConnectorType { line }

class FLConnectorLineSettings {
  const FLConnectorLineSettings({
    this.length,
    double? width,
    FLConnectorType? type,
    this.color,
  })  : width = width ?? 1.0,
        type = type ?? FLConnectorType.line;
  final String? length;
  final double width;
  final Color? color;
  final FLConnectorType type;
}
