import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/resources/app_colors.dart';
import 'package:flutter/material.dart';

class RadarSample1 extends StatelessWidget {
  const RadarSample1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RadarChart(
      RadarChartData(
        dataSets: [
          RadarDataSet(
            dataEntries: [
              RadarEntry(value: 4),
              RadarEntry(value: 1),
              RadarEntry(value: 3),
            ],
            fillColor: AppColors.flCyan.withOpacity(0.7),
          ),
          RadarDataSet(
            dataEntries: [
              RadarEntry(value: 2),
              RadarEntry(value: 5),
              RadarEntry(value: 1),
            ],
            fillColor: Colors.red.withOpacity(0.7),
          ),
        ],
        borderData: FlBorderData(show: false),
        gridBorderData: BorderSide(width: 0.0, color: Colors.transparent),
        radarBorderData: BorderSide(color: Colors.transparent),
        tickBorderData: BorderSide(width: 0, color: Colors.transparent),
      ),
    );
  }
}
