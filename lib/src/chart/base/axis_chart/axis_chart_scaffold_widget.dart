import 'package:fl_chart/src/extensions/fl_titles_data_extension.dart';
import 'package:flutter/material.dart';

import 'axis_chart_data.dart';
import 'side_titles/side_titles_widget.dart';

class AxisChartScaffoldWidget extends StatelessWidget {
  final Widget chart;
  final AxisChartData data;

  const AxisChartScaffoldWidget({
    Key? key,
    required this.chart,
    required this.data,
  }) : super(key: key);

  bool get showLeftTitles {
    if (!data.titlesData.show) {
      return false;
    }
    final showAxisTitles = data.titlesData.leftTitles.showAxisTitles;
    final showSideTitles = data.titlesData.leftTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  bool get showRightTitles {
    if (!data.titlesData.show) {
      return false;
    }
    final showAxisTitles = data.titlesData.rightTitles.showAxisTitles;
    final showSideTitles = data.titlesData.rightTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  bool get showTopTitles {
    if (!data.titlesData.show) {
      return false;
    }
    final showAxisTitles = data.titlesData.topTitles.showAxisTitles;
    final showSideTitles = data.titlesData.topTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  bool get showBottomTitles {
    if (!data.titlesData.show) {
      return false;
    }
    final showAxisTitles = data.titlesData.bottomTitles.showAxisTitles;
    final showSideTitles = data.titlesData.bottomTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          Padding(
            padding: data.titlesData.allSidesPadding,
            child: chart,
          ),
          if (showLeftTitles)
            SideTitlesWidget(
              side: TitlesSide.left,
              axisChartData: data,
              parentSize: constraints.biggest,
            ),
          if (showTopTitles)
            SideTitlesWidget(
              side: TitlesSide.top,
              axisChartData: data,
              parentSize: constraints.biggest,
            ),
          if (showRightTitles)
            SideTitlesWidget(
              side: TitlesSide.right,
              axisChartData: data,
              parentSize: constraints.biggest,
            ),
          if (showBottomTitles)
            SideTitlesWidget(
              side: TitlesSide.bottom,
              axisChartData: data,
              parentSize: constraints.biggest,
            ),
        ],
      );
    });
  }
}
