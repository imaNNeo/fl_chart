import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample5 extends StatelessWidget {
  final List<int> showIndexes = const [1, 3, 5];

  @override
  Widget build(BuildContext context) {
    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showIndexes,
        spots: const [
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
        belowBarData: const BarAreaData(
          show: true,
        ),
        dotData: const FlDotData(show: false),
      ),
    ];

    final LineChartBarData tooltipsOnBar = lineBarsData[0];

    return SizedBox(
      width: 300,
      height: 140,
      child: LineChart(
        LineChartData(
          showingTooltipIndicators: showIndexes.map((index) {
            return MapEntry(
              index,
              [
                LineBarSpot(
                    tooltipsOnBar, lineBarsData.indexOf(tooltipsOnBar), tooltipsOnBar.spots[index]),
              ],
            );
          }).toList(),
          lineTouchData: LineTouchData(
            enabled: false,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.pink,
              tooltipRoundedRadius: 8,
              getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                return lineBarsSpot.map((lineBarSpot) {
                  return LineTooltipItem(
                    lineBarSpot.y.toString(),
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: lineBarsData,
          minY: 0,
          titlesData: FlTitlesData(
            leftTitles: const SideTitles(
              showTitles: false,
            ),
            bottomTitles: SideTitles(
                showTitles: true,
                getTitles: (val) {
                  switch (val.toInt()) {
                    case 0:
                      return '00:00';
                    case 1:
                      return '04:00';
                    case 2:
                      return '08:00';
                    case 3:
                      return '12:00';
                    case 4:
                      return '16:00';
                    case 5:
                      return '20:00';
                    case 6:
                      return '23:59';
                  }
                  return '';
                },
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                  fontFamily: 'Digital',
                  fontSize: 18,
                )),
          ),
          axisTitleData: const FlAxisTitleData(
            rightTitle: AxisTitle(showTitle: true, titleText: 'count'),
            leftTitle: AxisTitle(showTitle: true, titleText: 'count'),
            topTitle:
                AxisTitle(showTitle: true, titleText: 'Wall clock', textAlign: TextAlign.left),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(
            show: true,
          ),
        ),
      ),
    );
  }
}
