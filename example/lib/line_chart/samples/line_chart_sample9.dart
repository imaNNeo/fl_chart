import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

// ignore: must_be_immutable
class LineChartSample9 extends StatelessWidget {
  final spots = List.generate(101, (i) => (i - 50) / 10)
      .map((x) => FlSpot(x, sin(x)))
      .toList();

  LineChartSample9({Key? key}) : super(key: key);

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.blueGrey,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(meta.formattedValue, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.blueGrey,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(meta.formattedValue, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 22.0, bottom: 20),
      child: SizedBox(
        width: 400,
        height: 400,
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                  maxContentWidth: 100,
                  tooltipBgColor: Colors.orange,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((LineBarSpot touchedSpot) {
                      final textStyle = TextStyle(
                        color: touchedSpot.bar.gradient?.colors[0] ??
                            touchedSpot.bar.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      );
                      return LineTooltipItem(
                          '${touchedSpot.x}, ${touchedSpot.y.toStringAsFixed(2)}',
                          textStyle);
                    }).toList();
                  }),
              handleBuiltInTouches: true,
              getTouchLineStart: (data, index) => 0,
            ),
            lineBarsData: [
              LineChartBarData(
                color: Colors.black,
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
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: leftTitleWidgets,
                  reservedSize: 56,
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: bottomTitleWidgets,
                  reservedSize: 36,
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
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
