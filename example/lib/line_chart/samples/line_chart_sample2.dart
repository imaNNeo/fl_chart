import 'package:fl_chart/chart/base/fl_axis_chart/fl_axis_chart_data.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_data.dart';
import 'package:fl_chart/chart/line_chart/line_chart.dart';
import 'package:fl_chart/chart/line_chart/line_chart_data.dart';
import 'package:fl_chart/fl_chart_widget.dart';
import 'package:flutter/material.dart';

class LineChartSample2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors = [
      Color(0xff23b6e6),
      Color(0xff02d39a),
    ];
    return AspectRatio(
      aspectRatio: 1.70,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          color: Color(0xff232d37)
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
          child: FlChartWidget(
            flChart: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawHorizontalGrid: true,
                  verticalGridColor: Color(0xff37434d),
                  verticalGridLineWidth: 1,
                  horizontalGridColor: Color(0xff37434d),
                  horizontalGridLineWidth: 1,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  horizontalTitlesTextStyle: TextStyle(
                    color: Color(0xff68737d),
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                  getHorizontalTitles: (value) {
                    switch(value.toInt()) {
                      case 2: return "MAR";
                      case 5: return "JUN";
                      case 8: return "SEP";
                    }

                    return "";
                  },
                  verticalTitlesTextStyle: TextStyle(
                    color: Color(0xff67727d),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  getVerticalTitles: (value) {
                    switch(value.toInt()) {
                      case 1: return "10k";
                      case 3: return "30k";
                      case 5: return "50k";
                    }
                    return "";
                  },
                  verticalTitlesReservedWidth: 28,
                  verticalTitleMargin: 12,
                  horizontalTitleMargin: 8,
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Color(0xff37434d), width: 1)
                ),
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 6,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 3),
                      FlSpot(2.6, 2),
                      FlSpot(4.9, 5),
                      FlSpot(6.8, 3.1),
                      FlSpot(8, 4),
                      FlSpot(9.5, 3),
                      FlSpot(11, 4),
                    ],
                    isCurved: true,
                    colors: gradientColors,
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: false,
                    ),
                    belowBarData: BelowBarData(
                      show: true,
                      colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}