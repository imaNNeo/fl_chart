enum FlScaleAxis {
  /// Scales the horizontal axis.
  horizontal,

  /// Scales the vertical axis.
  vertical,

  /// Scales both the horizontal and vertical axes.
  free,

  /// Does not scale the axes.
  none;

  /// Axes that allow scaling.
  static const scalingEnabledAxis = [
    free,
    horizontal,
    vertical,
  ];
}
