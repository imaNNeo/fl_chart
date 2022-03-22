import 'package:example/legend_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// Credit: https://dribbble.com/shots/10072126-Heeded-Dashboard
class BarChartSample6 extends StatelessWidget {
  const BarChartSample6({Key? key}) : super(key: key);

  static const pilateColor = Color(0xff632af2);
  static const cyclingColor = Color(0xffffb3ba);
  static const quickWorkoutColor = Color(0xff578eff);
  static const betweenSpace = 0.2;

  BarChartGroupData generateGroupData(
      int x, double pilates, double quickWorkout, double cycling) {
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: pilates,
          color: pilateColor,
          width: 5,
        ),
        BarChartRodData(
          fromY: pilates + betweenSpace,
          toY: pilates + betweenSpace + quickWorkout,
          color: quickWorkoutColor,
          width: 5,
        ),
        BarChartRodData(
          fromY: pilates + betweenSpace + quickWorkout + betweenSpace,
          toY: pilates + betweenSpace + quickWorkout + betweenSpace + cycling,
          color: cyclingColor,
          width: 5,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Activity',
              style: TextStyle(
                color: Color(0xff171547),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            LegendsListWidget(
              legends: [
                Legend("Pilates", pilateColor),
                Legend("Quick workouts", quickWorkoutColor),
                Legend("Cycling", cyclingColor),
              ],
            ),
            const SizedBox(height: 14),
            AspectRatio(
              aspectRatio: 2,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceBetween,
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(showTitles: false),
                    rightTitles: SideTitles(showTitles: false),
                    topTitles: SideTitles(showTitles: false),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => const TextStyle(
                        color: Color(0xff787694),
                        fontSize: 10,
                      ),
                      reservedSize: 8,
                      getTitles: (value) {
                        switch (value.toInt()) {
                          case 0:
                            return "JAN";
                          case 1:
                            return "FEB";
                          case 2:
                            return "MAR";
                          case 3:
                            return "APR";
                          case 4:
                            return "MAY";
                          case 5:
                            return "JUN";
                          case 6:
                            return "JUL";
                          case 7:
                            return "AUG";
                          case 8:
                            return "SEP";
                          case 9:
                            return "OCT";
                          case 10:
                            return "NOV";
                          case 11:
                            return "DEC";
                        }
                        return value.toString();
                      },
                    ),
                  ),
                  barTouchData: BarTouchData(enabled: false),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  barGroups: [
                    generateGroupData(0, 2, 3, 2),
                    generateGroupData(1, 2, 5, 1.7),
                    generateGroupData(2, 1.3, 3.1, 2.8),
                    generateGroupData(3, 3.1, 4, 3.1),
                    generateGroupData(4, 0.8, 3.3, 3.4),
                    generateGroupData(5, 2, 5.6, 1.8),
                    generateGroupData(6, 1.3, 3.2, 2),
                    generateGroupData(7, 2.3, 3.2, 3),
                    generateGroupData(8, 2, 4.8, 2.5),
                    generateGroupData(9, 1.2, 3.2, 2.5),
                    generateGroupData(10, 1, 4.8, 3),
                    generateGroupData(11, 2, 4.4, 2.8),
                  ],
                  maxY: 10 + (betweenSpace * 3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
