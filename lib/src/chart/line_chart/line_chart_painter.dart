import 'dart:ui' as ui;
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';
import 'package:fl_chart/src/extensions/canvas_extension.dart';
import 'package:fl_chart/src/extensions/path_extension.dart';
import 'package:fl_chart/src/extensions/paint_extension.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../fl_chart.dart';
import '../../utils/utils.dart';
import 'line_chart_data.dart';

/// Paints [LineChartData] in the canvas, it can be used in a [CustomPainter]
class LineChartPainter extends AxisChartPainter<LineChartData>
    with TouchHandler<LineTouchResponse> {
  Paint _barPaint,
      _barAreaPaint,
      _barAreaLinesPaint,
      _clearBarAreaPaint,
      _extraLinesPaint,
      _touchLinePaint,
      _bgTouchTooltipPaint,
      _imagePaint;

  /// Paints [data] into canvas, it is the animating [LineChartData],
  /// [targetData] is the animation's target and remains the same
  /// during animation, then we should use it  when we need to show
  /// tooltips or something like that, because [data] is changing constantly.
  ///
  /// [touchHandler] passes a [TouchHandler] to the parent,
  /// parent will use it for touch handling flow.
  ///
  /// [textScale] used for scaling texts inside the chart,
  /// parent can use [MediaQuery.textScaleFactor] to respect
  /// the system's font size.
  LineChartPainter(
      LineChartData data, LineChartData targetData, Function(TouchHandler) touchHandler,
      {double textScale})
      : super(data, targetData, textScale: textScale) {
    touchHandler(this);

    _barPaint = Paint()..style = PaintingStyle.stroke;

    _barAreaPaint = Paint()..style = PaintingStyle.fill;

    _barAreaLinesPaint = Paint()..style = PaintingStyle.stroke;

    _clearBarAreaPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0x000000000)
      ..blendMode = BlendMode.dstIn;

    _extraLinesPaint = Paint()..style = PaintingStyle.stroke;

    _touchLinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black;

    _bgTouchTooltipPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    _imagePaint = Paint();
  }

  /// Paints [LineChartData] into the provided canvas.
  @override
  void paint(Canvas canvas, Size size) {
    final canvasWrapper = CanvasWrapper(canvas, size);
    if (data.lineBarsData.isEmpty) {
      return;
    }

    if (data.clipData.any) {
      canvasWrapper.saveLayer(Rect.fromLTWH(0, -40, size.width + 40, size.height + 40), Paint());

      _clipToBorder(canvasWrapper);
    }

    super.paint(canvas, size);

    for (var betweenBarsData in data.betweenBarsData) {
      _drawBetweenBarsArea(canvasWrapper, data, betweenBarsData);
    }

    if (data.extraLinesData != null && !data.extraLinesData.extraLinesOnTop) {
      _drawExtraLines(canvasWrapper);
    }

    /// draw each line independently on the chart
    for (var i = 0; i < data.lineBarsData.length; i++) {
      final barData = data.lineBarsData[i];

      if (!barData.show) {
        continue;
      }

      _drawBarLine(canvasWrapper, barData);
      _drawDots(canvasWrapper, barData);

      if (data.extraLinesData != null && data.extraLinesData.extraLinesOnTop) {
        _drawExtraLines(canvasWrapper);
      }

      _drawTouchedSpotsIndicator(canvasWrapper, barData);
    }

    if (data.clipData.any) {
      canvasWrapper.restore();
    }

    drawAxisTitles(canvasWrapper);
    _drawTitles(canvasWrapper);

    // Draw touch tooltip on most top spot
    for (var i = 0; i < data.showingTooltipIndicators.length; i++) {
      var tooltipSpots = data.showingTooltipIndicators[i];

      final showingBarSpots = tooltipSpots.showingSpots;
      if (showingBarSpots.isEmpty) {
        continue;
      }
      final barSpots = List<LineBarSpot>.of(showingBarSpots);
      FlSpot topSpot = barSpots[0];
      for (var barSpot in barSpots) {
        if (barSpot.y > topSpot.y) {
          topSpot = barSpot;
        }
      }
      tooltipSpots = ShowingTooltipIndicators(tooltipSpots.lineIndex, barSpots);

      _drawTouchTooltip(canvasWrapper, data.lineTouchData.touchTooltipData, topSpot, tooltipSpots);
    }
  }

  void _clipToBorder(CanvasWrapper canvasWrapper) {
    final size = canvasWrapper.size;
    final clip = data.clipData;
    final usableSize = getChartUsableDrawSize(size);
    final border = data.borderData.show ? data.borderData.border : null;

    var left = 0.0;
    var top = 0.0;
    var right = size.width;
    var bottom = size.height;

    if (clip.left) {
      final borderWidth = border?.left?.width ?? 0;
      left = getLeftOffsetDrawSize() - (borderWidth / 2);
    }
    if (clip.top) {
      final borderWidth = border?.top?.width ?? 0;
      top = getTopOffsetDrawSize() - (borderWidth / 2);
    }
    if (clip.right) {
      final borderWidth = border?.right?.width ?? 0;
      right = getLeftOffsetDrawSize() + usableSize.width + (borderWidth / 2);
    }
    if (clip.bottom) {
      final borderWidth = border?.bottom?.width ?? 0;
      bottom = getTopOffsetDrawSize() + usableSize.height + (borderWidth / 2);
    }

    canvasWrapper.clipRect(Rect.fromLTRB(left, top, right, bottom));
  }

  void _drawBarLine(CanvasWrapper canvasWrapper, LineChartBarData barData) {
    final viewSize = canvasWrapper.size;
    final barList = <List<FlSpot>>[[]];

    // handle nullability by splitting off the list into multiple
    // separate lists when separated by nulls
    for (var spot in barData.spots) {
      if (spot.isNotNull()) {
        barList.last.add(spot);
      } else if (barList.last.isNotEmpty) {
        barList.add([]);
      }
    }
    // remove last item if one or more last spots were null
    if (barList.last.isEmpty) {
      barList.removeLast();
    }

    // paint each sublist that was built above
    // bar is passed in separately from barData
    // because barData is the whole line
    // and bar is a piece of that line
    for (var bar in barList) {
      final barPath = _generateBarPath(viewSize, barData, bar);

      final belowBarPath = _generateBelowBarPath(viewSize, barData, barPath, bar);
      final completelyFillBelowBarPath =
          _generateBelowBarPath(viewSize, barData, barPath, bar, fillCompletely: true);
      final aboveBarPath = _generateAboveBarPath(viewSize, barData, barPath, bar);
      final completelyFillAboveBarPath =
          _generateAboveBarPath(viewSize, barData, barPath, bar, fillCompletely: true);

      _drawBelowBar(canvasWrapper, belowBarPath, completelyFillAboveBarPath, barData);
      _drawAboveBar(canvasWrapper, aboveBarPath, completelyFillBelowBarPath, barData);
      _drawBarShadow(canvasWrapper, barPath, barData);
      _drawBar(canvasWrapper, barPath, barData);
    }
  }

  void _drawBetweenBarsArea(
      CanvasWrapper canvasWrapper, LineChartData data, BetweenBarsData betweenBarsData) {
    final viewSize = canvasWrapper.size;
    final fromBarData = data.lineBarsData[betweenBarsData.fromIndex];
    final toBarData = data.lineBarsData[betweenBarsData.toIndex];

    final spots = <FlSpot>[];
    spots.addAll(toBarData.spots.reversed.toList());
    final fromBarPath = _generateBarPath(
      viewSize,
      fromBarData,
      fromBarData.spots,
    );
    final barPath = _generateBarPath(
      viewSize,
      toBarData.copyWith(spots: spots),
      toBarData.copyWith(spots: spots).spots,
      appendToPath: fromBarPath,
    );

    _drawBetweenBar(canvasWrapper, barPath, betweenBarsData);
  }

  void _drawDots(CanvasWrapper canvasWrapper, LineChartBarData barData) {
    if (!barData.dotData.show || barData.spots == null || barData.spots.isEmpty) {
      return;
    }
    final viewSize = getChartUsableDrawSize(canvasWrapper.size);

    final barXDelta = _getBarLineXLength(barData, viewSize);

    for (var i = 0; i < barData.spots.length; i++) {
      final spot = barData.spots[i];
      if (spot.isNotNull() && barData.dotData.checkToShowDot(spot, barData)) {
        final x = getPixelX(spot.x, viewSize);
        final y = getPixelY(spot.y, viewSize);

        final xPercentInLine = ((x - getLeftOffsetDrawSize()) / barXDelta) * 100;

        final painter = barData.dotData.getDotPainter(spot, xPercentInLine, barData, i);

        canvasWrapper.drawDot(painter, spot, Offset(x, y));
      }
    }
  }

  void _drawTouchedSpotsIndicator(CanvasWrapper canvasWrapper, LineChartBarData barData) {
    final viewSize = canvasWrapper.size;
    final chartViewSize = getChartUsableDrawSize(viewSize);

    final barXDelta = _getBarLineXLength(barData, viewSize);

    // Todo technical debt, we can read the TouchedSpotIndicatorData directly,
    // Todo instead of mapping indexes to TouchedSpotIndicatorData
    final indicatorsData =
        data.lineTouchData.getTouchedSpotIndicator(barData, barData.showingIndicators);

    if (indicatorsData.length != barData.showingIndicators.length) {
      throw Exception('indicatorsData and touchedSpotOffsets size should be same');
    }

    for (var i = 0; i < barData.showingIndicators.length; i++) {
      final indicatorData = indicatorsData[i];
      final index = barData.showingIndicators[i];
      final spot = barData.spots[index];

      if (indicatorData == null) {
        continue;
      }

      final touchedSpot =
          Offset(getPixelX(spot.x, chartViewSize), getPixelY(spot.y, chartViewSize));

      /// For drawing the dot
      final showingDots =
          indicatorData.touchedSpotDotData != null && indicatorData.touchedSpotDotData.show;
      var dotHeight = 0.0;
      FlDotPainter dotPainter;

      if (showingDots) {
        final xPercentInLine = ((touchedSpot.dx - getLeftOffsetDrawSize()) / barXDelta) * 100;
        dotPainter =
            indicatorData.touchedSpotDotData.getDotPainter(spot, xPercentInLine, barData, index);
        dotHeight = dotPainter.getSize(spot).height;
      }

      /// For drawing the indicator line
      final bottom = Offset(touchedSpot.dx, getTopOffsetDrawSize() + chartViewSize.height);
      final top = Offset(getPixelX(spot.x, chartViewSize), getTopOffsetDrawSize());

      /// Draw to top or to the touchedSpot
      final lineEnd =
          data.lineTouchData.fullHeightTouchLine ? top : touchedSpot + Offset(0, dotHeight / 2);

      _touchLinePaint.color = indicatorData.indicatorBelowLine.color;
      _touchLinePaint.strokeWidth = indicatorData.indicatorBelowLine.strokeWidth;
      _touchLinePaint.transparentIfWidthIsZero();

      canvasWrapper.drawDashedLine(
          bottom, lineEnd, _touchLinePaint, indicatorData.indicatorBelowLine.dashArray);

      /// Draw the indicator dot
      if (showingDots) {
        canvasWrapper.drawDot(dotPainter, spot, touchedSpot);
      }
    }
  }

  /// Generates a path, based on [LineChartBarData.isStepChart] for step style, and normal style.
  Path _generateBarPath(Size viewSize, LineChartBarData barData, List<FlSpot> barSpots,
      {Path appendToPath}) {
    if (barData.isStepLineChart) {
      return _generateStepBarPath(viewSize, barData, barSpots, appendToPath: appendToPath);
    } else {
      return _generateNormalBarPath(viewSize, barData, barSpots, appendToPath: appendToPath);
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
  Path _generateNormalBarPath(Size viewSize, LineChartBarData barData, List<FlSpot> barSpots,
      {Path appendToPath}) {
    viewSize = getChartUsableDrawSize(viewSize);
    final path = appendToPath ?? Path();
    final size = barSpots.length;

    var temp = const Offset(0.0, 0.0);

    final x = getPixelX(barSpots[0].x, viewSize);
    final y = getPixelY(barSpots[0].y, viewSize);
    if (appendToPath == null) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
    for (var i = 1; i < size; i++) {
      /// CurrentSpot
      final current = Offset(
        getPixelX(barSpots[i].x, viewSize),
        getPixelY(barSpots[i].y, viewSize),
      );

      /// previous spot
      final previous = Offset(
        getPixelX(barSpots[i - 1].x, viewSize),
        getPixelY(barSpots[i - 1].y, viewSize),
      );

      /// next point
      final next = Offset(
        getPixelX(barSpots[i + 1 < size ? i + 1 : i].x, viewSize),
        getPixelY(barSpots[i + 1 < size ? i + 1 : i].y, viewSize),
      );

      final controlPoint1 = previous + temp;

      /// if the isCurved is false, we set 0 for smoothness,
      /// it means we should not have any smoothness then we face with
      /// the sharped corners line
      final smoothness = barData.isCurved ? barData.curveSmoothness : 0.0;
      temp = ((next - previous) / 2) * smoothness;

      if (barData.preventCurveOverShooting) {
        if ((next - current).dy <= barData.preventCurveOvershootingThreshold ||
            (current - previous).dy <= barData.preventCurveOvershootingThreshold) {
          temp = Offset(temp.dx, 0);
        }

        if ((next - current).dx <= barData.preventCurveOvershootingThreshold ||
            (current - previous).dx <= barData.preventCurveOvershootingThreshold) {
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

  /// generates a `Step Line Chart` bar style path.
  Path _generateStepBarPath(Size viewSize, LineChartBarData barData, List<FlSpot> barSpots,
      {Path appendToPath}) {
    viewSize = getChartUsableDrawSize(viewSize);
    final path = appendToPath ?? Path();
    final size = barSpots.length;

    final x = getPixelX(barSpots[0].x, viewSize);
    final y = getPixelY(barSpots[0].y, viewSize);
    if (appendToPath == null) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
    for (var i = 0; i < size; i++) {
      /// CurrentSpot
      final current = Offset(
        getPixelX(barSpots[i].x, viewSize),
        getPixelY(barSpots[i].y, viewSize),
      );

      /// next point
      final next = Offset(
        getPixelX(barSpots[i + 1 < size ? i + 1 : i].x, viewSize),
        getPixelY(barSpots[i + 1 < size ? i + 1 : i].y, viewSize),
      );

      final stepDirection = barData.lineChartStepData.stepDirection;

      // middle
      if (current.dy == next.dy) {
        path.lineTo(next.dx, next.dy);
      } else {
        final deltaX = next.dx - current.dx;

        path.lineTo(current.dx + deltaX - (deltaX * stepDirection), current.dy);
        path.lineTo(current.dx + deltaX - (deltaX * stepDirection), next.dy);
        path.lineTo(next.dx, next.dy);
      }
    }

    return path;
  }

  /// it generates below area path using a copy of [barPath],
  /// if cutOffY is provided by the [BarAreaData], it cut the area to the provided cutOffY value,
  /// if [fillCompletely] is true, the cutOffY will be ignored,
  /// and a completely filled path will return,
  Path _generateBelowBarPath(
      Size viewSize, LineChartBarData barData, Path barPath, List<FlSpot> barSpots,
      {bool fillCompletely = false}) {
    final belowBarPath = Path.from(barPath);

    final chartViewSize = getChartUsableDrawSize(viewSize);

    /// Line To Bottom Right
    var x = getPixelX(barSpots[barSpots.length - 1].x, chartViewSize);
    double y;
    if (!fillCompletely && barData.belowBarData.applyCutOffY) {
      y = getPixelY(barData.belowBarData.cutOffY, chartViewSize);
    } else {
      y = chartViewSize.height + getTopOffsetDrawSize();
    }
    belowBarPath.lineTo(x, y);

    /// Line To Bottom Left
    x = getPixelX(barSpots[0].x, chartViewSize);
    if (!fillCompletely && barData.belowBarData.applyCutOffY) {
      y = getPixelY(barData.belowBarData.cutOffY, chartViewSize);
    } else {
      y = chartViewSize.height + getTopOffsetDrawSize();
    }
    belowBarPath.lineTo(x, y);

    /// Line To Top Left
    x = getPixelX(barSpots[0].x, chartViewSize);
    y = getPixelY(barSpots[0].y, chartViewSize);
    belowBarPath.lineTo(x, y);
    belowBarPath.close();

    return belowBarPath;
  }

  /// it generates above area path using a copy of [barPath],
  /// if cutOffY is provided by the [BarAreaData], it cut the area to the provided cutOffY value,
  /// if [fillCompletely] is true, the cutOffY will be ignored,
  /// and a completely filled path will return,
  Path _generateAboveBarPath(
      Size viewSize, LineChartBarData barData, Path barPath, List<FlSpot> barSpots,
      {bool fillCompletely = false}) {
    final aboveBarPath = Path.from(barPath);

    final chartViewSize = getChartUsableDrawSize(viewSize);

    /// Line To Top Right
    var x = getPixelX(barSpots[barSpots.length - 1].x, chartViewSize);
    double y;
    if (!fillCompletely && barData.aboveBarData.applyCutOffY) {
      y = getPixelY(barData.aboveBarData.cutOffY, chartViewSize);
    } else {
      y = getTopOffsetDrawSize();
    }
    aboveBarPath.lineTo(x, y);

    /// Line To Top Left
    x = getPixelX(barSpots[0].x, chartViewSize);
    if (!fillCompletely && barData.aboveBarData.applyCutOffY) {
      y = getPixelY(barData.aboveBarData.cutOffY, chartViewSize);
    } else {
      y = getTopOffsetDrawSize();
    }
    aboveBarPath.lineTo(x, y);

    /// Line To Bottom Left
    x = getPixelX(barSpots[0].x, chartViewSize);
    y = getPixelY(barSpots[0].y, chartViewSize);
    aboveBarPath.lineTo(x, y);
    aboveBarPath.close();

    return aboveBarPath;
  }

  /// firstly we draw [belowBarPath], then if cutOffY value is provided in [BarAreaData],
  /// [belowBarPath] maybe draw over the main bar line,
  /// then to fix the problem we use [filledAboveBarPath] to clear the above section from this draw.
  void _drawBelowBar(CanvasWrapper canvasWrapper, Path belowBarPath, Path filledAboveBarPath,
      LineChartBarData barData) {
    if (!barData.belowBarData.show) {
      return;
    }

    final viewSize = canvasWrapper.size;
    final chartViewSize = getChartUsableDrawSize(viewSize);

    /// here we update the [belowBarPaint] to draw the solid color
    /// or the gradient based on the [BarAreaData] class.
    if (barData.belowBarData.colors.length == 1) {
      _barAreaPaint.color = barData.belowBarData.colors[0];
      _barAreaPaint.shader = null;
    } else {
      var stops = <double>[];
      if (barData.belowBarData.gradientColorStops == null ||
          barData.belowBarData.gradientColorStops.length != barData.belowBarData.colors.length) {
        /// provided gradientColorStops is invalid and we calculate it here
        barData.belowBarData.colors.asMap().forEach((index, color) {
          final percent = 1.0 / barData.belowBarData.colors.length;
          stops.add(percent * index);
        });
      } else {
        stops = barData.belowBarData.gradientColorStops;
      }

      final from = barData.belowBarData.gradientFrom;
      final to = barData.belowBarData.gradientTo;
      _barAreaPaint.shader = ui.Gradient.linear(
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
      canvasWrapper.saveLayer(Rect.fromLTWH(0, 0, viewSize.width, viewSize.height), Paint());
    }

    canvasWrapper.drawPath(belowBarPath, _barAreaPaint);

    // clear the above area that get out of the bar line
    if (barData.belowBarData.applyCutOffY) {
      canvasWrapper.drawPath(filledAboveBarPath, _clearBarAreaPaint);
      canvasWrapper.restore();
    }

    /// draw below spots line
    if (barData.belowBarData.spotsLine != null && barData.belowBarData.spotsLine.show) {
      for (var spot in barData.spots) {
        if (barData.belowBarData.spotsLine.checkToShowSpotLine(spot)) {
          final from = Offset(
            getPixelX(spot.x, chartViewSize),
            getPixelY(spot.y, chartViewSize),
          );

          final bottomPadding = getExtraNeededVerticalSpace() - getTopOffsetDrawSize();
          Offset to;

          // Check applyCutOffY
          if (barData.belowBarData.spotsLine.applyCutOffY && barData.belowBarData.applyCutOffY) {
            to = Offset(
              getPixelX(spot.x, chartViewSize),
              getPixelY(barData.belowBarData.cutOffY, chartViewSize),
            );
          } else {
            to = Offset(
              getPixelX(spot.x, chartViewSize),
              viewSize.height - bottomPadding,
            );
          }

          _barAreaLinesPaint.color = barData.belowBarData.spotsLine.flLineStyle.color;
          _barAreaLinesPaint.strokeWidth = barData.belowBarData.spotsLine.flLineStyle.strokeWidth;
          _barAreaLinesPaint.transparentIfWidthIsZero();

          canvasWrapper.drawDashedLine(
              from, to, _barAreaLinesPaint, barData.belowBarData.spotsLine.flLineStyle.dashArray);
        }
      }
    }
  }

  /// firstly we draw [aboveBarPath], then if cutOffY value is provided in [BarAreaData],
  /// [aboveBarPath] maybe draw over the main bar line,
  /// then to fix the problem we use [filledBelowBarPath] to clear the above section from this draw.
  void _drawAboveBar(CanvasWrapper canvasWrapper, Path aboveBarPath, Path filledBelowBarPath,
      LineChartBarData barData) {
    if (!barData.aboveBarData.show) {
      return;
    }

    final viewSize = canvasWrapper.size;
    final chartViewSize = getChartUsableDrawSize(viewSize);

    /// here we update the [aboveBarPaint] to draw the solid color
    /// or the gradient based on the [BarAreaData] class.
    if (barData.aboveBarData.colors.length == 1) {
      _barAreaPaint.color = barData.aboveBarData.colors[0];
      _barAreaPaint.shader = null;
    } else {
      var stops = <double>[];
      if (barData.aboveBarData.gradientColorStops == null ||
          barData.aboveBarData.gradientColorStops.length != barData.aboveBarData.colors.length) {
        /// provided gradientColorStops is invalid and we calculate it here
        barData.colors.asMap().forEach((index, color) {
          final percent = 1.0 / barData.colors.length;
          stops.add(percent * index);
        });
      } else {
        stops = barData.aboveBarData.gradientColorStops;
      }

      final from = barData.aboveBarData.gradientFrom;
      final to = barData.aboveBarData.gradientTo;
      _barAreaPaint.shader = ui.Gradient.linear(
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

    if (barData.aboveBarData.applyCutOffY) {
      canvasWrapper.saveLayer(Rect.fromLTWH(0, 0, viewSize.width, viewSize.height), Paint());
    }

    canvasWrapper.drawPath(aboveBarPath, _barAreaPaint);

    // clear the above area that get out of the bar line
    if (barData.aboveBarData.applyCutOffY) {
      canvasWrapper.drawPath(filledBelowBarPath, _clearBarAreaPaint);
      canvasWrapper.restore();
    }

    /// draw above spots line
    if (barData.aboveBarData.spotsLine != null && barData.aboveBarData.spotsLine.show) {
      for (var spot in barData.spots) {
        if (barData.aboveBarData.spotsLine.checkToShowSpotLine(spot)) {
          final from = Offset(
            getPixelX(spot.x, chartViewSize),
            getPixelY(spot.y, chartViewSize),
          );

          Offset to;

          // Check applyCutOffY
          if (barData.aboveBarData.spotsLine.applyCutOffY && barData.aboveBarData.applyCutOffY) {
            to = Offset(
              getPixelX(spot.x, chartViewSize),
              getPixelY(barData.aboveBarData.cutOffY, chartViewSize),
            );
          } else {
            to = Offset(
              getPixelX(spot.x, chartViewSize),
              getTopOffsetDrawSize(),
            );
          }

          _barAreaLinesPaint.color = barData.aboveBarData.spotsLine.flLineStyle.color;
          _barAreaLinesPaint.strokeWidth = barData.aboveBarData.spotsLine.flLineStyle.strokeWidth;
          _barAreaLinesPaint.transparentIfWidthIsZero();

          canvasWrapper.drawDashedLine(
              from, to, _barAreaLinesPaint, barData.aboveBarData.spotsLine.flLineStyle.dashArray);
        }
      }
    }
  }

  void _drawBetweenBar(
      CanvasWrapper canvasWrapper, Path aboveBarPath, BetweenBarsData betweenBarsData) {
    final viewSize = canvasWrapper.size;
    final chartViewSize = getChartUsableDrawSize(viewSize);

    /// here we update the [betweenBarsData] to draw the solid color
    /// or the gradient based on the [BetweenBarsData] class.
    if (betweenBarsData.colors.length == 1) {
      _barAreaPaint.color = betweenBarsData.colors[0];
      _barAreaPaint.shader = null;
    } else {
      var stops = <double>[];
      if (betweenBarsData.gradientColorStops == null ||
          betweenBarsData.gradientColorStops.length != betweenBarsData.colors.length) {
        /// provided gradientColorStops is invalid and we calculate it here
        betweenBarsData.colors.asMap().forEach((index, color) {
          final percent = 1.0 / betweenBarsData.colors.length;
          stops.add(percent * index);
        });
      } else {
        stops = betweenBarsData.gradientColorStops;
      }

      final from = betweenBarsData.gradientFrom;
      final to = betweenBarsData.gradientTo;
      _barAreaPaint.shader = ui.Gradient.linear(
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

    canvasWrapper.saveLayer(Rect.fromLTWH(0, 0, viewSize.width, viewSize.height), Paint());
    canvasWrapper.drawPath(aboveBarPath, _barAreaPaint);

    // clear the above area that get out of the bar line
    canvasWrapper.restore();
  }

  /// draw the main bar line's shadow by the [barPath]
  void _drawBarShadow(CanvasWrapper canvasWrapper, Path barPath, LineChartBarData barData) {
    if (!barData.show || barData.shadow.color.opacity == 0.0) {
      return;
    }

    _barPaint.strokeCap = barData.isStrokeCapRound ? StrokeCap.round : StrokeCap.butt;
    _barPaint.color = barData.shadow.color;
    _barPaint.shader = null;
    _barPaint.strokeWidth = barData.barWidth;
    _barPaint.color = barData.shadow.color;
    _barPaint.maskFilter =
        MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(barData.shadow.blurRadius));

    barPath = barPath.toDashedPath(barData.dashArray);

    barPath = barPath.shift(barData.shadow.offset);

    canvasWrapper.drawPath(
      barPath,
      _barPaint,
    );
  }

  static double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }

  /// draw the main bar line by the [barPath]
  void _drawBar(CanvasWrapper canvasWrapper, Path barPath, LineChartBarData barData) {
    if (!barData.show) {
      return;
    }
    final viewSize = canvasWrapper.size;
    final chartViewSize = getChartUsableDrawSize(viewSize);

    _barPaint.strokeCap = barData.isStrokeCapRound ? StrokeCap.round : StrokeCap.butt;

    /// here we update the [barPaint] to draw the solid color or
    /// the gradient color,
    /// if we have one color, solid color will apply,
    /// but if we have more than one color, gradient will apply.
    if (barData.colors.length == 1) {
      _barPaint.color = barData.colors[0];
      _barPaint.shader = null;
    } else {
      var stops = <double>[];
      if (barData.colorStops == null || barData.colorStops.length != barData.colors.length) {
        /// provided colorStops is invalid and we calculate it here
        barData.colors.asMap().forEach((index, color) {
          final percent = 1.0 / barData.colors.length;
          stops.add(percent * index);
        });
      } else {
        stops = barData.colorStops;
      }

      final from = barData.gradientFrom;
      final to = barData.gradientTo;

      _barPaint.shader = ui.Gradient.linear(
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

    _barPaint.maskFilter = null;
    _barPaint.strokeWidth = barData.barWidth;
    _barPaint.transparentIfWidthIsZero();

    barPath = barPath.toDashedPath(barData.dashArray);
    canvasWrapper.drawPath(barPath, _barPaint);
  }

  void _drawTitles(CanvasWrapper canvasWrapper) {
    if (!targetData.titlesData.show) {
      return;
    }
    final viewSize = getChartUsableDrawSize(canvasWrapper.size);

    // Left Titles
    final leftTitles = targetData.titlesData.leftTitles;
    final leftInterval =
        leftTitles.interval ?? getEfficientInterval(viewSize.height, data.verticalDiff);
    if (leftTitles.showTitles) {
      var verticalSeek = data.minY;
      while (verticalSeek <= data.maxY) {
        if (leftTitles.checkToShowTitle(
            data.minY, data.maxY, leftTitles, leftInterval, verticalSeek)) {
          var x = 0 + getLeftOffsetDrawSize();
          var y = getPixelY(verticalSeek, viewSize);

          final text = leftTitles.getTitles(verticalSeek);

          final span = TextSpan(style: leftTitles.getTextStyles(verticalSeek), text: text);
          final tp = TextPainter(
              text: span,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              textScaleFactor: textScale);
          tp.layout(maxWidth: getExtraNeededHorizontalSpace());
          x -= tp.width + leftTitles.margin;
          y -= tp.height / 2;
          canvasWrapper.save();
          canvasWrapper.translate(x + tp.width / 2, y + tp.height / 2);
          canvasWrapper.rotate(radians(leftTitles.rotateAngle));
          canvasWrapper.translate(-(x + tp.width / 2), -(y + tp.height / 2));
          y -= translateRotatedPosition(tp.width, leftTitles.rotateAngle);
          canvasWrapper.drawText(tp, Offset(x, y));
          canvasWrapper.restore();
        }
        if (data.maxY - verticalSeek < leftInterval && data.maxY != verticalSeek) {
          verticalSeek = data.maxY;
        } else {
          verticalSeek += leftInterval;
        }
      }
    }

    // Top titles
    final topTitles = targetData.titlesData.topTitles;
    final topInterval =
        topTitles.interval ?? getEfficientInterval(viewSize.width, data.horizontalDiff);
    if (topTitles.showTitles) {
      var horizontalSeek = data.minX;
      while (horizontalSeek <= data.maxX) {
        if (topTitles.checkToShowTitle(
            data.minX, data.maxX, topTitles, topInterval, horizontalSeek)) {
          var x = getPixelX(horizontalSeek, viewSize);
          var y = getTopOffsetDrawSize();

          final text = topTitles.getTitles(horizontalSeek);

          final span = TextSpan(style: topTitles.getTextStyles(horizontalSeek), text: text);
          final tp = TextPainter(
              text: span,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              textScaleFactor: textScale);
          tp.layout();

          x -= tp.width / 2;
          y -= topTitles.margin + tp.height;
          canvasWrapper.save();
          canvasWrapper.translate(x + tp.width / 2, y + tp.height / 2);
          canvasWrapper.rotate(radians(topTitles.rotateAngle));
          canvasWrapper.translate(-(x + tp.width / 2), -(y + tp.height / 2));
          x -= translateRotatedPosition(tp.width, topTitles.rotateAngle);
          canvasWrapper.drawText(tp, Offset(x, y));
          canvasWrapper.restore();
        }
        if (data.maxX - horizontalSeek < topInterval && data.maxX != horizontalSeek) {
          horizontalSeek = data.maxX;
        } else {
          horizontalSeek += topInterval;
        }
      }
    }

    // Right Titles
    final rightTitles = targetData.titlesData.rightTitles;
    final rightInterval =
        rightTitles.interval ?? getEfficientInterval(viewSize.height, data.verticalDiff);
    if (rightTitles.showTitles) {
      var verticalSeek = data.minY;
      while (verticalSeek <= data.maxY) {
        if (rightTitles.checkToShowTitle(
            data.minY, data.maxY, rightTitles, rightInterval, verticalSeek)) {
          var x = viewSize.width + getLeftOffsetDrawSize();
          var y = getPixelY(verticalSeek, viewSize);

          final text = rightTitles.getTitles(verticalSeek);

          final span = TextSpan(style: rightTitles.getTextStyles(verticalSeek), text: text);
          final tp = TextPainter(
              text: span,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              textScaleFactor: textScale);
          tp.layout(maxWidth: getExtraNeededHorizontalSpace());

          x += rightTitles.margin;
          y -= tp.height / 2;
          canvasWrapper.save();
          canvasWrapper.translate(x + tp.width / 2, y + tp.height / 2);
          canvasWrapper.rotate(radians(rightTitles.rotateAngle));
          canvasWrapper.translate(-(x + tp.width / 2), -(y + tp.height / 2));
          y += translateRotatedPosition(tp.width, leftTitles.rotateAngle);
          canvasWrapper.drawText(tp, Offset(x, y));
          canvasWrapper.restore();
        }

        if (data.maxY - verticalSeek < rightInterval && data.maxY != verticalSeek) {
          verticalSeek = data.maxY;
        } else {
          verticalSeek += rightInterval;
        }
      }
    }

    // Bottom titles
    final bottomTitles = targetData.titlesData.bottomTitles;
    final bottomInterval =
        bottomTitles.interval ?? getEfficientInterval(viewSize.width, data.horizontalDiff);
    if (bottomTitles.showTitles) {
      var horizontalSeek = data.minX;
      while (horizontalSeek <= data.maxX) {
        if (bottomTitles.checkToShowTitle(
            data.minX, data.maxX, bottomTitles, bottomInterval, horizontalSeek)) {
          var x = getPixelX(horizontalSeek, viewSize);
          var y = viewSize.height + getTopOffsetDrawSize();
          final text = bottomTitles.getTitles(horizontalSeek);
          final span = TextSpan(style: bottomTitles.getTextStyles(horizontalSeek), text: text);
          final tp = TextPainter(
              text: span,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              textScaleFactor: textScale);
          tp.layout();

          x -= tp.width / 2;
          y += bottomTitles.margin;
          canvasWrapper.save();
          canvasWrapper.translate(x + tp.width / 2, y + tp.height / 2);
          canvasWrapper.rotate(radians(bottomTitles.rotateAngle));
          canvasWrapper.translate(-(x + tp.width / 2), -(y + tp.height / 2));
          x += translateRotatedPosition(tp.width, bottomTitles.rotateAngle);
          canvasWrapper.drawText(tp, Offset(x, y));
          canvasWrapper.restore();
        }

        if (data.maxX - horizontalSeek < bottomInterval && data.maxX != horizontalSeek) {
          horizontalSeek = data.maxX;
        } else {
          horizontalSeek += bottomInterval;
        }
      }
    }
  }

  void _drawExtraLines(CanvasWrapper canvasWrapper) {
    if (data.extraLinesData == null) {
      return;
    }

    final viewSize = canvasWrapper.size;
    final chartUsableSize = getChartUsableDrawSize(viewSize);

    if (data.extraLinesData.horizontalLines.isNotEmpty) {
      for (var line in data.extraLinesData.horizontalLines) {
        final leftChartPadding = getLeftOffsetDrawSize();
        final from = Offset(leftChartPadding, getPixelY(line.y, chartUsableSize));

        final rightChartPadding = getExtraNeededHorizontalSpace() - getLeftOffsetDrawSize();
        final to = Offset(viewSize.width - rightChartPadding, getPixelY(line.y, chartUsableSize));

        _extraLinesPaint.color = line.color;
        _extraLinesPaint.strokeWidth = line.strokeWidth;
        _extraLinesPaint.transparentIfWidthIsZero();

        canvasWrapper.drawDashedLine(from, to, _extraLinesPaint, line.dashArray);

        if (line.sizedPicture != null) {
          final centerX = line.sizedPicture.width / 2;
          final centerY = line.sizedPicture.height / 2;
          final xPosition = leftChartPadding - centerX;
          final yPosition = to.dy - centerY;

          canvasWrapper.save();
          canvasWrapper.translate(xPosition, yPosition);
          canvasWrapper.drawPicture(line.sizedPicture.picture);
          canvasWrapper.restore();
        }

        if (line.image != null) {
          final centerX = line.image.width / 2;
          final centerY = line.image.height / 2;
          final centeredImageOffset = Offset(leftChartPadding - centerX, to.dy - centerY);
          canvasWrapper.drawImage(line.image, centeredImageOffset, _imagePaint);
        }

        if (line.label != null && line.label.show) {
          final label = line.label;
          final style = TextStyle(fontSize: 11, color: line.color).merge(label.style);
          final EdgeInsets padding = label.padding ?? EdgeInsets.zero;

          final span = TextSpan(
            text: label.labelResolver(line),
            style: style,
          );

          final tp = TextPainter(
            text: span,
            textDirection: TextDirection.ltr,
          );

          tp.layout();
          canvasWrapper.drawText(
              tp,
              label.alignment.withinRect(
                Rect.fromLTRB(
                  from.dx + padding.left,
                  from.dy - padding.bottom - tp.height,
                  to.dx - padding.right - tp.width,
                  to.dy + padding.top,
                ),
              ));
        }
      }
    }

    if (data.extraLinesData.verticalLines.isNotEmpty) {
      for (var line in data.extraLinesData.verticalLines) {
        final topChartPadding = getTopOffsetDrawSize();
        final from = Offset(getPixelX(line.x, chartUsableSize), topChartPadding);

        final bottomChartPadding = getExtraNeededVerticalSpace() - getTopOffsetDrawSize();
        final to = Offset(getPixelX(line.x, chartUsableSize), viewSize.height - bottomChartPadding);

        _extraLinesPaint.color = line.color;
        _extraLinesPaint.strokeWidth = line.strokeWidth;
        _extraLinesPaint.transparentIfWidthIsZero();

        canvasWrapper.drawDashedLine(from, to, _extraLinesPaint, line.dashArray);

        if (line.sizedPicture != null) {
          final centerX = line.sizedPicture.width / 2;
          final centerY = line.sizedPicture.height / 2;
          final xPosition = to.dx - centerX;
          final yPosition = viewSize.height - bottomChartPadding - centerY;

          canvasWrapper.save();
          canvasWrapper.translate(xPosition, yPosition);
          canvasWrapper.drawPicture(line.sizedPicture.picture);
          canvasWrapper.restore();
        }
        if (line.image != null) {
          final centerX = line.image.width / 2;
          final centerY = line.image.height / 2;
          final centeredImageOffset =
              Offset(to.dx - centerX, viewSize.height - bottomChartPadding - centerY);
          canvasWrapper.drawImage(line.image, centeredImageOffset, _imagePaint);
        }

        if (line.label != null && line.label.show) {
          final label = line.label;
          final style = TextStyle(fontSize: 11, color: line.color).merge(label.style);
          final EdgeInsets padding = label.padding ?? EdgeInsets.zero;

          final span = TextSpan(
            text: label.labelResolver(line),
            style: style,
          );

          final tp = TextPainter(
            text: span,
            textDirection: TextDirection.ltr,
          );

          tp.layout();

          canvasWrapper.drawText(
            tp,
            label.alignment.withinRect(
              Rect.fromLTRB(
                to.dx - padding.right - tp.width,
                from.dy + padding.top - topChartPadding,
                from.dx + padding.left,
                to.dy - padding.bottom + bottomChartPadding,
              ),
            ),
          );
        }
      }
    }
  }

  void _drawTouchTooltip(CanvasWrapper canvasWrapper, LineTouchTooltipData tooltipData,
      FlSpot showOnSpot, ShowingTooltipIndicators showingTooltipSpots) {
    final viewSize = canvasWrapper.size;
    final chartUsableSize = getChartUsableDrawSize(viewSize);

    const textsBelowMargin = 4;

    /// creating TextPainters to calculate the width and height of the tooltip
    final drawingTextPainters = <TextPainter>[];

    final tooltipItems = tooltipData.getTooltipItems(showingTooltipSpots.showingSpots);
    if (tooltipItems.length != showingTooltipSpots.showingSpots.length) {
      throw Exception('tooltipItems and touchedSpots size should be same');
    }

    for (var i = 0; i < showingTooltipSpots.showingSpots.length; i++) {
      final tooltipItem = tooltipItems[i];
      if (tooltipItem == null) {
        continue;
      }

      final span = TextSpan(style: tooltipItem.textStyle, text: tooltipItem.text);
      final tp = TextPainter(
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
    var biggerWidth = 0.0;
    var sumTextsHeight = 0.0;
    for (var tp in drawingTextPainters) {
      if (tp.width > biggerWidth) {
        biggerWidth = tp.width;
      }
      sumTextsHeight += tp.height;
    }
    sumTextsHeight += (drawingTextPainters.length - 1) * textsBelowMargin;

    /// if we have multiple bar lines,
    /// there are more than one FlCandidate on touch area,
    /// we should get the most top FlSpot Offset to draw the tooltip on top of it
    final mostTopOffset = Offset(
      getPixelX(showOnSpot.x, chartUsableSize),
      getPixelY(showOnSpot.y, chartUsableSize),
    );

    final tooltipWidth = biggerWidth + tooltipData.tooltipPadding.horizontal;
    final tooltipHeight = sumTextsHeight + tooltipData.tooltipPadding.vertical;

    double tooltipTopPosition;
    if (tooltipData.showOnTopOfTheChartBoxArea) {
      tooltipTopPosition = 0 - tooltipHeight - tooltipData.tooltipBottomMargin;
    } else {
      tooltipTopPosition = mostTopOffset.dy - tooltipHeight - tooltipData.tooltipBottomMargin;
    }

    /// draw the background rect with rounded radius
    var rect = Rect.fromLTWH(
      mostTopOffset.dx - (tooltipWidth / 2),
      tooltipTopPosition,
      tooltipWidth,
      tooltipHeight,
    );

    if (tooltipData.fitInsideHorizontally) {
      if (rect.left < 0) {
        final shiftAmount = 0 - rect.left;
        rect = Rect.fromLTRB(
          rect.left + shiftAmount,
          rect.top,
          rect.right + shiftAmount,
          rect.bottom,
        );
      }

      if (rect.right > viewSize.width) {
        final shiftAmount = rect.right - viewSize.width;
        rect = Rect.fromLTRB(
          rect.left - shiftAmount,
          rect.top,
          rect.right - shiftAmount,
          rect.bottom,
        );
      }
    }

    if (tooltipData.fitInsideVertically) {
      if (rect.top < 0) {
        final shiftAmount = 0 - rect.top;
        rect = Rect.fromLTRB(
          rect.left,
          rect.top + shiftAmount,
          rect.right,
          rect.bottom + shiftAmount,
        );
      }

      if (rect.bottom > viewSize.height) {
        final shiftAmount = rect.bottom - viewSize.height;
        rect = Rect.fromLTRB(
          rect.left,
          rect.top - shiftAmount,
          rect.right,
          rect.bottom - shiftAmount,
        );
      }
    }

    final radius = Radius.circular(tooltipData.tooltipRoundedRadius);
    final roundedRect = RRect.fromRectAndCorners(rect,
        topLeft: radius, topRight: radius, bottomLeft: radius, bottomRight: radius);
    _bgTouchTooltipPaint.color = tooltipData.tooltipBgColor;
    canvasWrapper.drawRRect(roundedRect, _bgTouchTooltipPaint);

    /// draw the texts one by one in below of each other
    var topPosSeek = tooltipData.tooltipPadding.top;
    for (var tp in drawingTextPainters) {
      final drawOffset = Offset(
        rect.center.dx - (tp.width / 2),
        rect.topCenter.dy + topPosSeek,
      );
      canvasWrapper.drawText(tp, drawOffset);
      topPosSeek += tp.height;
      topPosSeek += textsBelowMargin;
    }
  }

  double _getBarLineXLength(LineChartBarData barData, Size chartUsableSize) {
    if (barData.spots == null || barData.spots.isEmpty) {
      return 0.0;
    }

    final firstSpot = barData.spots[0];
    final firstSpotX = getPixelX(firstSpot.x, chartUsableSize);

    final lastSpot = barData.spots[barData.spots.length - 1];
    final lastSpotX = getPixelX(lastSpot.x, chartUsableSize);

    return lastSpotX - firstSpotX;
  }

  /// We add our needed horizontal space to parent needed.
  /// we have some titles that maybe draw in the left and right side of our chart,
  /// then we should draw the chart a with some left space,
  /// the left space is [getLeftOffsetDrawSize],
  /// and the whole space is [getExtraNeededHorizontalSpace]
  @override
  double getExtraNeededHorizontalSpace() {
    var sum = super.getExtraNeededHorizontalSpace();
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
    var sum = super.getExtraNeededVerticalSpace();
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

  /// Makes a [LineTouchResponse] based on the provided [FlTouchInput]
  ///
  /// Processes [FlTouchInput.getOffset] and checks
  /// the elements of the chart that are near the offset,
  /// then makes a [LineTouchResponse] from the elements that has been touched.
  @override
  LineTouchResponse handleTouch(FlTouchInput touchInput, Size size) {
    /// it holds list of nearest touched spots of each line
    /// and we use it to draw touch stuff on them
    final touchedSpots = <LineBarSpot>[];

    /// draw each line independently on the chart
    for (var i = 0; i < data.lineBarsData.length; i++) {
      final barData = data.lineBarsData[i];

      // find the nearest spot on touch area in this bar line
      final foundTouchedSpot = _getNearestTouchedSpot(size, touchInput.getOffset(), barData, i);
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

    final chartViewSize = getChartUsableDrawSize(viewSize);

    /// Find the nearest spot (on X axis)
    for (var i = 0; i < barData.spots.length; i++) {
      final spot = barData.spots[i];
      if (spot.isNotNull()) {
        if ((touchedPoint.dx - getPixelX(spot.x, chartViewSize)).abs() <=
            data.lineTouchData.touchSpotThreshold) {
          return LineBarSpot(barData, barDataPosition, spot);
        }
      }
    }

    return null;
  }

  /// Determines should it redraw the chart or not.
  ///
  /// If there is a change in the [LineChartData],
  /// [LineChartPainter] should repaint itself.
  @override
  bool shouldRepaint(LineChartPainter oldDelegate) => oldDelegate.data != data;
}
