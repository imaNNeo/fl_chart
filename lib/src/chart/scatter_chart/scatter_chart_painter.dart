import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';
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

    drawAxisTitles(canvas, size);
    _drawTitles(canvas, size);
    _drawSpots(canvas, size);

    for (int i = 0; i < targetData.scatterSpots.length; i++) {
      if (!targetData.showingTooltipIndicators.contains(i)) {
        continue;
      }

      final ScatterSpot scatterSpot = targetData.scatterSpots[i];
      _drawTouchTooltip(canvas, size, targetData.scatterTouchData.touchTooltipData, scatterSpot);
    }
  }

  void _drawTitles(Canvas canvas, Size viewSize) {
    if (!targetData.titlesData.show) {
      return;
    }
    viewSize = getChartUsableDrawSize(viewSize);

    // Left Titles
    final leftTitles = targetData.titlesData.leftTitles;
    final leftInterval =
        leftTitles.interval ?? getEfficientInterval(viewSize.height, data.verticalDiff);
    if (leftTitles.showTitles) {
      double verticalSeek = data.minY;
      while (verticalSeek <= data.maxY) {
        if (leftTitles.checkToShowTitle(
            data.minY, data.maxY, leftTitles, leftInterval, verticalSeek)) {
          double x = 0 + getLeftOffsetDrawSize();
          double y = getPixelY(verticalSeek, viewSize);

          final String text = leftTitles.getTitles(verticalSeek);

          final TextSpan span = TextSpan(style: leftTitles.getTextStyles(verticalSeek), text: text);
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
      double horizontalSeek = data.minX;
      while (horizontalSeek <= data.maxX) {
        if (topTitles.checkToShowTitle(
            data.minX, data.maxX, topTitles, topInterval, horizontalSeek)) {
          double x = getPixelX(horizontalSeek, viewSize);
          double y = getTopOffsetDrawSize();

          final String text = topTitles.getTitles(horizontalSeek);

          final TextSpan span =
              TextSpan(style: topTitles.getTextStyles(horizontalSeek), text: text);
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
      double verticalSeek = data.minY;
      while (verticalSeek <= data.maxY) {
        if (rightTitles.checkToShowTitle(
            data.minY, data.maxY, rightTitles, rightInterval, verticalSeek)) {
          double x = viewSize.width + getLeftOffsetDrawSize();
          double y = getPixelY(verticalSeek, viewSize);

          final String text = rightTitles.getTitles(verticalSeek);

          final TextSpan span =
              TextSpan(style: rightTitles.getTextStyles(verticalSeek), text: text);
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
      double horizontalSeek = data.minX;
      while (horizontalSeek <= data.maxX) {
        if (bottomTitles.checkToShowTitle(
            data.minX, data.maxX, bottomTitles, bottomInterval, horizontalSeek)) {
          double x = getPixelX(horizontalSeek, viewSize);
          double y = viewSize.height + getTopOffsetDrawSize();

          final String text = bottomTitles.getTitles(horizontalSeek);

          final TextSpan span =
              TextSpan(style: bottomTitles.getTextStyles(horizontalSeek), text: text);
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
        }
        if (data.maxX - horizontalSeek < bottomInterval && data.maxX != horizontalSeek) {
          horizontalSeek = data.maxX;
        } else {
          horizontalSeek += bottomInterval;
        }
      }
    }
  }

  void _drawSpots(Canvas canvas, Size viewSize) {
    if (data.scatterSpots == null) {
      return;
    }
    final chartUsableSize = getChartUsableDrawSize(viewSize);
    for (final ScatterSpot scatterSpot in data.scatterSpots) {
      if (!scatterSpot.show) {
        continue;
      }
      final double pixelX = getPixelX(scatterSpot.x, chartUsableSize);
      final double pixelY = getPixelY(scatterSpot.y, chartUsableSize);

      _spotsPaint.color = scatterSpot.color;

      canvas.drawCircle(
        Offset(pixelX, pixelY),
        scatterSpot.radius,
        _spotsPaint,
      );
    }
  }

  void _drawTouchTooltip(
      Canvas canvas, Size viewSize, ScatterTouchTooltipData tooltipData, ScatterSpot showOnSpot) {
    final Size chartUsableSize = getChartUsableDrawSize(viewSize);

    final ScatterTooltipItem tooltipItem = tooltipData.getTooltipItems(showOnSpot);

    if (tooltipItem == null) {
      return;
    }

    final TextSpan span = TextSpan(style: tooltipItem.textStyle, text: tooltipItem.text);
    final TextPainter drawingTextPainter = TextPainter(
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
    final Offset mostTopOffset = Offset(
      getPixelX(showOnSpot.x, chartUsableSize),
      getPixelY(showOnSpot.y, chartUsableSize),
    );

    final double tooltipWidth = width + tooltipData.tooltipPadding.horizontal;
    final double tooltipHeight = height + tooltipData.tooltipPadding.vertical;

    /// draw the background rect with rounded radius
    Rect rect = Rect.fromLTWH(mostTopOffset.dx - (tooltipWidth / 2),
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

    final Radius radius = Radius.circular(tooltipData.tooltipRoundedRadius);
    final RRect roundedRect = RRect.fromRectAndCorners(rect,
        topLeft: radius, topRight: radius, bottomLeft: radius, bottomRight: radius);
    _bgTouchTooltipPaint.color = tooltipData.tooltipBgColor;
    canvas.drawRRect(roundedRect, _bgTouchTooltipPaint);

    /// draw the texts one by one in below of each other
    final drawOffset = Offset(
      rect.center.dx - (drawingTextPainter.width / 2),
      rect.topCenter.dy + tooltipData.tooltipPadding.top,
    );
    drawingTextPainter.paint(canvas, drawOffset);
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

  /// Makes a [ScatterTouchResponse] based on the provided [FlTouchInput]
  ///
  /// Processes [FlTouchInput.getOffset] and checks
  /// the elements of the chart that are near the offset,
  /// then makes a [ScatterTouchResponse] from the elements that has been touched.
  @override
  ScatterTouchResponse handleTouch(FlTouchInput touchInput, Size size) {
    final Size chartViewSize = getChartUsableDrawSize(size);

    for (int i = 0; i < data.scatterSpots.length; i++) {
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
