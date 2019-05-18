//import 'dart:ui' as ui;
//
//import 'package:fl_chart/chart/bar_chart/bar_chart_data.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//
//import 'package:fl_chart/chart/base/fl_chart/fl_chart_painter.dart';
//
//class BarChartPainter extends FlChartPainter {
//  final BarChartData data;
//
//  Paint barPaint;
//
//  BarChartPainter(
//    this.data,
//    ) : super() {
//    barPaint = Paint()
//      ..color = Colors.red
//      ..style = PaintingStyle.fill
//      ..strokeWidth = 10;
//  }
//
//  @override
//  void paint(Canvas canvas, Size viewSize) {
//    if (data.groups.length == 0) {
//      return;
//    }
//    super.paint(canvas, viewSize);
//
//    Path barPath = _generateBarPath(viewSize);
//    _drawBelowBar(canvas, viewSize, Path.from(barPath));
//    _drawBar(canvas, viewSize, Path.from(barPath));
//    _drawDots(canvas, viewSize);
//    _drawViewBorder(canvas, viewSize);
//  }
//
//  void _drawGrid(Canvas canvas, Size viewSize) {
//    if (!data.showGridLines || data.gridData == null) {
//      return;
//    }
//    viewSize = _getChartUsableDrawSize(viewSize);
//    // Show Vertical Grid
//    if (data.gridData.drawVerticalGrid) {
//      int verticalCounter = 1;
//      gridPaint.color = data.gridData.verticalGridColor;
//      gridPaint.strokeWidth = data.gridData.verticalGridLineWidth;
//      while (data.gridData.verticalInterval * verticalCounter < data.maxY) {
//        var currentIntervalSeek = data.gridData.verticalInterval * verticalCounter;
//        if (data.gridData.checkToShowVerticalGrid(currentIntervalSeek)) {
//          double sameY = _getPixelY(currentIntervalSeek, viewSize);
//          double x1 = 0 + _getLeftOffsetDrawSize();
//          double y1 = sameY + _getTopOffsetDrawSize();
//          double x2 = viewSize.width + _getLeftOffsetDrawSize();
//          double y2 = sameY + _getTopOffsetDrawSize();
//          canvas.drawLine(
//            Offset(x1, y1),
//            Offset(x2, y2),
//            gridPaint,
//          );
//        }
//        verticalCounter++;
//      }
//    }
//
//    // Show Horizontal Grid
//    if (data.gridData.drawHorizontalGrid) {
//      int horizontalCounter = 1;
//      gridPaint.color = data.gridData.horizontalGridColor;
//      gridPaint.strokeWidth = data.gridData.horizontalGridLineWidth;
//      while (data.gridData.horizontalInterval * horizontalCounter < data.maxX) {
//        var currentIntervalSeek = data.gridData.horizontalInterval * horizontalCounter;
//        if (data.gridData.checkToShowHorizontalGrid(currentIntervalSeek)) {
//          double sameX = _getPixelX(currentIntervalSeek, viewSize);
//          double x1 = sameX;
//          double y1 = 0 + _getTopOffsetDrawSize();
//          double x2 = sameX;
//          double y2 = viewSize.height + _getTopOffsetDrawSize();
//          canvas.drawLine(
//            Offset(x1, y1),
//            Offset(x2, y2),
//            gridPaint,
//          );
//        }
//        horizontalCounter++;
//      }
//    }
//  }
//
//  void _drawTitles(Canvas canvas, Size viewSize) {
//    if (!data.showTitles) {
//      return;
//    }
//    viewSize = _getChartUsableDrawSize(viewSize);
//
//    // Vertical Titles
//    int verticalCounter = 0;
//    while (data.gridData.verticalInterval * verticalCounter <= data.maxY) {
//      double x = 0 + _getLeftOffsetDrawSize();
//      double y = _getPixelY(data.gridData.verticalInterval * verticalCounter, viewSize) +
//        _getTopOffsetDrawSize();
//
//      String text =
//      data.titlesData.getVerticalTitle(data.gridData.verticalInterval * verticalCounter);
//
//      TextSpan span = new TextSpan(style: data.titlesData.verticalTitlesTextStyle, text: text);
//      TextPainter tp = new TextPainter(
//        text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
//      tp.layout(maxWidth: _getExtraNeededHorizontalSpace());
//      x -= tp.width + data.titlesData.verticalTitleMargin;
//      y -= (tp.height / 2);
//      tp.paint(canvas, new Offset(x, y));
//
//      verticalCounter++;
//    }
//
//    // Horizontal titles
//    int horizontalCounter = 0;
//    while (data.gridData.horizontalInterval * horizontalCounter <= data.maxX) {
//      double x = _getPixelX(data.gridData.horizontalInterval * horizontalCounter, viewSize);
//      double y = viewSize.height + _getTopOffsetDrawSize();
//
//      String text =
//      data.titlesData.getHorizontalTitle(data.gridData.horizontalInterval * horizontalCounter);
//
//      TextSpan span = new TextSpan(style: data.titlesData.horizontalTitlesTextStyle, text: text);
//      TextPainter tp = new TextPainter(
//        text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
//      tp.layout();
//
//      x -= (tp.width / 2);
//      y += data.titlesData.horizontalTitleMargin;
//
//      tp.paint(canvas, Offset(x, y));
//
//      horizontalCounter++;
//    }
//  }
//
//  /*
//  barPath Ends in Top Right
//   */
//  void _drawBelowBar(Canvas canvas, Size viewSize, Path barPath) {
//    if (!data.showBelowBar) {
//      return;
//    }
//
//    Size chartViewSize = _getChartUsableDrawSize(viewSize);
//
//    // Line To Bottom Right
//    double x = _getPixelX(data.spots[data.spots.length - 1].x, chartViewSize);
//    double y = chartViewSize.height - _getTopOffsetDrawSize();
//    barPath.lineTo(x, y);
//
//    // Line To Bottom Left
//    x = _getPixelX(data.spots[0].x, chartViewSize);
//    y = chartViewSize.height - _getTopOffsetDrawSize();
//    barPath.lineTo(x, y);
//
//    // Line To Top Left
//    x = _getPixelX(data.spots[0].x, chartViewSize);
//    y = _getPixelY(data.spots[0].y, chartViewSize);
//    barPath.lineTo(x, y);
//    barPath.close();
//
//    if (data.belowBarData.colors.length == 1) {
//      belowBarPaint.color = data.belowBarData.colors[0];
//      belowBarPaint.shader = null;
//    } else {
//      var from = data.belowBarData.from;
//      var to = data.belowBarData.to;
//      belowBarPaint.shader = ui.Gradient.linear(
//        Offset(
//          _getLeftOffsetDrawSize() + (chartViewSize.width * from.dx),
//          _getTopOffsetDrawSize() + (chartViewSize.height * from.dy),
//        ),
//        Offset(
//          _getLeftOffsetDrawSize() + (chartViewSize.width * to.dx),
//          _getTopOffsetDrawSize() + (chartViewSize.height * to.dy),
//        ),
//        data.belowBarData.colors,
//        data.belowBarData.colorStops,
//      );
//    }
//
//    canvas.drawPath(barPath, belowBarPaint);
//  }
//
//  void _drawBar(Canvas canvas, Size viewSize, Path barPath) {
//    if (!data.showBar) {
//      return;
//    }
//    canvas.drawPath(barPath, barPaint);
//  }
//
//  void _drawDots(Canvas canvas, Size viewSize) {
//    if (!data.showDots) {
//      return;
//    }
//    viewSize = _getChartUsableDrawSize(viewSize);
//    data.spots.forEach((spot) {
//      if (data.dotData.checkToShowDot(spot)) {
//        double x = _getPixelX(spot.x, viewSize);
//        double y = _getPixelY(spot.y, viewSize);
//        canvas.drawCircle(Offset(x, y), dotSize, dotPaint);
//      }
//    });
//  }
//
//  void _drawViewBorder(Canvas canvas, Size viewSize) {
//    if (!data.showBorder) {
//      return;
//    }
//
//    var chartViewSize = _getChartUsableDrawSize(viewSize);
//
//    borderPaint.color = data.borderData.borderColor;
//    borderPaint.strokeWidth = data.borderData.borderWidth;
//
//    canvas.drawRect(
//      Rect.fromLTWH(
//        0 + _getLeftOffsetDrawSize(),
//        0 + _getTopOffsetDrawSize(),
//        chartViewSize.width,
//        chartViewSize.height,
//      ),
//      borderPaint);
//  }
//
//  Path _generateBarPath(Size viewSize) {
//    viewSize = _getChartUsableDrawSize(viewSize);
//    Path path = Path();
//    int size = data.spots.length;
//    path.reset();
//
//    double lX = 0.0, lY = 0.0;
//
//    double x = _getPixelX(data.spots[0].x, viewSize);
//    double y = _getPixelY(data.spots[0].y, viewSize);
//    path.moveTo(x, y);
//    for (int i = 1; i < size; i++) {
//      // CurrentSpot
//      LineChartSpot p = data.spots[i];
//      double px = _getPixelX(p.x, viewSize);
//      double py = _getPixelY(p.y, viewSize);
//
//      // previous spot
//      LineChartSpot p0 = data.spots[i - 1];
//      double p0x = _getPixelX(p0.x, viewSize);
//      double p0y = _getPixelY(p0.y, viewSize);
//
//      double x1 = p0x + lX;
//      double y1 = p0y + lY;
//
//      // next point
//      LineChartSpot p1 = data.spots[i + 1 < size ? i + 1 : i];
//      double p1x = _getPixelX(p1.x, viewSize);
//      double p1y = _getPixelY(p1.y, viewSize);
//
//      double smoothness = data.barData.isCurved ? data.barData.curveSmoothness : 0.0;
//      lX = ((p1x - p0x) / 2) * smoothness;
//      lY = ((p1y - p0y) / 2) * smoothness;
//      double x2 = px - lX;
//      double y2 = py - lY;
//
//      path.cubicTo(x1, y1, x2, y2, px, py);
//    }
//
//    return path;
//  }
//
//  double _getPixelX(double spotX, Size viewSize) {
//    return ((spotX / data.maxX) * viewSize.width) + _getLeftOffsetDrawSize();
//  }
//
//  double _getPixelY(
//    double spotY,
//    Size viewSize,
//    ) {
//    double y = data.maxY - spotY;
//    return ((y / data.maxY) * viewSize.height) + _getTopOffsetDrawSize();
//  }
//
//  Size _getChartUsableDrawSize(Size viewSize) {
//    double usableWidth = viewSize.width - _getExtraNeededHorizontalSpace();
//    double usableHeight = viewSize.height - _getExtraNeededVerticalSpace();
//    return Size(usableWidth, usableHeight);
//  }
//
//  double _getExtraNeededHorizontalSpace() {
//    if (data.showTitles) {
//      return data.titlesData.verticalTitlesReservedWidth + data.titlesData.verticalTitleMargin;
//    }
//    return 0;
//  }
//
//  double _getExtraNeededVerticalSpace() {
//    if (data.showTitles) {
//      return data.titlesData.horizontalTitlesReservedHeight + data.titlesData.horizontalTitleMargin;
//    }
//    return 0;
//  }
//
//  double _getLeftOffsetDrawSize() {
//    if (data.showTitles) {
//      return data.titlesData.verticalTitlesReservedWidth + data.titlesData.verticalTitleMargin;
//    }
//    return 0;
//  }
//
//  double _getTopOffsetDrawSize() {
//    return 0;
//  }
//
//  @override
//  bool shouldRepaint(CustomPainter oldDelegate) => false;
//}
