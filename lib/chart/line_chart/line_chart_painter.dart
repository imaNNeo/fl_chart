import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'line_chart_data.dart';

class LineChartPainter extends CustomPainter {

  final LineChartData data;

  Paint barPaint;
  Paint dotPaint;
  double dotSize;

  LineChartPainter(this.data,) {
    barPaint = Paint()
      ..color = data.barColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = data.barWidth;

    dotPaint = Paint()
      ..color = data.dotColor
      ..style = PaintingStyle.fill;

    dotSize = data.dotSize;
  }

  @override
  void paint(Canvas canvas, Size viewSize) {
    if (data.spots.length == 0) {
      return;
    }

    double getX(LineChartSpot spot,) {
      return (spot.x / data.maxX) * viewSize.width;
    }

    double getY(LineChartSpot spot,) {
      double y = data.maxY - spot.y;
      return (y / data.maxY) * viewSize.height;
    }

    Path path = Path();
    int size = data.spots.length;
    path.reset();

    double lX = 0.0, lY = 0.0;

    double x = getX(data.spots[0]);
    double y = getY(data.spots[0]);
    path.moveTo(x, y);
    for (int i = 1; i < size; i++) {
      // CurrentSpot
      LineChartSpot p = data.spots[i];
      double px = getX(p);
      double py = getY(p);

      // previous spot
      LineChartSpot p0 = data.spots[i - 1];
      double p0x = getX(p0);
      double p0y = getY(p0);

      double x1 = p0x + lX;
      double y1 = p0y + lY;

      // next point
      LineChartSpot p1 = data.spots[i + 1 < size ? i + 1 : i];
      double p1x = getX(p1);
      double p1y = getY(p1);

      double smoothness = data.isCurved ? data.curveSmoothness : 0.0;
      lX = ((p1x - p0x) / 2) * smoothness;
      lY = ((p1y - p0y) / 2) * smoothness;
      double x2 = px - lX;
      double y2 = py - lY;

      path.cubicTo(x1, y1, x2, y2, px, py);
    }
    canvas.drawPath(path, barPaint);

    // Draw dots
    if (data.showDots) {
      data.spots.forEach((spot) {
        double x = getX(spot);
        double y = getY(spot);
        canvas.drawCircle(Offset(x, y), dotSize, dotPaint);
      });
    }

    // Draw Borders
    Paint p = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRect(Rect.fromLTWH(0, 0, viewSize.width, viewSize.height), p);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

}