import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/extensions/bar_chart_data_extension.dart';
import 'package:fl_chart/src/extensions/edge_insets_extension.dart';
import 'package:fl_chart/src/extensions/fl_titles_data_extension.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';

import '../axis_chart_helper.dart';
import 'side_titles_flex.dart';

enum TitlesSide { left, top, right, bottom }

class SideTitlesWidget extends StatelessWidget {
  final TitlesSide side;
  final AxisChartData axisChartData;
  final Size parentSize;

  const SideTitlesWidget({
    Key? key,
    required this.side,
    required this.axisChartData,
    required this.parentSize,
  }) : super(key: key);

  bool get isHorizontal => side == TitlesSide.top || side == TitlesSide.bottom;

  bool get isVertical => !isHorizontal;

  double get minX => axisChartData.minX;

  double get maxX => axisChartData.maxX;

  double get baselineX => axisChartData.baselineX;

  double get minY => axisChartData.minY;

  double get maxY => axisChartData.maxY;

  double get baselineY => axisChartData.baselineY;

  double get axisMin => isHorizontal ? minX : minY;

  double get axisMax => isHorizontal ? maxX : maxY;

  double get axisBaseLine => isHorizontal ? baselineX : baselineY;

  FlTitlesData get titlesData => axisChartData.titlesData;

  bool get isLeftOrTop => side == TitlesSide.left || side == TitlesSide.top;

  bool get isRightOrBottom =>
      side == TitlesSide.right || side == TitlesSide.bottom;

  AxisTitles get axisTitles {
    switch (side) {
      case TitlesSide.left:
        return titlesData.leftTitles;
      case TitlesSide.top:
        return titlesData.topTitles;
      case TitlesSide.right:
        return titlesData.rightTitles;
      case TitlesSide.bottom:
        return titlesData.bottomTitles;
    }
  }

  SideTitles get sideTitles => axisTitles.sideTitles;

  Axis get direction => isHorizontal ? Axis.horizontal : Axis.vertical;

  Axis get counterDirection => isHorizontal ? Axis.vertical : Axis.horizontal;

  Alignment get alignment {
    switch (side) {
      case TitlesSide.left:
        return Alignment.centerLeft;
      case TitlesSide.top:
        return Alignment.topCenter;
      case TitlesSide.right:
        return Alignment.centerRight;
      case TitlesSide.bottom:
        return Alignment.bottomCenter;
    }
  }

  EdgeInsets get thisSidePadding {
    switch (side) {
      case TitlesSide.right:
      case TitlesSide.left:
        return titlesData.allSidesPadding.onlyTopBottom;
      case TitlesSide.top:
      case TitlesSide.bottom:
        return titlesData.allSidesPadding.onlyLeftRight;
    }
  }

  double get thisSidePaddingTotal {
    switch (side) {
      case TitlesSide.right:
      case TitlesSide.left:
        return titlesData.allSidesPadding.vertical;
      case TitlesSide.top:
      case TitlesSide.bottom:
        return titlesData.allSidesPadding.horizontal;
    }
  }

  List<AxisSideTitleWidgetHolder> makeWidgets(
    double axisViewSize,
    double axisMin,
    double axisMax,
  ) {
    List<AxisSideTitleMetaData> axisPositions;
    final interval = sideTitles.interval ??
        Utils().getEfficientInterval(
          axisViewSize,
          axisMax - axisMin,
        );
    if (isHorizontal && axisChartData is BarChartData) {
      final barChartData = axisChartData as BarChartData;
      final xLocations = barChartData.calculateGroupsX(axisViewSize);
      axisPositions = xLocations.asMap().entries.map((e) {
        final index = e.key;
        final xLocation = e.value;
        final xValue = barChartData.barGroups[index].x;
        return AxisSideTitleMetaData(xValue.toDouble(), xLocation);
      }).toList();
    } else {
      final axisValues = AxisChartHelper().iterateThroughAxis(
        min: axisMin,
        max: axisMax,
        baseLine: axisBaseLine,
        interval: interval,
      );
      axisPositions = axisValues.map((axisValue) {
        var portion = (axisValue - axisMin) / (axisMax - axisMin);
        if (isVertical) {
          portion = 1 - portion;
        }
        final axisLocation = portion * axisViewSize;
        return AxisSideTitleMetaData(axisValue, axisLocation);
      }).toList();
    }
    return axisPositions
        .map(
          (metaData) => AxisSideTitleWidgetHolder(
            metaData,
            sideTitles.getTitlesWidget(
              metaData.axisValue,
              TitleMeta(
                axisMin,
                axisMax,
                interval,
                sideTitles,
                Utils().formatNumber(metaData.axisValue),
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (!axisTitles.showAxisTitles && !axisTitles.showSideTitles) {
      return Container();
    }
    final axisViewSize = isHorizontal ? parentSize.width : parentSize.height;
    return Align(
      alignment: alignment,
      child: Flex(
        direction: counterDirection,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isLeftOrTop && axisTitles.axisNameWidget != null)
            _AxisTitleWidget(
              axisTitles: axisTitles,
              side: side,
              axisViewSize: axisViewSize,
            ),
          if (sideTitles.showTitles)
            Container(
              width: isHorizontal ? axisViewSize : sideTitles.reservedSize,
              height: isHorizontal ? sideTitles.reservedSize : axisViewSize,
              margin: thisSidePadding,
              child: SideTitlesFlex(
                direction: direction,
                axisSideMetaData: AxisSideMetaData(
                  axisMin,
                  axisMax,
                  axisViewSize - thisSidePaddingTotal,
                ),
                widgetHolders: makeWidgets(
                  axisViewSize - thisSidePaddingTotal,
                  axisMin,
                  axisMax,
                ),
              ),
            ),
          if (isRightOrBottom && axisTitles.axisNameWidget != null)
            _AxisTitleWidget(
              axisTitles: axisTitles,
              side: side,
              axisViewSize: axisViewSize,
            ),
        ],
      ),
    );
  }
}

class _AxisTitleWidget extends StatelessWidget {
  final AxisTitles axisTitles;
  final TitlesSide side;
  final double axisViewSize;

  const _AxisTitleWidget({
    Key? key,
    required this.axisTitles,
    required this.side,
    required this.axisViewSize,
  }) : super(key: key);

  int get axisNameQuarterTurns {
    switch (side) {
      case TitlesSide.right:
        return 3;
      case TitlesSide.left:
        return 3;
      case TitlesSide.top:
        return 0;
      case TitlesSide.bottom:
        return 0;
    }
  }

  bool get isHorizontal => side == TitlesSide.top || side == TitlesSide.bottom;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isHorizontal ? axisViewSize : axisTitles.axisNameSize,
      height: isHorizontal ? axisTitles.axisNameSize : axisViewSize,
      child: Center(
        child: RotatedBox(
          quarterTurns: axisNameQuarterTurns,
          child: axisTitles.axisNameWidget,
        ),
      ),
    );
  }
}
