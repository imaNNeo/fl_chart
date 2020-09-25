import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample7 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 140,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(enabled: false),
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
              barWidth: 2,
              colors: [
                Colors.green,
              ],
              dotData: FlDotData(
                show: false,
              ),
            ),
            LineChartBarData(
              spots: [
                FlSpot(0, 0),
                FlSpot(1, 3),
                FlSpot(2, 4),
                FlSpot(3, 5),
                FlSpot(4, 8),
                FlSpot(5, 3),
                FlSpot(6, 5),
                FlSpot(7, 8),
                FlSpot(8, 4),
                FlSpot(9, 7),
                FlSpot(10, 7),
                FlSpot(11, 8),
              ],
              isCurved: true,
              barWidth: 2,
              colors: [
                Colors.black,
              ],
              dotData: FlDotData(
                show: false,
              ),
            ),
            LineChartBarData(
              spots: [
                FlSpot(0, 7),
                FlSpot(1, 3),
                FlSpot(2, 4),
                FlSpot(3, 0),
                FlSpot(4, 3),
                FlSpot(5, 4),
                FlSpot(6, 5),
                FlSpot(7, 3),
                FlSpot(8, 2),
                FlSpot(9, 4),
                FlSpot(10, 1),
                FlSpot(11, 3),
              ],
              isCurved: false,
              barWidth: 2,
              colors: [
                Colors.red,
              ],
              dotData: FlDotData(
                show: false,
              ),
            ),
          ],
          betweenBarsData: [
            BetweenBarsData(
              fromIndex: 0,
              toIndex: 2,
              colors: [Colors.red.withOpacity(0.3)],
            )
          ],
          minY: 0,
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => const TextStyle(
                    fontSize: 10, color: Colors.purple, fontWeight: FontWeight.bold),
                getTitles: (value) {
                  switch (value.toInt()) {
                    case 0:
                      return 'Jan';
                    case 1:
                      return 'Feb';
                    case 2:
                      return 'Mar';
                    case 3:
                      return 'Apr';
                    case 4:
                      return 'May';
                    case 5:
                      return 'Jun';
                    case 6:
                      return 'Jul';
                    case 7:
                      return 'Aug';
                    case 8:
                      return 'Sep';
                    case 9:
                      return 'Oct';
                    case 10:
                      return 'Nov';
                    case 11:
                      return 'Dec';
                    default:
                      return '';
                  }
                }),
            leftTitles: SideTitles(
              showTitles: true,
              getTitles: (value) {
                return '\$ ${value + 0.5}';
              },
            ),
          ),
          gridData: FlGridData(
            show: true,
            checkToShowHorizontalLine: (double value) {
              return value == 1 || value == 6 || value == 4 || value == 5;
            },
          ),
        ),
      ),
    );
  }
}
