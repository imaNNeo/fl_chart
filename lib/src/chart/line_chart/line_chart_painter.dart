import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_extensions.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/extensions/paint_extension.dart';
import 'package:fl_chart/src/extensions/path_extension.dart';
import 'package:fl_chart/src/extensions/text_align_extension.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';

/// Paints [LineChartData] in the canvas, it can be used in a [CustomPainter]
class LineChartPainter extends AxisChartPainter<LineChartData> {
  /// Paints [dataList] into canvas, it is the animating [LineChartData],
  /// [targetData] is the animation's target and remains the same
  /// during animation, then we should use it  when we need to show
  /// tooltips or something like that, because [dataList] is changing constantly.
  ///
  /// [textScale] used for scaling texts inside the chart,
  /// parent can use [MediaQuery.textScaleFactor] to respect
  /// the system's font size.
  LineChartPainter() : super() {
    _barPaint = Paint()..style = PaintingStyle.stroke;

    _barAreaPaint = Paint()..style = PaintingStyle.fill;

    _barAreaLinesPaint = Paint()..style = PaintingStyle.stroke;

    _clearBarAreaPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0x00000000)
      ..blendMode = BlendMode.dstIn;

    _touchLinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black;

    _bgTouchTooltipPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    _borderTouchTooltipPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.transparent
      ..strokeWidth = 1.0;
  }
  late Paint _barPaint;
  late Paint _barAreaPaint;
  late Paint _barAreaLinesPaint;
  late Paint _clearBarAreaPaint;
  late Paint _touchLinePaint;
  late Paint _bgTouchTooltipPaint;
  late Paint _borderTouchTooltipPaint;

  /// Paints [LineChartData] into the provided canvas.
  @override
  void paint(
    BuildContext context,
    CanvasWrapper canvasWrapper,
    PaintHolder<LineChartData> holder,
  ) {
    final data = holder.data;
    if (data.lineBarsData.isEmpty) {
      return;
    }

    if (data.clipData.any) {
      canvasWrapper.saveLayer(
        Rect.fromLTWH(
          0,
          -40,
          canvasWrapper.size.width + 40,
          canvasWrapper.size.height + 40,
        ),
        Paint(),
      );

      clipToBorder(canvasWrapper, holder);
    }

    super.paint(context, canvasWrapper, holder);

    for (final betweenBarsData in data.betweenBarsData) {
      drawBetweenBarsArea(canvasWrapper, data, betweenBarsData, holder);
    }

    if (!data.extraLinesData.extraLinesOnTop) {
      super.drawExtraLines(context, canvasWrapper, holder);
    }

    final lineIndexDrawingInfo = <LineIndexDrawingInfo>[];

    /// draw each line independently on the chart
    for (var i = 0; i < data.lineBarsData.length; i++) {
      final barData = data.lineBarsData[i];

      if (!barData.show) {
        continue;
      }

      drawBarLine(canvasWrapper, barData, holder);
      drawDots(canvasWrapper, barData, holder);

      if (data.extraLinesData.extraLinesOnTop) {
        super.drawExtraLines(context, canvasWrapper, holder);
      }

      final indicatorsData = data.lineTouchData
          .getTouchedSpotIndicator(barData, barData.showingIndicators);

      if (indicatorsData.length != barData.showingIndicators.length) {
        throw Exception(
          'indicatorsData and touchedSpotOffsets size should be same',
        );
      }

      for (var j = 0; j < barData.showingIndicators.length; j++) {
        final indicatorData = indicatorsData[j];
        final index = barData.showingIndicators[j];
        if (index < 0 || index >= barData.spots.length) {
          continue;
        }
        final spot = barData.spots[index];

        if (indicatorData == null) {
          continue;
        }
        lineIndexDrawingInfo.add(
          LineIndexDrawingInfo(barData, i, spot, index, indicatorData),
        );
      }
    }

    drawTouchedSpotsIndicator(canvasWrapper, lineIndexDrawingInfo, holder);

    if (data.clipData.any) {
      canvasWrapper.restore();
    }

    // Draw touch tooltip on most top spot
    for (var i = 0; i < data.showingTooltipIndicators.length; i++) {
      var tooltipSpots = data.showingTooltipIndicators[i];

      final showingBarSpots = tooltipSpots.showingSpots;
      if (showingBarSpots.isEmpty) {
        continue;
      }
      final barSpots = List<LineBarSpot>.of(showingBarSpots);
      FlSpot topSpot = barSpots[0];
      for (final barSpot in barSpots) {
        if (barSpot.y > topSpot.y) {
          topSpot = barSpot;
        }
      }
      tooltipSpots = ShowingTooltipIndicators(barSpots);

      drawTouchTooltip(
        context,
        canvasWrapper,
        data.lineTouchData.touchTooltipData,
        topSpot,
        tooltipSpots,
        holder,
      );
    }
  }

  @visibleForTesting
  void clipToBorder(
    CanvasWrapper canvasWrapper,
    PaintHolder<LineChartData> holder,
  ) {
    final data = holder.data;
    final viewSize = canvasWrapper.size;
    final clip = data.clipData;
    final border = data.borderData.show ? data.borderData.border : null;

    var left = 0.0;
    var top = 0.0;
    var right = viewSize.width;
    var bottom = viewSize.height;

    if (clip.left) {
      final borderWidth = border?.left.width ?? 0;
      left = borderWidth / 2;
    }
    if (clip.top) {
      final borderWidth = border?.top.width ?? 0;
      top = borderWidth / 2;
    }
    if (clip.right) {
      final borderWidth = border?.right.width ?? 0;
      right = viewSize.width - (borderWidth / 2);
    }
    if (clip.bottom) {
      final borderWidth = border?.bottom.width ?? 0;
      bottom = viewSize.height - (borderWidth / 2);
    }

    canvasWrapper.clipRect(Rect.fromLTRB(left, top, right, bottom));
  }

  @visibleForTesting
  void drawBarLine(
    CanvasWrapper canvasWrapper,
    LineChartBarData barData,
    PaintHolder<LineChartData> holder,
  ) {
    final viewSize = canvasWrapper.size;
    final barList = barData.spots.splitByNullSpots();

    // paint each sublist that was built above
    // bar is passed in separately from barData
    // because barData is the whole line
    // and bar is a piece of that line
    for (final bar in barList) {
      final barPath = generateBarPath(viewSize, barData, bar, holder);

      final belowBarPath =
          generateBelowBarPath(viewSize, barData, barPath, bar, holder);
      final completelyFillBelowBarPath = generateBelowBarPath(
        viewSize,
        barData,
        barPath,
        bar,
        holder,
        fillCompletely: true,
      );
      final aboveBarPath =
          generateAboveBarPath(viewSize, barData, barPath, bar, holder);
      final completelyFillAboveBarPath = generateAboveBarPath(
        viewSize,
        barData,
        barPath,
        bar,
        holder,
        fillCompletely: true,
      );

      drawBelowBar(
        canvasWrapper,
        belowBarPath,
        completelyFillAboveBarPath,
        holder,
        barData,
      );
      drawAboveBar(
        canvasWrapper,
        aboveBarPath,
        completelyFillBelowBarPath,
        holder,
        barData,
      );
      drawBarShadow(canvasWrapper, barPath, barData);
      drawBar(canvasWrapper, barPath, barData, holder);
    }
  }

  @visibleForTesting
  void drawBetweenBarsArea(
    CanvasWrapper canvasWrapper,
    LineChartData data,
    BetweenBarsData betweenBarsData,
    PaintHolder<LineChartData> holder,
  ) {
    final viewSize = canvasWrapper.size;
    final fromBarData = data.lineBarsData[betweenBarsData.fromIndex];
    final toBarData = data.lineBarsData[betweenBarsData.toIndex];

    final fromBarSplitLines = fromBarData.spots.splitByNullSpots();
    final toBarSplitLines = toBarData.spots.splitByNullSpots();

    if (fromBarSplitLines.length != toBarSplitLines.length) {
      throw ArgumentError(
        'Cannot draw betWeenBarsArea when null spots are inconsistent.',
      );
    }

    for (var i = 0; i < fromBarSplitLines.length; i++) {
      final fromSpots = fromBarSplitLines[i];
      final toSpots = toBarSplitLines[i].reversed.toList();

      final fromBarPath = generateBarPath(
        viewSize,
        fromBarData,
        fromSpots,
        holder,
      );
      final barPath = generateBarPath(
        viewSize,
        toBarData.copyWith(spots: toSpots),
        toSpots,
        holder,
        appendToPath: fromBarPath,
      );
      final left = min(fromBarData.mostLeftSpot.x, toBarData.mostLeftSpot.x);
      final top = max(fromBarData.mostTopSpot.y, toBarData.mostTopSpot.y);
      final right = max(fromBarData.mostRightSpot.x, toBarData.mostRightSpot.x);
      final bottom = min(
        fromBarData.mostBottomSpot.y,
        toBarData.mostBottomSpot.y,
      );
      final aroundRect = Rect.fromLTRB(
        getPixelX(left, viewSize, holder),
        getPixelY(top, viewSize, holder),
        getPixelX(right, viewSize, holder),
        getPixelY(bottom, viewSize, holder),
      );

      drawBetweenBar(
        canvasWrapper,
        barPath,
        betweenBarsData,
        aroundRect,
        holder,
      );
    }
  }

  @visibleForTesting
  void drawDots(
    CanvasWrapper canvasWrapper,
    LineChartBarData barData,
    PaintHolder<LineChartData> holder,
  ) {
    if (!barData.dotData.show || barData.spots.isEmpty) {
      return;
    }
    final viewSize = canvasWrapper.size;

    final barXDelta = getBarLineXLength(barData, viewSize, holder);

    for (var i = 0; i < barData.spots.length; i++) {
      final spot = barData.spots[i];
      if (spot.isNotNull() && barData.dotData.checkToShowDot(spot, barData)) {
        final x = getPixelX(spot.x, viewSize, holder);
        final y = getPixelY(spot.y, viewSize, holder);
        final xPercentInLine = (x / barXDelta) * 100;
        final painter =
            barData.dotData.getDotPainter(spot, xPercentInLine, barData, i);

        canvasWrapper.drawDot(painter, spot, Offset(x, y));
      }
    }
  }

  @visibleForTesting
  void drawTouchedSpotsIndicator(
    CanvasWrapper canvasWrapper,
    List<LineIndexDrawingInfo> lineIndexDrawingInfo,
    PaintHolder<LineChartData> holder,
  ) {
    if (lineIndexDrawingInfo.isEmpty) {
      return;
    }
    final viewSize = canvasWrapper.size;

    lineIndexDrawingInfo.sort((a, b) => b.spot.y.compareTo(a.spot.y));

    for (final info in lineIndexDrawingInfo) {
      final barData = info.line;
      final barXDelta = getBarLineXLength(barData, viewSize, holder);

      final data = holder.data;

      final index = info.spotIndex;
      final spot = info.spot;
      final indicatorData = info.indicatorData;

      final touchedSpot = Offset(
        getPixelX(spot.x, viewSize, holder),
        getPixelY(spot.y, viewSize, holder),
      );

      /// For drawing the dot
      final showingDots = indicatorData.touchedSpotDotData.show;
      var dotHeight = 0.0;
      late FlDotPainter dotPainter;

      if (showingDots) {
        final xPercentInLine = (touchedSpot.dx / barXDelta) * 100;
        dotPainter = indicatorData.touchedSpotDotData
            .getDotPainter(spot, xPercentInLine, barData, index);
        dotHeight = dotPainter.getSize(spot).height;
      }

      /// For drawing the indicator line
      final lineStartY = min(
        data.maxY,
        max(data.minY, data.lineTouchData.getTouchLineStart(barData, index)),
      );
      final lineEndY = min(
        data.maxY,
        max(data.minY, data.lineTouchData.getTouchLineEnd(barData, index)),
      );
      final lineStart =
          Offset(touchedSpot.dx, getPixelY(lineStartY, viewSize, holder));
      var lineEnd =
          Offset(touchedSpot.dx, getPixelY(lineEndY, viewSize, holder));

      /// If line end is inside the dot, adjust it so that it doesn't overlap with the dot.
      final dotMinY = touchedSpot.dy - dotHeight / 2;
      final dotMaxY = touchedSpot.dy + dotHeight / 2;
      if (lineEnd.dy > dotMinY && lineEnd.dy < dotMaxY) {
        if (lineStart.dy < lineEnd.dy) {
          lineEnd -= Offset(0, lineEnd.dy - dotMinY);
        } else {
          lineEnd += Offset(0, dotMaxY - lineEnd.dy);
        }
      }

      final indicatorLine = indicatorData.indicatorBelowLine;
      _touchLinePaint
        ..setColorOrGradientForLine(
          indicatorLine.color,
          indicatorLine.gradient,
          from: lineStart,
          to: lineEnd,
        )
        ..strokeWidth = indicatorLine.strokeWidth
        ..transparentIfWidthIsZero();

      canvasWrapper.drawDashedLine(
        lineStart,
        lineEnd,
        _touchLinePaint,
        indicatorLine.dashArray,
      );

      /// Draw the indicator dot
      if (showingDots) {
        canvasWrapper.drawDot(dotPainter, spot, touchedSpot);
      }
    }
  }

  /// Generates a path, based on [LineChartBarData.isStepChart] for step style, and normal style.
  @visibleForTesting
  Path generateBarPath(
    Size viewSize,
    LineChartBarData barData,
    List<FlSpot> barSpots,
    PaintHolder<LineChartData> holder, {
    Path? appendToPath,
  }) {
    if (barData.isStepLineChart) {
      return generateStepBarPath(
        viewSize,
        barData,
        barSpots,
        holder,
        appendToPath: appendToPath,
      );
    } else {
      return generateNormalBarPath(
        viewSize,
        barData,
        barSpots,
        holder,
        appendToPath: appendToPath,
      );
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
  @visibleForTesting
  Path generateNormalBarPath(
    Size viewSize,
    LineChartBarData barData,
    List<FlSpot> barSpots,
    PaintHolder<LineChartData> holder, {
    Path? appendToPath,
  }) {
    final path = appendToPath ?? Path();
    final size = barSpots.length;

    var temp = Offset.zero;

    final x = getPixelX(barSpots[0].x, viewSize, holder);
    final y = getPixelY(barSpots[0].y, viewSize, holder);
    if (appendToPath == null) {
      path.moveTo(x, y);
      if (size == 1) {
        path.lineTo(x, y);
      }
    } else {
      path.lineTo(x, y);
    }
    for (var i = 1; i < size; i++) {
      /// CurrentSpot
      final current = Offset(
        getPixelX(barSpots[i].x, viewSize, holder),
        getPixelY(barSpots[i].y, viewSize, holder),
      );

      /// previous spot
      final previous = Offset(
        getPixelX(barSpots[i - 1].x, viewSize, holder),
        getPixelY(barSpots[i - 1].y, viewSize, holder),
      );

      /// next point
      final next = Offset(
        getPixelX(barSpots[i + 1 < size ? i + 1 : i].x, viewSize, holder),
        getPixelY(barSpots[i + 1 < size ? i + 1 : i].y, viewSize, holder),
      );

      final controlPoint1 = previous + temp;

      /// if the isCurved is false, we set 0 for smoothness,
      /// it means we should not have any smoothness then we face with
      /// the sharped corners line
      final smoothness = barData.isCurved ? barData.curveSmoothness : 0.0;
      temp = ((next - previous) / 2) * smoothness;

      if (barData.preventCurveOverShooting) {
        if ((next - current).dy <= barData.preventCurveOvershootingThreshold ||
            (current - previous).dy <=
                barData.preventCurveOvershootingThreshold) {
          temp = Offset(temp.dx, 0);
        }

        if ((next - current).dx <= barData.preventCurveOvershootingThreshold ||
            (current - previous).dx <=
                barData.preventCurveOvershootingThreshold) {
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
  @visibleForTesting
  Path generateStepBarPath(
    Size viewSize,
    LineChartBarData barData,
    List<FlSpot> barSpots,
    PaintHolder<LineChartData> holder, {
    Path? appendToPath,
  }) {
    final path = appendToPath ?? Path();
    final size = barSpots.length;

    final x = getPixelX(barSpots[0].x, viewSize, holder);
    final y = getPixelY(barSpots[0].y, viewSize, holder);
    if (appendToPath == null) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
    for (var i = 0; i < size; i++) {
      /// CurrentSpot
      final current = Offset(
        getPixelX(barSpots[i].x, viewSize, holder),
        getPixelY(barSpots[i].y, viewSize, holder),
      );

      /// next point
      final next = Offset(
        getPixelX(barSpots[i + 1 < size ? i + 1 : i].x, viewSize, holder),
        getPixelY(barSpots[i + 1 < size ? i + 1 : i].y, viewSize, holder),
      );

      final stepDirection = barData.lineChartStepData.stepDirection;

      // middle
      if (current.dy == next.dy) {
        path.lineTo(next.dx, next.dy);
      } else {
        final deltaX = next.dx - current.dx;

        path
          ..lineTo(current.dx + deltaX - (deltaX * stepDirection), current.dy)
          ..lineTo(current.dx + deltaX - (deltaX * stepDirection), next.dy)
          ..lineTo(next.dx, next.dy);
      }
    }

    return path;
  }

  /// it generates below area path using a copy of [barPath],
  /// if cutOffY is provided by the [BarAreaData], it cut the area to the provided cutOffY value,
  /// if [fillCompletely] is true, the cutOffY will be ignored,
  /// and a completely filled path will return,
  @visibleForTesting
  Path generateBelowBarPath(
    Size viewSize,
    LineChartBarData barData,
    Path barPath,
    List<FlSpot> barSpots,
    PaintHolder<LineChartData> holder, {
    bool fillCompletely = false,
  }) {
    final belowBarPath = Path.from(barPath);

    /// Line To Bottom Right
    var x = getPixelX(barSpots[barSpots.length - 1].x, viewSize, holder);
    double y;
    if (!fillCompletely && barData.belowBarData.applyCutOffY) {
      y = getPixelY(barData.belowBarData.cutOffY, viewSize, holder);
    } else {
      y = viewSize.height;
    }
    belowBarPath.lineTo(x, y);

    /// Line To Bottom Left
    x = getPixelX(barSpots[0].x, viewSize, holder);
    if (!fillCompletely && barData.belowBarData.applyCutOffY) {
      y = getPixelY(barData.belowBarData.cutOffY, viewSize, holder);
    } else {
      y = viewSize.height;
    }
    belowBarPath.lineTo(x, y);

    /// Line To Top Left
    x = getPixelX(barSpots[0].x, viewSize, holder);
    y = getPixelY(barSpots[0].y, viewSize, holder);
    belowBarPath
      ..lineTo(x, y)
      ..close();

    return belowBarPath;
  }

  /// it generates above area path using a copy of [barPath],
  /// if cutOffY is provided by the [BarAreaData], it cut the area to the provided cutOffY value,
  /// if [fillCompletely] is true, the cutOffY will be ignored,
  /// and a completely filled path will return,
  @visibleForTesting
  Path generateAboveBarPath(
    Size viewSize,
    LineChartBarData barData,
    Path barPath,
    List<FlSpot> barSpots,
    PaintHolder<LineChartData> holder, {
    bool fillCompletely = false,
  }) {
    final aboveBarPath = Path.from(barPath);

    /// Line To Top Right
    var x = getPixelX(barSpots[barSpots.length - 1].x, viewSize, holder);
    double y;
    if (!fillCompletely && barData.aboveBarData.applyCutOffY) {
      y = getPixelY(barData.aboveBarData.cutOffY, viewSize, holder);
    } else {
      y = 0.0;
    }
    aboveBarPath.lineTo(x, y);

    /// Line To Top Left
    x = getPixelX(barSpots[0].x, viewSize, holder);
    if (!fillCompletely && barData.aboveBarData.applyCutOffY) {
      y = getPixelY(barData.aboveBarData.cutOffY, viewSize, holder);
    } else {
      y = 0.0;
    }
    aboveBarPath.lineTo(x, y);

    /// Line To Bottom Left
    x = getPixelX(barSpots[0].x, viewSize, holder);
    y = getPixelY(barSpots[0].y, viewSize, holder);
    aboveBarPath
      ..lineTo(x, y)
      ..close();

    return aboveBarPath;
  }

  /// firstly we draw [belowBarPath], then if cutOffY value is provided in [BarAreaData],
  /// [belowBarPath] maybe draw over the main bar line,
  /// then to fix the problem we use [filledAboveBarPath] to clear the above section from this draw.
  @visibleForTesting
  void drawBelowBar(
    CanvasWrapper canvasWrapper,
    Path belowBarPath,
    Path filledAboveBarPath,
    PaintHolder<LineChartData> holder,
    LineChartBarData barData,
  ) {
    if (!barData.belowBarData.show) {
      return;
    }

    final viewSize = canvasWrapper.size;

    final belowBarLargestRect = Rect.fromLTRB(
      getPixelX(barData.mostLeftSpot.x, viewSize, holder),
      getPixelY(barData.mostTopSpot.y, viewSize, holder),
      getPixelX(barData.mostRightSpot.x, viewSize, holder),
      viewSize.height,
    );

    final belowBar = barData.belowBarData;
    _barAreaPaint.setColorOrGradient(
      belowBar.color,
      belowBar.gradient,
      belowBarLargestRect,
    );

    if (barData.belowBarData.applyCutOffY) {
      canvasWrapper.saveLayer(
        Rect.fromLTWH(0, 0, viewSize.width, viewSize.height),
        Paint(),
      );
    }

    canvasWrapper.drawPath(belowBarPath, _barAreaPaint);

    // clear the above area that get out of the bar line
    if (barData.belowBarData.applyCutOffY) {
      canvasWrapper
        ..drawPath(filledAboveBarPath, _clearBarAreaPaint)
        ..restore();
    }

    /// draw below spots line
    if (barData.belowBarData.spotsLine.show) {
      for (final spot in barData.spots) {
        if (barData.belowBarData.spotsLine.checkToShowSpotLine(spot)) {
          final from = Offset(
            getPixelX(spot.x, viewSize, holder),
            getPixelY(spot.y, viewSize, holder),
          );

          Offset to;

          // Check applyCutOffY
          if (barData.belowBarData.spotsLine.applyCutOffY &&
              barData.belowBarData.applyCutOffY) {
            to = Offset(
              getPixelX(spot.x, viewSize, holder),
              getPixelY(barData.belowBarData.cutOffY, viewSize, holder),
            );
          } else {
            to = Offset(
              getPixelX(spot.x, viewSize, holder),
              viewSize.height,
            );
          }

          final lineStyle = barData.belowBarData.spotsLine.flLineStyle;
          _barAreaLinesPaint
            ..setColorOrGradientForLine(
              lineStyle.color,
              lineStyle.gradient,
              from: from,
              to: to,
            )
            ..strokeWidth = lineStyle.strokeWidth
            ..transparentIfWidthIsZero();

          canvasWrapper.drawDashedLine(
            from,
            to,
            _barAreaLinesPaint,
            lineStyle.dashArray,
          );
        }
      }
    }
  }

  /// firstly we draw [aboveBarPath], then if cutOffY value is provided in [BarAreaData],
  /// [aboveBarPath] maybe draw over the main bar line,
  /// then to fix the problem we use [filledBelowBarPath] to clear the above section from this draw.
  @visibleForTesting
  void drawAboveBar(
    CanvasWrapper canvasWrapper,
    Path aboveBarPath,
    Path filledBelowBarPath,
    PaintHolder<LineChartData> holder,
    LineChartBarData barData,
  ) {
    if (!barData.aboveBarData.show) {
      return;
    }

    final viewSize = canvasWrapper.size;

    final aboveBarLargestRect = Rect.fromLTRB(
      getPixelX(barData.mostLeftSpot.x, viewSize, holder),
      0,
      getPixelX(barData.mostRightSpot.x, viewSize, holder),
      getPixelY(barData.mostBottomSpot.y, viewSize, holder),
    );

    final aboveBar = barData.aboveBarData;
    _barAreaPaint.setColorOrGradient(
      aboveBar.color,
      aboveBar.gradient,
      aboveBarLargestRect,
    );

    if (barData.aboveBarData.applyCutOffY) {
      canvasWrapper.saveLayer(
        Rect.fromLTWH(0, 0, viewSize.width, viewSize.height),
        Paint(),
      );
    }

    canvasWrapper.drawPath(aboveBarPath, _barAreaPaint);

    // clear the above area that get out of the bar line
    if (barData.aboveBarData.applyCutOffY) {
      canvasWrapper
        ..drawPath(filledBelowBarPath, _clearBarAreaPaint)
        ..restore();
    }

    /// draw above spots line
    if (barData.aboveBarData.spotsLine.show) {
      for (final spot in barData.spots) {
        if (barData.aboveBarData.spotsLine.checkToShowSpotLine(spot)) {
          final from = Offset(
            getPixelX(spot.x, viewSize, holder),
            getPixelY(spot.y, viewSize, holder),
          );

          Offset to;

          // Check applyCutOffY
          if (barData.aboveBarData.spotsLine.applyCutOffY &&
              barData.aboveBarData.applyCutOffY) {
            to = Offset(
              getPixelX(spot.x, viewSize, holder),
              getPixelY(barData.aboveBarData.cutOffY, viewSize, holder),
            );
          } else {
            to = Offset(
              getPixelX(spot.x, viewSize, holder),
              0,
            );
          }

          final lineStyle = barData.aboveBarData.spotsLine.flLineStyle;
          _barAreaLinesPaint
            ..setColorOrGradientForLine(
              lineStyle.color,
              lineStyle.gradient,
              from: from,
              to: to,
            )
            ..strokeWidth = lineStyle.strokeWidth
            ..transparentIfWidthIsZero();

          canvasWrapper.drawDashedLine(
            from,
            to,
            _barAreaLinesPaint,
            lineStyle.dashArray,
          );
        }
      }
    }
  }

  @visibleForTesting
  void drawBetweenBar(
    CanvasWrapper canvasWrapper,
    Path barPath,
    BetweenBarsData betweenBarsData,
    Rect aroundRect,
    PaintHolder<LineChartData> holder,
  ) {
    final viewSize = canvasWrapper.size;

    _barAreaPaint.setColorOrGradient(
      betweenBarsData.color,
      betweenBarsData.gradient,
      aroundRect,
    );

    canvasWrapper
      ..saveLayer(
        Rect.fromLTWH(0, 0, viewSize.width, viewSize.height),
        Paint(),
      )
      ..drawPath(barPath, _barAreaPaint)
      ..restore(); // clear the above area that get out of the bar line
  }

  /// draw the main bar line's shadow by the [barPath]
  @visibleForTesting
  void drawBarShadow(
    CanvasWrapper canvasWrapper,
    Path barPath,
    LineChartBarData barData,
  ) {
    if (!barData.show || barData.shadow.color.opacity == 0.0) {
      return;
    }
    if (barPath.computeMetrics().isEmpty) {
      return;
    }

    _barPaint
      ..strokeCap = barData.isStrokeCapRound ? StrokeCap.round : StrokeCap.butt
      ..strokeJoin =
          barData.isStrokeJoinRound ? StrokeJoin.round : StrokeJoin.miter
      ..color = barData.shadow.color
      ..shader = null
      ..strokeWidth = barData.barWidth
      ..color = barData.shadow.color
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        Utils().convertRadiusToSigma(barData.shadow.blurRadius),
      );

    barPath = barPath.toDashedPath(barData.dashArray);

    barPath = barPath.shift(barData.shadow.offset);

    canvasWrapper.drawPath(
      barPath,
      _barPaint,
    );
  }

  /// draw the main bar line by the [barPath]
  @visibleForTesting
  void drawBar(
    CanvasWrapper canvasWrapper,
    Path barPath,
    LineChartBarData barData,
    PaintHolder<LineChartData> holder,
  ) {
    if (!barData.show) {
      return;
    }
    final viewSize = canvasWrapper.size;

    _barPaint
      ..strokeCap = barData.isStrokeCapRound ? StrokeCap.round : StrokeCap.butt
      ..strokeJoin =
          barData.isStrokeJoinRound ? StrokeJoin.round : StrokeJoin.miter;

    final rectAroundTheLine = Rect.fromLTRB(
      getPixelX(barData.mostLeftSpot.x, viewSize, holder),
      getPixelY(barData.mostTopSpot.y, viewSize, holder),
      getPixelX(barData.mostRightSpot.x, viewSize, holder),
      getPixelY(barData.mostBottomSpot.y, viewSize, holder),
    );
    _barPaint
      ..setColorOrGradient(
        barData.color,
        barData.gradient,
        rectAroundTheLine,
      )
      ..maskFilter = null
      ..strokeWidth = barData.barWidth
      ..transparentIfWidthIsZero();

    barPath = barPath.toDashedPath(barData.dashArray);
    canvasWrapper.drawPath(barPath, _barPaint);
  }

  @visibleForTesting
  void drawTouchTooltip(
    BuildContext context,
    CanvasWrapper canvasWrapper,
    LineTouchTooltipData tooltipData,
    FlSpot showOnSpot,
    ShowingTooltipIndicators showingTooltipSpots,
    PaintHolder<LineChartData> holder,
  ) {
    final viewSize = canvasWrapper.size;

    const textsBelowMargin = 4;

    /// creating TextPainters to calculate the width and height of the tooltip
    final drawingTextPainters = <TextPainter>[];

    final tooltipItems =
        tooltipData.getTooltipItems(showingTooltipSpots.showingSpots);
    if (tooltipItems.length != showingTooltipSpots.showingSpots.length) {
      throw Exception('tooltipItems and touchedSpots size should be same');
    }

    for (var i = 0; i < showingTooltipSpots.showingSpots.length; i++) {
      final tooltipItem = tooltipItems[i];
      if (tooltipItem == null) {
        continue;
      }

      final span = TextSpan(
        style: Utils().getThemeAwareTextStyle(context, tooltipItem.textStyle),
        text: tooltipItem.text,
        children: tooltipItem.children,
      );

      final tp = TextPainter(
        text: span,
        textAlign: tooltipItem.textAlign,
        textDirection: tooltipItem.textDirection,
        textScaler: holder.textScaler,
      )..layout(maxWidth: tooltipData.maxContentWidth);
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
    for (final tp in drawingTextPainters) {
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
      getPixelX(showOnSpot.x, viewSize, holder),
      getPixelY(showOnSpot.y, viewSize, holder),
    );

    final tooltipWidth = biggerWidth + tooltipData.tooltipPadding.horizontal;
    final tooltipHeight = sumTextsHeight + tooltipData.tooltipPadding.vertical;

    double tooltipTopPosition;
    if (tooltipData.showOnTopOfTheChartBoxArea) {
      tooltipTopPosition = 0 - tooltipHeight - tooltipData.tooltipMargin;
    } else {
      tooltipTopPosition =
          mostTopOffset.dy - tooltipHeight - tooltipData.tooltipMargin;
    }

    final tooltipLeftPosition = getTooltipLeft(
      mostTopOffset.dx,
      tooltipWidth,
      tooltipData.tooltipHorizontalAlignment,
      tooltipData.tooltipHorizontalOffset,
    );

    /// draw the background rect with rounded radius
    var rect = Rect.fromLTWH(
      tooltipLeftPosition,
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
    final roundedRect = RRect.fromRectAndCorners(
      rect,
      topLeft: radius,
      topRight: radius,
      bottomLeft: radius,
      bottomRight: radius,
    );
    _bgTouchTooltipPaint.color = tooltipData.tooltipBgColor;

    final rotateAngle = tooltipData.rotateAngle;
    final rectRotationOffset =
        Offset(0, Utils().calculateRotationOffset(rect.size, rotateAngle).dy);
    final rectDrawOffset = Offset(roundedRect.left, roundedRect.top);

    final textRotationOffset =
        Utils().calculateRotationOffset(rect.size, rotateAngle);

    if (tooltipData.tooltipBorder != BorderSide.none) {
      _borderTouchTooltipPaint
        ..color = tooltipData.tooltipBorder.color
        ..strokeWidth = tooltipData.tooltipBorder.width;
    }

    canvasWrapper.drawRotated(
      size: rect.size,
      rotationOffset: rectRotationOffset,
      drawOffset: rectDrawOffset,
      angle: rotateAngle,
      drawCallback: () {
        canvasWrapper
          ..drawRRect(roundedRect, _bgTouchTooltipPaint)
          ..drawRRect(roundedRect, _borderTouchTooltipPaint);
      },
    );

    /// draw the texts one by one in below of each other
    var topPosSeek = tooltipData.tooltipPadding.top;
    for (final tp in drawingTextPainters) {
      final yOffset = rect.topCenter.dy +
          topPosSeek -
          textRotationOffset.dy +
          rectRotationOffset.dy;

      final align = tp.textAlign.getFinalHorizontalAlignment(tp.textDirection);
      final xOffset = switch (align) {
        HorizontalAlignment.left => rect.left + tooltipData.tooltipPadding.left,
        HorizontalAlignment.right =>
          rect.right - tooltipData.tooltipPadding.right - tp.width,
        _ => rect.center.dx - (tp.width / 2),
      };

      final drawOffset = Offset(
        xOffset,
        yOffset,
      );

      canvasWrapper.drawRotated(
        size: rect.size,
        rotationOffset: rectRotationOffset,
        drawOffset: rectDrawOffset,
        angle: rotateAngle,
        drawCallback: () {
          canvasWrapper.drawText(tp, drawOffset);
        },
      );
      topPosSeek += tp.height;
      topPosSeek += textsBelowMargin;
    }
  }

  @visibleForTesting
  double getBarLineXLength(
    LineChartBarData barData,
    Size chartUsableSize,
    PaintHolder<LineChartData> holder,
  ) {
    if (barData.spots.isEmpty) {
      return 0;
    }

    final firstSpot = barData.spots[0];
    final firstSpotX = getPixelX(firstSpot.x, chartUsableSize, holder);

    final lastSpot = barData.spots[barData.spots.length - 1];
    final lastSpotX = getPixelX(lastSpot.x, chartUsableSize, holder);

    return lastSpotX - firstSpotX;
  }

  /// Makes a [LineTouchResponse] based on the provided [localPosition]
  ///
  /// Processes [localPosition] and checks
  /// the elements of the chart that are near the offset,
  /// then makes a [LineTouchResponse] from the elements that has been touched.
  List<TouchLineBarSpot>? handleTouch(
    Offset localPosition,
    Size size,
    PaintHolder<LineChartData> holder,
  ) {
    final data = holder.data;

    /// it holds list of nearest touched spots of each line
    /// and we use it to draw touch stuff on them
    final touchedSpots = <TouchLineBarSpot>[];

    /// draw each line independently on the chart
    for (var i = 0; i < data.lineBarsData.length; i++) {
      final barData = data.lineBarsData[i];

      // find the nearest spot on touch area in this bar line
      final foundTouchedSpot =
          getNearestTouchedSpot(size, localPosition, barData, i, holder);
      if (foundTouchedSpot != null) {
        touchedSpots.add(foundTouchedSpot);
      }
    }

    touchedSpots.sort((a, b) => a.distance.compareTo(b.distance));

    return touchedSpots.isEmpty ? null : touchedSpots;
  }

  /// find the nearest spot base on the touched offset
  @visibleForTesting
  TouchLineBarSpot? getNearestTouchedSpot(
    Size viewSize,
    Offset touchedPoint,
    LineChartBarData barData,
    int barDataPosition,
    PaintHolder<LineChartData> holder,
  ) {
    final data = holder.data;
    if (!barData.show) {
      return null;
    }

    /// Find the nearest spot (based on distanceCalculator)
    final sortedSpots = <FlSpot>[];
    double? smallestDistance;
    for (final spot in barData.spots) {
      if (spot.isNull()) continue;
      final distance = data.lineTouchData.distanceCalculator(
        touchedPoint,
        Offset(
          getPixelX(spot.x, viewSize, holder),
          getPixelY(spot.y, viewSize, holder),
        ),
      );

      if (distance <= data.lineTouchData.touchSpotThreshold) {
        smallestDistance ??= distance;

        if (distance < smallestDistance) {
          sortedSpots.insert(0, spot);
          smallestDistance = distance;
        } else {
          sortedSpots.add(spot);
        }
      }
    }

    if (sortedSpots.isNotEmpty) {
      return TouchLineBarSpot(
        barData,
        barDataPosition,
        sortedSpots.first,
        smallestDistance!,
      );
    } else {
      return null;
    }
  }
}

@visibleForTesting
class LineIndexDrawingInfo {
  LineIndexDrawingInfo(
    this.line,
    this.lineIndex,
    this.spot,
    this.spotIndex,
    this.indicatorData,
  );

  final LineChartBarData line;
  final int lineIndex;
  final FlSpot spot;
  final int spotIndex;
  final TouchedSpotIndicatorData indicatorData;
}
