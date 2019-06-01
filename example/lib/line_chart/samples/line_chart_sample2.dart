import 'package:fl_chart/chart/base/fl_axis_chart/fl_axis_chart_data.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_data.dart';
import 'package:fl_chart/chart/line_chart/line_chart.dart';
import 'package:fl_chart/chart/line_chart/line_chart_data.dart';
import 'package:fl_chart/fl_chart_widget.dart';
import 'package:flutter/material.dart';

class LineChartSample2 extends StatelessWidget {

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
                  FlSpot(0, 4),
                  FlSpot(1, 3.5),
                  FlSpot(2, 4.5),
                  FlSpot(3, 1),
                  FlSpot(4, 4),
                  FlSpot(5, 6),
                  FlSpot(6, 6.5),
                  FlSpot(7, 6),
                  FlSpot(8, 4),
                  FlSpot(9, 6),
                  FlSpot(10, 6),
                  FlSpot(11, 7),
                ],
                isCurved: true,
                barWidth: 8,
                colors: [
                  Colors.purpleAccent,
                ],
                belowBarData: BelowBarData(
                  show: true,
                  colors: [Colors.deepPurple.withOpacity(0.2)],
                ),
                dotData: FlDotData(
                  show: false,
                ),
              ),
            ],
            titlesData: FlTitlesData(
              horizontalTitlesTextStyle:
              TextStyle(fontSize: 10, color: Colors.purple, fontWeight: FontWeight.bold),
              getVerticalTitles: (value) {
                return "\$ ${value + 0.5}";
              },
              getHorizontalTitles: (value) {
                switch (value.toInt()) {
                  case 0:
                    return "Jan";
                  case 1:
                    return "Feb";
                  case 2:
                    return "Mar";
                  case 3:
                    return "Apr";
                  case 4:
                    return "May";
                  case 5:
                    return "Jun";
                  case 6:
                    return "Jul";
                  case 7:
                    return "Aug";
                  case 8:
                    return "Sep";
                  case 9:
                    return "Oct";
                  case 10:
                    return "Nov";
                  case 11:
                    return "Dec";
                }
              }),
            gridData: FlGridData(
              show: true,
              checkToShowVerticalGrid: (double value) {
                return value == 1 || value == 6 || value == 4 || value == 5;
              }),
          ),
        ),
      ),
    );
  }

}