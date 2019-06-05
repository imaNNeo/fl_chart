import 'package:fl_chart/src/chart/bar_chart/bar_chart_data.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BarChartPainter extends AxisChartPainter {
  final BarChartData data;

  Paint barPaint;

  BarChartPainter(
    this.data,
  ) : super(data) {
    barPaint = Paint()..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    if (data.barGroups.isEmpty) {
      return;
    }

    List<double> groupsX = calculateGroupsX(size, data.barGroups, data.alignment);
    drawBars(canvas, size, groupsX);
    drawTitles(canvas, size, groupsX);
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


  void drawBars(Canvas canvas, Size viewSize, List<double> barsX) {
    Size drawSize = getChartUsableDrawSize(viewSize);

    data.barGroups.asMap().forEach((groupIndex, barGroup) {

      /// If the height of rounded bars is less than their roundedRadius,
      /// we can't draw them properly,
      /// then we try to make them width lower radius,
      /// in this section we resize a new List with proper barsRadius.
      List<BarChartRodData> resizedWidthRods = barGroup.barRods.map((barRod) {
        if (!barRod.isRound) {
          return barRod;
        }

        double fromY = getPixelY(0, drawSize);
        double toY = getPixelY(barRod.y, drawSize);

        double barWidth = barRod.width;

        double barHeight = (fromY - toY).abs();
        while (barHeight < barWidth) {
          barWidth -= barWidth * 0.1;
        }

        if (barWidth == barRod.width) {
          return barRod;
        } else {
          return barRod.copyWith(width: barWidth);
        }
      }).toList();

      double tempX = 0;
      resizedWidthRods.asMap().forEach((barIndex, barRod) {
        double widthHalf = barRod.width / 2;
        double roundedRadius = barRod.isRound ? widthHalf : 0;

        double x = barsX[groupIndex] - (barGroup.width / 2) + tempX + widthHalf;

        Offset from, to;

        barPaint.strokeWidth = barRod.width;
        barPaint.strokeCap = barRod.isRound ? StrokeCap.round : StrokeCap.butt;

        /// Draw [BackgroundBarChartRodData]
        if (barRod.backDrawRodData.show) {
          from = Offset(x, getPixelY(0, drawSize) - roundedRadius,);
          to = Offset(x, getPixelY(barRod.backDrawRodData.y, drawSize) + roundedRadius,);
          barPaint.color = barRod.backDrawRodData.color;
          canvas.drawLine(from, to, barPaint);
        }

        // draw Main Rod
        from = Offset(x, getPixelY(0, drawSize) - roundedRadius,);
        to = Offset(x, getPixelY(barRod.y, drawSize) + roundedRadius,);
        barPaint.color = barRod.color;
        canvas.drawLine(from, to, barPaint);

        tempX += barRod.width + barGroup.barsSpace;
      });
    });
  }

  void drawTitles(Canvas canvas, Size viewSize, List<double> groupsX) {
    if (!data.titlesData.show) {
      return;
    }
    Size drawSize = getChartUsableDrawSize(viewSize);

    // Vertical Titles
    if (data.titlesData.showVerticalTitles) {
      int verticalCounter = 0;
      while (data.gridData.verticalInterval * verticalCounter <= data.maxY) {
        double x = 0 + getLeftOffsetDrawSize();
        double y = getPixelY(data.gridData.verticalInterval * verticalCounter, drawSize) +
            getTopOffsetDrawSize();

        String text =
            data.titlesData.getVerticalTitles(data.gridData.verticalInterval * verticalCounter);

        TextSpan span = TextSpan(style: data.titlesData.verticalTitlesTextStyle, text: text);
        TextPainter tp = TextPainter(
            text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
        tp.layout(maxWidth: getExtraNeededHorizontalSpace());
        x -= tp.width + data.titlesData.verticalTitleMargin;
        y -= (tp.height / 2);
        tp.paint(canvas, Offset(x, y));

        verticalCounter++;
      }
    }

    // Horizontal titles
    groupsX.asMap().forEach((int index, double x) {
      String text = data.titlesData.getHorizontalTitles(index.toDouble());

      TextSpan span = TextSpan(style: data.titlesData.horizontalTitlesTextStyle, text: text);
      TextPainter tp = TextPainter(
          text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      tp.layout();

      double textX = x - (tp.width / 2);
      double textY =
          drawSize.height + getTopOffsetDrawSize() + data.titlesData.horizontalTitleMargin;

      tp.paint(canvas, Offset(textX, textY));
    });
  }

  /// We add our needed horizontal space to parent needed.
  /// we have some titles that maybe draw in the left side of our chart,
  /// then we should draw the chart a with some left space,
  /// the left space is [getLeftOffsetDrawSize], and the whole
  @override
  double getExtraNeededHorizontalSpace() {
    double parentNeeded = super.getExtraNeededHorizontalSpace();
    if (data.titlesData.show && data.titlesData.showVerticalTitles) {
      return parentNeeded +
        data.titlesData.verticalTitlesReservedWidth +
        data.titlesData.verticalTitleMargin;
    }
    return parentNeeded;
  }

  /// We add our needed vertical space to parent needed.
  /// we have some titles that maybe draw in the bottom side of our chart.
  @override
  double getExtraNeededVerticalSpace() {
    double parentNeeded = super.getExtraNeededVerticalSpace();
    if (data.titlesData.show && data.titlesData.showHorizontalTitles) {
      return parentNeeded +
        data.titlesData.horizontalTitlesReservedHeight +
        data.titlesData.horizontalTitleMargin;
    }
    return parentNeeded;
  }

  /// calculate left offset for draw the chart,
  /// maybe we want to show both left and right titles,
  /// then just the left titles will effect on this function.
  @override
  double getLeftOffsetDrawSize() {
    double parentNeeded = super.getLeftOffsetDrawSize();
    if (data.titlesData.show && data.titlesData.showVerticalTitles) {
      return parentNeeded +
        data.titlesData.verticalTitlesReservedWidth +
        data.titlesData.verticalTitleMargin;
    }
    return parentNeeded;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
