import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';

/// Paints [CandlestickChartData] in the canvas, it can be used in a [CustomPainter]
class CandlestickChartPainter extends AxisChartPainter<CandlestickChartData> {
  /// Paints [CandlestickChartData] in the canvas
  CandlestickChartPainter() : super() {
    _bgTouchTooltipPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    _borderTouchTooltipPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.transparent
      ..strokeWidth = 1.0;

    _clipPaint = Paint();
  }

  late Paint _bgTouchTooltipPaint;
  late Paint _borderTouchTooltipPaint;
  late Paint _clipPaint;

  /// Paints [CandlestickChartData] into the provided canvas.
  @override
  void paint(
    BuildContext context,
    CanvasWrapper canvasWrapper,
    PaintHolder<CandlestickChartData> holder,
  ) {
    if (holder.chartVirtualRect != null) {
      canvasWrapper
        ..saveLayer(
          Offset.zero & canvasWrapper.size,
          _clipPaint,
        )
        ..clipRect(Offset.zero & canvasWrapper.size);
    }
    super.paint(context, canvasWrapper, holder);
    drawAxisSpotIndicator(context, canvasWrapper, holder);
    drawCandlesticks(context, canvasWrapper, holder);

    if (holder.chartVirtualRect != null) {
      canvasWrapper.restore();
    }

    drawTouchTooltips(context, canvasWrapper, holder);
  }

  @visibleForTesting
  void drawCandlesticks(
    BuildContext context,
    CanvasWrapper canvasWrapper,
    PaintHolder<CandlestickChartData> holder,
  ) {
    final data = holder.data;
    final viewSize = canvasWrapper.size;
    final clip = data.clipData;
    final border = data.borderData.show ? data.borderData.border : null;

    if (data.clipData.any) {
      canvasWrapper.saveLayer(
        Rect.fromLTRB(
          0,
          0,
          canvasWrapper.size.width,
          canvasWrapper.size.height,
        ),
        _clipPaint,
      );

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

    for (var i = 0; i < data.candlestickSpots.length; i++) {
      final candlestickSpot = data.candlestickSpots[i];

      if (!candlestickSpot.show) {
        continue;
      }
      holder.data.candlestickPainter.paint(
        canvasWrapper.canvas,
        (x) => getPixelX(x, viewSize, holder),
        (y) => getPixelY(y, viewSize, holder),
        candlestickSpot,
        i,
      );
    }

    if (data.clipData.any) {
      canvasWrapper.restore();
    }
  }

  @visibleForTesting
  void drawTouchTooltips(
    BuildContext context,
    CanvasWrapper canvasWrapper,
    PaintHolder<CandlestickChartData> holder,
  ) {
    final targetData = holder.targetData;
    for (var i = 0; i < targetData.candlestickSpots.length; i++) {
      if (!targetData.showingTooltipIndicators.contains(i)) {
        continue;
      }

      final candlestickSpot = targetData.candlestickSpots[i];
      drawTouchTooltip(
        context,
        canvasWrapper,
        targetData.candlestickTouchData.touchTooltipData,
        candlestickSpot,
        i,
        holder,
      );
    }
  }

  @visibleForTesting
  void drawTouchTooltip(
    BuildContext context,
    CanvasWrapper canvasWrapper,
    CandlestickTouchTooltipData tooltipData,
    CandlestickSpot showOnSpot,
    int spotIndex,
    PaintHolder<CandlestickChartData> holder,
  ) {
    final viewSize = canvasWrapper.size;

    final tooltipItem = tooltipData.getTooltipItems(
      holder.data.candlestickPainter,
      showOnSpot,
      spotIndex,
    );

    if (tooltipItem == null) {
      return;
    }

    final span = TextSpan(
      style: Utils().getThemeAwareTextStyle(context, tooltipItem.textStyle),
      text: tooltipItem.text,
      children: tooltipItem.children,
    );

    final drawingTextPainter = TextPainter(
      text: span,
      textAlign: tooltipItem.textAlign,
      textDirection: tooltipItem.textDirection,
      textScaler: holder.textScaler,
    )..layout(maxWidth: tooltipData.maxContentWidth);

    final width = drawingTextPainter.width;
    final height = drawingTextPainter.height;

    final tooltipOriginPoint = Offset(
      getPixelX(showOnSpot.x, viewSize, holder),
      getPixelY(
        showOnSpot.high,
        viewSize,
        holder,
      ),
    );

    final tooltipWidth = width + tooltipData.tooltipPadding.horizontal;
    final tooltipHeight = height + tooltipData.tooltipPadding.vertical;

    double tooltipTopPosition;
    if (tooltipData.showOnTopOfTheChartBoxArea) {
      tooltipTopPosition = 0 - tooltipHeight - tooltipItem.bottomMargin;
    } else {
      tooltipTopPosition =
          tooltipOriginPoint.dy - tooltipHeight - tooltipItem.bottomMargin;
    }

    final tooltipLeftPosition = getTooltipLeft(
      tooltipOriginPoint.dx,
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

    final roundedRect = RRect.fromRectAndCorners(
      rect,
      topLeft: tooltipData.tooltipBorderRadius.topLeft,
      topRight: tooltipData.tooltipBorderRadius.topRight,
      bottomLeft: tooltipData.tooltipBorderRadius.bottomLeft,
      bottomRight: tooltipData.tooltipBorderRadius.bottomRight,
    );

    _bgTouchTooltipPaint.color = tooltipData.getTooltipColor(showOnSpot);

    final rotateAngle = tooltipData.rotateAngle;
    final rectRotationOffset =
        Offset(0, Utils().calculateRotationOffset(rect.size, rotateAngle).dy);
    final rectDrawOffset = Offset(roundedRect.left, roundedRect.top);

    final textRotationOffset =
        Utils().calculateRotationOffset(drawingTextPainter.size, rotateAngle);

    final drawOffset = Offset(
      rect.center.dx - (drawingTextPainter.width / 2),
      rect.topCenter.dy +
          tooltipData.tooltipPadding.top -
          textRotationOffset.dy +
          rectRotationOffset.dy,
    );

    if (tooltipData.tooltipBorder != BorderSide.none) {
      _borderTouchTooltipPaint
        ..color = tooltipData.tooltipBorder.color
        ..strokeWidth = tooltipData.tooltipBorder.width;
    }

    final reverseQuarterTurnsAngle = -holder.data.rotationQuarterTurns * 90;
    canvasWrapper.drawRotated(
      size: rect.size,
      rotationOffset: rectRotationOffset,
      drawOffset: rectDrawOffset,
      angle: reverseQuarterTurnsAngle + rotateAngle,
      drawCallback: () {
        canvasWrapper
          ..drawRRect(roundedRect, _bgTouchTooltipPaint)
          ..drawRRect(roundedRect, _borderTouchTooltipPaint)
          ..drawText(drawingTextPainter, drawOffset);
      },
    );
  }

  @visibleForTesting
  void drawAxisSpotIndicator(
    BuildContext context,
    CanvasWrapper canvasWrapper,
    PaintHolder<CandlestickChartData> holder,
  ) {
    final pointIndicator = holder.data.touchedPointIndicator;
    if (pointIndicator == null) {
      return;
    }

    final viewSize = canvasWrapper.size;
    pointIndicator.painter.paint(
      context,
      canvasWrapper.canvas,
      canvasWrapper.size,
      pointIndicator,
      (x) => getPixelX(x, viewSize, holder),
      (y) => getPixelY(y, viewSize, holder),
      holder.data,
    );
  }

  /// Makes a [CandlestickTouchedSpot] based on the provided [localPosition]
  ///
  /// Processes [localPosition] and checks
  /// the elements of the chart that are near the offset,
  /// then makes a [CandlestickTouchedSpot] from the elements that has been touched.
  ///
  /// Returns null if finds nothing!
  CandlestickTouchedSpot? handleTouch(
    Offset localPosition,
    Size viewSize,
    PaintHolder<CandlestickChartData> holder,
  ) {
    final data = holder.data;

    final touchedSpots =
        <({CandlestickSpot spot, int index, double distance})>[];
    for (var i = data.candlestickSpots.length - 1; i >= 0; i--) {
      // Reverse the loop to check the topmost spot first
      final spot = data.candlestickSpots[i];
      if (!spot.show) {
        continue;
      }

      final spotPixelX = getPixelX(spot.x, viewSize, holder);

      final (hit, distance) = holder.targetData.candlestickPainter.hitTest(
        spot,
        spotPixelX,
        localPosition.dx,
        holder.data.candlestickTouchData.touchSpotThreshold,
      );
      if (hit) {
        touchedSpots.add(
          (
            spot: spot,
            index: i,
            distance: distance,
          ),
        );
      }
    }

    if (touchedSpots.isEmpty) {
      return null;
    }
    // Sort the touched spots by distance
    touchedSpots.sort((a, b) => a.distance.compareTo(b.distance));
    final closestSpot = touchedSpots.first;
    return CandlestickTouchedSpot(closestSpot.spot, closestSpot.index);
  }
}
