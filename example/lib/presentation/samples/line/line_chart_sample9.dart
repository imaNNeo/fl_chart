import 'dart:math';

import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LineChartSample9 extends StatelessWidget {
  LineChartSample9({super.key});

  final spots = List.generate(101, (i) => (i - 50) / 10)
      .map((x) => FlSpot(x, cos(x)))
      .toList();

  Widget bottomTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    if (value % 1 != 0) {
      return Container();
    }
    final style = TextStyle(
      color: AppColors.contentColorBlue,
      fontWeight: FontWeight.bold,
      fontSize: min(18, 18 * chartWidth / 300),
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(meta.formattedValue, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    final style = TextStyle(
      color: AppColors.contentColorYellow,
      fontWeight: FontWeight.bold,
      fontSize: min(18, 18 * chartWidth / 300),
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
      padding: const EdgeInsets.only(
        left: 12,
        bottom: 12,
        right: 20,
        top: 20,
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    maxContentWidth: 100,
                    getTooltipColor: (touchedSpot) => Colors.black,
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
                          textStyle,
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                  getTouchLineStart: (data, index) => 0,
                ),
                lineBarsData: [
                  LineChartBarData(
                    color: AppColors.contentColorPink,
                    spots: spots,
                    isCurved: true,
                    isStrokeCapRound: true,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: false,
                    ),
                    dotData: const FlDotData(show: false),
                  ),
                ],
                minY: -1.5,
                maxY: 1.5,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) =>
                          leftTitleWidgets(value, meta, constraints.maxWidth),
                      reservedSize: 56,
                    ),
                    drawBelowEverything: true,
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) =>
                          bottomTitleWidgets(value, meta, constraints.maxWidth),
                      reservedSize: 36,
                      interval: 1,
                    ),
                    drawBelowEverything: true,
                  ),
                  topTitles: const AxisTitles(
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
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppColors.contentColorBlue.withOpacity(1),
                    dashArray: [8, 2],
                    strokeWidth: 0.8,
                  ),
                  getDrawingVerticalLine: (_) => FlLine(
                    color: AppColors.contentColorYellow.withOpacity(1),
                    dashArray: [8, 2],
                    strokeWidth: 0.8,
                  ),
                  checkToShowVerticalLine: (value) {
                    return value.toInt() == 0;
                  },
                ),
                borderData: FlBorderData(show: false),
              ),
            );
          },
        ),
      ),
    );
  }
}
