import 'dart:ui' as ui;

import 'package:fl_chart/chart/base/fl_axis_chart/fl_axis_chart_data.dart';
import 'package:fl_chart/chart/base/fl_axis_chart/fl_axis_chart_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'line_chart_data.dart';

class LineChartPainter extends FlAxisChartPainter {
  final LineChartData data;

  Paint barPaint, belowBarPaint;

  LineChartPainter(
    this.data,
  ) : super(data) {
    barPaint = Paint()
      ..color = data.barData.barColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = data.barData.barWidth;

    belowBarPaint = Paint()
      ..color = Colors.orange.withOpacity(0.5)
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size viewSize) {
    if (data.spots.length == 0) {
      return;
    }
    super.paint(canvas, viewSize);

    Path barPath = _generateBarPath(viewSize);
    drawBelowBar(canvas, viewSize, Path.from(barPath));
    drawBar(canvas, viewSize, Path.from(barPath));
    drawTitles(canvas, viewSize);
  }

  /*
  barPath Ends in Top Right
   */
  void drawBelowBar(Canvas canvas, Size viewSize, Path barPath) {
    if (!data.belowBarData.show) {
      return;
    }

    Size chartViewSize = getChartUsableDrawSize(viewSize);

    // Line To Bottom Right
    double x = getPixelX(data.spots[data.spots.length - 1].x, chartViewSize);
    double y = chartViewSize.height - getTopOffsetDrawSize();
    barPath.lineTo(x, y);

    // Line To Bottom Left
    x = getPixelX(data.spots[0].x, chartViewSize);
    y = chartViewSize.height - getTopOffsetDrawSize();
    barPath.lineTo(x, y);

    // Line To Top Left
    x = getPixelX(data.spots[0].x, chartViewSize);
    y = getPixelY(data.spots[0].y, chartViewSize);
    barPath.lineTo(x, y);
    barPath.close();

    if (data.belowBarData.colors.length == 1) {
      belowBarPaint.color = data.belowBarData.colors[0];
      belowBarPaint.shader = null;
    } else {
      var from = data.belowBarData.from;
      var to = data.belowBarData.to;
      belowBarPaint.shader = ui.Gradient.linear(
        Offset(
          getLeftOffsetDrawSize() + (chartViewSize.width * from.dx),
          getTopOffsetDrawSize() + (chartViewSize.height * from.dy),
        ),
        Offset(
          getLeftOffsetDrawSize() + (chartViewSize.width * to.dx),
          getTopOffsetDrawSize() + (chartViewSize.height * to.dy),
        ),
        data.belowBarData.colors,
        data.belowBarData.colorStops,
      );
    }

    canvas.drawPath(barPath, belowBarPaint);
  }

  void drawBar(Canvas canvas, Size viewSize, Path barPath) {
    if (!data.barData.show) {
      return;
    }
    canvas.drawPath(barPath, barPaint);
  }

  void drawTitles(Canvas canvas, Size viewSize) {
    if (!data.titlesData.show) {
      return;
    }
    viewSize = getChartUsableDrawSize(viewSize);

    // Vertical Titles
    if (data.titlesData.showVerticalTitles) {
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
    }

    // Horizontal titles
    if (data.titlesData.showHorizontalTitles) {
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
  }

  Path _generateBarPath(Size viewSize) {
    viewSize = getChartUsableDrawSize(viewSize);
    Path path = Path();
    int size = data.spots.length;
    path.reset();

    double lX = 0.0, lY = 0.0;

    double x = getPixelX(data.spots[0].x, viewSize);
    double y = getPixelY(data.spots[0].y, viewSize);
    path.moveTo(x, y);
    for (int i = 1; i < size; i++) {
      // CurrentSpot
      AxisSpot p = data.spots[i];
      double px = getPixelX(p.x, viewSize);
      double py = getPixelY(p.y, viewSize);

      // previous spot
      AxisSpot p0 = data.spots[i - 1];
      double p0x = getPixelX(p0.x, viewSize);
      double p0y = getPixelY(p0.y, viewSize);

      double x1 = p0x + lX;
      double y1 = p0y + lY;

      // next point
      AxisSpot p1 = data.spots[i + 1 < size ? i + 1 : i];
      double p1x = getPixelX(p1.x, viewSize);
      double p1y = getPixelY(p1.y, viewSize);

      double smoothness = data.barData.isCurved ? data.barData.curveSmoothness : 0.0;
      lX = ((p1x - p0x) / 2) * smoothness;
      lY = ((p1y - p0y) / 2) * smoothness;
      double x2 = px - lX;
      double y2 = py - lY;

      path.cubicTo(x1, y1, x2, y2, px, py);
    }

    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
