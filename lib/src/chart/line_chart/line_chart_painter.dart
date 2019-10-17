import 'dart:async';
import 'dart:ui' as ui;

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'line_chart_data.dart';

class LineChartPainter extends AxisChartPainter {
  final LineChartData data;
  final LineChartData targetData;

  /// [barPaint] is responsible to painting the bar line
  /// [barAreaPaint] is responsible to fill the below or above space of the bar line
  /// [barAreaLinesPaint] is responsible to draw vertical lines on above or below of the bar line
  /// [dotPaint] is responsible to draw dots on spot points
  /// [clearAroundBorderPaint] is responsible to clip the border
  /// [extraLinesPaint] is responsible to draw extr lines
  /// [touchLinePaint] is responsible to draw touch indicators(below line and spot)
  /// [bgTouchTooltipPaint] is responsible to draw box backgroundTooltip of touched point;
  Paint barPaint,
      barAreaPaint,
      barAreaLinesPaint,
      clearBarAreaPaint,
      dotPaint,
      clearAroundBorderPaint,
      extraLinesPaint,
      touchLinePaint;

  LineChartPainter(
    this.data,
    this.targetData,
    FlTouchInputNotifier touchInputNotifier,
    StreamSink<LineTouchResponse> touchedResponseSink,
  ) : super(data, targetData,
            touchInputNotifier: touchInputNotifier,
            touchedResponseSink: touchedResponseSink) {
    barPaint = Paint()..style = PaintingStyle.stroke;

    barAreaPaint = Paint()..style = PaintingStyle.fill;

    barAreaLinesPaint = Paint()..style = PaintingStyle.stroke;

    clearBarAreaPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0x000000000)
      ..blendMode = BlendMode.dstIn;
    
    dotPaint = Paint()..style = PaintingStyle.fill;

    clearAroundBorderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0x000000000)
      ..blendMode = BlendMode.dstIn;

    extraLinesPaint = Paint()..style = PaintingStyle.stroke;

    touchLinePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;
  }

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    if (data.lineBarsData.isEmpty) {
      return;
    }

    if (data.clipToBorder) {
      /// save layer to clip it to border after lines drew
      canvas.saveLayer(
          Rect.fromLTWH(0, -40, size.width + 40, size.height + 40),
          Paint());
    }

    /// it holds list of nearest touched spots of each line
    /// and we use it to draw touch stuff on them
    final List<LineTouchedSpot> touchedSpots = [];

    /// draw each line independently on the chart
    for (int i = 0; i<data.lineBarsData.length; i++) {
      final barData = data.lineBarsData[i];

      drawBarLine(canvas, size, barData);
      drawDots(canvas, size, barData);

      // find the nearest spot on touch area in this bar line
      final LineTouchedSpot foundTouchedSpot =
          _getNearestTouchedSpot(canvas, size, barData, i);
      if (foundTouchedSpot != null) {
        touchedSpots.add(foundTouchedSpot);
      }
    }

    if (data.clipToBorder) {
      removeOutsideBorder(canvas, size);

      /// restore layer to previous state (after clipping the chart)
      canvas.restore();
    }

    // Draw touch indicators (below spot line and spot dot)
    drawTouchedSpotsIndicator(canvas, size, touchedSpots);

    drawTitles(canvas, size);

    drawExtraLines(canvas, size);

    // Draw touch tooltip on most top spot
    super.drawTouchTooltip(
        canvas, size, data.lineTouchData.touchTooltipData, touchedSpots);

    if (touchedResponseSink != null &&
        touchInputNotifier != null &&
        touchInputNotifier.value != null &&
        !(touchInputNotifier.value.runtimeType is NonTouch)) {
      touchedResponseSink
          .add(LineTouchResponse(touchedSpots, touchInputNotifier.value));
    }
  }

  void drawBarLine(Canvas canvas, Size viewSize, LineChartBarData barData) {
    final barPath = _generateBarPath(viewSize, barData);

    final belowBarPath = _generateBelowBarPath(viewSize, barData, barPath);
    final completelyFillBelowBarPath = _generateBelowBarPath(viewSize, barData, barPath, fillCompletely: true);

    final aboveBarPath = _generateAboveBarPath(viewSize, barData, barPath);
    final completelyFillAboveBarPath = _generateAboveBarPath(viewSize, barData, barPath, fillCompletely: true);

    _drawBelowBar(canvas, viewSize, belowBarPath, completelyFillAboveBarPath, barData);
    _drawAboveBar(canvas, viewSize, aboveBarPath, completelyFillBelowBarPath, barData);
    _drawBar(canvas, viewSize, barPath, barData);
  }

  /// find the nearest spot base on the touched offset
  LineTouchedSpot _getNearestTouchedSpot(
      Canvas canvas, Size viewSize, LineChartBarData barData, int barDataPosition) {
    final Size chartViewSize = getChartUsableDrawSize(viewSize);

    if (touchInputNotifier == null || touchInputNotifier.value == null) {
      return null;
    }

    final touch = touchInputNotifier.value;

    if (touch.getOffset() == null) {
      return null;
    }

    final touchedPoint = touch.getOffset();

    /// Find the nearest spot (on X axis)
    for (FlSpot spot in barData.spots) {
      if ((touchedPoint.dx - getPixelX(spot.x, chartViewSize)).abs() <=
          data.lineTouchData.touchSpotThreshold) {
        final nearestSpot = spot;
        final Offset nearestSpotPos = Offset(
          getPixelX(nearestSpot.x, chartViewSize),
          getPixelY(nearestSpot.y, chartViewSize),
        );

        return LineTouchedSpot(barData, barDataPosition, nearestSpot, nearestSpotPos);
      }
    }

    return null;
  }

  void drawDots(Canvas canvas, Size viewSize, LineChartBarData barData) {
    if (!barData.dotData.show) {
      return;
    }
    viewSize = getChartUsableDrawSize(viewSize);
    barData.spots.forEach((spot) {
      if (barData.dotData.checkToShowDot(spot)) {
        double x = getPixelX(spot.x, viewSize);
        double y = getPixelY(spot.y, viewSize);
        dotPaint.color = barData.dotData.dotColor;
        canvas.drawCircle(Offset(x, y), barData.dotData.dotSize, dotPaint);
      }
    });
  }

  /// firstly we generate the bar line that we should draw,
  /// then we reuse it to fill below bar space.
  /// there is two type of barPath that generate here,
  /// first one is the sharp corners line on spot connections
  /// second one is curved corners line on spot connections,
  /// and we use isCurved to find out how we should generate it,
  Path _generateBarPath(Size viewSize, LineChartBarData barData) {
    viewSize = getChartUsableDrawSize(viewSize);
    Path path = Path();
    int size = barData.spots.length;
    path.reset();

    var temp = const Offset(0.0, 0.0);

    double x = getPixelX(barData.spots[0].x, viewSize);
    double y = getPixelY(barData.spots[0].y, viewSize);
    path.moveTo(x, y);
    for (int i = 1; i < size; i++) {
      /// CurrentSpot
      final current = Offset(
        getPixelX(barData.spots[i].x, viewSize),
        getPixelY(barData.spots[i].y, viewSize),
      );

      /// previous spot
      final previous = Offset(
        getPixelX(barData.spots[i - 1].x, viewSize),
        getPixelY(barData.spots[i - 1].y, viewSize),
      );

      /// next point
      final next = Offset(
        getPixelX(barData.spots[i + 1 < size ? i + 1 : i].x, viewSize),
        getPixelY(barData.spots[i + 1 < size ? i + 1 : i].y, viewSize),
      );

      final controlPoint1 = previous + temp;

      /// if the isCurved is false, we set 0 for smoothness,
      /// it means we should not have any smoothness then we face with
      /// the sharped corners line
      final smoothness = barData.isCurved ? barData.curveSmoothness : 0.0;
      temp = ((next - previous) / 2) * smoothness;

      if (barData.preventCurveOverShooting) {
        if ((next - current).dy <= 10 || (current - previous).dy <= 10) {
          temp = Offset(temp.dx, 0);
        }

        if ((next - current).dx <= 10 || (current - previous).dx <= 10) {
          temp = Offset(0, temp.dy);
        }
      }

      final controlPoint2 = current - temp;

      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        current.dx,
        current.dy,
      );
    }

    return path;
  }

  /// it generates below area path using a copy of [barPath],
  /// if cutOffY is provided by the [BarAreaData], it cut the area to the provided cutOffY value,
  /// if [fillCompletely] is true, the cutOffY will be ignored,
  /// and a completely filled path will return,
  Path _generateBelowBarPath(Size viewSize, LineChartBarData barData, Path barPath, {bool fillCompletely = false}) {
    final belowBarPath = Path.from(barPath);

    final chartViewSize = getChartUsableDrawSize(viewSize);

    /// Line To Bottom Right
    double x =
    getPixelX(barData.spots[barData.spots.length - 1].x, chartViewSize);
    double y;
    if (!fillCompletely && barData.belowBarData.applyCutOffY) {
      y = getPixelY(barData.belowBarData.cutOffY, chartViewSize);
    } else {
      y = chartViewSize.height + getTopOffsetDrawSize();
    }
    belowBarPath.lineTo(x, y);

    /// Line To Bottom Left
    x = getPixelX(barData.spots[0].x, chartViewSize);
    if (!fillCompletely && barData.belowBarData.applyCutOffY) {
      y = getPixelY(barData.belowBarData.cutOffY, chartViewSize);
    } else {
      y = chartViewSize.height + getTopOffsetDrawSize();
    }
    belowBarPath.lineTo(x, y);

    /// Line To Top Left
    x = getPixelX(barData.spots[0].x, chartViewSize);
    y = getPixelY(barData.spots[0].y, chartViewSize);
    belowBarPath.lineTo(x, y);
    belowBarPath.close();

    return belowBarPath;
  }

  /// it generates above area path using a copy of [barPath],
  /// if cutOffY is provided by the [BarAreaData], it cut the area to the provided cutOffY value,
  /// if [fillCompletely] is true, the cutOffY will be ignored,
  /// and a completely filled path will return,
  Path _generateAboveBarPath(Size viewSize, LineChartBarData barData, Path barPath, {bool fillCompletely = false}) {
    final aboveBarPath = Path.from(barPath);

    final chartViewSize = getChartUsableDrawSize(viewSize);

    /// Line To Top Right
    double x =
    getPixelX(barData.spots[barData.spots.length - 1].x, chartViewSize);
    double y;
    if (!fillCompletely && barData.aboveBarData.applyCutOffY) {
      y = getPixelY(barData.aboveBarData.cutOffY, chartViewSize);
    } else {
      y = getTopOffsetDrawSize();
    }
    aboveBarPath.lineTo(x, y);

    /// Line To Top Left
    x = getPixelX(barData.spots[0].x, chartViewSize);
    if (!fillCompletely && barData.aboveBarData.applyCutOffY) {
      y = getPixelY(barData.aboveBarData.cutOffY, chartViewSize);
    } else {
      y = getTopOffsetDrawSize();
    }
    aboveBarPath.lineTo(x, y);

    /// Line To Bottom Left
    x = getPixelX(barData.spots[0].x, chartViewSize);
    y = getPixelY(barData.spots[0].y, chartViewSize);
    aboveBarPath.lineTo(x, y);
    aboveBarPath.close();

    return aboveBarPath;
  }

  /// firstly we draw [belowBarPath], then if cutOffY value is provided in [BarAreaData],
  /// [belowBarPath] maybe draw over the main bar line,
  /// then to fix the problem we use [filledAboveBarPath] to clear the above section from this draw.
  void _drawBelowBar(Canvas canvas, Size viewSize, Path belowBarPath, Path filledAboveBarPath,
    LineChartBarData barData) {
    if (!barData.belowBarData.show) {
      return;
    }

    final chartViewSize = getChartUsableDrawSize(viewSize);

    /// here we update the [belowBarPaint] to draw the solid color
    /// or the gradient based on the [BarAreaData] class.
    if (barData.belowBarData.colors.length == 1) {
      barAreaPaint.color = barData.belowBarData.colors[0];
      barAreaPaint.shader = null;
    } else {
      List<double> stops = [];
      if (barData.belowBarData.gradientColorStops == null ||
          barData.belowBarData.gradientColorStops.length !=
              barData.belowBarData.colors.length) {
        /// provided gradientColorStops is invalid and we calculate it here
        barData.colors.asMap().forEach((index, color) {
          final percent = 1.0 / barData.colors.length;
          stops.add(percent * (index + 1));
        });
      } else {
        stops = barData.belowBarData.gradientColorStops;
      }

      final from = barData.belowBarData.gradientFrom;
      final to = barData.belowBarData.gradientTo;
      barAreaPaint.shader = ui.Gradient.linear(
        Offset(
          getLeftOffsetDrawSize() + (chartViewSize.width * from.dx),
          getTopOffsetDrawSize() + (chartViewSize.height * from.dy),
        ),
        Offset(
          getLeftOffsetDrawSize() + (chartViewSize.width * to.dx),
          getTopOffsetDrawSize() + (chartViewSize.height * to.dy),
        ),
        barData.belowBarData.colors,
        stops,
      );
    }

    if (barData.belowBarData.applyCutOffY) {
      canvas.saveLayer(Rect.fromLTWH(0, 0, viewSize.width, viewSize.height), Paint());
    }
    
    canvas.drawPath(belowBarPath, barAreaPaint);

    // clear the above area that get out of the bar line
    if (barData.belowBarData.applyCutOffY) {
      canvas.drawPath(filledAboveBarPath, clearBarAreaPaint);
      canvas.restore();
    }


    /// draw below spots line
    if (barData.belowBarData.spotsLine != null && barData.belowBarData.spotsLine.show) {
      for (FlSpot spot in barData.spots) {
        if (barData.belowBarData.spotsLine.checkToShowSpotLine(spot)) {
          final Offset from = Offset(
            getPixelX(spot.x, chartViewSize),
            getPixelY(spot.y, chartViewSize),
          );

          final double bottomPadding =
              getExtraNeededVerticalSpace() - getTopOffsetDrawSize();
          final Offset to = Offset(
            getPixelX(spot.x, chartViewSize),
            viewSize.height - bottomPadding,
          );

          barAreaLinesPaint.color =
              barData.belowBarData.spotsLine.flLineStyle.color;
          barAreaLinesPaint.strokeWidth =
              barData.belowBarData.spotsLine.flLineStyle.strokeWidth;

          canvas.drawLine(from, to, barAreaLinesPaint);
        }
      }
    }
  }

  /// firstly we draw [aboveBarPath], then if cutOffY value is provided in [BarAreaData],
  /// [aboveBarPath] maybe draw over the main bar line,
  /// then to fix the problem we use [filledBelowBarPath] to clear the above section from this draw.
  void _drawAboveBar(Canvas canvas, Size viewSize, Path aboveBarPath, Path filledBelowBarPath,
    LineChartBarData barData) {
    if (!barData.aboveBarData.show) {
      return;
    }
    final chartViewSize = getChartUsableDrawSize(viewSize);

    /// here we update the [aboveBarPaint] to draw the solid color
    /// or the gradient based on the [BarAreaData] class.
    if (barData.aboveBarData.colors.length == 1) {
      barAreaPaint.color = barData.aboveBarData.colors[0];
      barAreaPaint.shader = null;
    } else {
      List<double> stops = [];
      if (barData.aboveBarData.gradientColorStops == null ||
        barData.aboveBarData.gradientColorStops.length !=
          barData.aboveBarData.colors.length) {
        /// provided gradientColorStops is invalid and we calculate it here
        barData.colors.asMap().forEach((index, color) {
          final percent = 1.0 / barData.colors.length;
          stops.add(percent * (index + 1));
        });
      } else {
        stops = barData.aboveBarData.gradientColorStops;
      }

      final from = barData.aboveBarData.gradientFrom;
      final to = barData.aboveBarData.gradientTo;
      barAreaPaint.shader = ui.Gradient.linear(
        Offset(
          getLeftOffsetDrawSize() + (chartViewSize.width * from.dx),
          getTopOffsetDrawSize() + (chartViewSize.height * from.dy),
        ),
        Offset(
          getLeftOffsetDrawSize() + (chartViewSize.width * to.dx),
          getTopOffsetDrawSize() + (chartViewSize.height * to.dy),
        ),
        barData.aboveBarData.colors,
        stops,
      );
    }

    canvas.saveLayer(Rect.fromLTWH(0, 0, viewSize.width, viewSize.height), Paint());
    canvas.drawPath(aboveBarPath, barAreaPaint);

    // clear the above area that get out of the bar line
    canvas.drawPath(filledBelowBarPath, clearBarAreaPaint);
    canvas.restore();

    /// draw above spots line
    if (barData.aboveBarData.spotsLine != null && barData.aboveBarData.spotsLine.show) {
      for (FlSpot spot in barData.spots) {
        if (barData.aboveBarData.spotsLine
            .checkToShowSpotLine(spot)) {
          final Offset from = Offset(
            getPixelX(spot.x, chartViewSize),
            getPixelY(spot.y, chartViewSize),
          );

          final Offset to = Offset(
            getPixelX(spot.x, chartViewSize),
            getTopOffsetDrawSize(),
          );

          barAreaLinesPaint.color =
            barData.aboveBarData.spotsLine.flLineStyle.color;
          barAreaLinesPaint.strokeWidth =
            barData.aboveBarData.spotsLine.flLineStyle.strokeWidth;

          canvas.drawLine(from, to, barAreaLinesPaint);
        }
      }
    }
  }

  /// draw the main bar line by the [barPath]
  void _drawBar(
      Canvas canvas, Size viewSize, Path barPath, LineChartBarData barData) {
    if (!barData.show) {
      return;
    }

    barPaint.strokeCap =
        barData.isStrokeCapRound ? StrokeCap.round : StrokeCap.butt;

    /// here we update the [barPaint] to draw the solid color or
    /// the gradient color,
    /// if we have one color, solid color will apply,
    /// but if we have more than one color, gradient will apply.
    if (barData.colors.length == 1) {
      barPaint.color = barData.colors[0];
      barPaint.shader = null;
    } else {
      List<double> stops = [];
      if (barData.colorStops == null ||
          barData.colorStops.length != barData.colors.length) {
        /// provided colorStops is invalid and we calculate it here
        barData.colors.asMap().forEach((index, color) {
          double ss = 1.0 / barData.colors.length;
          stops.add(ss * (index + 1));
        });
      } else {
        stops = barData.colorStops;
      }

      barPaint.shader = ui.Gradient.linear(
        Offset(
          getLeftOffsetDrawSize(),
          getTopOffsetDrawSize() + (viewSize.height / 2),
        ),
        Offset(
          getLeftOffsetDrawSize() + viewSize.width,
          getTopOffsetDrawSize() + (viewSize.height / 2),
        ),
        barData.colors,
        stops,
      );
    }

    barPaint.strokeWidth = barData.barWidth;
    canvas.drawPath(barPath, barPaint);
  }

  /// clip the border (remove outside the border)
  void removeOutsideBorder(Canvas canvas, Size viewSize) {
    if (!data.clipToBorder) {
      return;
    }

    clearAroundBorderPaint.strokeWidth = barPaint.strokeWidth / 2;
    double halfStrokeWidth = clearAroundBorderPaint.strokeWidth / 2;
    Rect rect = Rect.fromLTRB(
      getLeftOffsetDrawSize() - halfStrokeWidth,
      getTopOffsetDrawSize() - halfStrokeWidth,
      viewSize.width -
          (getExtraNeededHorizontalSpace() - getLeftOffsetDrawSize()) +
          halfStrokeWidth,
      viewSize.height -
          (getExtraNeededVerticalSpace() - getTopOffsetDrawSize()) +
          halfStrokeWidth,
    );
    canvas.drawRect(rect, clearAroundBorderPaint);
  }

  void drawTouchedSpotsIndicator(
      Canvas canvas, Size viewSize, List<LineTouchedSpot> lineTouchedSpots) {
    if (!shouldDrawTouch()) {
      return;
    }

    if (lineTouchedSpots == null || lineTouchedSpots.isEmpty) {
      return;
    }

    final Size chartViewSize = getChartUsableDrawSize(viewSize);

    /// sort the touched spots top to down, base on their y value
    lineTouchedSpots.sort((a, b) => a.offset.dy.compareTo(b.offset.dy));

    final List<TouchedSpotIndicatorData> indicatorsData =
        data.lineTouchData.getTouchedSpotIndicator(lineTouchedSpots);

    if (indicatorsData.length != lineTouchedSpots.length) {
      throw Exception(
          'indicatorsData and touchedSpotOffsets size should be same');
    }

    for (int i = 0; i < lineTouchedSpots.length; i++) {
      final TouchedSpotIndicatorData indicatorData = indicatorsData[i];
      final LineTouchedSpot touchedSpot = lineTouchedSpots[i];

      if (indicatorData == null) {
        continue;
      }

      /// Draw the indicator line
      final from = Offset(
          touchedSpot.offset.dx, getTopOffsetDrawSize() + chartViewSize.height);
      final to = touchedSpot.offset;

      touchLinePaint.color = indicatorData.indicatorBelowLine.color;
      touchLinePaint.strokeWidth = indicatorData.indicatorBelowLine.strokeWidth;
      canvas.drawLine(from, to, touchLinePaint);

      /// Draw the indicator dot
      final double selectedSpotDotSize =
          indicatorData.touchedSpotDotData.dotSize;
      dotPaint.color = indicatorData.touchedSpotDotData.dotColor;
      canvas.drawCircle(to, selectedSpotDotSize, dotPaint);
    }
  }

  void drawTitles(Canvas canvas, Size viewSize) {
    if (!data.titlesData.show) {
      return;
    }
    viewSize = getChartUsableDrawSize(viewSize);

    // Left Titles
    final leftTitles = data.titlesData.leftTitles;
    if (leftTitles.showTitles) {
      double verticalSeek = data.minY;
      while (verticalSeek <= data.maxY) {
        double x = 0 + getLeftOffsetDrawSize();
        double y = getPixelY(verticalSeek, viewSize);

        final String text = leftTitles.getTitles(verticalSeek);

        final TextSpan span = TextSpan(style: leftTitles.textStyle, text: text);
        final TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr);
        tp.layout(maxWidth: getExtraNeededHorizontalSpace());
        x -= tp.width + leftTitles.margin;
        y -= tp.height / 2;
        tp.paint(canvas, Offset(x, y));

        verticalSeek += leftTitles.interval;
      }
    }

    // Top titles
    final topTitles = data.titlesData.topTitles;
    if (topTitles.showTitles) {
      double horizontalSeek = data.minX;
      while (horizontalSeek <= data.maxX) {
        double x = getPixelX(horizontalSeek, viewSize);
        double y = getTopOffsetDrawSize();

        String text = topTitles.getTitles(horizontalSeek);

        TextSpan span = TextSpan(style: topTitles.textStyle, text: text);
        TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr);
        tp.layout();

        x -= tp.width / 2;
        y -= topTitles.margin + tp.height;

        tp.paint(canvas, Offset(x, y));

        horizontalSeek += topTitles.interval;
      }
    }

    // Right Titles
    final rightTitles = data.titlesData.rightTitles;
    if (rightTitles.showTitles) {
      double verticalSeek = data.minY;
      while (verticalSeek <= data.maxY) {
        double x = viewSize.width + getLeftOffsetDrawSize();
        double y = getPixelY(verticalSeek, viewSize);

        final String text = rightTitles.getTitles(verticalSeek);

        final TextSpan span =
            TextSpan(style: rightTitles.textStyle, text: text);
        final TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr);
        tp.layout(maxWidth: getExtraNeededHorizontalSpace());
        x += rightTitles.margin;
        y -= tp.height / 2;
        tp.paint(canvas, Offset(x, y));

        verticalSeek += rightTitles.interval;
      }
    }

    // Bottom titles
    final bottomTitles = data.titlesData.bottomTitles;
    if (bottomTitles.showTitles) {
      double horizontalSeek = data.minX;
      while (horizontalSeek <= data.maxX) {
        double x = getPixelX(horizontalSeek, viewSize);
        double y = viewSize.height + getTopOffsetDrawSize();

        String text = bottomTitles.getTitles(horizontalSeek);

        TextSpan span = TextSpan(style: bottomTitles.textStyle, text: text);
        TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr);
        tp.layout();

        x -= tp.width / 2;
        y += bottomTitles.margin;

        tp.paint(canvas, Offset(x, y));

        horizontalSeek += bottomTitles.interval;
      }
    }
  }

  void drawExtraLines(Canvas canvas, Size viewSize) {
    if (data.extraLinesData == null) {
      return;
    }

    final Size chartUsableSize = getChartUsableDrawSize(viewSize);

    if (data.extraLinesData.showHorizontalLines) {
      for (HorizontalLine line in data.extraLinesData.horizontalLines) {
        final double topChartPadding = getTopOffsetDrawSize();
        final Offset from =
            Offset(getPixelX(line.x, chartUsableSize), topChartPadding);

        final double bottomChartPadding =
            getExtraNeededVerticalSpace() - getTopOffsetDrawSize();
        final Offset to = Offset(getPixelX(line.x, chartUsableSize),
            viewSize.height - bottomChartPadding);

        extraLinesPaint.color = line.color;
        extraLinesPaint.strokeWidth = line.strokeWidth;

        canvas.drawLine(from, to, extraLinesPaint);
      }
    }

    if (data.extraLinesData.showVerticalLines) {
      for (VerticalLine line in data.extraLinesData.verticalLines) {
        final double leftChartPadding = getLeftOffsetDrawSize();
        final Offset from =
            Offset(leftChartPadding, getPixelY(line.y, chartUsableSize));

        final double rightChartPadding =
            getExtraNeededHorizontalSpace() - getLeftOffsetDrawSize();
        final Offset to = Offset(viewSize.width - rightChartPadding,
            getPixelY(line.y, chartUsableSize));

        extraLinesPaint.color = line.color;
        extraLinesPaint.strokeWidth = line.strokeWidth;

        canvas.drawLine(from, to, extraLinesPaint);
      }
    }
  }

  /// We add our needed horizontal space to parent needed.
  /// we have some titles that maybe draw in the left and right side of our chart,
  /// then we should draw the chart a with some left space,
  /// the left space is [getLeftOffsetDrawSize],
  /// and the whole space is [getExtraNeededHorizontalSpace]
  @override
  double getExtraNeededHorizontalSpace() {
    double sum = super.getExtraNeededHorizontalSpace();
    if (data.titlesData.show) {
      final leftSide = data.titlesData.leftTitles;
      if (leftSide.showTitles) {
        sum += leftSide.reservedSize + leftSide.margin;
      }

      final rightSide = data.titlesData.rightTitles;
      if (rightSide.showTitles) {
        sum += rightSide.reservedSize + rightSide.margin;
      }
    }
    return sum;
  }

  /// We add our needed vertical space to parent needed.
  /// we have some titles that maybe draw in the top and bottom side of our chart,
  /// then we should draw the chart a with some top space,
  /// the top space is [getTopOffsetDrawSize()],
  /// and the whole space is [getExtraNeededVerticalSpace]
  @override
  double getExtraNeededVerticalSpace() {
    double sum = super.getExtraNeededVerticalSpace();
    if (data.titlesData.show) {
      final topSide = data.titlesData.topTitles;
      if (topSide.showTitles) {
        sum += topSide.reservedSize + topSide.margin;
      }

      final bottomSide = data.titlesData.bottomTitles;
      if (bottomSide.showTitles) {
        sum += bottomSide.reservedSize + bottomSide.margin;
      }
    }
    return sum;
  }

  /// calculate left offset for draw the chart,
  /// maybe we want to show both left and right titles,
  /// then just the left titles will effect on this function.
  @override
  double getLeftOffsetDrawSize() {
    var sum = super.getLeftOffsetDrawSize();

    final leftTitles = data.titlesData.leftTitles;
    if (data.titlesData.show && leftTitles.showTitles) {
      sum += leftTitles.reservedSize + leftTitles.margin;
    }
    return sum;
  }

  /// calculate top offset for draw the chart,
  /// maybe we want to show both top and bottom titles,
  /// then just the top titles will effect on this function.
  @override
  double getTopOffsetDrawSize() {
    var sum = super.getTopOffsetDrawSize();

    final topTitles = data.titlesData.topTitles;
    if (data.titlesData.show && topTitles.showTitles) {
      sum += topTitles.reservedSize + topTitles.margin;
    }

    return sum;
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) =>
      oldDelegate.data != data ||
      oldDelegate.touchInputNotifier != touchInputNotifier;
}
