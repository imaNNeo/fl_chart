import 'package:fl_chart/fl_chart.dart';
import 'package:example_new/resources/app_colors.dart';
import 'package:flutter/material.dart';

class BarSample1 extends StatelessWidget {
  const BarSample1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(BarChartData(
      barGroups: [
        BarChartGroupData(x: 0, barRods: [
          BarChartRodData(toY: 4, color: AppColors.flCyan)
        ]),
        BarChartGroupData(x: 1, barRods: [
          BarChartRodData(toY: 6, color: AppColors.flCyan)
        ]),
        BarChartGroupData(x: 2, barRods: [
          BarChartRodData(toY: 3, color: AppColors.flCyan)
        ]),
        BarChartGroupData(x: 3, barRods: [
          BarChartRodData(toY: 1, color: AppColors.flCyan)
        ]),
      ],
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
    ));
  }
}
