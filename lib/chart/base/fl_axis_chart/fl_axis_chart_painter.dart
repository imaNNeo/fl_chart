import 'package:fl_chart/chart/base/fl_axis_chart/fl_axis_chart_data.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_painter.dart';
import 'package:flutter/material.dart';

abstract class FlAxisChartPainter<D extends FlAxisChartData> extends FlChartPainter<D> {
  final D data;
  Paint gridPaint, borderPaint, dotPaint;

  FlAxisChartPainter(this.data) : super(data) {
    gridPaint = new Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.5;

    dotPaint = Paint()
      ..color = data.dotData.dotColor
      ..style = PaintingStyle.fill;

    borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
  }

  @override
  void paint(Canvas canvas, Size viewSize) {
    super.paint(canvas, viewSize);
    drawGrid(canvas, viewSize);
    drawBehindDots(canvas, viewSize);
    drawDots(canvas, viewSize);
  }

  void drawGrid(Canvas canvas, Size viewSize) {
    if (!data.gridData.show || data.gridData == null) {
      return;
    }
    var usableViewSize = getChartUsableDrawSize(viewSize);
    // Show Vertical Grid
    if (data.gridData.drawVerticalGrid) {
      int verticalCounter = 1;
      gridPaint.color = data.gridData.verticalGridColor;
      gridPaint.strokeWidth = data.gridData.verticalGridLineWidth;
      while (data.gridData.verticalInterval * verticalCounter < data.maxY) {
        var currentIntervalSeek = data.gridData.verticalInterval * verticalCounter;
        if (data.gridData.checkToShowVerticalGrid(currentIntervalSeek)) {
          double sameY = getPixelY(currentIntervalSeek, usableViewSize);
          double x1 = 0 + getLeftOffsetDrawSize();
          double y1 = sameY + getTopOffsetDrawSize();
          double x2 = usableViewSize.width + getLeftOffsetDrawSize();
          double y2 = sameY + getTopOffsetDrawSize();
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
      int horizontalCounter = 1;
      gridPaint.color = data.gridData.horizontalGridColor;
      gridPaint.strokeWidth = data.gridData.horizontalGridLineWidth;
      while (data.gridData.horizontalInterval * horizontalCounter < data.maxX) {
        var currentIntervalSeek = data.gridData.horizontalInterval * horizontalCounter;
        if (data.gridData.checkToShowHorizontalGrid(currentIntervalSeek)) {
          double sameX = getPixelX(currentIntervalSeek, usableViewSize);
          double x1 = sameX;
          double y1 = 0 + getTopOffsetDrawSize();
          double x2 = sameX;
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

  void drawBehindDots(Canvas canvas, Size viewSize) { }

  void drawDots(Canvas canvas, Size viewSize) {
    if (!data.dotData.show) {
      return;
    }
    viewSize = getChartUsableDrawSize(viewSize);
    data.spots.forEach((spot) {
      if (data.dotData.checkToShowDot(spot)) {
        double x = getPixelX(spot.x, viewSize);
        double y = getPixelY(spot.y, viewSize);
        canvas.drawCircle(Offset(x, y), data.dotData.dotSize, dotPaint);
      }
    });
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
      return parentNeeded + data.titlesData.verticalTitlesReservedWidth + data.titlesData.verticalTitleMargin;
    }
    return parentNeeded;
  }

  @override
  double getExtraNeededVerticalSpace() {
    double parentNeeded = super.getExtraNeededVerticalSpace();
    if (data.titlesData.show && data.titlesData.showHorizontalTitles) {
      return parentNeeded + data.titlesData.horizontalTitlesReservedHeight + data.titlesData.horizontalTitleMargin;
    }
    return parentNeeded;
  }

  double getLeftOffsetDrawSize() {
    double parentNeeded = super.getLeftOffsetDrawSize();
    if (data.titlesData.show && data.titlesData.showVerticalTitles) {
      return parentNeeded + data.titlesData.verticalTitlesReservedWidth + data.titlesData.verticalTitleMargin;
    }
    return parentNeeded;
  }

  double getTopOffsetDrawSize() {
    return super.getTopOffsetDrawSize();
  }

}