import 'package:fl_chart/chart/bar_chart/bar_chart_data.dart';
import 'package:fl_chart/chart/base/fl_axis_chart/fl_axis_chart_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BarChartPainter extends FlAxisChartPainter {
  final BarChartData data;

  Paint barPaint;

  BarChartPainter(
    this.data,
    ) : super(data) {
    barPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;
  }

  @override
  void paint(Canvas canvas, Size viewSize) {
    if (data.spots.length == 0) {
      return;
    }
    super.paint(canvas, viewSize);

    EdgeInsets chartInsidePadding = EdgeInsets.all(data.barSpots[0].width / 2);

    drawBars(canvas, viewSize, chartInsidePadding);
    drawTitles(canvas, viewSize, chartInsidePadding);
  }

  void drawBars(Canvas canvas, Size viewSize, EdgeInsets chartInsidePadding) {
    Size drawSize = getChartUsableDrawSize(viewSize);
    drawSize = Size(drawSize.width - chartInsidePadding.horizontal, drawSize.height - chartInsidePadding.vertical);
    data.barSpots.forEach((BarChartRodData barData) {
      Offset from = Offset(
        chartInsidePadding.left + getPixelX(barData.x, drawSize),
        chartInsidePadding.top + getPixelY(0, drawSize),
      );

      Offset to = Offset(
        chartInsidePadding.left + getPixelX(barData.x, drawSize),
        chartInsidePadding.top + getPixelY(barData.y, drawSize),
      );

      barPaint.color = barData.color;
      barPaint.strokeWidth = barData.width;
      canvas.drawLine(from, to, barPaint);
    });
  }

  void drawTitles(Canvas canvas, Size viewSize, EdgeInsets chartInsidePadding) {
    if (!data.titlesData.show) {
      return;
    }
    Size drawSize = getChartUsableDrawSize(viewSize);
    drawSize = Size(drawSize.width - chartInsidePadding.horizontal, drawSize.height);

    // Vertical Titles
    if (data.titlesData.showVerticalTitles) {
      int verticalCounter = 0;
      while (data.gridData.verticalInterval * verticalCounter <= data.maxY) {
        double x = 0 + getLeftOffsetDrawSize();
        double y = getPixelY(data.gridData.verticalInterval * verticalCounter, drawSize) +
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
        double x = chartInsidePadding.left + getPixelX(data.gridData.horizontalInterval * horizontalCounter, drawSize);
        double y = drawSize.height + getTopOffsetDrawSize();

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

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
