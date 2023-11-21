// coverage:ignore-file
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/material.dart';

/// Base class of our painters.
class BaseChartPainter<D extends BaseChartData> {
  /// Draws some basic elements
  const BaseChartPainter();

  // Paints [BaseChartData] into the provided canvas.
  void paint(
    BuildContext context,
    CanvasWrapper canvasWrapper,
    PaintHolder<D> holder,
  ) {}
}

/// Holds data for painting on canvas
class PaintHolder<Data extends BaseChartData> {
  /// Holds data for painting on canvas
  const PaintHolder(this.data, this.targetData, this.textScaler);

  /// [data] is what we need to show frame by frame (it might be changed by an animator)
  final Data data;

  /// [targetData] is the target of animation that is playing.
  final Data targetData;

  /// system [TextScaler] used for scaling texts for better readability
  final TextScaler textScaler;
}
