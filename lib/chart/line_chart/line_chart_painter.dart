import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'line_chart_data.dart';

class LineChartPainter extends CustomPainter {

  final LineChartData data;

  Paint barPaint, dotPaint, gridPaint;
  double dotSize;

  LineChartPainter(this.data,) {
    barPaint = Paint()
      ..color = data.barData.barColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = data.barData.barWidth;

    dotPaint = Paint()
      ..color = data.dotData.dotColor
      ..style = PaintingStyle.fill;

    gridPaint = new Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.5;

    dotSize = data.dotData.dotSize;
  }

  @override
  void paint(Canvas canvas, Size viewSize) {
    if (data.spots.length == 0) {
      return;
    }
    _drawGrid(canvas, viewSize);
    _drawTitles(canvas, viewSize);
    _drawBar(canvas, viewSize);
    _drawDots(canvas, viewSize);
    _drawViewBorder(canvas, viewSize);
  }

  void _drawGrid(Canvas canvas, Size viewSize) {
    if (!data.showGridLines || data.gridData == null) {
      return;
    }
    viewSize = _getChartUsableDrawSize(viewSize);
    // Show Vertical Grid
    if (data.gridData.drawVerticalGrid) {
      int verticalCounter = 0;
      gridPaint.color = data.gridData.verticalGridColor;
      gridPaint.strokeWidth = data.gridData.verticalGridLineWidth;
      while (data.gridData.verticalInterval * verticalCounter <= data.maxY) {
        var currentIntervalSeek = data.gridData.verticalInterval * verticalCounter;
        if (data.gridData.checkToShowVerticalGrid(currentIntervalSeek)) {
          double sameY = _getPixelY(currentIntervalSeek, viewSize);
          double x1 = 0 + _getLeftOffsetDrawSize();
          double y1 = sameY + _getTopOffsetDrawSize();
          double x2 = viewSize.width + _getLeftOffsetDrawSize();
          double y2 = sameY + _getTopOffsetDrawSize();
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
      int horizontalCounter = 0;
      gridPaint.color = data.gridData.horizontalGridColor;
      gridPaint.strokeWidth = data.gridData.horizontalGridLineWidth;
      while (data.gridData.horizontalInterval * horizontalCounter <= data.maxX) {
        var currentIntervalSeek = data.gridData.horizontalInterval * horizontalCounter;
        if (data.gridData.checkToShowHorizontalGrid(currentIntervalSeek)) {
          double sameX = _getPixelX(currentIntervalSeek, viewSize);
          double x1 = sameX;
          double y1 = 0 + _getTopOffsetDrawSize();
          double x2 = sameX;
          double y2 = viewSize.height + _getTopOffsetDrawSize();
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
    if (!data.showTitles) {
      return;
    }
    viewSize = _getChartUsableDrawSize(viewSize);

    // Vertical Titles
    int verticalCounter = 0;
    while (data.gridData.verticalInterval * verticalCounter <= data.maxY) {
      double x = 0 + _getLeftOffsetDrawSize();
      double y = _getPixelY(data.gridData.verticalInterval * verticalCounter, viewSize) +
        _getTopOffsetDrawSize();

      String text = data.titlesData.getVerticalTitle(
        data.gridData.verticalInterval * verticalCounter);

      TextSpan span = new TextSpan(style: data.titlesData.verticalTitlesTextStyle, text: text);
      TextPainter tp = new TextPainter(
        text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      tp.layout(maxWidth: _getExtraNeededHorizontalSpace());
      x -= tp.width + data.titlesData.verticalTitleMargin;
      y -= (tp.height / 2);
      tp.paint(canvas, new Offset(x, y));

      verticalCounter++;
    }

    // Horizontal titles
    int horizontalCounter = 0;
    while (data.gridData.horizontalInterval * horizontalCounter <= data.maxX) {
      double x = _getPixelX(data.gridData.horizontalInterval * horizontalCounter, viewSize);
      double y = viewSize.height + _getTopOffsetDrawSize();

      String text = data.titlesData.getHorizontalTitle(
        data.gridData.horizontalInterval * horizontalCounter);

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

  void _drawBar(Canvas canvas, Size viewSize) {
    if (!data.showBar) {
      return;
    }
    viewSize = _getChartUsableDrawSize(viewSize);

    Path path = Path();
    int size = data.spots.length;
    path.reset();

    double lX = 0.0,
      lY = 0.0;

    double x = _getPixelX(data.spots[0].x, viewSize);
    double y = _getPixelY(data.spots[0].y, viewSize);
    path.moveTo(x, y);
    for (int i = 1; i < size; i++) {
      // CurrentSpot
      LineChartSpot p = data.spots[i];
      double px = _getPixelX(p.x, viewSize);
      double py = _getPixelY(p.y, viewSize);

      // previous spot
      LineChartSpot p0 = data.spots[i - 1];
      double p0x = _getPixelX(p0.x, viewSize);
      double p0y = _getPixelY(p0.y, viewSize);

      double x1 = p0x + lX;
      double y1 = p0y + lY;

      // next point
      LineChartSpot p1 = data.spots[i + 1 < size ? i + 1 : i];
      double p1x = _getPixelX(p1.x, viewSize);
      double p1y = _getPixelY(p1.y, viewSize);

      double smoothness = data.barData.isCurved ? data.barData.curveSmoothness : 0.0;
      lX = ((p1x - p0x) / 2) * smoothness;
      lY = ((p1y - p0y) / 2) * smoothness;
      double x2 = px - lX;
      double y2 = py - lY;

      path.cubicTo(x1, y1, x2, y2, px, py);
    }
    canvas.drawPath(path, barPaint);
  }

  void _drawDots(Canvas canvas, Size viewSize) {
    if (!data.showDots) {
      return;
    }
    viewSize = _getChartUsableDrawSize(viewSize);
    data.spots.forEach((spot) {
      if (data.dotData.checkToShowDot(spot)) {
        double x = _getPixelX(spot.x, viewSize);
        double y = _getPixelY(spot.y, viewSize);
        canvas.drawCircle(Offset(x, y), dotSize, dotPaint);
      }
    });
  }

  void _drawViewBorder(Canvas canvas, Size viewSize) {
    viewSize = _getChartUsableDrawSize(viewSize);
    Paint p = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRect(
      Rect.fromLTWH(
        0 + _getLeftOffsetDrawSize(),
        0 + _getTopOffsetDrawSize(),
        viewSize.width,
        viewSize.height,
      ), p);
  }

  double _getPixelX(double spotX, Size viewSize) {
    return ((spotX / data.maxX) * viewSize.width) + _getLeftOffsetDrawSize();
  }

  double _getPixelY(double spotY, Size viewSize,) {
    double y = data.maxY - spotY;
    return ((y / data.maxY) * viewSize.height) + _getTopOffsetDrawSize();
  }

  Size _getChartUsableDrawSize(Size viewSize) {
    double usableWidth = viewSize.width - _getExtraNeededHorizontalSpace();
    double usableHeight = viewSize.height - _getExtraNeededVerticalSpace();
    return Size(usableWidth, usableHeight);
  }

  double _getExtraNeededHorizontalSpace() {
    if (data.showTitles) {
      return data.titlesData.verticalTitlesReservedWidth;
    }
    return 0;
  }

  double _getExtraNeededVerticalSpace() {
    if (data.showTitles) {
      return data.titlesData.horizontalTitlesReservedHeight;
    }
    return 0;
  }

  double _getLeftOffsetDrawSize() {
    if (data.showTitles && data.titlesData.verticalTitlesAlignment == TitleAlignment.LEFT) {
      return data.titlesData.verticalTitlesReservedWidth;
    }
    return 0;
  }

  double _getTopOffsetDrawSize() {
    if (data.showTitles && data.titlesData.horizontalTitlesAlignment == TitleAlignment.TOP) {
      return data.titlesData.horizontalTitlesReservedHeight;
    }
    return 0;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

}