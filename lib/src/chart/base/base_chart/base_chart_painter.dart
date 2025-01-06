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
  const PaintHolder(
    this.data,
    this.targetData,
    this.textScaler, [
    this.chartVirtualRect,
  ]);

  /// [data] is what we need to show frame by frame (it might be changed by an animator)
  final Data data;

  /// [targetData] is the target of animation that is playing.
  final Data targetData;

  /// system [TextScaler] used for scaling texts for better readability
  final TextScaler textScaler;

  /// The virtual rect representing the chart when it is scaled or panned.
  ///
  /// The chart will be drawn in this virtual canvas, and then clipped to the
  /// actual canvas.
  ///
  /// When the chart is scaled, the virtual canvas will be larger than the
  /// actual canvas. This will lead to the content being laid out on the larger
  /// area. Thus resulting in the scaling effect.
  ///
  /// Null when not scaling or panning.
  final Rect? chartVirtualRect;

  /// Returns the size of the chart that is actually being painted.
  ///
  /// When scaling the chart, the chart is painted on a larger area to simulate
  /// the zoom effect. This function returns the size of the area that is
  /// actually being painted.
  ///
  /// When not scaled it returns the actual size of the chart.
  Size getChartUsableSize(Size viewSize) {
    return chartVirtualRect?.size ?? viewSize;
  }
}
