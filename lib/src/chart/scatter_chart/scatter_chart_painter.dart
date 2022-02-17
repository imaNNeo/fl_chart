import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_helper.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import 'scatter_chart_data.dart';

/// Paints [ScatterChartData] in the canvas, it can be used in a [CustomPainter]
class ScatterChartPainter extends AxisChartPainter<ScatterChartData> {
  /// [_spotsPaint] is responsible to draw scatter spots
  late Paint _spotsPaint, _bgTouchTooltipPaint;

  /// Paints [data] into canvas, it is the animating [ScatterChartData],
  /// [targetData] is the animation's target and remains the same
  /// during animation, then we should use it  when we need to show
  /// tooltips or something like that, because [data] is changing constantly.
  ///
  /// [textScale] used for scaling texts inside the chart,
  /// parent can use [MediaQuery.textScaleFactor] to respect
  /// the system's font size.
  ScatterChartPainter() : super() {
    _spotsPaint = Paint()..style = PaintingStyle.fill;

    _bgTouchTooltipPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;
  }

  /// Paints [ScatterChartData] into the provided canvas.
  @override
  void paint(BuildContext context, CanvasWrapper canvasWrapper,
      PaintHolder<ScatterChartData> holder) {
    super.paint(context, canvasWrapper, holder);
    drawAxisTitles(context, canvasWrapper, holder);
    drawTitles(context, canvasWrapper, holder);
    drawSpots(canvasWrapper, holder);
    drawTouchTooltips(context, canvasWrapper, holder);
  }

  @visibleForTesting
  void drawTitles(BuildContext context, CanvasWrapper canvasWrapper,
      PaintHolder<ScatterChartData> holder) {
    final data = holder.data;
    final targetData = holder.targetData;
    if (!targetData.titlesData.show) {
      return;
    }
    final viewSize = getChartUsableDrawSize(canvasWrapper.size, holder);

    // Left Titles
    final leftTitles = targetData.titlesData.leftTitles;
    final leftInterval = leftTitles.interval ??
        Utils().getEfficientInterval(viewSize.height, data.verticalDiff);
    if (leftTitles.showTitles) {
      AxisChartHelper().iterateThroughAxis(
        min: data.minY,
        max: data.maxY,
        baseLine: data.baselineY,
        interval: leftInterval,
        action: (axisValue) {
          if (leftTitles.checkToShowTitle(
              data.minY, data.maxY, leftTitles, leftInterval, axisValue)) {
            var x = 0 + getLeftOffsetDrawSize(holder);
            var y = getPixelY(axisValue, viewSize, holder);

            final text = leftTitles.getTitles(axisValue);

            final span = TextSpan(
              style: Utils().getThemeAwareTextStyle(
                  context, leftTitles.getTextStyles(context, axisValue)),
              text: text,
            );
            final tp = TextPainter(
              text: span,
              textAlign: leftTitles.textAlign,
              textDirection: leftTitles.textDirection,
              textScaleFactor: holder.textScale,
            );
            tp.layout(
              maxWidth: leftTitles.reservedSize,
              minWidth: leftTitles.reservedSize,
            );
            x -= tp.width + leftTitles.margin;
            y -= tp.height / 2;

            x += Utils()
                .calculateRotationOffset(tp.size, leftTitles.rotateAngle)
                .dx;
            canvasWrapper.drawText(tp, Offset(x, y), leftTitles.rotateAngle);
          }
        },
      );
    }

    // Top titles
    final topTitles = targetData.titlesData.topTitles;
    final topInterval = topTitles.interval ??
        Utils().getEfficientInterval(viewSize.width, data.horizontalDiff);
    if (topTitles.showTitles) {
      AxisChartHelper().iterateThroughAxis(
        min: data.minX,
        max: data.maxX,
        baseLine: data.baselineX,
        interval: topInterval,
        action: (axisValue) {
          if (topTitles.checkToShowTitle(
              data.minX, data.maxX, topTitles, topInterval, axisValue)) {
            var x = getPixelX(axisValue, viewSize, holder);
            var y = getTopOffsetDrawSize(holder);

            final text = topTitles.getTitles(axisValue);

            final span = TextSpan(
              style: Utils().getThemeAwareTextStyle(
                  context, topTitles.getTextStyles(context, axisValue)),
              text: text,
            );
            final tp = TextPainter(
              text: span,
              textAlign: topTitles.textAlign,
              textDirection: topTitles.textDirection,
              textScaleFactor: holder.textScale,
            );
            tp.layout();

            x -= tp.width / 2;
            y -= topTitles.margin + tp.height;
            y += Utils()
                .calculateRotationOffset(tp.size, topTitles.rotateAngle)
                .dy;
            canvasWrapper.drawText(tp, Offset(x, y), topTitles.rotateAngle);
          }
        },
      );
    }

    // Right Titles
    final rightTitles = targetData.titlesData.rightTitles;
    final rightInterval = rightTitles.interval ??
        Utils().getEfficientInterval(viewSize.height, data.verticalDiff);
    if (rightTitles.showTitles) {
      AxisChartHelper().iterateThroughAxis(
        min: data.minY,
        max: data.maxY,
        baseLine: data.baselineY,
        interval: rightInterval,
        action: (axisValue) {
          if (rightTitles.checkToShowTitle(
              data.minY, data.maxY, rightTitles, rightInterval, axisValue)) {
            var x = viewSize.width + getLeftOffsetDrawSize(holder);
            var y = getPixelY(axisValue, viewSize, holder);

            final text = rightTitles.getTitles(axisValue);

            final span = TextSpan(
              style: Utils().getThemeAwareTextStyle(
                  context, rightTitles.getTextStyles(context, axisValue)),
              text: text,
            );
            final tp = TextPainter(
              text: span,
              textAlign: rightTitles.textAlign,
              textDirection: rightTitles.textDirection,
              textScaleFactor: holder.textScale,
            );
            tp.layout(
              maxWidth: rightTitles.reservedSize,
              minWidth: rightTitles.reservedSize,
            );

            x += rightTitles.margin;
            y -= tp.height / 2;
            x -= Utils()
                .calculateRotationOffset(tp.size, rightTitles.rotateAngle)
                .dx;
            canvasWrapper.drawText(tp, Offset(x, y), rightTitles.rotateAngle);
          }
        },
      );
    }

    // Bottom titles
    final bottomTitles = targetData.titlesData.bottomTitles;
    final bottomInterval = bottomTitles.interval ??
        Utils().getEfficientInterval(viewSize.width, data.horizontalDiff);
    if (bottomTitles.showTitles) {
      AxisChartHelper().iterateThroughAxis(
        min: data.minX,
        max: data.maxX,
        baseLine: data.baselineX,
        interval: bottomInterval,
        action: (axisValue) {
          if (bottomTitles.checkToShowTitle(
              data.minX, data.maxX, bottomTitles, bottomInterval, axisValue)) {
            var x = getPixelX(axisValue, viewSize, holder);
            var y = viewSize.height + getTopOffsetDrawSize(holder);

            final text = bottomTitles.getTitles(axisValue);

            final span = TextSpan(
              style: Utils().getThemeAwareTextStyle(
                  context, bottomTitles.getTextStyles(context, axisValue)),
              text: text,
            );
            final tp = TextPainter(
              text: span,
              textAlign: bottomTitles.textAlign,
              textDirection: bottomTitles.textDirection,
              textScaleFactor: holder.textScale,
            );
            tp.layout();

            x -= tp.width / 2;
            y += bottomTitles.margin;
            y -= Utils()
                .calculateRotationOffset(tp.size, bottomTitles.rotateAngle)
                .dy;
            canvasWrapper.drawText(tp, Offset(x, y), bottomTitles.rotateAngle);
          }
        },
      );
    }
  }

  @visibleForTesting
  void drawSpots(
      CanvasWrapper canvasWrapper, PaintHolder<ScatterChartData> holder) {
    final data = holder.data;
    final viewSize = canvasWrapper.size;
    final chartUsableSize = getChartUsableDrawSize(viewSize, holder);
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
        Paint(),
      );

      var left = 0.0;
      var top = 0.0;
      var right = viewSize.width;
      var bottom = viewSize.height;

      if (clip.left) {
        final borderWidth = border?.left.width ?? 0;
        left = getLeftOffsetDrawSize(holder) + (borderWidth / 2);
      }
      if (clip.top) {
        final borderWidth = border?.top.width ?? 0;
        top = getTopOffsetDrawSize(holder) + (borderWidth / 2);
      }
      if (clip.right) {
        final borderWidth = border?.right.width ?? 0;
        right = getLeftOffsetDrawSize(holder) +
            chartUsableSize.width -
            (borderWidth / 2);
      }
      if (clip.bottom) {
        final borderWidth = border?.bottom.width ?? 0;
        bottom = getTopOffsetDrawSize(holder) +
            chartUsableSize.height -
            (borderWidth / 2);
      }

      canvasWrapper.clipRect(Rect.fromLTRB(left, top, right, bottom));
    }

    for (final scatterSpot in data.scatterSpots) {
      if (!scatterSpot.show) {
        continue;
      }
      final pixelX = getPixelX(scatterSpot.x, chartUsableSize, holder);
      final pixelY = getPixelY(scatterSpot.y, chartUsableSize, holder);

      _spotsPaint.color = scatterSpot.color;

      canvasWrapper.drawCircle(
        Offset(pixelX, pixelY),
        scatterSpot.radius,
        _spotsPaint,
      );
    }

    if (data.scatterLabelSettings.showLabel) {
      TextStyle textStyle =
          data.scatterLabelSettings.textStyle ?? const TextStyle();

      for (final scatterSpot in data.scatterSpots) {
        if (scatterSpot.label.isEmpty || !scatterSpot.show) {
          continue;
        }

        final pixelX = getPixelX(scatterSpot.x, chartUsableSize, holder);
        final pixelY = getPixelY(scatterSpot.y, chartUsableSize, holder);

        double newPixelY;

        double centerChartY =
            getTopOffsetDrawSize(holder) + chartUsableSize.height / 2;

        /// if the spot is in the lower half of the chart, then draw the label either in the center or above the spot,
        /// if the spot is in upper half of the chart, then draw the label either in the center or below the spot.
        if (pixelY > centerChartY) {
          /// if the radius of the spot is greater than the font size of the label, then draw the label inside the bubble,
          /// else draw the label above the bubble.
          var off = scatterSpot.radius > (textStyle.fontSize ?? 0)
              ? (textStyle.fontSize ?? 0) / 2
              : scatterSpot.radius;

          newPixelY = pixelY - off;
        } else {
          /// if the radius of the spot is greater than the font size of the label, then draw the label inside the bubble,
          /// else draw the label below the bubble.
          var off = scatterSpot.radius > (textStyle.fontSize ?? 0)
              ? -(textStyle.fontSize ?? 0) / 2
              : scatterSpot.radius;
          newPixelY = pixelY + off;
        }
        final span = TextSpan(
          text: scatterSpot.label,
          style: data.scatterLabelSettings.textStyle ?? const TextStyle(),
        );

        final tp = TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          textScaleFactor: holder.textScale,
        );
        tp.layout(maxWidth: chartUsableSize.width);

        canvasWrapper.drawText(
          tp,
          Offset(pixelX - tp.width / 2, newPixelY),
        );
      }
    }

    if (data.clipData.any) {
      canvasWrapper.restore();
    }
  }

  @visibleForTesting
  void drawTouchTooltips(BuildContext context, CanvasWrapper canvasWrapper,
      PaintHolder<ScatterChartData> holder) {
    final targetData = holder.targetData;
    for (var i = 0; i < targetData.scatterSpots.length; i++) {
      if (!targetData.showingTooltipIndicators.contains(i)) {
        continue;
      }

      final scatterSpot = targetData.scatterSpots[i];
      drawTouchTooltip(
        context,
        canvasWrapper,
        targetData.scatterTouchData.touchTooltipData,
        scatterSpot,
        holder,
      );
    }
  }

  @visibleForTesting
  void drawTouchTooltip(
      BuildContext context,
      CanvasWrapper canvasWrapper,
      ScatterTouchTooltipData tooltipData,
      ScatterSpot showOnSpot,
      PaintHolder<ScatterChartData> holder) {
    final viewSize = canvasWrapper.size;
    final chartUsableSize = getChartUsableDrawSize(viewSize, holder);

    final tooltipItem = tooltipData.getTooltipItems(showOnSpot);

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
        textScaleFactor: holder.textScale);
    drawingTextPainter.layout(maxWidth: tooltipData.maxContentWidth);

    final width = drawingTextPainter.width;
    final height = drawingTextPainter.height;

    /// if we have multiple bar lines,
    /// there are more than one FlCandidate on touch area,
    /// we should get the most top FlSpot Offset to draw the tooltip on top of it
    final mostTopOffset = Offset(
      getPixelX(showOnSpot.x, chartUsableSize, holder),
      getPixelY(showOnSpot.y, chartUsableSize, holder),
    );

    final tooltipWidth = width + tooltipData.tooltipPadding.horizontal;
    final tooltipHeight = height + tooltipData.tooltipPadding.vertical;

    /// draw the background rect with rounded radius
    var rect = Rect.fromLTWH(
      mostTopOffset.dx - (tooltipWidth / 2),
      mostTopOffset.dy -
          tooltipHeight -
          showOnSpot.radius -
          tooltipItem.bottomMargin,
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
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius);
    _bgTouchTooltipPaint.color = tooltipData.tooltipBgColor;

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
    canvasWrapper.drawRotated(
      size: rect.size,
      rotationOffset: rectRotationOffset,
      drawOffset: rectDrawOffset,
      angle: rotateAngle,
      drawCallback: () {
        canvasWrapper.drawRRect(roundedRect, _bgTouchTooltipPaint);
        canvasWrapper.drawText(drawingTextPainter, drawOffset);
      },
    );
  }

  /// We add our needed horizontal space to parent needed.
  /// we have some titles that maybe draw in the left and right side of our chart,
  /// then we should draw the chart a with some left space,
  /// the left space is [getLeftOffsetDrawSize],
  /// and the whole space is [getExtraNeededHorizontalSpace]
  @override
  double getExtraNeededHorizontalSpace(PaintHolder<ScatterChartData> holder) {
    final data = holder.data;
    var sum = super.getExtraNeededHorizontalSpace(holder);
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
  double getExtraNeededVerticalSpace(PaintHolder<ScatterChartData> holder) {
    final data = holder.data;
    var sum = super.getExtraNeededVerticalSpace(holder);
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
  double getLeftOffsetDrawSize(PaintHolder<ScatterChartData> holder) {
    final data = holder.data;
    var sum = super.getLeftOffsetDrawSize(holder);

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
  double getTopOffsetDrawSize(PaintHolder<ScatterChartData> holder) {
    final data = holder.data;
    var sum = super.getTopOffsetDrawSize(holder);

    final topTitles = data.titlesData.topTitles;
    if (data.titlesData.show && topTitles.showTitles) {
      sum += topTitles.reservedSize + topTitles.margin;
    }

    return sum;
  }

  /// Makes a [ScatterTouchedSpot] based on the provided [localPosition]
  ///
  /// Processes [localPosition] and checks
  /// the elements of the chart that are near the offset,
  /// then makes a [ScatterTouchedSpot] from the elements that has been touched.
  ///
  /// Returns null if finds nothing!
  ScatterTouchedSpot? handleTouch(
    Offset localPosition,
    Size size,
    PaintHolder<ScatterChartData> holder,
  ) {
    final data = holder.data;
    final chartViewSize = getChartUsableDrawSize(size, holder);

    for (var i = 0; i < data.scatterSpots.length; i++) {
      final spot = data.scatterSpots[i];

      final spotPixelX = getPixelX(spot.x, chartViewSize, holder);
      final spotPixelY = getPixelY(spot.y, chartViewSize, holder);

      final distance =
          (localPosition - Offset(spotPixelX, spotPixelY)).distance;

      if (distance < spot.radius + data.scatterTouchData.touchSpotThreshold) {
        return ScatterTouchedSpot(spot, i);
      }
    }
    return null;
  }
}
