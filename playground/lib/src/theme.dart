import 'package:flutter/material.dart';

/// The colors of flchart.dev, so the playground blends into the docs.
abstract final class AppColors {
  static const background = Color(0xFF1B2339);
  static const surface = Color(0xFF222B45);
  static const codeBackground = Color(0xFF161D31);
  static const border = Color(0x1AFFFFFF);
  static const primary = Color(0xFF50E4FF);
  static const secondary = Color(0xFFB57BFF);
  static const muted = Color(0xFFA3AECB);
}

const monoFontFamily = 'RobotoMono';

final playgroundTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
    primary: AppColors.primary,
    surface: AppColors.surface,
  ),
  scaffoldBackgroundColor: AppColors.background,
);
