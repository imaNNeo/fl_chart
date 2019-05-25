import 'package:fl_chart/chart/base/fl_axis_chart/fl_axis_chart_data.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_painter.dart';
import 'package:flutter/material.dart';

abstract class FlAxisChartPainter<D extends FlAxisChartData> extends FlChartPainter<D> {
  final D data;
  Paint gridPaint;

  FlAxisChartPainter(this.data) : super(data) {
    gridPaint = new Paint()..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size viewSize) {
    super.paint(canvas, viewSize);
    drawGrid(canvas, viewSize);
  }

  void drawGrid(Canvas canvas, Size viewSize) {
    if (!data.gridData.show || data.gridData == null) {
      return;
    }
    var usableViewSize = getChartUsableDrawSize(viewSize);
    // Show Vertical Grid
    if (data.gridData.drawVerticalGrid) {
      gridPaint.color = data.gridData.verticalGridColor;
      gridPaint.strokeWidth = data.gridData.verticalGridLineWidth;

      int verticalCounter = 1;
      while (data.gridData.verticalInterval * verticalCounter < data.maxY) {
        var currentIntervalSeek = data.gridData.verticalInterval * verticalCounter;
        if (data.gridData.checkToShowVerticalGrid(currentIntervalSeek)) {
          double bothY = getPixelY(currentIntervalSeek, usableViewSize);
          double x1 = 0 + getLeftOffsetDrawSize();
          double y1 = bothY + getTopOffsetDrawSize();
          double x2 = usableViewSize.width + getLeftOffsetDrawSize();
          double y2 = bothY + getTopOffsetDrawSize();
          canvas.drawLine(
            Offset(x1, y1),
            Offset(x2, y2),
            gridPaint,
          );
        }
        verticalCounter++;
      }
    }

    // Show Horizontal Grid
    if (data.gridData.drawHorizontalGrid) {
      gridPaint.color = data.gridData.horizontalGridColor;
      gridPaint.strokeWidth = data.gridData.horizontalGridLineWidth;

      int horizontalCounter = 1;
      while (data.gridData.horizontalInterval * horizontalCounter < data.maxX) {
        var currentIntervalSeek = data.gridData.horizontalInterval * horizontalCounter;
        if (data.gridData.checkToShowHorizontalGrid(currentIntervalSeek)) {
          double bothX = getPixelX(currentIntervalSeek, usableViewSize);
          double x1 = bothX;
          double y1 = 0 + getTopOffsetDrawSize();
          double x2 = bothX;
          double y2 = usableViewSize.height + getTopOffsetDrawSize();
          canvas.drawLine(
            Offset(x1, y1),
            Offset(x2, y2),
            gridPaint,
          );
        }
        horizontalCounter++;
      }
    }
  }

  double getPixelX(double spotX, Size chartUsableSize) {
    return ((spotX / data.maxX) * chartUsableSize.width) + getLeftOffsetDrawSize();
  }

  double getPixelY(
    double spotY,
    Size chartUsableSize,
  ) {
    double y = data.maxY - spotY;
    return ((y / data.maxY) * chartUsableSize.height) + getTopOffsetDrawSize();
  }

  @override
  double getExtraNeededHorizontalSpace() {
    double parentNeeded = super.getExtraNeededHorizontalSpace();
    if (data.titlesData.show && data.titlesData.showVerticalTitles) {
      return parentNeeded +
          data.titlesData.verticalTitlesReservedWidth +
          data.titlesData.verticalTitleMargin;
    }
    return parentNeeded;
  }

  @override
  double getExtraNeededVerticalSpace() {
    double parentNeeded = super.getExtraNeededVerticalSpace();
    if (data.titlesData.show && data.titlesData.showHorizontalTitles) {
      return parentNeeded +
          data.titlesData.horizontalTitlesReservedHeight +
          data.titlesData.horizontalTitleMargin;
    }
    return parentNeeded;
  }

  double getLeftOffsetDrawSize() {
    double parentNeeded = super.getLeftOffsetDrawSize();
    if (data.titlesData.show && data.titlesData.showVerticalTitles) {
      return parentNeeded +
          data.titlesData.verticalTitlesReservedWidth +
          data.titlesData.verticalTitleMargin;
    }
    return parentNeeded;
  }
}
