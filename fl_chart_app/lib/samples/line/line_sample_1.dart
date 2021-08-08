import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/resources/app_resources.dart';
import 'package:flutter/material.dart';

class LineSample1 extends StatelessWidget {
  const LineSample1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            dotData: FlDotData(
              show: false,
            ),
            colors: [
              AppColors.flCyan,
            ],
            spots: [
              FlSpot(0, 0),
              FlSpot(1, 2),
              FlSpot(2, 1),
              FlSpot(3, 4),
            ],
          )
        ],
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: false,
        ),
        gridData: FlGridData(show: false),
      ),
    );
  }
}
