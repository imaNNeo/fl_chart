import 'package:fl_chart/chart/base/fl_chart/fl_chart_data.dart';
import 'package:flutter/material.dart';

abstract class FlChartPainter<D extends FlChartData> extends CustomPainter {
  final D data;
  Paint borderPaint;

  FlChartPainter(this.data) {
    borderPaint = Paint()
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size viewSize) {
    drawViewBorder(canvas, viewSize);
  }

  void drawViewBorder(Canvas canvas, Size viewSize) {
    if (!data.borderData.show) {
      return;
    }

    var chartViewSize = getChartUsableDrawSize(viewSize);

    borderPaint.color = data.borderData.borderColor;
    borderPaint.strokeWidth = data.borderData.borderWidth;

    canvas.drawRect(
        Rect.fromLTWH(
          0 + getLeftOffsetDrawSize(),
          0 + getTopOffsetDrawSize(),
          chartViewSize.width,
          chartViewSize.height,
        ),
        borderPaint);
  }

  Size getChartUsableDrawSize(Size viewSize) {
    double usableWidth = viewSize.width - getExtraNeededHorizontalSpace();
    double usableHeight = viewSize.height - getExtraNeededVerticalSpace();
    return Size(usableWidth, usableHeight);
  }

  double getExtraNeededHorizontalSpace() => 0;
  double getExtraNeededVerticalSpace() => 0;
  double getLeftOffsetDrawSize() => 0;
  double getTopOffsetDrawSize() => 0;
}
