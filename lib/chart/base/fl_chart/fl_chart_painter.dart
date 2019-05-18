import 'package:fl_chart/chart/base/fl_chart/fl_chart_data.dart';
import 'package:flutter/material.dart';

abstract class FlChartPainter<D extends FlChartData> extends CustomPainter{
  final D data;
  Paint borderPaint;

  FlChartPainter(this.data) {
    borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
  }

  @override
  void paint(Canvas canvas, Size viewSize) {
    _drawViewBorder(canvas, viewSize);
  }


  void _drawViewBorder(Canvas canvas, Size viewSize) {
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

  double getExtraNeededHorizontalSpace() {
    return 0;
  }

  double getExtraNeededVerticalSpace() {
    return 0;
  }

  double getLeftOffsetDrawSize() {
    return 0;
  }

  double getTopOffsetDrawSize() {
    return 0;
  }

}