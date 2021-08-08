import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ScatterSample1 extends StatelessWidget {
  const ScatterSample1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScatterChart(ScatterChartData(
        minX: 0,
        maxX: 10,
        minY: 0,
        maxY: 10,
        scatterSpots: [
          ScatterSpot(1, 1, radius: 12),
          ScatterSpot(4, 1.5, radius: 8),
          ScatterSpot(2, 3, radius: 18),
          ScatterSpot(5, 5, radius: 22),
          ScatterSpot(8, 4, radius: 10),
          ScatterSpot(9, 9, radius: 16),
          ScatterSpot(1, 8, radius: 8),
          ScatterSpot(2, 6, radius: 20),
        ],
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(show: false)));
  }
}
