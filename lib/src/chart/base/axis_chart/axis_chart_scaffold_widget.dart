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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          SideTitlesWidget(
            side: TitlesSide.left,
            axisChartData: data,
            parentSize: constraints.biggest,
          ),
          SideTitlesWidget(
            side: TitlesSide.top,
            axisChartData: data,
            parentSize: constraints.biggest,
          ),
          SideTitlesWidget(
            side: TitlesSide.right,
            axisChartData: data,
            parentSize: constraints.biggest,
          ),
          SideTitlesWidget(
            side: TitlesSide.bottom,
            axisChartData: data,
            parentSize: constraints.biggest,
          ),
          Padding(
            padding: data.titlesData.allSidesPadding,
            child: chart,
          ),
        ],
      );
    });
  }
}
