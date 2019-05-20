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

    List<double> barsX = calculateBarsX(viewSize, data.barSpots, data.alignment);
    drawBars(canvas, viewSize, barsX);
    drawTitles(canvas, viewSize, barsX);
  }

  List<double> calculateBarsX(Size viewSize,
    List<BarChartRodData> spots, BarChartAlignment alignment) {
    Size drawSize = getChartUsableDrawSize(viewSize);

    List<double> barsX = List(spots.length);

    double leftTextsSpace = getLeftOffsetDrawSize();

    switch (alignment) {
      case BarChartAlignment.start:
        double tempX = 0;
        spots.asMap().forEach((i, spot) {
          barsX[i] = leftTextsSpace + tempX + spot.width / 2;
          tempX += spot.width;
        });
        break;

      case BarChartAlignment.end:
        double tempX = 0;
        for (int i = spots.length - 1; i >= 0; i--) {
          var spot = spots[i];
          barsX[i] = (leftTextsSpace + drawSize.width) - tempX - spot.width / 2;
          tempX += spot.width;
        }
        break;

      case BarChartAlignment.center:
        double linesSumWidth = 0;
        spots.forEach((spot) {
          linesSumWidth += spot.width;
        });

        double horizontalMargin = (drawSize.width - linesSumWidth) / 2;

        double tempX = 0;
        for (int i = 0; i < spots.length; i++) {
          var spot = spots[i];
          barsX[i] = leftTextsSpace + horizontalMargin + tempX + spot.width / 2;
          tempX += spot.width;
        }
        break;

      case BarChartAlignment.spaceBetween:
        double sumWidth = 0;
        spots.forEach((spot) {
          sumWidth += spot.width;
        });
        double spaceAvailable = drawSize.width - sumWidth;
        double eachSpace = spaceAvailable / (spots.length - 1);

        double tempX = 0;
        spots.asMap().forEach((index, spot) {
          tempX += (spot.width / 2);
          if (index != 0) {
            tempX += eachSpace;
          }
          barsX[index] = leftTextsSpace + tempX;
          tempX += (spot.width / 2);
        });
        break;

      case BarChartAlignment.spaceAround:
        double sumWidth = 0;
        spots.forEach((spot) {
          sumWidth += spot.width;
        });
        double spaceAvailable = drawSize.width - sumWidth;
        double eachSpace = spaceAvailable / (spots.length * 2);

        double tempX = 0;
        spots.asMap().forEach((i, spot) {
          var spot = spots[i];
          tempX += eachSpace;
          tempX += spot.width / 2;
          barsX[i] = leftTextsSpace + tempX;
          tempX += spot.width / 2;
          tempX += eachSpace;
        });
        break;
      case BarChartAlignment.spaceEvenly:
        double sumWidth = 0;
        spots.forEach((spot) {
          sumWidth += spot.width;
        });
        double spaceAvailable = drawSize.width - sumWidth;
        double eachSpace = spaceAvailable / (spots.length + 1);

        double tempX = 0;
        spots.asMap().forEach((i, spot) {
          tempX += eachSpace;
          tempX += spot.width / 2;
          barsX[i] = leftTextsSpace + tempX;
          tempX += spot.width / 2;
        });
        break;
    }

    return barsX;
  }

  void drawBars(Canvas canvas, Size viewSize, List<double> barsX) {
    Size drawSize = getChartUsableDrawSize(viewSize);

    data.barSpots.asMap().forEach((int index, BarChartRodData barData) {
      double barWidth = barData.width;

      double fromY = getPixelY(0, drawSize);
      double toY = getPixelY(barData.y, drawSize);

      while ((fromY - toY).abs() < barWidth) {
        barWidth -= barWidth * 0.1;
      }

      Offset from = Offset(
        barsX[index],
        fromY - (barWidth / 2),
      );


      Offset to = Offset(
        barsX[index],
        toY + (barWidth / 2),
      );

      barPaint.color = barData.color;
      barPaint.strokeWidth = barWidth;
      canvas.drawLine(from, to, barPaint);
    });
  }

  void drawTitles(Canvas canvas, Size viewSize, List<double> barsX) {
    if (!data.titlesData.show) {
      return;
    }
    Size drawSize = getChartUsableDrawSize(viewSize);

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
    barsX.asMap().forEach((int index, double x) {
      String text = data.titlesData.getHorizontalTitle(index.toDouble());

      TextSpan span = new TextSpan(style: data.titlesData.horizontalTitlesTextStyle, text: text);
      TextPainter tp = new TextPainter(
        text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      tp.layout();

      double textX = x - (tp.width / 2);
      double textY = drawSize.height + getTopOffsetDrawSize() + data.titlesData.horizontalTitleMargin;

      tp.paint(canvas, Offset(textX, textY));
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
