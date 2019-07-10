import 'dart:async';

import 'package:fl_chart/src/chart/bar_chart/bar_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_painter.dart';
import 'package:flutter/material.dart';

import 'axis_chart_data.dart';

/// This class is responsible to draw the grid behind all axis base charts.
/// also we have two useful function [getPixelX] and [getPixelY] that used
/// in child classes -> [BarChartPainter], [LineChartPainter]
abstract class AxisChartPainter<D extends AxisChartData> extends BaseChartPainter<D> {
  final D data;

  Paint gridPaint, backgroundPaint, bgTouchTooltipPaint;

  AxisChartPainter(this.data, {FlTouchInputNotifier touchInputNotifier, StreamSink<BaseTouchResponse> touchedResponseSink}) :
      super(data, touchInputNotifier: touchInputNotifier, touchedResponseSink: touchedResponseSink) {
    gridPaint = Paint()..style = PaintingStyle.fill;

    backgroundPaint = Paint()..style = PaintingStyle.fill;

    bgTouchTooltipPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;
  }

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    drawBackground(canvas, size);
    drawGrid(canvas, size);
  }

  void drawGrid(Canvas canvas, Size viewSize) {
    if (!data.gridData.show || data.gridData == null) {
      return;
    }
    final Size usableViewSize = getChartUsableDrawSize(viewSize);
    // Show Vertical Grid
    if (data.gridData.drawVerticalGrid) {

      double verticalSeek = data.minY;
      while (verticalSeek < data.maxY) {
        if (data.gridData.checkToShowVerticalGrid(verticalSeek)) {

          final FlLine flLineStyle = data.gridData.getDrawingVerticalGridLine(verticalSeek);
          gridPaint.color = flLineStyle.color;
          gridPaint.strokeWidth = flLineStyle.strokeWidth;

          final double bothY = getPixelY(verticalSeek, usableViewSize);
          final double x1 = 0 + getLeftOffsetDrawSize();
          final double y1 = bothY + getTopOffsetDrawSize();
          final double x2 = usableViewSize.width + getLeftOffsetDrawSize();
          final double y2 = bothY + getTopOffsetDrawSize();
          canvas.drawLine(
            Offset(x1, y1),
            Offset(x2, y2),
            gridPaint,
          );
        }
        verticalSeek += data.gridData.verticalInterval;
      }
    }

    // Show Horizontal Grid
    if (data.gridData.drawHorizontalGrid) {

      double horizontalSeek = data.minX;
      while (horizontalSeek < data.maxX) {
        if (data.gridData.checkToShowHorizontalGrid(horizontalSeek)) {

          final FlLine flLine = data.gridData.getDrawingHorizontalGridLine(horizontalSeek);
          gridPaint.color = flLine.color;
          gridPaint.strokeWidth = flLine.strokeWidth;

          final double bothX = getPixelX(horizontalSeek, usableViewSize);
          final double x1 = bothX;
          final double y1 = 0 + getTopOffsetDrawSize();
          final double x2 = bothX;
          final double y2 = usableViewSize.height + getTopOffsetDrawSize();
          canvas.drawLine(
            Offset(x1, y1),
            Offset(x2, y2),
            gridPaint,
          );
        }

        horizontalSeek += data.gridData.horizontalInterval;
      }
    }
  }

  /// This function draws a colored background behind the chart.
  void drawBackground(Canvas canvas, Size viewSize) {
    if (data.backgroundColor == null) {
      return;
    }

    final Size usableViewSize = getChartUsableDrawSize(viewSize);
    backgroundPaint.color = data.backgroundColor;
    canvas.drawRect(
      Rect.fromLTWH(
        getLeftOffsetDrawSize(),
        getTopOffsetDrawSize(),
        usableViewSize.width,
        usableViewSize.height,
      ),
      backgroundPaint,
    );
  }

  void drawTouchTooltip(Canvas canvas, Size viewSize, TouchTooltipData tooltipData, List<TouchedSpot> touchedSpots) {
    
    if (touchInputNotifier.value is FlLongPressEnd) {
      return;
    }

    const double textsBelowMargin = 4;

    /// creating TextPainters to calculate the width and height of the tooltip
    final List<TextPainter> drawingTextPainters = [];

    final List<TooltipItem> tooltipItems = tooltipData.getTooltipItems(touchedSpots);
    if (tooltipItems.length != touchedSpots.length) {
      throw Exception('tooltipItems and touchedSpots size should be same');
    }

    for (int i = 0; i < touchedSpots.length; i++) {
      final TooltipItem tooltipItem = tooltipItems[i];
      if (tooltipItem == null) {
        continue;
      }

      final TextSpan span = TextSpan(style: tooltipItem.textStyle, text: tooltipItem.text);
      final TextPainter tp = TextPainter(
        text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      tp.layout(maxWidth: tooltipData.maxContentWidth);
      drawingTextPainters.add(tp);
    }
    if (drawingTextPainters.isEmpty) {
      return;
    }

    /// biggerWidth
    /// some texts maybe larger, then we should
    /// draw the tooltip' width as wide as biggerWidth
    ///
    /// sumTextsHeight
    /// sum up all Texts height, then we should
    /// draw the tooltip's height as tall as sumTextsHeight
    double biggerWidth = 0;
    double sumTextsHeight = 0;
    for (TextPainter tp in drawingTextPainters) {
      if (tp.width > biggerWidth) {
        biggerWidth = tp.width;
      }
      sumTextsHeight += tp.height;
    }
    sumTextsHeight += (drawingTextPainters.length - 1) * textsBelowMargin;


    /// if we have multiple bar lines,
    /// there are more than one FlCandidate on touch area,
    /// we should get the most top FlSpot Offset to draw the tooltip on top of it
    final Offset mostTopOffset = touchedSpots.first.offset;

    final double tooltipWidth = biggerWidth + tooltipData.tooltipPadding.horizontal;
    final double tooltipHeight = sumTextsHeight + tooltipData.tooltipPadding.vertical;

    /// draw the background rect with rounded radius
    final Rect rect = Rect.fromLTWH(mostTopOffset.dx - (tooltipWidth / 2), mostTopOffset.dy - tooltipHeight - tooltipData.tooltipBottomMargin, tooltipWidth, tooltipHeight);
    final Radius radius = Radius.circular(tooltipData.tooltipRoundedRadius);
    final RRect roundedRect = RRect.fromRectAndCorners(rect, topLeft: radius, topRight: radius, bottomLeft: radius, bottomRight: radius);
    bgTouchTooltipPaint.color = tooltipData.tooltipBgColor;
    canvas.drawRRect(roundedRect, bgTouchTooltipPaint);

    /// draw the texts one by one in below of each other
    double topPosSeek = tooltipData.tooltipPadding.top;
    for (TextPainter tp in drawingTextPainters) {
      final drawOffset = Offset(
        rect.center.dx - (tp.width / 2),
        rect.topCenter.dy + topPosSeek,
      );
      tp.paint(canvas, drawOffset);
      topPosSeek += tp.height;
      topPosSeek += textsBelowMargin;
    }
  }

  /// With this function we can convert our [FlSpot] x
  /// to the view base axis x .
  /// the view 0, 0 is on the top/left, but the spots is bottom/left
  double getPixelX(double spotX, Size chartUsableSize) {
    return (((spotX - data.minX) / (data.maxX - data.minX)) * chartUsableSize.width) + getLeftOffsetDrawSize();
  }

  /// With this function we can convert our [FlSpot] y
  /// to the view base axis y.
  double getPixelY(
    double spotY,
    Size chartUsableSize,
  ) {
    double y = ((spotY - data.minY) / (data.maxY - data.minY)) * chartUsableSize.height;
    y = chartUsableSize.height - y;
    return y + getTopOffsetDrawSize();
  }
}
