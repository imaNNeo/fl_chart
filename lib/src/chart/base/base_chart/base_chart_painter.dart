import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/src/extensions/paint_extension.dart';
import 'base_chart_data.dart';
import 'touch_input.dart';

/// Base class of our painters.
///
/// It is responsible to do basic jobs, like drawing borders of charts.
abstract class BaseChartPainter<D extends BaseChartData> extends CustomPainter {
  final D data;
  final D targetData;
  Paint _borderPaint;
  double textScale;

  /// Draws some basic things line border
  BaseChartPainter(this.data, this.targetData, {this.textScale = 1}) : super() {
    _borderPaint = Paint()..style = PaintingStyle.stroke;
  }

  /// Paints [BaseChartData] into the provided canvas.
  @override
  void paint(Canvas canvas, Size size) {
    final canvasWrapper = CanvasWrapper(canvas, size);
    _drawViewBorder(canvasWrapper);
  }

  void _drawViewBorder(CanvasWrapper canvasWrapper) {
    if (!data.borderData.show) {
      return;
    }

    final viewSize = canvasWrapper.size;
    final chartViewSize = getChartUsableDrawSize(viewSize);

    final topLeft = Offset(getLeftOffsetDrawSize(), getTopOffsetDrawSize());
    final topRight = Offset(getLeftOffsetDrawSize() + chartViewSize.width, getTopOffsetDrawSize());
    final bottomLeft =
        Offset(getLeftOffsetDrawSize(), getTopOffsetDrawSize() + chartViewSize.height);
    final bottomRight = Offset(getLeftOffsetDrawSize() + chartViewSize.width,
        getTopOffsetDrawSize() + chartViewSize.height);

    /// Draw Top Line
    final topBorder = data.borderData.border.top;
    if (topBorder.width != 0.0) {
      _borderPaint.color = topBorder.color;
      _borderPaint.strokeWidth = topBorder.width;
      _borderPaint.transparentIfWidthIsZero();
      canvasWrapper.drawLine(topLeft, topRight, _borderPaint);
    }

    /// Draw Right Line
    final rightBorder = data.borderData.border.right;
    if (rightBorder.width != 0.0) {
      _borderPaint.color = rightBorder.color;
      _borderPaint.strokeWidth = rightBorder.width;
      _borderPaint.transparentIfWidthIsZero();
      canvasWrapper.drawLine(topRight, bottomRight, _borderPaint);
    }

    /// Draw Bottom Line
    final bottomBorder = data.borderData.border.bottom;
    if (bottomBorder.width != 0.0) {
      _borderPaint.color = bottomBorder.color;
      _borderPaint.strokeWidth = bottomBorder.width;
      _borderPaint.transparentIfWidthIsZero();
      canvasWrapper.drawLine(bottomRight, bottomLeft, _borderPaint);
    }

    /// Draw Left Line
    final leftBorder = data.borderData.border.left;
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
  Size getChartUsableDrawSize(Size viewSize) {
    final usableWidth = viewSize.width - getExtraNeededHorizontalSpace();
    final usableHeight = viewSize.height - getExtraNeededVerticalSpace();
    return Size(usableWidth, usableHeight);
  }

  /// Extra space needed to show horizontal contents around the chart,
  /// like: left, right padding, left, right titles, and so on,
  double getExtraNeededHorizontalSpace() => 0;

  /// Extra space needed to show vertical contents around the chart,
  /// like: top, bottom padding, top, bottom titles, and so on,
  double getExtraNeededVerticalSpace() => 0;

  /// Left offset to draw the chart's main content
  /// we should use this to offset our x axis when we drawing the chart,
  /// and the width space we can use to draw chart is[getChartUsableDrawSize.width]
  double getLeftOffsetDrawSize() => 0;

  /// Top offset to draw the chart's main content
  /// we should use this to offset our y axis when we drawing the chart,
  /// and the height space we can use to draw chart is[getChartUsableDrawSize.height]
  double getTopOffsetDrawSize() => 0;
}

mixin TouchHandler<T extends BaseTouchResponse> {
  T handleTouch(
    FlTouchInput touchInput,
    Size size,
  ) =>
      throw UnsupportedError('not implemented');
}
