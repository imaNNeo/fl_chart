import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../utils/utils.dart';
import 'scatter_chart_data.dart';

/// Paints [ScatterChartData] in the canvas, it can be used in a [CustomPainter]
class ScatterChartPainter extends AxisChartPainter<ScatterChartData>
    with TouchHandler<ScatterTouchResponse> {
  /// [_spotsPaint] is responsible to draw scatter spots
  Paint _spotsPaint, _bgTouchTooltipPaint;

  /// Paints [data] into canvas, it is the animating [ScatterChartData],
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
  ScatterChartPainter(
      ScatterChartData data, ScatterChartData targetData, Function(TouchHandler) touchHandler,
      {double textScale})
      : super(data, targetData, textScale: textScale) {
    touchHandler(this);

    _spotsPaint = Paint()..style = PaintingStyle.fill;

    _bgTouchTooltipPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;
  }

  /// Paints [ScatterChartData] into the provided canvas.
  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    final canvasWrapper = CanvasWrapper(canvas, size);

    drawAxisTitles(canvasWrapper);
    _drawTitles(canvasWrapper);
    _drawSpots(canvasWrapper);

    for (var i = 0; i < targetData.scatterSpots.length; i++) {
      if (!targetData.showingTooltipIndicators.contains(i)) {
        continue;
      }

      final scatterSpot = targetData.scatterSpots[i];
      _drawTouchTooltip(canvasWrapper, targetData.scatterTouchData.touchTooltipData, scatterSpot);
    }
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

  void _drawSpots(CanvasWrapper canvasWrapper) {
    if (data.scatterSpots == null) {
      return;
    }
    final viewSize = canvasWrapper.size;
    final chartUsableSize = getChartUsableDrawSize(viewSize);
    for (final scatterSpot in data.scatterSpots) {
      if (!scatterSpot.show) {
        continue;
      }
      final pixelX = getPixelX(scatterSpot.x, chartUsableSize);
      final pixelY = getPixelY(scatterSpot.y, chartUsableSize);

      _spotsPaint.color = scatterSpot.color;

      canvasWrapper.drawCircle(
        Offset(pixelX, pixelY),
        scatterSpot.radius,
        _spotsPaint,
      );
    }
  }

  void _drawTouchTooltip(
      CanvasWrapper canvasWrapper, ScatterTouchTooltipData tooltipData, ScatterSpot showOnSpot) {
    final viewSize = canvasWrapper.size;
    final chartUsableSize = getChartUsableDrawSize(viewSize);

    final tooltipItem = tooltipData.getTooltipItems(showOnSpot);

    if (tooltipItem == null) {
      return;
    }

    final span = TextSpan(style: tooltipItem.textStyle, text: tooltipItem.text);
    final drawingTextPainter = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        textScaleFactor: textScale);
    drawingTextPainter.layout(maxWidth: tooltipData.maxContentWidth);

    final width = drawingTextPainter.width;
    final height = drawingTextPainter.height;

    /// if we have multiple bar lines,
    /// there are more than one FlCandidate on touch area,
    /// we should get the most top FlSpot Offset to draw the tooltip on top of it
    final mostTopOffset = Offset(
      getPixelX(showOnSpot.x, chartUsableSize),
      getPixelY(showOnSpot.y, chartUsableSize),
    );

    final tooltipWidth = width + tooltipData.tooltipPadding.horizontal;
    final tooltipHeight = height + tooltipData.tooltipPadding.vertical;

    /// draw the background rect with rounded radius
    var rect = Rect.fromLTWH(mostTopOffset.dx - (tooltipWidth / 2),
        mostTopOffset.dy - tooltipHeight - tooltipItem.bottomMargin, tooltipWidth, tooltipHeight);

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
    final drawOffset = Offset(
      rect.center.dx - (drawingTextPainter.width / 2),
      rect.topCenter.dy + tooltipData.tooltipPadding.top,
    );
    canvasWrapper.drawText(drawingTextPainter, drawOffset);
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

  /// Makes a [ScatterTouchResponse] based on the provided [FlTouchInput]
  ///
  /// Processes [FlTouchInput.getOffset] and checks
  /// the elements of the chart that are near the offset,
  /// then makes a [ScatterTouchResponse] from the elements that has been touched.
  @override
  ScatterTouchResponse handleTouch(FlTouchInput touchInput, Size size) {
    final chartViewSize = getChartUsableDrawSize(size);

    for (var i = 0; i < data.scatterSpots.length; i++) {
      final spot = data.scatterSpots[i];

      final spotPixelX = getPixelX(spot.x, chartViewSize);
      final spotPixelY = getPixelY(spot.y, chartViewSize);

      if ((touchInput.getOffset().dx - spotPixelX).abs() <=
              (spot.radius / 2) + data.scatterTouchData.touchSpotThreshold &&
          (touchInput.getOffset().dy - spotPixelY).abs() <=
              (spot.radius / 2) + data.scatterTouchData.touchSpotThreshold) {
        return ScatterTouchResponse(touchInput, spot, i);
      }
    }

    return ScatterTouchResponse(touchInput, null, -1);
  }

  /// Determines should it redraw the chart or not.
  ///
  /// If there is a change in the [ScatterChartData],
  /// [ScatterChartPainter] should repaint itself.
  @override
  bool shouldRepaint(ScatterChartPainter oldDelegate) => oldDelegate.data != data;
}
