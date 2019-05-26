import 'package:fl_chart/chart/bar_chart/bar_chart_data.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_painter.dart';
import 'package:fl_chart/chart/line_chart/line_chart_data.dart';
import 'package:fl_chart/chart/pie_chart/pie_chart_data.dart';
import 'package:flutter/material.dart';

/// This class holds all data needed to [FlChartPainter],
/// in this phase just the [FlBorderData] provided
/// to drawing chart border line,
/// see inherited samples:
/// [LineChartData], [BarChartData], [PieChartData]
class FlChartData {
  final FlBorderData borderData;

  FlChartData({
    this.borderData = const FlBorderData(),
  });
}

/***** BorderData *****/
/// Border Data that contains
/// [show] show or hide the border line on our chart
/// [borderColor] color of chart border line
/// [borderWidth] width of chart border line
class FlBorderData {
  final bool show;
  final Color borderColor;
  final double borderWidth;

  const FlBorderData({
    this.show = true,
    this.borderColor = Colors.black,
    this.borderWidth = 1.0,
  });
}


/***** TitlesData *****/
/// we use this typedef to determine which titles
/// we should show (according to the value),
/// we pass the value and get a boolean to show the title for that value.
typedef GetTitleFunction = String Function(double value);

String defaultGetTitle(double value) {
  return "${value.toInt()}";
}

/// This class is responsible to hold data about showing titles.
/// titles show on the bottom and left of chart
/// we call the bottom titles -> horizontal titles,
/// and the left titles -> vertical titles.
class FlTitlesData {
  final bool show;

  // Horizontal
  final bool showHorizontalTitles;
  final GetTitleFunction getHorizontalTitles;
  final double horizontalTitlesReservedHeight;
  final TextStyle horizontalTitlesTextStyle;
  final double horizontalTitleMargin;

  // Vertical
  final bool showVerticalTitles;
  final GetTitleFunction getVerticalTitles;
  final double verticalTitlesReservedWidth;
  final TextStyle verticalTitlesTextStyle;
  final double verticalTitleMargin;

  const FlTitlesData({
    this.show = true,
    // Horizontal
    this.showHorizontalTitles = true,
    this.getHorizontalTitles = defaultGetTitle,
    this.horizontalTitlesReservedHeight = 22,
    this.horizontalTitlesTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 11,
    ),
    this.horizontalTitleMargin = 6,

    // Vertical
    this.showVerticalTitles = true,
    this.getVerticalTitles = defaultGetTitle,
    this.verticalTitlesReservedWidth = 40,
    this.verticalTitlesTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 11,
    ),
    this.verticalTitleMargin = 6,
  });
}