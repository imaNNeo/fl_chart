import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample3 extends StatelessWidget {
  final weekDays = [
    'Sat',
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Text(
              'Average Line',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              ' and ',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              'Indicators',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(
          height: 18,
        ),
        SizedBox(
          width: 300,
          height: 140,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                  getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                    return spotIndexes.map((spotIndex) {
                      final FlSpot spot = barData.spots[spotIndex];
                      if (spot.x == 0 || spot.x == 6) {
                        return null;
                      }
                      return TouchedSpotIndicatorData(
                        const FlLine(color: Colors.blue, strokeWidth: 4),
                        const FlDotData(dotSize: 8, dotColor: Colors.deepOrange),
                      );
                    }).toList();
                  },
                  touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.blueAccent,
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          final flSpot = barSpot;
                          if (flSpot.x == 0 || flSpot.x == 6) {
                            return null;
                          }

                          return LineTooltipItem(
                            '${weekDays[flSpot.x.toInt()]} \n${flSpot.y} k calories',
                            const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      })),
              extraLinesData: ExtraLinesData(horizontalLines: [
                HorizontalLine(
                  y: 1.8,
                  color: Colors.green.withOpacity(0.7),
                  strokeWidth: 4,
                ),
              ]),
              lineBarsData: [
                LineChartBarData(
                  spots: const [
                    FlSpot(0, 1.3),
                    FlSpot(1, 1),
                    FlSpot(2, 1.8),
                    FlSpot(3, 1.5),
                    FlSpot(4, 2.2),
                    FlSpot(5, 1.8),
                    FlSpot(6, 3),
                  ],
                  isCurved: false,
                  barWidth: 4,
                  colors: [
                    Colors.orange,
                  ],
                  belowBarData: BarAreaData(
                    show: true,
                    colors: [
                      Colors.orange.withOpacity(0.5),
                      Colors.orange.withOpacity(0.0),
                    ],
                    gradientColorStops: [0.5, 1.0],
                    gradientFrom: const Offset(0, 0),
                    gradientTo: const Offset(0, 1),
                    spotsLine: BarAreaSpotsLine(
                      show: true,
                      flLineStyle: const FlLine(
                        color: Colors.blue,
                        strokeWidth: 2,
                      ),
                      checkToShowSpotLine: (spot) {
                        if (spot.x == 0 || spot.x == 6) {
                          return false;
                        }

                        return true;
                      },
                    ),
                  ),
                  dotData: FlDotData(
                      show: true,
                      dotColor: Colors.deepOrange,
                      dotSize: 6,
                      checkToShowDot: (spot) {
                        return spot.x != 0 && spot.x != 6;
                      }),
                ),
              ],
              minY: 0,
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (value) {
                  if (value == 0) {
                    return const FlLine(
                      color: Colors.deepOrange,
                      strokeWidth: 2,
                    );
                  } else {
                    return const FlLine(
                      color: Colors.grey,
                      strokeWidth: 0.5,
                    );
                  }
                },
                getDrawingVerticalLine: (value) {
                  if (value == 0) {
                    return const FlLine(
                      color: Colors.black,
                      strokeWidth: 2,
                    );
                  } else {
                    return const FlLine(
                      color: Colors.grey,
                      strokeWidth: 0.5,
                    );
                  }
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                leftTitles: SideTitles(
                  showTitles: true,
                  getTitles: (value) {
                    switch (value.toInt()) {
                      case 0:
                        return '';
                      case 1:
                        return '1k calories';
                      case 2:
                        return '2k calories';
                      case 3:
                        return '3k calories';
                    }

                    return '';
                  },
                  textStyle: const TextStyle(color: Colors.black, fontSize: 10),
                ),
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTitles: (value) {
                    return weekDays[value.toInt()];
                  },
                  textStyle: const TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
