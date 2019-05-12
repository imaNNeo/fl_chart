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
  void paint(Canvas canvas, Size size) {
    // QuadraticBazier
//    Path path = Path();
//    var point0 = Offset(0, size.height / 2);
//    var point1 = Offset(size.width / 2, size.height);
//    var point2 = Offset(size.width, size.height / 2);
//    path.moveTo(point0.dx, point0.dy);
//    path.quadraticBezierTo(point1.dx, point1.dy, point2.dx, point2.dy);
//    canvas.drawPath(path, chartPaint);
//    canvas.drawCircle(point0, dotSize, dotPaint);
//    canvas.drawCircle(point1, dotSize, dotPaint);
//    canvas.drawCircle(point2, dotSize, dotPaint);


    // Cubic
//    Path path = Path();
//    var point0 = Offset(0, size.height / 2);
//    var point1 = Offset(size.width / 4, 3 * size.height / 4);
//    var point2 = Offset(3 * size.width / 4, size.height / 4);
//    var point3 = Offset(size.width, size.height);
//    path.moveTo(point0.dx, point0.dy);
//    path.cubicTo(point1.dx, point1.dy, point2.dx, point2.dy, point3.dx, point3.dy);
//    canvas.drawPath(path, chartPaint);
//    canvas.drawCircle(point0, dotSize, dotPaint);
//    canvas.drawCircle(point1, dotSize, dotPaint);
//    canvas.drawCircle(point2, dotSize, dotPaint);
//    canvas.drawCircle(point3, dotSize, dotPaint);


    // Conic
//    Path path = Path();
//    var point0 = Offset(0, size.height / 2);
//    var point1 = Offset(size.width / 4, 3 * size.height / 4);
//    var point2 = Offset(size.width, size.height / 3);
//    var weight = 3.0;
//    path.moveTo(point0.dx, point0.dy);
//    path.conicTo(point1.dx, point1.dy, point2.dx, point2.dy, weight);
//    canvas.drawPath(path, chartPaint);
//    canvas.drawCircle(point0, dotSize, dotPaint);
//    canvas.drawCircle(point1, dotSize, dotPaint);
//    canvas.drawCircle(point2, dotSize, dotPaint);


//    Paint cellsPaint = Paint()
//      ..color = Colors.black
//      ..style = PaintingStyle.stroke
//      ..strokeWidth = 0.5;
//    double cellWidth = size.width / maxX;
//    double cellHeight = size.height / maxY;

    // Draw horizontal lines
//    for (int i = 0; i < maxY; i++) {
//      double height = i * cellHeight;
//      canvas.drawLine(Offset(0, height), Offset(size.width, height), cellsPaint);
//    }
//
//    // Draw vertical lines
//    for (int i = 0; i < maxX; i++) {
//      double width = i * cellWidth;
//      canvas.drawLine(Offset(width, 0), Offset(width, size.height), cellsPaint);
//    }

    bars.forEach((_DrawingBar bar) {
      // Draw chart lines
      Path path = Path();
      double x = padding.left + (bar.spots[0].x / bar.maxX) * usableWidth(size);
      double y = padding.top + (bar.spots[0].y / bar.maxY) * usableHeight(size);
      path.moveTo(x, y);
      bar.spots.asMap().forEach((pos, spot) {
        if (pos != 0) {
          double x = padding.left + (spot.x / bar.maxX) * usableWidth(size);
          double y = padding.top + (spot.y / bar.maxY) * usableHeight(size);
          path.lineTo(x, y);
        }
      });
      chartPaint.color = bar.barColor;
      canvas.drawPath(path, chartPaint);

      // Draw dots
      if (bar.showDots) {
        dotPaint.color = bar.dotColor;
        bar.spots.forEach((spot) {
          double x = padding.left + (spot.x / bar.maxX) * usableWidth(size);
          double y = padding.top + (spot.y / bar.maxY) * usableHeight(size);
          canvas.drawCircle(Offset(x, y), dotSize, dotPaint);
        });
      }
    });

    // Draw Borders
    Paint p = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;
    canvas.drawRect(Rect.fromLTWH(padding.left, padding.top, usableWidth(size), usableHeight(size)), p);

    p.color = Colors.red;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), p);
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