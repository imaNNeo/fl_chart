import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/resources/app_colors.dart';
import 'package:flutter/material.dart';

class BarSample1 extends StatelessWidget {
  const BarSample1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(BarChartData(
      barGroups: [
        BarChartGroupData(x: 0, barRods: [
          BarChartRodData(y: 4, colors: [AppColors.flCyan])
        ]),
        BarChartGroupData(x: 1, barRods: [
          BarChartRodData(y: 6, colors: [AppColors.flCyan])
        ]),
        BarChartGroupData(x: 2, barRods: [
          BarChartRodData(y: 3, colors: [AppColors.flCyan])
        ]),
        BarChartGroupData(x: 3, barRods: [
          BarChartRodData(y: 1, colors: [AppColors.flCyan])
        ]),
      ],
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
    ));
  }
}
