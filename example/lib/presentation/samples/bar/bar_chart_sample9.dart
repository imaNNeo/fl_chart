import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:flutter/material.dart';

/// This sample demonstrates the [TooltipDirection.aboveChartBoxArea] feature,
/// which always draws the tooltip above the entire chart box area,
/// regardless of the bar rod's position or value.
class BarChartSample9 extends StatelessWidget {
  const BarChartSample9({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Tooltip above chart box area',
              style: TextStyle(
                color: AppColors.contentColorWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: 20,
                  minY: 0,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      direction: TooltipDirection.aboveChartBoxArea,
                      getTooltipColor: (group) => AppColors.contentColorCyan,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          rod.toY.toStringAsFixed(1),
                          const TextStyle(
                            color: AppColors.contentColorBlack,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                          return Text(
                            days[value.toInt() % days.length],
                            style: const TextStyle(
                              color: AppColors.contentColorWhite,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) =>
                            const SizedBox.shrink(),
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      showingTooltipIndicators: [0],
                      barRods: [
                        BarChartRodData(
                            toY: 18, color: AppColors.contentColorCyan),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      showingTooltipIndicators: [0],
                      barRods: [
                        BarChartRodData(
                            toY: 5, color: AppColors.contentColorCyan),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      showingTooltipIndicators: [0],
                      barRods: [
                        BarChartRodData(
                            toY: 14, color: AppColors.contentColorCyan),
                      ],
                    ),
                    BarChartGroupData(
                      x: 3,
                      showingTooltipIndicators: [0],
                      barRods: [
                        BarChartRodData(
                            toY: 9, color: AppColors.contentColorCyan),
                      ],
                    ),
                    BarChartGroupData(
                      x: 4,
                      showingTooltipIndicators: [0],
                      barRods: [
                        BarChartRodData(
                            toY: 19, color: AppColors.contentColorCyan),
                      ],
                    ),
                    BarChartGroupData(
                      x: 5,
                      showingTooltipIndicators: [0],
                      barRods: [
                        BarChartRodData(
                            toY: 3, color: AppColors.contentColorCyan),
                      ],
                    ),
                    BarChartGroupData(
                      x: 6,
                      showingTooltipIndicators: [0],
                      barRods: [
                        BarChartRodData(
                            toY: 12, color: AppColors.contentColorCyan),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
