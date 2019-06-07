import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ComposedStackSample1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        barChart(),
        lineChart(),
      ],
    );
  }

  Widget barChart() {
    return FlChart(
      chart: BarChart(
        BarChartData(
          maxY: 6,
          barGroups: [
            const BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  y: 4,
                  backDrawRodData: BackgroundBarChartRodData(show: false),
                ),
              ],
            ),
            const BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  y: 2,
                  backDrawRodData: BackgroundBarChartRodData(show: false),
                ),
              ],
            ),
            const BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  y: 3,
                  backDrawRodData: BackgroundBarChartRodData(show: false),
                ),
              ],
            ),
            const BarChartGroupData(
              x: 3,
              barRods: [
                BarChartRodData(
                  y: 6,
                  backDrawRodData: BackgroundBarChartRodData(show: false),
                ),
              ],
            ),
            const BarChartGroupData(
              x: 4,
              barRods: [
                BarChartRodData(
                  y: 3.5,
                  backDrawRodData: BackgroundBarChartRodData(show: false),
                ),
              ],
            ),
          ],
          titlesData: FlTitlesData(
            getHorizontalTitles: (value) => value.toInt().toString(),
            getVerticalTitles: (value) => value.toInt().toString(),
            verticalTitlesReservedWidth: 36,
          )
        ),
      ),
    );
  }

  Widget lineChart() {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: FlChart(
        chart: LineChart(
          LineChartData(
            minY: 0,
            maxY: 6,
            lineBarsData: [
              LineChartBarData(
                spots: [
                  const FlSpot(0, 2),
                  const FlSpot(1, 1),
                  const FlSpot(2, 2),
                  const FlSpot(3, 5),
                  const FlSpot(4, 2),
                ],
                colors: [Colors.red.withOpacity(0.5)],
                barWidth: 8,
                dotData: const FlDotData(show: true, dotColor: Colors.black, dotSize: 8),
                belowBarData: const BelowBarData(show: false),
              ),
            ],
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              getVerticalTitles: (value) => '',
              getHorizontalTitles: (value) => '',
            )
          )
        ),
      ),
    );
  }

}