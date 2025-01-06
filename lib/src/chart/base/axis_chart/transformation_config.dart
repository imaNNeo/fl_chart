import 'package:fl_chart/src/chart/base/axis_chart/scale_axis.dart';
import 'package:flutter/widgets.dart';

/// Configuration for the transformation of an axis-based chart.
class FlTransformationConfig {
  const FlTransformationConfig({
    this.scaleAxis = FlScaleAxis.none,
    this.minScale = 1,
    this.maxScale = 2.5,
    this.panEnabled = true,
    this.scaleEnabled = true,
    this.trackpadScrollCausesScale = false,
    this.transformationController,
  })  : assert(minScale >= 1, 'minScale must be greater than or equal to 1'),
        assert(
          maxScale >= minScale,
          'maxScale must be greater than or equal to minScale',
        );

  /// Determines what axis of the chart should be scaled.
  final FlScaleAxis scaleAxis;

  /// The minimum scale of the chart.
  ///
  /// Ignored when [scaleAxis] is [FlScaleAxis.none].
  final double minScale;

  /// The maximum scale of the chart.
  ///
  /// Ignored when [scaleAxis] is [FlScaleAxis.none].
  final double maxScale;

  /// If false, the user will be prevented from panning.
  ///
  /// Ignored when [scaleAxis] is [FlScaleAxis.none].
  final bool panEnabled;

  /// If false, the user will be prevented from scaling.
  ///
  /// Ignored when [scaleAxis] is [FlScaleAxis.none].
  final bool scaleEnabled;

  /// Whether trackpad scroll causes scale.
  ///
  /// Ignored when [scaleAxis] is [FlScaleAxis.none].
  final bool trackpadScrollCausesScale;

  /// The transformation controller to control the transformation of the chart.
  final TransformationController? transformationController;
}
