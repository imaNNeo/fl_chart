library flutter_smooth_chart;
import 'package:flutter/material.dart';
import 'package:flutter_smooth_chart/entity/bar.dart';

import 'entity/spot.dart';

class SmoothChart extends StatefulWidget {

  final EdgeInsets padding;

  final List<Bar> bars;

  SmoothChart(this.bars, {Key key, this.padding = EdgeInsets.zero,}) : super(key: key) {
    if (bars == null) {
      throw Exception("bars might not be null");
    }
  }

  @override
  State<StatefulWidget> createState() => _SmoothChartState();

}

class _SmoothChartState extends State<SmoothChart> {

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SmoothChartPainter(widget.padding, convertToDrawingBars(widget.bars)),
    );
  }

  List<_DrawingBar> convertToDrawingBars(List<Bar> bars) {
    return bars.map((Bar bar) {
      // Find the largest x
      double maxX = bar.spots[0].x;
      bar.spots.forEach((spot) {
        if (spot.x > maxX) {
          maxX = spot.x;
        }
      });

      // Find the largest y
      double maxY = bar.spots[0].y;
      bar.spots.forEach((spot) {
        if (spot.y > maxY) {
          maxY = spot.y;
        }
      });

      // Reverse vertical y axis to work with mobile coordinates (top left is zero)
      List<Spot> newSpots = bar.spots.map((spot) {
        return Spot(spot.x, maxY - spot.y);
      }).toList();

      return _DrawingBar(newSpots, maxX, maxY, bar.barColor, bar.dotColor, bar.showDots);
    }).toList();
  }

}

class _SmoothChartPainter extends CustomPainter {

  final double SMOOTHNESS = 0.35;

  final EdgeInsets padding;
  final List<_DrawingBar> bars;

  Paint chartPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4.0;

  Paint dotPaint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.fill;
  double dotSize = 4;

  _SmoothChartPainter(this.padding, this.bars,);

  @override
  void paint(Canvas canvas, Size viewSize) {
    bars.forEach((_DrawingBar bar) {

      double getX(Spot spot) {
        return padding.left + (spot.x / bar.maxX) * usableWidth(viewSize);
      }

      double getY(Spot spot) {
        return padding.top + (spot.y / bar.maxY) * usableHeight(viewSize);
      }

      Path path = Path();
      int mMinY = 0;

      int size = bar.spots.length;

      path.reset();
      double lX = 0.0, lY = 0.0;

      double x = getX(bar.spots[0]);
      double y = getY(bar.spots[0]);
      path.moveTo(x, y);
      for (int i=1; i<size; i++) {
        Spot p = bar.spots[i];
        double px = getX(p);
        double py = getY(p);

        // first spot
        Spot p0 = bar.spots[i-1];	// previous spot
        double p0x = getX(p0);
        double p0y = getY(p0);

        double x1 = p0x + lX;
        double y1 = p0y + lY;

        // second spot
        Spot p1 = bar.spots[i + 1 < size ? i + 1 : i]; // next point
        double p1x = getX(p1);
        double p1y = getY(p1);

        lX = ((p1x - p0x) / 2) * SMOOTHNESS; // (lX,lY) is the slope of the reference line
        lY = ((p1y - p0y) / 2) * SMOOTHNESS;
        double x2 = px - lX;
        double y2 = py - lY;

        path.cubicTo(x1, y1, x2, y2, px, py);
      }
      chartPaint.color = bar.barColor;

      canvas.drawPath(path, chartPaint);

      // Draw dots
      if (bar.showDots) {
        dotPaint.color = bar.dotColor;
        bar.spots.forEach((spot) {
          double x = padding.left + (spot.x / bar.maxX) * usableWidth(viewSize);
          double y = padding.top + (spot.y / bar.maxY) * usableHeight(viewSize);
          canvas.drawCircle(Offset(x, y), dotSize, dotPaint);
        });
      }
    });

    // Draw Borders
    Paint p = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;
    canvas.drawRect(Rect.fromLTWH(padding.left, padding.top, usableWidth(viewSize), usableHeight(viewSize)), p);

    p.color = Colors.red;
    canvas.drawRect(Rect.fromLTWH(0, 0, viewSize.width, viewSize.height), p);
  }

  double usableWidth(Size size) {
    return size.width - padding.horizontal;
  }

  double usableHeight(Size size) {
    return size.height - padding.vertical;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

}

class _DrawingBar {
  final List<Spot> spots;
  final double maxX;
  final double maxY;
  final Color barColor;
  final Color dotColor;
  final bool showDots;

  _DrawingBar(this.spots, this.maxX, this.maxY, this.barColor, this.dotColor, this.showDots);
}