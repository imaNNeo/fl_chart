import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LineChartSample11 extends StatelessWidget {
  final spots = List.generate(101, (i) => (i - 50) / 10).map((x) => FlSpot(x, sin(x))).toList();
  final bool alignYMarksLeft, alignYMarksRight;

  LineChartSample11({
    this.alignYMarksLeft = false,
    this.alignYMarksRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: 400,
        height: 200,
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                  maxContentWidth: 100,
                  tooltipBgColor: Colors.orange,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((LineBarSpot touchedSpot) {
                      final textStyle = TextStyle(
                        color: touchedSpot.bar.colors[0],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      );
                      return LineTooltipItem(
                          '${touchedSpot.x}, ${touchedSpot.y.toStringAsFixed(2)}', textStyle);
                    }).toList();
                  }),
              handleBuiltInTouches: true,
              getTouchLineStart: (data, index) => 0,
            ),
            lineBarsData: [
              LineChartBarData(
                colors: [
                  Colors.black,
                ],
                spots: spots,
                isCurved: true,
                isStrokeCapRound: true,
                barWidth: 3,
                belowBarData: BarAreaData(
                  show: false,
                ),
                dotData: FlDotData(show: false),
              ),
            ],
            minY: -1.5,
            maxY: 1.5,
            titlesData: FlTitlesData(
              leftTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => const TextStyle(
                    color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 18),
                margin: 25,
                alignLeftTitlesToLeft: alignYMarksLeft,
              ),
              rightTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => const TextStyle(
                    color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 18),
                margin: 25,
                alignRightTitlesToRight: alignYMarksRight,
              ),
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => const TextStyle(
                    color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 18),
                margin: 16,
              ),
              topTitles: SideTitles(showTitles: false),
            ),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              drawVerticalLine: true,
              horizontalInterval: 1.5,
              verticalInterval: 5,
              checkToShowHorizontalLine: (value) {
                return value.toInt() == 0;
              },
              checkToShowVerticalLine: (value) {
                return value.toInt() == 0;
              },
            ),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }
}
