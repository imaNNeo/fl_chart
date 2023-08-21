import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/side_titles/side_titles_widget.dart';
import 'package:fl_chart/src/extensions/fl_titles_data_extension.dart';
import 'package:flutter/material.dart';

/// A scaffold to show an axis-based chart
///
/// It contains some placeholders to represent an axis-based chart.
///
/// It's something like the below graph:
/// |----------------------|
/// |      |  top  |       |
/// |------|-------|-------|
/// | left | chart | right |
/// |------|-------|-------|
/// |      | bottom|       |
/// |----------------------|
///
/// `left`, `top`, `right`, `bottom` are some place holders to show titles
/// provided by [AxisChartData.titlesData] around the chart
/// `chart` is a centered place holder to show a raw chart.
class AxisChartScaffoldWidget extends StatelessWidget {
  const AxisChartScaffoldWidget({
    super.key,
    required this.chart,
    required this.data,
  });
  final Widget chart;
  final AxisChartData data;

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

  List<Widget> stackWidgets(BoxConstraints constraints) {
    final widgets = <Widget>[
      Container(
        margin: data.titlesData.allSidesPadding,
        decoration: BoxDecoration(
          border: data.borderData.isVisible() ? data.borderData.border : null,
        ),
        child: chart,
      ),
    ];

    int insertIndex(bool drawBelow) => drawBelow ? 0 : widgets.length;

    if (showLeftTitles) {
      widgets.insert(
        insertIndex(data.titlesData.leftTitles.drawBelowEverything),
        SideTitlesWidget(
          side: AxisSide.left,
          axisChartData: data,
          parentSize: constraints.biggest,
        ),
      );
    }

    if (showTopTitles) {
      widgets.insert(
        insertIndex(data.titlesData.topTitles.drawBelowEverything),
        SideTitlesWidget(
          side: AxisSide.top,
          axisChartData: data,
          parentSize: constraints.biggest,
        ),
      );
    }

    if (showRightTitles) {
      widgets.insert(
        insertIndex(data.titlesData.rightTitles.drawBelowEverything),
        SideTitlesWidget(
          side: AxisSide.right,
          axisChartData: data,
          parentSize: constraints.biggest,
        ),
      );
    }

    if (showBottomTitles) {
      widgets.insert(
        insertIndex(data.titlesData.bottomTitles.drawBelowEverything),
        SideTitlesWidget(
          side: AxisSide.bottom,
          axisChartData: data,
          parentSize: constraints.biggest,
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(children: stackWidgets(constraints));
      },
    );
  }
}
