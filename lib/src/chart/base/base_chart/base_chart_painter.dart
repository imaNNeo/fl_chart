// coverage:ignore-file
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/src/extensions/paint_extension.dart';
import 'base_chart_data.dart';

/// Base class of our painters.
///
/// It is responsible to do basic draws, like drawing borders of charts.
class BaseChartPainter<D extends BaseChartData> {
  late Paint _borderPaint;

  /// Draws some basic elements like border
  BaseChartPainter() : super() {
    _borderPaint = Paint()..style = PaintingStyle.stroke;
  }

  // Paints [BaseChartData] into the provided canvas.
  void paint(BuildContext context, CanvasWrapper canvasWrapper,
      PaintHolder<D> holder) {
    _drawViewBorder(context, canvasWrapper, holder.data.borderData, holder);
  }

  void _drawViewBorder(
    BuildContext context,
    CanvasWrapper canvasWrapper,
    FlBorderData borderData,
    PaintHolder<D> holder,
  ) {
    if (!borderData.show) {
      return;
    }

    final viewSize = canvasWrapper.size;

    const topLeft = Offset(0, 0);
    final topRight = Offset(viewSize.width, 0);
    final bottomLeft = Offset(0, viewSize.height);
    final bottomRight = Offset(viewSize.width, viewSize.height);

    /// Draw Top Line
    final topBorder = borderData.border.top;
    if (topBorder.width != 0.0) {
      _borderPaint.color = topBorder.color;
      _borderPaint.strokeWidth = topBorder.width;
      _borderPaint.transparentIfWidthIsZero();
      canvasWrapper.drawLine(topLeft, topRight, _borderPaint);
    }

    /// Draw Right Line
    final rightBorder = borderData.border.right;
    if (rightBorder.width != 0.0) {
      _borderPaint.color = rightBorder.color;
      _borderPaint.strokeWidth = rightBorder.width;
      _borderPaint.transparentIfWidthIsZero();
      canvasWrapper.drawLine(topRight, bottomRight, _borderPaint);
    }

    /// Draw Bottom Line
    final bottomBorder = borderData.border.bottom;
    if (bottomBorder.width != 0.0) {
      _borderPaint.color = bottomBorder.color;
      _borderPaint.strokeWidth = bottomBorder.width;
      _borderPaint.transparentIfWidthIsZero();
      canvasWrapper.drawLine(bottomRight, bottomLeft, _borderPaint);
    }

    /// Draw Left Line
    final leftBorder = borderData.border.left;
    if (leftBorder.width != 0.0) {
      _borderPaint.color = leftBorder.color;
      _borderPaint.strokeWidth = leftBorder.width;
      _borderPaint.transparentIfWidthIsZero();
      canvasWrapper.drawLine(bottomLeft, topLeft, _borderPaint);
    }
  }
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
