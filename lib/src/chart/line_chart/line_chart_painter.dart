import 'dart:ui' as ui;

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';
import 'package:fl_chart/src/extensions/canvas_extension.dart';
import 'package:fl_chart/src/extensions/path_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../utils/utils.dart';
import 'line_chart_data.dart';

class LineChartPainter extends AxisChartPainter<LineChartData>
    with TouchHandler<LineTouchResponse> {
  /// [barPaint] is responsible to painting the bar line
  /// [barAreaPaint] is responsible to fill the below or above space of the bar line
  /// [barAreaLinesPaint] is responsible to draw vertical lines on above or below of the bar line
  /// [dotPaint] is responsible to draw dots on spot points
  /// [clearAroundBorderPaint] is responsible to clip the border
  /// [extraLinesPaint] is responsible to draw extra lines
  /// [touchLinePaint] is responsible to draw touch indicators(below line and spot)
  /// [bgTouchTooltipPaint] is responsible to draw box backgroundTooltip of touched point;
  /// [rangeAnnotationPaint] draws range annotations;
  Paint barPaint,
      barAreaPaint,
      barAreaLinesPaint,
      clearBarAreaPaint,
      dotPaint,
      clearAroundBorderPaint,
      extraLinesPaint,
      touchLinePaint,
      rangeAnnotationPaint,
      bgTouchTooltipPaint;

  LineChartPainter(
      LineChartData data, LineChartData targetData, Function(TouchHandler) touchHandler,
      {double textScale})
      : super(data, targetData, textScale: textScale) {
    touchHandler(this);

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

    rangeAnnotationPaint = Paint()..style = PaintingStyle.fill;

    extraLinesPaint = Paint()..style = PaintingStyle.stroke;

    touchLinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black;

    bgTouchTooltipPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (data.lineBarsData.isEmpty) {
      return;
    }

    if (data.clipToBorder) {
      /// save layer to clip it to border after lines drew
      canvas.saveLayer(Rect.fromLTWH(0, -40, size.width + 40, size.height + 40), Paint());
    }

    for (BetweenBarsData betweenBarsData in data.betweenBarsData) {
      drawBetweenBarsArea(canvas, size, data, betweenBarsData);
    }

    super.drawBackground(canvas, size);
    drawRangeAnnotation(canvas, size);
    super.drawGrid(canvas, size);

    if (data.extraLinesData != null && !data.extraLinesData.extraLinesOnTop) {
      drawExtraLines(canvas, size);
    }

    /// draw each line independently on the chart
    for (int i = 0; i < data.lineBarsData.length; i++) {
      final barData = data.lineBarsData[i];

      if (!barData.show) {
        continue;
      }

      drawBarLine(canvas, size, barData);
      drawDots(canvas, size, barData);
      drawTouchedSpotsIndicator(canvas, size, barData);
    }

    if (data.extraLinesData != null && data.extraLinesData.extraLinesOnTop) {
      drawExtraLines(canvas, size);
    }

    if (data.clipToBorder) {
      removeOutsideBorder(canvas, size);

      /// restore layer to previous state (after clipping the chart)
      canvas.restore();
    }

    drawAxisTitles(canvas, size);
    drawTitles(canvas, size);

    // Draw touch tooltip on most top spot
    for (int i = 0; i < data.showingTooltipIndicators.length; i++) {
      MapEntry<int, List<LineBarSpot>> tooltipSpots = data.showingTooltipIndicators[i];

      final List<LineBarSpot> showingBarSpots = tooltipSpots.value;
      if (showingBarSpots.isEmpty) {
        continue;
      }
      final List<LineBarSpot> barSpots = List.of(showingBarSpots);
      FlSpot topSpot = barSpots[0];
      for (LineBarSpot barSpot in barSpots) {
        if (barSpot.y > topSpot.y) {
          topSpot = barSpot;
        }
      }
      tooltipSpots = MapEntry(tooltipSpots.key, barSpots);

      drawTouchTooltip(canvas, size, data.lineTouchData.touchTooltipData, topSpot, tooltipSpots);
    }
  }

  void drawBarLine(Canvas canvas, Size viewSize, LineChartBarData barData) {
    final barPath = _generateBarPath(viewSize, barData);

    final belowBarPath = _generateBelowBarPath(viewSize, barData, barPath);
    final completelyFillBelowBarPath =
        _generateBelowBarPath(viewSize, barData, barPath, fillCompletely: true);

    final aboveBarPath = _generateAboveBarPath(viewSize, barData, barPath);
    final completelyFillAboveBarPath =
        _generateAboveBarPath(viewSize, barData, barPath, fillCompletely: true);

    _drawBelowBar(canvas, viewSize, belowBarPath, completelyFillAboveBarPath, barData);
    _drawAboveBar(canvas, viewSize, aboveBarPath, completelyFillBelowBarPath, barData);
    _drawBar(canvas, viewSize, barPath, barData);
  }

  void drawBetweenBarsArea(
      Canvas canvas, Size viewSize, LineChartData data, BetweenBarsData betweenBarsData) {
    final LineChartBarData fromBarData = data.lineBarsData[betweenBarsData.fromIndex];
    final LineChartBarData toBarData = data.lineBarsData[betweenBarsData.toIndex];

    final List<FlSpot> spots = [];
    spots.addAll(toBarData.spots.reversed.toList());
    final fromBarPath = _generateBarPath(viewSize, fromBarData);
    final barPath =
        _generateBarPath(viewSize, toBarData.copyWith(spots: spots), appendToPath: fromBarPath);

    _drawBetweenBar(canvas, viewSize, barPath, betweenBarsData);
  }

  void drawDots(Canvas canvas, Size viewSize, LineChartBarData barData) {
    if (!barData.dotData.show) {
      return;
    }
    viewSize = getChartUsableDrawSize(viewSize);
    for (int i = 0; i < barData.spots.length; i++) {
      final FlSpot spot = barData.spots[i];
      if (barData.dotData.checkToShowDot(spot)) {
        final double x = getPixelX(spot.x, viewSize);
        final double y = getPixelY(spot.y, viewSize);
        dotPaint.color = barData.dotData.dotColor;
        canvas.drawCircle(Offset(x, y), barData.dotData.dotSize, dotPaint);
      }
    }
  }

  void drawTouchedSpotsIndicator(Canvas canvas, Size viewSize, LineChartBarData barData) {
    final Size chartViewSize = getChartUsableDrawSize(viewSize);

    // Todo technical debt, we can read the TouchedSpotIndicatorData directly,
    // Todo instead of mapping indexes to TouchedSpotIndicatorData
    final List<TouchedSpotIndicatorData> indicatorsData =
        data.lineTouchData.getTouchedSpotIndicator(barData, barData.showingIndicators);

    if (indicatorsData.length != barData.showingIndicators.length) {
      throw Exception('indicatorsData and touchedSpotOffsets size should be same');
    }

    for (int i = 0; i < barData.showingIndicators.length; i++) {
      final TouchedSpotIndicatorData indicatorData = indicatorsData[i];
      final int index = barData.showingIndicators[i];
      FlSpot spot = barData.spots[index];

      if (indicatorData == null) {
        continue;
      }

      final Offset touchedSpot =
          Offset(getPixelX(spot.x, chartViewSize), getPixelY(spot.y, chartViewSize));

      /// Draw the indicator line
      final from = Offset(touchedSpot.dx, getTopOffsetDrawSize() + chartViewSize.height);
      final to = touchedSpot;

      touchLinePaint.color = indicatorData.indicatorBelowLine.color;
      touchLinePaint.strokeWidth = indicatorData.indicatorBelowLine.strokeWidth;

      canvas.drawDashedLine(from, to, touchLinePaint, indicatorData.indicatorBelowLine.dashArray);

      /// Draw the indicator dot
      if (indicatorData.touchedSpotDotData != null && indicatorData.touchedSpotDotData.show) {
        final double selectedSpotDotSize = indicatorData.touchedSpotDotData.dotSize;
        dotPaint.color = indicatorData.touchedSpotDotData.dotColor;
        canvas.drawCircle(to, selectedSpotDotSize, dotPaint);
      }
    }
  }

  /// firstly we generate the bar line that we should draw,
  /// then we reuse it to fill below bar space.
  /// there is two type of barPath that generate here,
  /// first one is the sharp corners line on spot connections
  /// second one is curved corners line on spot connections,
  /// and we use isCurved to find out how we should generate it,
  /// If you want to concatenate paths together for creating an area between
  /// multiple bars for example, you can pass the appendToPath
  Path _generateBarPath(Size viewSize, LineChartBarData barData, {Path appendToPath}) {
    viewSize = getChartUsableDrawSize(viewSize);
    final Path path = appendToPath ?? Path();
    final int size = barData.spots.length;

    var temp = const Offset(0.0, 0.0);

    final double x = getPixelX(barData.spots[0].x, viewSize);
    final double y = getPixelY(barData.spots[0].y, viewSize);
    if (appendToPath == null) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
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
  Path _generateBelowBarPath(Size viewSize, LineChartBarData barData, Path barPath,
      {bool fillCompletely = false}) {
    final belowBarPath = Path.from(barPath);

    final chartViewSize = getChartUsableDrawSize(viewSize);

    /// Line To Bottom Right
    double x = getPixelX(barData.spots[barData.spots.length - 1].x, chartViewSize);
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
  Path _generateAboveBarPath(Size viewSize, LineChartBarData barData, Path barPath,
      {bool fillCompletely = false}) {
    final aboveBarPath = Path.from(barPath);

    final chartViewSize = getChartUsableDrawSize(viewSize);

    /// Line To Top Right
    double x = getPixelX(barData.spots[barData.spots.length - 1].x, chartViewSize);
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
          barData.belowBarData.gradientColorStops.length != barData.belowBarData.colors.length) {
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

          final double bottomPadding = getExtraNeededVerticalSpace() - getTopOffsetDrawSize();
          final Offset to = Offset(
            getPixelX(spot.x, chartViewSize),
            viewSize.height - bottomPadding,
          );

          barAreaLinesPaint.color = barData.belowBarData.spotsLine.flLineStyle.color;
          barAreaLinesPaint.strokeWidth = barData.belowBarData.spotsLine.flLineStyle.strokeWidth;

          canvas.drawDashedLine(
              from, to, barAreaLinesPaint, barData.belowBarData.spotsLine.flLineStyle.dashArray);
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
          barData.aboveBarData.gradientColorStops.length != barData.aboveBarData.colors.length) {
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
        if (barData.aboveBarData.spotsLine.checkToShowSpotLine(spot)) {
          final Offset from = Offset(
            getPixelX(spot.x, chartViewSize),
            getPixelY(spot.y, chartViewSize),
          );

          final Offset to = Offset(
            getPixelX(spot.x, chartViewSize),
            getTopOffsetDrawSize(),
          );

          barAreaLinesPaint.color = barData.aboveBarData.spotsLine.flLineStyle.color;
          barAreaLinesPaint.strokeWidth = barData.aboveBarData.spotsLine.flLineStyle.strokeWidth;

          canvas.drawDashedLine(
              from, to, barAreaLinesPaint, barData.aboveBarData.spotsLine.flLineStyle.dashArray);
        }
      }
    }
  }

  void _drawBetweenBar(
      Canvas canvas, Size viewSize, Path aboveBarPath, BetweenBarsData betweenBarsData) {
    final chartViewSize = getChartUsableDrawSize(viewSize);

    /// here we update the [betweenBarsData] to draw the solid color
    /// or the gradient based on the [BetweenBarsData] class.
    if (betweenBarsData.colors.length == 1) {
      barAreaPaint.color = betweenBarsData.colors[0];
      barAreaPaint.shader = null;
    } else {
      List<double> stops = [];
      if (betweenBarsData.gradientColorStops == null ||
          betweenBarsData.gradientColorStops.length != betweenBarsData.colors.length) {
        /// provided gradientColorStops is invalid and we calculate it here
        betweenBarsData.colors.asMap().forEach((index, color) {
          final percent = 1.0 / betweenBarsData.colors.length;
          stops.add(percent * (index + 1));
        });
      } else {
        stops = betweenBarsData.gradientColorStops;
      }

      final from = betweenBarsData.gradientFrom;
      final to = betweenBarsData.gradientTo;
      barAreaPaint.shader = ui.Gradient.linear(
        Offset(
          getLeftOffsetDrawSize() + (chartViewSize.width * from.dx),
          getTopOffsetDrawSize() + (chartViewSize.height * from.dy),
        ),
        Offset(
          getLeftOffsetDrawSize() + (chartViewSize.width * to.dx),
          getTopOffsetDrawSize() + (chartViewSize.height * to.dy),
        ),
        betweenBarsData.colors,
        stops,
      );
    }

    canvas.saveLayer(Rect.fromLTWH(0, 0, viewSize.width, viewSize.height), Paint());
    canvas.drawPath(aboveBarPath, barAreaPaint);

    // clear the above area that get out of the bar line
    canvas.restore();
  }

  /// draw the main bar line by the [barPath]
  void _drawBar(Canvas canvas, Size viewSize, Path barPath, LineChartBarData barData) {
    if (!barData.show) {
      return;
    }
    final chartViewSize = getChartUsableDrawSize(viewSize);

    barPaint.strokeCap = barData.isStrokeCapRound ? StrokeCap.round : StrokeCap.butt;

    /// here we update the [barPaint] to draw the solid color or
    /// the gradient color,
    /// if we have one color, solid color will apply,
    /// but if we have more than one color, gradient will apply.
    if (barData.colors.length == 1) {
      barPaint.color = barData.colors[0];
      barPaint.shader = null;
    } else {
      List<double> stops = [];
      if (barData.colorStops == null || barData.colorStops.length != barData.colors.length) {
        /// provided colorStops is invalid and we calculate it here
        barData.colors.asMap().forEach((index, color) {
          final double ss = 1.0 / barData.colors.length;
          stops.add(ss * (index + 1));
        });
      } else {
        stops = barData.colorStops;
      }

      final from = barData.gradientFrom;
      final to = barData.gradientTo;

      barPaint.shader = ui.Gradient.linear(
        Offset(
          getLeftOffsetDrawSize() + (chartViewSize.width * from.dx),
          getTopOffsetDrawSize() + (chartViewSize.height * from.dy),
        ),
        Offset(
          getLeftOffsetDrawSize() + (chartViewSize.width * to.dx),
          getTopOffsetDrawSize() + (chartViewSize.height * to.dy),
        ),
        barData.colors,
        stops,
      );
    }

    barPaint.strokeWidth = barData.barWidth;
    barPath = barPath.toDashedPath(barData.dashArray);
    canvas.drawPath(barPath, barPaint);
  }

  /// clip the border (remove outside the border)
  void removeOutsideBorder(Canvas canvas, Size viewSize) {
    if (!data.clipToBorder) {
      return;
    }

    clearAroundBorderPaint.strokeWidth = barPaint.strokeWidth / 2;
    final double halfStrokeWidth = clearAroundBorderPaint.strokeWidth / 2;
    final Rect rect = Rect.fromLTRB(
      getLeftOffsetDrawSize() - halfStrokeWidth,
      getTopOffsetDrawSize() - halfStrokeWidth,
      viewSize.width -
          (getExtraNeededHorizontalSpace() - getLeftOffsetDrawSize()) +
          halfStrokeWidth,
      viewSize.height - (getExtraNeededVerticalSpace() - getTopOffsetDrawSize()) + halfStrokeWidth,
    );
    canvas.drawRect(rect, clearAroundBorderPaint);
  }

  void drawTitles(Canvas canvas, Size viewSize) {
    if (!targetData.titlesData.show) {
      return;
    }
    viewSize = getChartUsableDrawSize(viewSize);

    // Left Titles
    final leftTitles = targetData.titlesData.leftTitles;
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
            textDirection: TextDirection.ltr,
            textScaleFactor: textScale);
        tp.layout(maxWidth: getExtraNeededHorizontalSpace());
        x -= tp.width + leftTitles.margin;
        y -= tp.height / 2;
        canvas.save();
        canvas.translate(x + tp.width / 2, y + tp.height / 2);
        canvas.rotate(radians(leftTitles.rotateAngle));
        canvas.translate(-(x + tp.width / 2), -(y + tp.height / 2));
        y -= translateRotatedPosition(tp.width, leftTitles.rotateAngle);
        tp.paint(canvas, Offset(x, y));
        canvas.restore();

        verticalSeek += leftTitles.interval;
      }
    }

    // Top titles
    final topTitles = targetData.titlesData.topTitles;
    if (topTitles.showTitles) {
      double horizontalSeek = data.minX;
      while (horizontalSeek <= data.maxX) {
        double x = getPixelX(horizontalSeek, viewSize);
        double y = getTopOffsetDrawSize();

        final String text = topTitles.getTitles(horizontalSeek);

        final TextSpan span = TextSpan(style: topTitles.textStyle, text: text);
        final TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            textScaleFactor: textScale);
        tp.layout();

        x -= tp.width / 2;
        y -= topTitles.margin + tp.height;
        canvas.save();
        canvas.translate(x + tp.width / 2, y + tp.height / 2);
        canvas.rotate(radians(topTitles.rotateAngle));
        canvas.translate(-(x + tp.width / 2), -(y + tp.height / 2));
        x -= translateRotatedPosition(tp.width, topTitles.rotateAngle);
        tp.paint(canvas, Offset(x, y));
        canvas.restore();

        horizontalSeek += topTitles.interval;
      }
    }

    // Right Titles
    final rightTitles = targetData.titlesData.rightTitles;
    if (rightTitles.showTitles) {
      double verticalSeek = data.minY;
      while (verticalSeek <= data.maxY) {
        double x = viewSize.width + getLeftOffsetDrawSize();
        double y = getPixelY(verticalSeek, viewSize);

        final String text = rightTitles.getTitles(verticalSeek);

        final TextSpan span = TextSpan(style: rightTitles.textStyle, text: text);
        final TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            textScaleFactor: textScale);
        tp.layout(maxWidth: getExtraNeededHorizontalSpace());

        x += rightTitles.margin;
        y -= tp.height / 2;
        canvas.save();
        canvas.translate(x + tp.width / 2, y + tp.height / 2);
        canvas.rotate(radians(rightTitles.rotateAngle));
        canvas.translate(-(x + tp.width / 2), -(y + tp.height / 2));
        y += translateRotatedPosition(tp.width, leftTitles.rotateAngle);
        tp.paint(canvas, Offset(x, y));
        canvas.restore();

        verticalSeek += rightTitles.interval;
      }
    }

    // Bottom titles
    final bottomTitles = targetData.titlesData.bottomTitles;
    if (bottomTitles.showTitles) {
      double horizontalSeek = data.minX;
      while (horizontalSeek <= data.maxX) {
        double x = getPixelX(horizontalSeek, viewSize);
        double y = viewSize.height + getTopOffsetDrawSize();
        final String text = bottomTitles.getTitles(horizontalSeek);
        final TextSpan span = TextSpan(style: bottomTitles.textStyle, text: text);
        final TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            textScaleFactor: textScale);
        tp.layout();

        x -= tp.width / 2;
        y += bottomTitles.margin;
        canvas.save();
        canvas.translate(x + tp.width / 2, y + tp.height / 2);
        canvas.rotate(radians(bottomTitles.rotateAngle));
        canvas.translate(-(x + tp.width / 2), -(y + tp.height / 2));
        x += translateRotatedPosition(tp.width, bottomTitles.rotateAngle);
        tp.paint(canvas, Offset(x, y));
        canvas.restore();

        horizontalSeek += bottomTitles.interval;
      }
    }
  }

  void drawExtraLines(Canvas canvas, Size viewSize) {
    if (data.extraLinesData == null) {
      return;
    }

    final Size chartUsableSize = getChartUsableDrawSize(viewSize);

    if (data.extraLinesData.horizontalLines.isNotEmpty) {
      for (HorizontalLine line in data.extraLinesData.horizontalLines) {
        final double leftChartPadding = getLeftOffsetDrawSize();
        final Offset from = Offset(leftChartPadding, getPixelY(line.y, chartUsableSize));

        final double rightChartPadding = getExtraNeededHorizontalSpace() - getLeftOffsetDrawSize();
        final Offset to =
            Offset(viewSize.width - rightChartPadding, getPixelY(line.y, chartUsableSize));

        extraLinesPaint.color = line.color;
        extraLinesPaint.strokeWidth = line.strokeWidth;

        canvas.drawDashedLine(from, to, extraLinesPaint, line.dashArray);
      }
    }

    if (data.extraLinesData.verticalLines.isNotEmpty) {
      for (VerticalLine line in data.extraLinesData.verticalLines) {
        final double topChartPadding = getTopOffsetDrawSize();
        final Offset from = Offset(getPixelX(line.x, chartUsableSize), topChartPadding);

        final double bottomChartPadding = getExtraNeededVerticalSpace() - getTopOffsetDrawSize();
        final Offset to =
            Offset(getPixelX(line.x, chartUsableSize), viewSize.height - bottomChartPadding);

        extraLinesPaint.color = line.color;
        extraLinesPaint.strokeWidth = line.strokeWidth;

        canvas.drawDashedLine(from, to, extraLinesPaint, line.dashArray);
      }
    }
  }

  void drawRangeAnnotation(Canvas canvas, Size viewSize) {
    if (data.rangeAnnotations == null) {
      return;
    }

    final Size chartUsableSize = getChartUsableDrawSize(viewSize);

    if (data.rangeAnnotations.verticalRangeAnnotations.isNotEmpty) {
      for (VerticalRangeAnnotation annotation in data.rangeAnnotations.verticalRangeAnnotations) {
        final double topChartPadding = getTopOffsetDrawSize();
        final Offset from = Offset(getPixelX(annotation.x1, chartUsableSize), topChartPadding);

        final double bottomChartPadding = getExtraNeededVerticalSpace() - getTopOffsetDrawSize();
        final Offset to = Offset(
            getPixelX(annotation.x2, chartUsableSize), viewSize.height - bottomChartPadding); //9

        final Rect rect = Rect.fromPoints(from, to);

        rangeAnnotationPaint.color = annotation.color;

        canvas.drawRect(rect, rangeAnnotationPaint);
      }
    }

    if (data.rangeAnnotations.horizontalRangeAnnotations.isNotEmpty) {
      for (HorizontalRangeAnnotation annotation
          in data.rangeAnnotations.horizontalRangeAnnotations) {
        final double leftChartPadding = getLeftOffsetDrawSize();
        final Offset from = Offset(leftChartPadding, getPixelY(annotation.y1, chartUsableSize));

        final double rightChartPadding = getExtraNeededHorizontalSpace() - getLeftOffsetDrawSize();
        final Offset to =
            Offset(viewSize.width - rightChartPadding, getPixelY(annotation.y2, chartUsableSize));

        final Rect rect = Rect.fromPoints(from, to);

        rangeAnnotationPaint.color = annotation.color;

        canvas.drawRect(rect, rangeAnnotationPaint);
      }
    }
  }

  void drawTouchTooltip(Canvas canvas, Size viewSize, LineTouchTooltipData tooltipData,
      FlSpot showOnSpot, MapEntry<int, List<LineBarSpot>> showingTooltipSpots) {
    final Size chartUsableSize = getChartUsableDrawSize(viewSize);

    const double textsBelowMargin = 4;

    /// creating TextPainters to calculate the width and height of the tooltip
    final List<TextPainter> drawingTextPainters = [];

    final List<LineTooltipItem> tooltipItems =
        tooltipData.getTooltipItems(showingTooltipSpots.value);
    if (tooltipItems.length != showingTooltipSpots.value.length) {
      throw Exception('tooltipItems and touchedSpots size should be same');
    }

    for (int i = 0; i < showingTooltipSpots.value.length; i++) {
      final LineTooltipItem tooltipItem = tooltipItems[i];
      if (tooltipItem == null) {
        continue;
      }

      final TextSpan span = TextSpan(style: tooltipItem.textStyle, text: tooltipItem.text);
      final TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          textScaleFactor: textScale);
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
    final Offset mostTopOffset = Offset(
      getPixelX(showOnSpot.x, chartUsableSize),
      getPixelY(showOnSpot.y, chartUsableSize),
    );

    final double tooltipWidth = biggerWidth + tooltipData.tooltipPadding.horizontal;
    final double tooltipHeight = sumTextsHeight + tooltipData.tooltipPadding.vertical;

    /// draw the background rect with rounded radius
    final Rect rect = Rect.fromLTWH(
        mostTopOffset.dx - (tooltipWidth / 2),
        mostTopOffset.dy - tooltipHeight - tooltipData.tooltipBottomMargin,
        tooltipWidth,
        tooltipHeight);
    final Radius radius = Radius.circular(tooltipData.tooltipRoundedRadius);
    final RRect roundedRect = RRect.fromRectAndCorners(rect,
        topLeft: radius, topRight: radius, bottomLeft: radius, bottomRight: radius);
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
  LineTouchResponse handleTouch(FlTouchInput touchInput, Size size) {
    /// it holds list of nearest touched spots of each line
    /// and we use it to draw touch stuff on them
    final List<LineBarSpot> touchedSpots = [];

    /// draw each line independently on the chart
    for (int i = 0; i < data.lineBarsData.length; i++) {
      final barData = data.lineBarsData[i];

      // find the nearest spot on touch area in this bar line
      final LineBarSpot foundTouchedSpot =
          _getNearestTouchedSpot(size, touchInput.getOffset(), barData, i);
      if (foundTouchedSpot != null) {
        touchedSpots.add(foundTouchedSpot);
      }
    }

    return LineTouchResponse(touchedSpots, touchInput);
  }

  /// find the nearest spot base on the touched offset
  LineBarSpot _getNearestTouchedSpot(
      Size viewSize, Offset touchedPoint, LineChartBarData barData, int barDataPosition) {
    if (!barData.show) {
      return null;
    }

    final Size chartViewSize = getChartUsableDrawSize(viewSize);

    /// Find the nearest spot (on X axis)
    for (int i = 0; i < barData.spots.length; i++) {
      final spot = barData.spots[i];
      if ((touchedPoint.dx - getPixelX(spot.x, chartViewSize)).abs() <=
          data.lineTouchData.touchSpotThreshold) {
        return LineBarSpot(barData, barDataPosition, spot);
      }
    }

    return null;
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) => oldDelegate.data != data;
}
