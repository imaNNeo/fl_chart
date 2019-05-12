library flutter_smooth_chart;
import 'package:flutter/material.dart';

class SmoothChart extends StatefulWidget {

  final EdgeInsets padding;

  const SmoothChart({Key key, this.padding = EdgeInsets.zero}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SmoothChartState();

}

class _SmoothChartState extends State<SmoothChart> {

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SmoothChartPainter(widget.padding),
    );
  }

}

class _SmoothChartPainter extends CustomPainter {

  final EdgeInsets padding;

  List<List<double>> data;

  double maxX;
  double maxY;

  _SmoothChartPainter(this.padding) {
    data = [
      [0, 0],
      [1, 2],
      [2, 1],
      [3, 4],
      [4, 5],
      [5, 1.5],
      [6, 8]
    ];

    maxX = data[0][0];
    maxY = data[0][1];
    data.forEach((s) {
      if (s[0] > maxX) {
        maxX = s[0];
      }

      if (s[1] > maxY) {
        maxY = s[1];
      }
    });

    data = data.map((point) {
      return List.of([point[0], maxY - point[1]]);
    }).toList();
  }


  @override
  void paint(Canvas canvas, Size size) {
    Paint chartPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    Paint dotPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    double dotSize = 4;



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


    Paint cellsPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    double cellWidth = size.width / maxX;
    double cellHeight = size.height / maxY;

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

    // Draw chart lines
    Path path = Path();
    double x = padding.left + (data[0][0] / maxX) * usableWidth(size);
    double y = padding.top + (data[0][1] / maxY) * usableHeight(size);
    path.moveTo(x, y);
    data.asMap().forEach((pos, point) {
      if (pos != 0) {
        double x = padding.left + (point[0] / maxX) * usableWidth(size);
        double y = padding.top + (point[1] / maxY) * usableHeight(size);
        path.lineTo(x, y);
      }
    });
    canvas.drawPath(path, chartPaint);

    // Draw dots
    data.forEach((point) {
      double x = padding.left + (point[0] / maxX) * usableWidth(size);
      double y = padding.top + (point[1] / maxY) * usableHeight(size);
      canvas.drawCircle(Offset(x, y), dotSize, dotPaint);
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