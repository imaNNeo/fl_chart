import 'package:fl_chart/chart/base/fl_axis_chart/fl_axis_chart_data.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_data.dart';
import 'package:fl_chart/chart/line_chart/line_chart.dart';
import 'package:fl_chart/chart/line_chart/line_chart_data.dart';
import 'package:fl_chart/fl_chart_widget.dart';
import 'package:flutter/material.dart';

class LineChartSample5 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 140,
      child: FlChartWidget(
        flChart: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(0, 1),
                  FlSpot(1, 2),
                  FlSpot(2, 1.5),
                  FlSpot(3, 3),
                  FlSpot(4, 3.5),
                  FlSpot(5, 5),
                  FlSpot(6, 8),
                ],
                isCurved: true,
                barWidth: 4,
                belowBarData: BelowBarData(
                  show: true,
                ),
                dotData: FlDotData(show: false),
              ),
            ],
            titlesData: FlTitlesData(
              getVerticalTitles: (val) {
                return "";
              },
              verticalTitleMargin: 0,
              verticalTitlesReservedWidth: 0,
              getHorizontalTitles: (val) {
                switch (val.toInt()) {
                  case 0:
                    return "00:00";
                  case 1:
                    return "04:00";
                  case 2:
                    return "08:00";
                  case 3:
                    return "12:00";
                  case 4:
                    return "16:00";
                  case 5:
                    return "20:00";
                  case 6:
                    return "23:59";
                }
                return "";
              },
              horizontalTitlesTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
                fontFamily: "Digital",
                fontSize: 18,
              )),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(
              show: true,
            ),
          ),
        ),
      ),
    );
  }

}