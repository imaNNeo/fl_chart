import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_data.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_painter.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HorizontalBarChartPainter extends AxisChartPainter<HorizontalBarChartData>
    with TouchHandler<BarTouchResponse> {
  Paint barPaint, bgTouchTooltipPaint;
  Paint clearPaint;

  List<GroupBarsPosition> groupBarsPosition;

  HorizontalBarChartPainter(HorizontalBarChartData data,
      HorizontalBarChartData targetData, Function(TouchHandler) touchHandler,
      {double textScale = 1})
      : super(data, targetData, textScale: textScale) {
    touchHandler(this);
    barPaint = Paint()..style = PaintingStyle.fill;

    bgTouchTooltipPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    clearPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white
      ..blendMode = BlendMode.dstIn;
  }

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    if (data.barGroups.isEmpty) {
      return;
    }

    final List<double> verticalGroups =
        calculateGroupValues(size, data.barGroups, data.alignment);
    groupBarsPosition =
        calculateGroupAndBarsPosition(verticalGroups, data.barGroups);

    drawBars(canvas, size, groupBarsPosition);
    drawAxisTitles(canvas, size);
    drawTitles(canvas, size, groupBarsPosition);

    for (int i = 0; i < targetData.barGroups.length; i++) {
      final barGroup = targetData.barGroups[i];
      for (int j = 0; j < barGroup.barRods.length; j++) {
        if (!barGroup.showingTooltipIndicators.contains(j)) {
          continue;
        }
        final barRod = barGroup.barRods[j];

        drawTouchTooltip(canvas, size, groupBarsPosition,
            targetData.barTouchData.touchTooltipData, barGroup, i, barRod, j);
      }
    }
  }

  /// this method calculates the y of our showing groups,
  /// they calculate as center of the group
  /// we position the groups based on the given [alignment],
  List<double> calculateGroupValues(Size viewSize,
      List<BarChartGroupData> barGroups, BarChartAlignment alignment) {
    final Size drawSize = getChartUsableDrawSize(viewSize);

    final List<double> verticalGroups = List<double>(barGroups.length);

    final double topTextSpace = getTopOffsetDrawSize();

    switch (alignment) {
      case BarChartAlignment.start:
        double tempValue = 0;
        barGroups.asMap().forEach((i, group) {
          verticalGroups[i] = topTextSpace + tempValue + group.width / 2;
          tempValue += group.width + data.groupsSpace;
        });
        break;

      case BarChartAlignment.end:
        double tempValue = 0;
        for (int i = barGroups.length - 1; i >= 0; i--) {
          final group = barGroups[i];
          verticalGroups[i] =
              (topTextSpace + drawSize.height) - tempValue - group.width / 2;
          tempValue += group.width + data.groupsSpace;
        }
        break;

      case BarChartAlignment.center:
        double sumHeight =
            barGroups.map((group) => group.width).reduce((a, b) => a + b);
        sumHeight += data.groupsSpace * (barGroups.length - 1);
        final double verticalMargin = (drawSize.height - sumHeight) / 2;

        double tempValue = 0;
        for (int i = 0; i < barGroups.length; i++) {
          final group = barGroups[i];
          verticalGroups[i] =
              topTextSpace + verticalMargin + tempValue + group.width / 2;

          final double groupSpace =
              i == barGroups.length - 1 ? 0 : data.groupsSpace;
          tempValue += group.width + groupSpace;
        }
        break;

      case BarChartAlignment.spaceBetween:
        final double sumHeight =
            barGroups.map((group) => group.width).reduce((a, b) => a + b);
        final double spaceAvailable = drawSize.height - sumHeight;
        final double eachSpace = spaceAvailable / (barGroups.length - 1);

        double tempValue = 0;
        barGroups.asMap().forEach((index, group) {
          tempValue += group.width / 2;
          if (index != 0) {
            tempValue += eachSpace;
          }
          verticalGroups[index] = topTextSpace + tempValue;
          tempValue += group.width / 2;
        });
        break;

      case BarChartAlignment.spaceAround:
        final double sumHeight =
            barGroups.map((group) => group.width).reduce((a, b) => a + b);
        final double spaceAvailable = drawSize.height - sumHeight;
        final double eachSpace = spaceAvailable / (barGroups.length * 2);

        double tempValue = 0;
        barGroups.asMap().forEach((i, group) {
          tempValue += eachSpace;
          tempValue += group.width / 2;
          verticalGroups[i] = topTextSpace + tempValue;
          tempValue += group.width / 2;
          tempValue += eachSpace;
        });
        break;

      case BarChartAlignment.spaceEvenly:
        final double sumHeight =
            barGroups.map((group) => group.width).reduce((a, b) => a + b);
        final double spaceAvailable = drawSize.height - sumHeight;
        final double eachSpace = spaceAvailable / (barGroups.length + 1);

        double tempValue = 0;
        barGroups.asMap().forEach((i, group) {
          tempValue += eachSpace;
          tempValue += group.width / 2;
          verticalGroups[i] = topTextSpace + tempValue;
          tempValue += group.width / 2;
        });
        break;
    }

    return verticalGroups;
  }

  List<GroupBarsPosition> calculateGroupAndBarsPosition(
      List<double> verticalGroups, List<BarChartGroupData> barGroups) {
    if (verticalGroups.length != barGroups.length) {
      throw Exception('inconsistent state groupsX.length != barGroups.length');
    }

    final List<GroupBarsPosition> groupBarsPosition = [];
    for (int i = 0; i < barGroups.length; i++) {
      final BarChartGroupData barGroup = barGroups[i];
      final double groupValue = verticalGroups[i];

      double tempValue = 0;
      final List<double> barsValues = [];
      barGroup.barRods.asMap().forEach((barIndex, barRod) {
        final double widthHalf = barRod.width / 2;
        barsValues
            .add(groupValue - (barGroup.width / 2) + tempValue + widthHalf);
        tempValue += barRod.width + barGroup.barsSpace;
      });
      groupBarsPosition.add(GroupBarsPosition(groupValue, barsValues));
    }
    return groupBarsPosition;
  }

  void drawBars(
      Canvas canvas, Size viewSize, List<GroupBarsPosition> groupBarsPosition) {
    final Size drawSize = getChartUsableDrawSize(viewSize);

    for (int i = 0; i < data.barGroups.length; i++) {
      final barGroup = data.barGroups[i];
      for (int j = 0; j < barGroup.barRods.length; j++) {
        final barRod = barGroup.barRods[j];
        final double widthHalf = barRod.width / 2;
        final BorderRadius borderRadius =
            barRod.borderRadius ?? BorderRadius.circular(barRod.width / 2);

        final double down = groupBarsPosition[i].barsOffset[j];

        final left = getPixelX(0, drawSize);
        final top = down - widthHalf;
        final bottom = down + widthHalf;
        final cornerLeft =
            max(borderRadius.topLeft.x, borderRadius.bottomLeft.x);
        final cornerWidth = cornerLeft +
            max(borderRadius.topRight.x, borderRadius.bottomRight.x);
        final right = barRod.value != 0
            ? max(getPixelX(barRod.value, drawSize), cornerWidth)
            : left;

        /// Draw [BackgroundBarChartRodData]
        if (barRod.backDrawRodData.show && barRod.backDrawRodData.value != 0) {
          final backRight = max(
              getPixelX(barRod.backDrawRodData.value, drawSize), cornerWidth);

          barPaint.color = barRod.backDrawRodData.color;
          canvas.drawRRect(
              RRect.fromLTRBAndCorners(left, top, backRight, bottom,
                  topLeft: borderRadius.topLeft,
                  topRight: borderRadius.topRight,
                  bottomLeft: borderRadius.bottomLeft,
                  bottomRight: borderRadius.bottomRight),
              barPaint);
        }

        // draw Main Rod
        if (barRod.value != 0) {
          barPaint.color = barRod.color;
          final barRect = RRect.fromLTRBAndCorners(left, top, right, bottom,
              topLeft: borderRadius.topLeft,
              topRight: borderRadius.topRight,
              bottomLeft: borderRadius.bottomLeft,
              bottomRight: borderRadius.bottomRight);
          canvas.drawRRect(barRect, barPaint);

          // draw rod stack
          if (barRod.rodStackItem != null && barRod.rodStackItem.isNotEmpty) {
            for (int i = 0; i < barRod.rodStackItem.length; i++) {
              final stackItem = barRod.rodStackItem[i];
              final stackBottom = getPixelY(stackItem.fromValue, drawSize);
              final stackTop =
                  max(getPixelY(stackItem.toValue, drawSize), cornerWidth);

              barPaint.color = stackItem.color;
              canvas.save();
              canvas
                  .clipRect(Rect.fromLTRB(left, stackTop, right, stackBottom));
              canvas.drawRRect(barRect, barPaint);
              canvas.restore();
            }
          }
        }

        // draw main title
        if (barRod.showTitle && (barRod.title?.isNotEmpty ?? false)) {
          final span = TextSpan(style: barRod.titleStyle, text: barRod.title);
          var tp = TextPainter(
              text: span,
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr,
              maxLines: 1,
              ellipsis: '…',
              textScaleFactor: textScale);
          var offset = barRod.titlePadding + cornerLeft;
          final topLeft = Offset(left, down);
          final contentWidth = right - left - cornerWidth;
          if (contentWidth > 0) {
            tp.layout(maxWidth: contentWidth);
          }
          if (contentWidth <= 0 ||
              (tp.maxIntrinsicWidth > contentWidth - barRod.titlePadding &&
                  contentWidth < drawSize.width - right)) {
            final span =
                TextSpan(style: barRod.sideTitleStyle, text: barRod.title);
            tp = TextPainter(
                text: span,
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                maxLines: 1,
                ellipsis: '…',
                textScaleFactor: textScale);
            offset = contentWidth + cornerWidth + barRod.titlePadding;
            final spaceRight = drawSize.width -
                contentWidth -
                barRod.titlePadding -
                cornerWidth;
            if (spaceRight > 0) {
              tp.layout(maxWidth: spaceRight);
              tp.paint(canvas, topLeft.translate(offset, -tp.height / 2));
            }
          } else if (contentWidth > 0) {
            tp.paint(canvas, topLeft.translate(offset, -tp.height / 2));
          }
        }
      }
    }
  }

  void drawTitles(
      Canvas canvas, Size viewSize, List<GroupBarsPosition> groupBarsPosition) {
    if (!data.titlesData.show) {
      return;
    }
    final Size drawSize = getChartUsableDrawSize(viewSize);

    // Top Titles
    final topTitles = data.titlesData.topTitles;
    if (topTitles.showTitles) {
      double verticalSeek = data.minX;
      while (verticalSeek <= data.maxX) {
        double x = getLeftOffsetDrawSize();

        final String text = topTitles.getTitles(verticalSeek);

        final TextSpan span = TextSpan(style: topTitles.textStyle, text: text);
        final TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            maxLines: 1,
            textScaleFactor: textScale);
        tp.layout();
        x = getPixelX(verticalSeek, drawSize) -
            (verticalSeek * tp.width / data.maxX);
        tp.paint(canvas,
            Offset(x, getTopOffsetDrawSize() - topTitles.margin - tp.height));
        verticalSeek += topTitles.interval;
      }
    }

    // Left Titles
    final leftTitles = data.titlesData.leftTitles;
    if (leftTitles.showTitles) {
      for (int index = 0; index < groupBarsPosition.length; index++) {
        final GroupBarsPosition groupBarPos = groupBarsPosition[index];

        final String text = leftTitles.getTitles(index.toDouble());

        final TextSpan span = TextSpan(style: leftTitles.textStyle, text: text);
        final TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.right,
            textDirection: TextDirection.ltr,
            maxLines: 1,
            textScaleFactor: textScale);
        tp.layout(minWidth: leftTitles.reservedSize);

        final double textY = groupBarPos.groupOffset - tp.height / 2;

        tp.paint(canvas, Offset(super.getLeftOffsetDrawSize(), textY));
      }
    }
  }

  void drawTouchTooltip(
    Canvas canvas,
    Size viewSize,
    List<GroupBarsPosition> groupPositions,
    BarTouchTooltipData tooltipData,
    BarChartGroupData showOnBarGroup,
    int barGroupIndex,
    BarChartRodData showOnRodData,
    int barRodIndex,
  ) {
    final Size chartUsableSize = getChartUsableDrawSize(viewSize);

    const double textsBelowMargin = 4;

    final BarTooltipItem tooltipItem = tooltipData.getTooltipItem(
      showOnBarGroup,
      barGroupIndex,
      showOnRodData,
      barRodIndex,
    );

    if (tooltipItem == null) {
      return;
    }

    final TextSpan span =
        TextSpan(style: tooltipItem.textStyle, text: tooltipItem.text);
    final TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        textScaleFactor: textScale);
    tp.layout(maxWidth: tooltipData.maxContentWidth);

    /// creating TextPainters to calculate the width and height of the tooltip
    final TextPainter drawingTextPainter = tp;

    /// biggerWidth
    /// some texts maybe larger, then we should
    /// draw the tooltip' width as wide as biggerWidth
    ///
    /// sumTextsHeight
    /// sum up all Texts height, then we should
    /// draw the tooltip's height as tall as sumTextsHeight
    final double textWidth = drawingTextPainter.width;
    final double textHeight = drawingTextPainter.height + textsBelowMargin;

    /// if we have multiple bar lines,
    /// there are more than one FlCandidate on touch area,
    /// we should get the most top FlSpot Offset to draw the tooltip on top of it
    final Offset mostTopOffset = Offset(
      getPixelX(showOnRodData.value, chartUsableSize),
      groupPositions[barGroupIndex].barsOffset[barRodIndex],
    );

    final double tooltipWidth =
        textWidth + tooltipData.tooltipPadding.horizontal;
    final double tooltipHeight =
        textHeight + tooltipData.tooltipPadding.vertical;

    /// draw the background rect with rounded radius
    final Rect rect = Rect.fromLTWH(
        min(mostTopOffset.dx + tooltipData.tooltipBottomMargin,
            viewSize.width - tooltipWidth),
        mostTopOffset.dy - tooltipHeight / 2,
        tooltipWidth,
        tooltipHeight);
    final Radius radius = Radius.circular(tooltipData.tooltipRoundedRadius);
    final RRect roundedRect = RRect.fromRectAndCorners(rect,
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius);
    bgTouchTooltipPaint.color = tooltipData.tooltipBgColor;
    canvas.drawRRect(roundedRect, bgTouchTooltipPaint);

    /// draw the texts one by one in below of each other
    final double top = tooltipData.tooltipPadding.top;
    final drawOffset = Offset(
      rect.center.dx - (tp.width / 2),
      rect.topCenter.dy + top,
    );
    tp.paint(canvas, drawOffset);
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
      final bottomSide = data.titlesData.bottomTitles;
      if (bottomSide.showTitles) {
        sum += bottomSide.reservedSize + bottomSide.margin;
      }
    }
    return sum;
  }

  @override
  double getTopOffsetDrawSize() {
    var sum = super.getTopOffsetDrawSize();

    final topTitles = data.titlesData.topTitles;
    if (data.titlesData.show && topTitles.showTitles) {
      sum += topTitles.reservedSize + topTitles.margin;
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

  @override
  BarTouchResponse handleTouch(FlTouchInput touchInput, Size size) {
    final BarTouchedSpot touchedSpot =
        _getNearestTouchedSpot(size, touchInput.getOffset(), groupBarsPosition);
    return BarTouchResponse(touchedSpot, touchInput);
  }

  /// find the nearest spot base on the touched offset
  BarTouchedSpot _getNearestTouchedSpot(Size viewSize, Offset touchedPoint,
      List<GroupBarsPosition> groupBarsPosition) {
    final Size chartViewSize = getChartUsableDrawSize(viewSize);

    for (int i = 0; i < groupBarsPosition.length; i++) {
      final GroupBarsPosition groupBarPos = groupBarsPosition[i];
      for (int j = 0; j < groupBarPos.barsOffset.length; j++) {
        final double barY = groupBarPos.barsOffset[j];
        final double barWidth = targetData.barGroups[i].barRods[j].width;
        final double barMinX = getPixelX(0, chartViewSize);
        final double barMaxX =
            getPixelX(targetData.barGroups[i].barRods[j].value, chartViewSize);
        final double barMinY = barY - barWidth / 2;
        final double barMaxY = barMinY + barWidth;

        final double backDrawBarMaxX = getPixelX(
            targetData.barGroups[i].barRods[j].backDrawRodData.value,
            chartViewSize);
        final EdgeInsets touchExtraThreshold =
            targetData.barTouchData.touchExtraThreshold;

        final bool isXInBarBounds =
            (barMinX - touchExtraThreshold.left <= touchedPoint.dx) &&
                (touchedPoint.dx <= barMaxX + touchExtraThreshold.right);

        final bool isYInTouchBounds =
            (barMinY - touchExtraThreshold.top <= touchedPoint.dy) &&
                (touchedPoint.dy <= barMaxY + touchExtraThreshold.bottom);

        final bool isXInBarBackDrawBounds =
            (barMinX - touchExtraThreshold.left <= touchedPoint.dx) &&
                (touchedPoint.dx <=
                    backDrawBarMaxX + touchExtraThreshold.right);

        final bool isXInTouchBounds =
            (targetData.barTouchData.allowTouchBarBackDraw &&
                    isXInBarBackDrawBounds) ||
                isXInBarBounds;

        if (isXInTouchBounds && isYInTouchBounds) {
          final nearestGroup = targetData.barGroups[i];
          final nearestBarRod = nearestGroup.barRods[j];
          final nearestSpot =
              FlSpot(nearestGroup.value.toDouble(), nearestBarRod.value);
          final nearestSpotPos =
              Offset(getPixelX(nearestSpot.x, chartViewSize), barY);

          return BarTouchedSpot(
              nearestGroup, i, nearestBarRod, j, nearestSpot, nearestSpotPos);
        }
      }
    }

    return null;
  }

  @override
  bool shouldRepaint(HorizontalBarChartPainter oldDelegate) =>
      oldDelegate.data != data;
}
