import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LineChartSample9 extends StatelessWidget {
  final spots = [
    FlSpot(0, 5),
    FlSpot(2, 1),
    FlSpot(4, 5),
    FlSpot(6, 3),
  ];

  final spots2 = [
    FlSpot(0, 2),
    FlSpot(2, 4),
    FlSpot(4, 3),
    FlSpot(6, 2),
  ];

  double minSpotX, maxSpotX;
  double minSpotY, maxSpotY;

  LineChartSample9() {
    minSpotX = spots.first.x;
    maxSpotX = spots.first.x;
    minSpotY = spots.first.y;
    maxSpotY = spots.first.y;

    for (FlSpot spot in spots) {
      if (spot.x > maxSpotX) {
        maxSpotX = spot.x;
      }

      if (spot.x < minSpotX) {
        minSpotX = spot.x;
      }

      if (spot.y > maxSpotY) {
        maxSpotY = spot.y;
      }

      if (spot.y < minSpotY) {
        minSpotY = spot.y;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(right: 22.0, bottom: 20),
        child: SizedBox(
          width: 300,
          height: 200,
          child: LineChart(
            LineChartData(
              minY: 1,
              maxY: 5,
              lineTouchData: LineTouchData(
                fullHeightTouchLine: true,
                getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                  return spotIndexes.map((spotIndex) {
                    return TouchedSpotIndicatorData(
                      FlLine(color: Colors.orange, strokeWidth: 3),
                      FlDotData(
                          dotSize: 8, getDotColor: (spot, percent, barData) => Colors.deepOrange),
                    );
                  }).toList();
                },
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.blueAccent,
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  minY: 0,
                  maxY: 6,
                  colors: [
                    Colors.deepOrangeAccent,
                    Colors.orangeAccent,
                  ],
                  spots: spots,
                  isCurved: true,
                  isStrokeCapRound: true,
                  barWidth: 10,
                  belowBarData: BarAreaData(
                    show: false,
                  ),
                  dotData: FlDotData(
                    show: true,
                    getDotColor: (spot, percent, barData) => Colors.deepOrange.withOpacity(0.5),
                    dotSize: 12,
                  ),
                ),
                LineChartBarData(
                  colors: [
                    Colors.lightBlueAccent,
                    Colors.blue,
                  ],
                  spots: spots2,
                  isCurved: true,
                  isStrokeCapRound: true,
                  barWidth: 10,
                  belowBarData: BarAreaData(
                    show: false,
                  ),
                  dotData: FlDotData(
                    show: true,
                    getDotColor: (spot, percent, barData) => Colors.blue.withOpacity(0.5),
                    dotSize: 12,
                  ),
                ),
              ],
              titlesData: FlTitlesData(
                leftTitles: SideTitles(
                  minY: 0,
                  maxY: 6,
                  showTitles: true,
                  getTitles: (double value) {
                    return value.toInt().toString();
                  },
                  textStyle: const TextStyle(
                      color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 18),
                  margin: 16,
                ),
                rightTitles: SideTitles(
                  // minY: 1,
                  // maxY: 5,
                  showTitles: true,
                  getTitles: (double value) {
                    return value.toInt().toString();
                  },
                  textStyle: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18),
                  margin: 16,
                ),
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTitles: (double value) {
                    return value.toInt().toString();
                  },
                  textStyle: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                  margin: 16,
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
            ),
          ),
        ),
      ),
    );
  }

  double reverseY(double y, double minX, double maxX) {
    return (maxX + minX) - y;
  }

  List<FlSpot> reverseSpots(List<FlSpot> inputSpots, double minY, double maxY) {
    return inputSpots.map((spot) {
      return spot.copyWith(y: (maxY + minY) - spot.y);
    }).toList();
  }
}
