// coverage:ignore-file
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/material.dart';
import 'base_chart_data.dart';

/// Base class of our painters.
class BaseChartPainter<D extends BaseChartData> {
  /// Draws some basic elements
  BaseChartPainter() : super();

  // Paints [BaseChartData] into the provided canvas.
  void paint(BuildContext context, CanvasWrapper canvasWrapper,
      PaintHolder<D> holder) {}
}

/// Holds data for painting on canvas
class PaintHolder<Data extends BaseChartData> {
  /// [data] is what we need to show frame by frame (it might be changed by an animator)
  final Data data;

  /// [targetData] is the target of animation that is playing.
  final Data targetData;

  /// system [textScale]
  final double textScale;

  /// Holds data for painting on canvas
  PaintHolder(this.data, this.targetData, this.textScale);
}
