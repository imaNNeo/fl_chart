import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'line_chart_data.dart';

class LineChartPainter extends CustomPainter {

  final LineChartData data;

  Paint barPaint, dotPaint, gridPaint;
  double dotSize;

  LineChartPainter(this.data,) {
    barPaint = Paint()
      ..color = data.barColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = data.barWidth;

    dotPaint = Paint()
      ..color = data.dotColor
      ..style = PaintingStyle.fill;

    gridPaint = new Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.5;

    dotSize = data.dotSize;
  }

  @override
  void paint(Canvas canvas, Size viewSize) {
    if (data.spots.length == 0) {
      return;
    }
    drawBackgroundGrid(canvas, viewSize);
    drawLineChart(canvas, viewSize);
    drawDots(canvas, viewSize);
    drawViewBorder(canvas, viewSize);
  }

  void drawBackgroundGrid(Canvas canvas, Size viewSize) {
    if (data.showGridLines && data.gridData != null) {
      // Show Vertical Grid
      if (data.gridData.drawVerticalGrid) {
        int verticalCounter = 0;
        gridPaint.color = data.gridData.verticalGridColor;
        gridPaint.strokeWidth = data.gridData.verticalGridLineWidth;
        while (data.gridData.verticalInterval * verticalCounter <= data.maxY) {
          double sameY = getPixelY(data.gridData.verticalInterval * verticalCounter, viewSize);
          double x1 = 0;
          double y1 = sameY;
          double x2 = viewSize.width;
          double y2 = sameY;
          canvas.drawLine(
            Offset(x1, y1),
            Offset(x2, y2),
            gridPaint,
          );
          verticalCounter++;
        }
      }

      // Show Horizontal Grid
      if (data.gridData.drawHorizontalGrid) {
        int horizontalCounter = 0;
        gridPaint.color = data.gridData.horizontalGridColor;
        gridPaint.strokeWidth = data.gridData.horizontalGridLineWidth;
        while (data.gridData.horizontalInterval * horizontalCounter <= data.maxX) {
          double sameX = getPixelX(data.gridData.horizontalInterval * horizontalCounter, viewSize);
          double x1 = sameX;
          double y1 = 0;
          double x2 = sameX;
          double y2 = viewSize.height;
          canvas.drawLine(
            Offset(x1, y1),
            Offset(x2, y2),
            gridPaint,
          );
          horizontalCounter++;
        }
      }
    }
  }

  void drawLineChart(Canvas canvas, Size viewSize) {
    Path path = Path();
    int size = data.spots.length;
    path.reset();

    double lX = 0.0, lY = 0.0;

    double x = getPixelX(data.spots[0].x, viewSize);
    double y = getPixelY(data.spots[0].y, viewSize);
    path.moveTo(x, y);
    for (int i = 1; i < size; i++) {
      // CurrentSpot
      LineChartSpot p = data.spots[i];
      double px = getPixelX(p.x, viewSize);
      double py = getPixelY(p.y, viewSize);

      // previous spot
      LineChartSpot p0 = data.spots[i - 1];
      double p0x = getPixelX(p0.x, viewSize);
      double p0y = getPixelY(p0.y, viewSize);

      double x1 = p0x + lX;
      double y1 = p0y + lY;

      // next point
      LineChartSpot p1 = data.spots[i + 1 < size ? i + 1 : i];
      double p1x = getPixelX(p1.x, viewSize);
      double p1y = getPixelY(p1.y, viewSize);

      double smoothness = data.isCurved ? data.curveSmoothness : 0.0;
      lX = ((p1x - p0x) / 2) * smoothness;
      lY = ((p1y - p0y) / 2) * smoothness;
      double x2 = px - lX;
      double y2 = py - lY;

      path.cubicTo(x1, y1, x2, y2, px, py);
    }
    canvas.drawPath(path, barPaint);
  }

  void drawDots(Canvas canvas, Size viewSize) {
    if (data.showDots) {
      data.spots.forEach((spot) {
        double x = getPixelX(spot.x, viewSize);
        double y = getPixelY(spot.y, viewSize);
        canvas.drawCircle(Offset(x, y), dotSize, dotPaint);
      });
    }
  }

  void drawViewBorder(Canvas canvas, Size viewSize) {
    Paint p = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRect(Rect.fromLTWH(0, 0, viewSize.width, viewSize.height), p);
  }

  double getPixelX(double spotX, Size viewSize) {
    return (spotX / data.maxX) * viewSize.width;
  }

  double getPixelY(double spotY, Size viewSize,) {
    double y = data.maxY - spotY;
    return (y / data.maxY) * viewSize.height;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

}