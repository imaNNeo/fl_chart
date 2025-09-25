import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Example demonstrating the new hatching support for BarChartRodStackItem
class BarChartSample9 extends StatefulWidget {
  const BarChartSample9({super.key});

  @override
  State<BarChartSample9> createState() => _BarChartSample9State();
}

class _BarChartSample9State extends State<BarChartSample9> {
  final Duration animDuration = const Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 30,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => Colors.blueGrey,
                tooltipHorizontalAlignment: FLHorizontalAlignment.right,
                tooltipMargin: -10,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  String weekDay;
                  switch (group.x) {
                    case 0:
                      weekDay = 'Monday';
                      break;
                    case 1:
                      weekDay = 'Tuesday';
                      break;
                    case 2:
                      weekDay = 'Wednesday';
                      break;
                    case 3:
                      weekDay = 'Thursday';
                      break;
                    case 4:
                      weekDay = 'Friday';
                      break;
                    case 5:
                      weekDay = 'Saturday';
                      break;
                    case 6:
                      weekDay = 'Sunday';
                      break;
                    default:
                      throw Error();
                  }
                  return BarTooltipItem(
                    '$weekDay\n',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: (rod.toY - rod.fromY).toString(),
                        style: const TextStyle(
                          color: Colors.yellow,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: _getTitles,
                  reservedSize: 38,
                ),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: [
              _makeGroupData(0, 5, 12),
              _makeGroupData(1, 6.5, 10),
              _makeGroupData(2, 5, 14),
              _makeGroupData(3, 7.5, 15),
              _makeGroupData(4, 9, 11.5),
              _makeGroupData(5, 11.5, 16),
              _makeGroupData(6, 6.5, 13),
            ],
            gridData: const FlGridData(show: false),
          ),
          swapAnimationDuration: animDuration,
        ),
      ),
    );
  }

  Widget _getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('M', style: style);
        break;
      case 1:
        text = const Text('T', style: style);
        break;
      case 2:
        text = const Text('W', style: style);
        break;
      case 3:
        text = const Text('T', style: style);
        break;
      case 4:
        text = const Text('F', style: style);
        break;
      case 5:
        text = const Text('S', style: style);
        break;
      case 6:
        text = const Text('S', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      meta: meta,
      space: 16,
      child: text,
    );
  }

  BarChartGroupData _makeGroupData(
    int x,
    double y1,
    double y2,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1 + y2,
          color: Colors.transparent, // Make the main rod transparent
          width: 22,
          borderRadius: BorderRadius.circular(4),
          rodStackItems: [
            // Regular solid color stack item
            BarChartRodStackItem(
              0,
              y1,
              const Color(0xff0293ee),
            ),
            // Hatched stack item with diagonal lines
            BarChartRodStackItem(
              y1,
              y1 + y2,
              null, // No solid color
              isHatched: true,
              hatchPattern: const HatchPattern(
                hatchColor: Color(0xff38f3f3),
                backgroundColor: Color(0xff0293ee),
                spacing: 6.0,
                angle: -45.0,
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}