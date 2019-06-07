import 'package:fl_chart/src/chart/bar_chart/bar_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_painter.dart';
import 'package:flutter/material.dart';

import 'axis_chart_data.dart';

/// This class is responsible to draw the grid behind all axis base charts.
/// also we have two useful function [getPixelX] and [getPixelY] that used
/// in child classes -> [BarChartPainter], [LineChartPainter]
abstract class AxisChartPainter<D extends AxisChartData> extends BaseChartPainter<D> {
  final D data;

  Paint gridPaint;

  AxisChartPainter(this.data) : super(data) {
    gridPaint = Paint()..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    drawGrid(canvas, size);
  }

  void drawGrid(Canvas canvas, Size viewSize) {
    if (!data.gridData.show || data.gridData == null) {
      return;
    }
    final Size usableViewSize = getChartUsableDrawSize(viewSize);
    // Show Vertical Grid
    if (data.gridData.drawVerticalGrid) {
      gridPaint.color = data.gridData.verticalGridColor;
      gridPaint.strokeWidth = data.gridData.verticalGridLineWidth;

      double verticalSeek = data.minY;
      while (verticalSeek < data.maxY) {
        if (data.gridData.checkToShowVerticalGrid(verticalSeek)) {
          final double bothY = getPixelY(verticalSeek, usableViewSize);
          final double x1 = 0 + getLeftOffsetDrawSize();
          final double y1 = bothY + getTopOffsetDrawSize();
          final double x2 = usableViewSize.width + getLeftOffsetDrawSize();
          final double y2 = bothY + getTopOffsetDrawSize();
          canvas.drawLine(
            Offset(x1, y1),
            Offset(x2, y2),
            gridPaint,
          );
        }
        verticalSeek += data.gridData.verticalInterval;
      }
    }

    // Show Horizontal Grid
    if (data.gridData.drawHorizontalGrid) {
      gridPaint.color = data.gridData.horizontalGridColor;
      gridPaint.strokeWidth = data.gridData.horizontalGridLineWidth;

      double horizontalSeek = data.minX;
      while (horizontalSeek < data.maxX) {
        if (data.gridData.checkToShowHorizontalGrid(horizontalSeek)) {
          final double bothX = getPixelX(horizontalSeek, usableViewSize);
          final double x1 = bothX;
          final double y1 = 0 + getTopOffsetDrawSize();
          final double x2 = bothX;
          final double y2 = usableViewSize.height + getTopOffsetDrawSize();
          canvas.drawLine(
            Offset(x1, y1),
            Offset(x2, y2),
            gridPaint,
          );
        }

        horizontalSeek += data.gridData.horizontalInterval;
      }
    }
  }

  /// With this function we can convert our [FlSpot] x
  /// to the view base axis x .
  /// the view 0, 0 is on the top/left, but the spots is bottom/left
  double getPixelX(double spotX, Size chartUsableSize) {
    return (((spotX - data.minX) / (data.maxX - data.minX)) * chartUsableSize.width) + getLeftOffsetDrawSize();
  }

  /// With this function we can convert our [FlSpot] y
  /// to the view base axis y.
  double getPixelY(
    double spotY,
    Size chartUsableSize,
  ) {
    double y = ((spotY - data.minY) / (data.maxY - data.minY)) * chartUsableSize.height;
    y = chartUsableSize.height - y;
    return y + getTopOffsetDrawSize();
  }
}
