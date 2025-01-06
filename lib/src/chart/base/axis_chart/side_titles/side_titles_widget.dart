import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_helper.dart';
import 'package:fl_chart/src/chart/base/axis_chart/side_titles/side_titles_flex.dart';
import 'package:fl_chart/src/extensions/bar_chart_data_extension.dart';
import 'package:fl_chart/src/extensions/edge_insets_extension.dart';
import 'package:fl_chart/src/extensions/fl_border_data_extension.dart';
import 'package:fl_chart/src/extensions/fl_titles_data_extension.dart';
import 'package:fl_chart/src/extensions/size_extension.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';

class SideTitlesWidget extends StatefulWidget {
  const SideTitlesWidget({
    super.key,
    required this.side,
    required this.axisChartData,
    required this.parentSize,
    this.chartVirtualRect,
  });

  final AxisSide side;
  final AxisChartData axisChartData;
  final Size parentSize;
  final Rect? chartVirtualRect;

  @override
  State<SideTitlesWidget> createState() => _SideTitlesWidgetState();
}

class _SideTitlesWidgetState extends State<SideTitlesWidget> {
  bool get isHorizontal =>
      widget.side == AxisSide.top || widget.side == AxisSide.bottom;

  bool get isVertical => !isHorizontal;

  double get minX => widget.axisChartData.minX;

  double get maxX => widget.axisChartData.maxX;

  double get baselineX => widget.axisChartData.baselineX;

  double get minY => widget.axisChartData.minY;

  double get maxY => widget.axisChartData.maxY;

  double get baselineY => widget.axisChartData.baselineY;

  double get axisMin => isHorizontal ? minX : minY;

  double get axisMax => isHorizontal ? maxX : maxY;

  double get axisBaseLine => isHorizontal ? baselineX : baselineY;

  FlTitlesData get titlesData => widget.axisChartData.titlesData;

  bool get isLeftOrTop =>
      widget.side == AxisSide.left || widget.side == AxisSide.top;

  bool get isRightOrBottom =>
      widget.side == AxisSide.right || widget.side == AxisSide.bottom;

  AxisTitles get axisTitles => switch (widget.side) {
        AxisSide.left => titlesData.leftTitles,
        AxisSide.top => titlesData.topTitles,
        AxisSide.right => titlesData.rightTitles,
        AxisSide.bottom => titlesData.bottomTitles,
      };

  SideTitles get sideTitles => axisTitles.sideTitles;

  Axis get direction => isHorizontal ? Axis.horizontal : Axis.vertical;

  Axis get counterDirection => isHorizontal ? Axis.vertical : Axis.horizontal;

  Alignment get alignment => switch (widget.side) {
        AxisSide.left => Alignment.centerLeft,
        AxisSide.top => Alignment.topCenter,
        AxisSide.right => Alignment.centerRight,
        AxisSide.bottom => Alignment.bottomCenter,
      };

  EdgeInsets get thisSidePadding {
    final titlesPadding = titlesData.allSidesPadding;
    final borderPadding = widget.axisChartData.borderData.allSidesPadding;
    return switch (widget.side) {
      AxisSide.right ||
      AxisSide.left =>
        titlesPadding.onlyTopBottom + borderPadding.onlyTopBottom,
      AxisSide.top ||
      AxisSide.bottom =>
        titlesPadding.onlyLeftRight + borderPadding.onlyLeftRight,
    };
  }

  double get thisSidePaddingTotal {
    final borderPadding = widget.axisChartData.borderData.allSidesPadding;
    final titlesPadding = titlesData.allSidesPadding;
    return switch (widget.side) {
      AxisSide.right ||
      AxisSide.left =>
        titlesPadding.vertical + borderPadding.vertical,
      AxisSide.top ||
      AxisSide.bottom =>
        titlesPadding.horizontal + borderPadding.horizontal,
    };
  }

  Size get viewSize {
    late Size size;
    final chartVirtualRect = widget.chartVirtualRect;
    if (chartVirtualRect == null) {
      size = widget.parentSize;
    } else {
      size = chartVirtualRect.size +
          Offset(thisSidePaddingTotal, thisSidePaddingTotal);
    }

    return size.rotateByQuarterTurns(
      widget.axisChartData.rotationQuarterTurns,
    );
  }

  double get axisOffset {
    final chartVirtualRect = widget.chartVirtualRect;
    if (chartVirtualRect == null) {
      return 0;
    }

    return switch (widget.side) {
      AxisSide.left || AxisSide.right => chartVirtualRect.top,
      AxisSide.top || AxisSide.bottom => chartVirtualRect.left,
    };
  }

  List<AxisSideTitleWidgetHolder> makeWidgets(
    double axisViewSize,
    double axisMin,
    double axisMax,
    AxisSide side,
  ) {
    List<AxisSideTitleMetaData> axisPositions;
    final interval = sideTitles.interval ??
        Utils().getEfficientInterval(
          axisViewSize,
          axisMax - axisMin,
        );
    if (isHorizontal && widget.axisChartData is BarChartData) {
      final barChartData = widget.axisChartData as BarChartData;
      if (barChartData.barGroups.isEmpty) {
        return [];
      }
      final xLocations = barChartData.calculateGroupsX(axisViewSize);
      axisPositions = xLocations.asMap().entries.map((e) {
        final index = e.key;
        final xLocation = e.value;
        final xValue = barChartData.barGroups[index].x;
        final adjustedLocation = xLocation + axisOffset;
        return AxisSideTitleMetaData(xValue.toDouble(), adjustedLocation);
      }).toList();
    } else {
      final axisValues = AxisChartHelper().iterateThroughAxis(
        min: axisMin,
        max: axisMax,
        minIncluded: sideTitles.minIncluded,
        maxIncluded: sideTitles.maxIncluded,
        baseLine: axisBaseLine,
        interval: interval,
      );
      axisPositions = axisValues.map((axisValue) {
        final axisDiff = axisMax - axisMin;
        var portion = 0.0;
        if (axisDiff > 0) {
          portion = (axisValue - axisMin) / axisDiff;
        }
        if (isVertical) {
          portion = 1 - portion;
        }
        final axisLocation = portion * axisViewSize + axisOffset;
        return AxisSideTitleMetaData(axisValue, axisLocation);
      }).toList();
    }

    axisPositions = _getPositionsWithinChartRange(axisPositions, side);

    return axisPositions.map(
      (metaData) {
        return AxisSideTitleWidgetHolder(
          metaData,
          sideTitles.getTitlesWidget(
            metaData.axisValue,
            TitleMeta(
              min: axisMin,
              max: axisMax,
              appliedInterval: interval,
              sideTitles: sideTitles,
              formattedValue: Utils().formatNumber(
                axisMin,
                axisMax,
                metaData.axisValue,
              ),
              axisSide: side,
              parentAxisSize: axisViewSize,
              axisPosition: metaData.axisPixelLocation,
              rotationQuarterTurns: widget.axisChartData.rotationQuarterTurns,
            ),
          ),
        );
      },
    ).toList();
  }

  List<AxisSideTitleMetaData> _getPositionsWithinChartRange(
    List<AxisSideTitleMetaData> axisPositions,
    AxisSide side,
  ) {
    final chartSize = Size(
      widget.parentSize.width - thisSidePaddingTotal,
      widget.parentSize.height - thisSidePaddingTotal,
    ).rotateByQuarterTurns(widget.axisChartData.rotationQuarterTurns);
    // Add 1 pixel to the chart's edges to avoid clipping the last title.
    final chartRect = (Offset.zero & chartSize).inflate(1);

    return axisPositions.where((metaData) {
      final location = metaData.axisPixelLocation;
      return switch (side) {
        AxisSide.left ||
        AxisSide.right =>
          chartRect.contains(Offset(0, location)),
        AxisSide.top ||
        AxisSide.bottom =>
          chartRect.contains(Offset(location, 0)),
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (!axisTitles.showAxisTitles && !axisTitles.showSideTitles) {
      return Container();
    }

    final axisViewSize = isHorizontal ? viewSize.width : viewSize.height;
    return Align(
      alignment: alignment,
      child: Flex(
        direction: counterDirection,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLeftOrTop && axisTitles.axisNameWidget != null)
            _AxisTitleWidget(
              axisTitles: axisTitles,
              side: widget.side,
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
                  widget.side,
                ),
              ),
            ),
          if (isRightOrBottom && axisTitles.axisNameWidget != null)
            _AxisTitleWidget(
              axisTitles: axisTitles,
              side: widget.side,
              axisViewSize: axisViewSize,
            ),
        ],
      ),
    );
  }
}

class _AxisTitleWidget extends StatelessWidget {
  const _AxisTitleWidget({
    required this.axisTitles,
    required this.side,
    required this.axisViewSize,
  });

  final AxisTitles axisTitles;
  final AxisSide side;
  final double axisViewSize;

  int get axisNameQuarterTurns => switch (side) {
        AxisSide.right => 3,
        AxisSide.left => 3,
        AxisSide.top => 0,
        AxisSide.bottom => 0,
      };

  bool get isHorizontal => side == AxisSide.top || side == AxisSide.bottom;

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
