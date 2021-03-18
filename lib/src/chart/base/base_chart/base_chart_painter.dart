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
  void paint(Canvas canvas, Size size, PaintHolder<D> holder) {
    final canvasWrapper = CanvasWrapper(canvas, size);
    _drawViewBorder(canvasWrapper, holder.data.borderData, holder);
  }

  void _drawViewBorder(
    CanvasWrapper canvasWrapper,
    FlBorderData borderData,
    PaintHolder<D> holder,
  ) {
    if (!borderData.show) {
      return;
    }

    final viewSize = canvasWrapper.size;
    final chartViewSize = getChartUsableDrawSize(viewSize, holder);

    final topLeft = Offset(getLeftOffsetDrawSize(holder), getTopOffsetDrawSize(holder));
    final topRight =
        Offset(getLeftOffsetDrawSize(holder) + chartViewSize.width, getTopOffsetDrawSize(holder));
    final bottomLeft =
        Offset(getLeftOffsetDrawSize(holder), getTopOffsetDrawSize(holder) + chartViewSize.height);
    final bottomRight = Offset(getLeftOffsetDrawSize(holder) + chartViewSize.width,
        getTopOffsetDrawSize(holder) + chartViewSize.height);

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

  /// Calculate the size that we can draw our chart's main content.
  /// [getExtraNeededHorizontalSpace] and [getExtraNeededVerticalSpace]
  /// is the needed space to draw horizontal and vertical
  /// stuff around our chart.
  /// then we subtract them from raw [viewSize]
  Size getChartUsableDrawSize(Size viewSize, PaintHolder<D> holder) {
    final usableWidth = viewSize.width - getExtraNeededHorizontalSpace(holder);
    final usableHeight = viewSize.height - getExtraNeededVerticalSpace(holder);
    return Size(usableWidth, usableHeight);
  }

  /// Extra space needed to show horizontal contents around the chart,
  /// like: left, right padding, left, right titles, and so on,
  double getExtraNeededHorizontalSpace(PaintHolder<D> holder) => 0;

  /// Extra space needed to show vertical contents around the chart,
  /// like: top, bottom padding, top, bottom titles, and so on,
  double getExtraNeededVerticalSpace(PaintHolder<D> holder) => 0;

  /// Left offset to draw the chart's main content
  /// we should use this to offset our x axis when we drawing the chart,
  /// and the width space we can use to draw chart is[getChartUsableDrawSize.width]
  double getLeftOffsetDrawSize(PaintHolder<D> holder) => 0;

  /// Top offset to draw the chart's main content
  /// we should use this to offset our y axis when we drawing the chart,
  /// and the height space we can use to draw chart is[getChartUsableDrawSize.height]
  double getTopOffsetDrawSize(PaintHolder<D> holder) => 0;
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
