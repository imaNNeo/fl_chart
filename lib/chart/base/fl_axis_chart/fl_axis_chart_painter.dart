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
    _drawGrid(canvas, viewSize);
    _drawTitles(canvas, viewSize);
    _drawDots(canvas, viewSize);
  }

  void _drawGrid(Canvas canvas, Size viewSize) {
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

  void _drawTitles(Canvas canvas, Size viewSize) {
    if (!data.titlesData.show) {
      return;
    }
    viewSize = getChartUsableDrawSize(viewSize);

    // Vertical Titles
    int verticalCounter = 0;
    while (data.gridData.verticalInterval * verticalCounter <= data.maxY) {
      double x = 0 + getLeftOffsetDrawSize();
      double y = getPixelY(data.gridData.verticalInterval * verticalCounter, viewSize) +
        getTopOffsetDrawSize();

      String text =
      data.titlesData.getVerticalTitle(data.gridData.verticalInterval * verticalCounter);

      TextSpan span = new TextSpan(style: data.titlesData.verticalTitlesTextStyle, text: text);
      TextPainter tp = new TextPainter(
        text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      tp.layout(maxWidth: getExtraNeededHorizontalSpace());
      x -= tp.width + data.titlesData.verticalTitleMargin;
      y -= (tp.height / 2);
      tp.paint(canvas, new Offset(x, y));

      verticalCounter++;
    }

    // Horizontal titles
    int horizontalCounter = 0;
    while (data.gridData.horizontalInterval * horizontalCounter <= data.maxX) {
      double x = getPixelX(data.gridData.horizontalInterval * horizontalCounter, viewSize);
      double y = viewSize.height + getTopOffsetDrawSize();

      String text =
      data.titlesData.getHorizontalTitle(data.gridData.horizontalInterval * horizontalCounter);

      TextSpan span = new TextSpan(style: data.titlesData.horizontalTitlesTextStyle, text: text);
      TextPainter tp = new TextPainter(
        text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      tp.layout();

      x -= (tp.width / 2);
      y += data.titlesData.horizontalTitleMargin;

      tp.paint(canvas, Offset(x, y));

      horizontalCounter++;
    }
  }

  void _drawDots(Canvas canvas, Size viewSize) {
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

  double getPixelX(double spotX, Size viewSize) {
    return ((spotX / data.maxX) * viewSize.width) + getLeftOffsetDrawSize();
  }

  double getPixelY(
    double spotY,
    Size viewSize,
    ) {
    double y = data.maxY - spotY;
    return ((y / data.maxY) * viewSize.height) + getTopOffsetDrawSize();
  }

  @override
  double getExtraNeededHorizontalSpace() {
    double parentNeeded = super.getExtraNeededHorizontalSpace();
    if (data.titlesData.show) {
      return parentNeeded + data.titlesData.verticalTitlesReservedWidth + data.titlesData.verticalTitleMargin;
    }
    return parentNeeded;
  }

  @override
  double getExtraNeededVerticalSpace() {
    double parentNeeded = super.getExtraNeededVerticalSpace();
    if (data.titlesData.show) {
      return parentNeeded + data.titlesData.horizontalTitlesReservedHeight + data.titlesData.horizontalTitleMargin;
    }
    return parentNeeded;
  }

  double getLeftOffsetDrawSize() {
    double parentNeeded = super.getLeftOffsetDrawSize();
    if (data.titlesData.show) {
      return parentNeeded + data.titlesData.verticalTitlesReservedWidth + data.titlesData.verticalTitleMargin;
    }
    return parentNeeded;
  }

  double getTopOffsetDrawSize() {
    return super.getTopOffsetDrawSize();
  }

}