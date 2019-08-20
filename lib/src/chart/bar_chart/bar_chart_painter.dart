import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_data.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BarChartPainter extends AxisChartPainter {
  final BarChartData data;

  Paint barPaint;

  BarChartPainter(
    this.data,
    FlTouchInputNotifier touchController,
    StreamSink<BarTouchResponse> touchedResponseSink,
  ) : super(data, touchInputNotifier: touchController, touchedResponseSink: touchedResponseSink) {
    barPaint = Paint()..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    if (data.barGroups.isEmpty) {
      return;
    }

    final List<double> groupsX = calculateGroupsX(size, data.barGroups, data.alignment);
    final List<GroupBarsPosition> groupBarsPosition =
      calculateGroupAndBarsPosition(size, groupsX, data.barGroups);

    final BarTouchedSpot touchedSpot =
      _getNearestTouchedSpot(canvas, size, groupBarsPosition);

    drawBars(canvas, size, groupBarsPosition);
    drawTitles(canvas, size, groupBarsPosition);

    super.drawTouchTooltip(canvas, size, data.barTouchData.touchTooltipData, [touchedSpot]);

    if (touchedResponseSink != null && touchInputNotifier != null
      && touchInputNotifier.value != null
      && !(touchInputNotifier.value.runtimeType is NonTouch)) {
      touchedResponseSink.add(BarTouchResponse(touchedSpot, touchInputNotifier.value));
      releaseIfEndTouch();
    }
  }

  /// this method calculates the x of our showing groups,
  /// they calculate as center of the group
  /// we position the groups based on the given [alignment],
  List<double> calculateGroupsX(
      Size viewSize, List<BarChartGroupData> barGroups, BarChartAlignment alignment) {
    Size drawSize = getChartUsableDrawSize(viewSize);

    List<double> groupsX = List(barGroups.length);

    double leftTextsSpace = getLeftOffsetDrawSize();

    switch (alignment) {
      case BarChartAlignment.start:
        double tempX = 0;
        barGroups.asMap().forEach((i, group) {
          groupsX[i] = leftTextsSpace + tempX + group.width / 2;
          tempX += group.width;
        });
        break;

      case BarChartAlignment.end:
        double tempX = 0;
        for (int i = barGroups.length - 1; i >= 0; i--) {
          var group = barGroups[i];
          groupsX[i] = (leftTextsSpace + drawSize.width) - tempX - group.width / 2;
          tempX += group.width;
        }
        break;

      case BarChartAlignment.center:
        double sumWidth = barGroups.map((group) => group.width).reduce((a, b) => a + b);

        double horizontalMargin = (drawSize.width - sumWidth) / 2;

        double tempX = 0;
        for (int i = 0; i < barGroups.length; i++) {
          var group = barGroups[i];
          groupsX[i] = leftTextsSpace + horizontalMargin + tempX + group.width / 2;
          tempX += group.width;
        }
        break;

      case BarChartAlignment.spaceBetween:
        double sumWidth = barGroups.map((group) => group.width).reduce((a, b) => a + b);
        double spaceAvailable = drawSize.width - sumWidth;
        double eachSpace = spaceAvailable / (barGroups.length - 1);

        double tempX = 0;
        barGroups.asMap().forEach((index, group) {
          tempX += (group.width / 2);
          if (index != 0) {
            tempX += eachSpace;
          }
          groupsX[index] = leftTextsSpace + tempX;
          tempX += (group.width / 2);
        });
        break;

      case BarChartAlignment.spaceAround:
        double sumWidth = barGroups.map((group) => group.width).reduce((a, b) => a + b);
        double spaceAvailable = drawSize.width - sumWidth;
        double eachSpace = spaceAvailable / (barGroups.length * 2);

        double tempX = 0;
        barGroups.asMap().forEach((i, group) {
          tempX += eachSpace;
          tempX += group.width / 2;
          groupsX[i] = leftTextsSpace + tempX;
          tempX += group.width / 2;
          tempX += eachSpace;
        });
        break;

      case BarChartAlignment.spaceEvenly:
        double sumWidth = barGroups.map((group) => group.width).reduce((a, b) => a + b);
        double spaceAvailable = drawSize.width - sumWidth;
        double eachSpace = spaceAvailable / (barGroups.length + 1);

        double tempX = 0;
        barGroups.asMap().forEach((i, group) {
          tempX += eachSpace;
          tempX += group.width / 2;
          groupsX[i] = leftTextsSpace + tempX;
          tempX += group.width / 2;
        });
        break;
    }

    return groupsX;
  }

  List<GroupBarsPosition> calculateGroupAndBarsPosition(Size viewSize, List<double> groupsX, List<BarChartGroupData> barGroups) {
    if (groupsX.length != barGroups.length) {
      throw Exception('inconsistent state groupsX.length != barGroups.length');
    }

    final List<GroupBarsPosition> groupBarsPosition = [];
    for (int i = 0; i < barGroups.length; i++) {
      final BarChartGroupData barGroup = barGroups[i];
      final double groupX = groupsX[i];

      double tempX = 0;
      final List<double> barsX = [];
      barGroup.barRods.asMap().forEach((barIndex, barRod) {
        final double widthHalf = barRod.width / 2;
        barsX.add(groupX - (barGroup.width / 2) + tempX + widthHalf);
        tempX += barRod.width + barGroup.barsSpace;
      });
      groupBarsPosition.add(GroupBarsPosition(groupX, barsX));
    }
    return groupBarsPosition;
  }


  void drawBars(Canvas canvas, Size viewSize, List<GroupBarsPosition> groupBarsPosition) {
    Size drawSize = getChartUsableDrawSize(viewSize);

    data.barGroups.asMap().forEach((groupIndex, barGroup) {

      barGroup.barRods.asMap().forEach((barIndex, barRod) {
        double widthHalf = barRod.width / 2;
        double roundedRadius = barRod.isRound ? widthHalf : 0;

        final double x = groupBarsPosition[groupIndex].barsX[barIndex];

        Offset from, to;

        barPaint.strokeWidth = barRod.width;
        barPaint.strokeCap = barRod.isRound ? StrokeCap.round : StrokeCap.butt;

        /// Draw [BackgroundBarChartRodData]
        if (barRod.backDrawRodData.show && barRod.backDrawRodData.y != 0) {
          from = Offset(x, getPixelY(0, drawSize) - roundedRadius,);
          to = Offset(x, getPixelY(barRod.backDrawRodData.y, drawSize) + roundedRadius,);
          barPaint.color = barRod.backDrawRodData.color;
          canvas.drawLine(from, to, barPaint);
        }

        // draw Main Rod
        if (barRod.y != 0) {
          final yFrom = getPixelY(0, drawSize);
          from = Offset(x, yFrom - roundedRadius,);

          var yTo = getPixelY(barRod.y, drawSize);

          if ((yFrom - yTo).abs() <= barRod.width) {
            yTo = yFrom - barRod.width;
          }

          to = Offset(x, yTo + roundedRadius,);
          barPaint.color = barRod.color;
          canvas.drawLine(from, to, barPaint);
        }
      });
    });
  }

  void drawTitles(Canvas canvas, Size viewSize, List<GroupBarsPosition> groupBarsPosition) {
    if (!data.titlesData.show) {
      return;
    }
    Size drawSize = getChartUsableDrawSize(viewSize);

    // Left Titles
    final leftTitles = data.titlesData.leftTitles;
    if (leftTitles.showTitles) {
      int verticalCounter = 0;
      while (data.gridData.verticalInterval * verticalCounter <= data.maxY) {
        double x = 0 + getLeftOffsetDrawSize();
        double y = getPixelY(data.gridData.verticalInterval * verticalCounter, drawSize) +
            getTopOffsetDrawSize();

        String text = leftTitles.getTitles(data.gridData.verticalInterval * verticalCounter);

        TextSpan span = TextSpan(style: leftTitles.textStyle, text: text);
        TextPainter tp = TextPainter(
            text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
        tp.layout(maxWidth: getExtraNeededHorizontalSpace());
        x -= tp.width + leftTitles.margin;
        y -= tp.height / 2;
        tp.paint(canvas, Offset(x, y));

        verticalCounter++;
      }
    }

    // Right Titles
    final rightTitles = data.titlesData.rightTitles;
    if (rightTitles.showTitles) {
      int verticalCounter = 0;
      while (data.gridData.verticalInterval * verticalCounter <= data.maxY) {
        double x = drawSize.width + getLeftOffsetDrawSize();
        double y = getPixelY(data.gridData.verticalInterval * verticalCounter, drawSize) +
          getTopOffsetDrawSize();

        String text = rightTitles.getTitles(data.gridData.verticalInterval * verticalCounter);

        TextSpan span = TextSpan(style: rightTitles.textStyle, text: text);
        TextPainter tp = TextPainter(
          text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
        tp.layout(maxWidth: getExtraNeededHorizontalSpace());
        x += rightTitles.margin;
        y -= tp.height / 2;
        tp.paint(canvas, Offset(x, y));

        verticalCounter++;
      }
    }

    // Bottom titles
    final bottomTitles = data.titlesData.bottomTitles;
    if (bottomTitles.showTitles) {
      for (int index = 0; index < groupBarsPosition.length; index ++) {
        GroupBarsPosition groupBarPos = groupBarsPosition[index];

        String text = bottomTitles.getTitles(index.toDouble());

        TextSpan span = TextSpan(style: bottomTitles.textStyle, text: text);
        TextPainter tp = TextPainter(
          text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
        tp.layout();

        double textX = groupBarPos.groupX - (tp.width / 2);
        double textY =
          drawSize.height + getTopOffsetDrawSize() + bottomTitles.margin;

        tp.paint(canvas, Offset(textX, textY));
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

  /// find the nearest spot base on the touched offset
  BarTouchedSpot _getNearestTouchedSpot(Canvas canvas, Size viewSize, List<GroupBarsPosition> groupBarsPosition) {
    final Size chartViewSize = getChartUsableDrawSize(viewSize);

    if (touchInputNotifier == null || touchInputNotifier.value == null) {
      return null;
    }


    final touch = touchInputNotifier.value;

    if (touch.getOffset() == null) {
      return null;
    }

    final touchedPoint = touch.getOffset();

    /// Find the nearest barRod
    for (int i = 0; i < groupBarsPosition.length; i++) {
      final GroupBarsPosition groupBarPos = groupBarsPosition[i];
      for (int j = 0; j < groupBarPos.barsX.length; j++) {

        final double barX = groupBarPos.barsX[j];
        final double barWidth = data.barGroups[i].barRods[j].width;
        final double halfBarWidth = barWidth / 2;
        final double barTopY = getPixelY(data.barGroups[i].barRods[j].y, chartViewSize);
        final double barBotY = getPixelY(0, chartViewSize);
        final double backDrawBarTopY = getPixelY(data.barGroups[i].barRods[j].backDrawRodData.y, chartViewSize);
        final EdgeInsets touchExtraThreshold = data.barTouchData.touchExtraThreshold;

        final bool isXInTouchBounds =
          (touchedPoint.dx <= barX + halfBarWidth + touchExtraThreshold.right) &&
            (touchedPoint.dx >= barX - halfBarWidth - touchExtraThreshold.left);

        final bool isYInBarBounds =
          (touchedPoint.dy <= barBotY + touchExtraThreshold.bottom) &&
            (touchedPoint.dy >= barTopY - touchExtraThreshold.top);

        final bool isYInBarBackDrawBounds =
          (touchedPoint.dy <= barBotY + touchExtraThreshold.bottom) &&
            (touchedPoint.dy >= backDrawBarTopY - touchExtraThreshold.top);

        final bool isYInTouchBounds =
          (data.barTouchData.allowTouchBarBackDraw && isYInBarBackDrawBounds) || isYInBarBounds;

        if (isXInTouchBounds && isYInTouchBounds) {
          final nearestGroup = data.barGroups[i];
          final nearestBarRod = nearestGroup.barRods[j];
          final nearestSpot = FlSpot(nearestGroup.x.toDouble(), nearestBarRod.y);
          final nearestSpotPos = Offset(barX, getPixelY(nearestSpot.y, chartViewSize));

          return BarTouchedSpot(nearestGroup, nearestBarRod, nearestSpot, nearestSpotPos);
        }
      }
    }

    return BarTouchedSpot(null, null, null, null);
  }

  @override
  bool shouldRepaint(BarChartPainter oldDelegate) =>
      oldDelegate.data != this.data;
}

class GroupBarsPosition {
  final double groupX;
  final List<double> barsX;

  GroupBarsPosition(this.groupX, this.barsX);
}