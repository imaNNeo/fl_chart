import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class LineChartSample3 extends StatefulWidget {
  final weekDays = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  final List<double> yValues = [1.3, 1, 1.8, 1.5, 2.2, 1.8, 3];

  @override
  State createState() => _LineChartSample3State();
}

class _LineChartSample3State extends State<LineChartSample3> {
  double touchedValue;

  @override
  void initState() {
    touchedValue = -1;
    super.initState();
  }

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
                        FlLine(color: Colors.blue, strokeWidth: 4),
                        FlDotData(
                          getDotPainter: (spot, percent, barData, index) {
                            if (index % 2 == 0) {
                              return FlDotCirclePainter(
                                  radius: 8,
                                  color: Colors.white,
                                  strokeWidth: 5,
                                  strokeColor: Colors.deepOrange);
                            } else {
                              return FlDotSquarePainter(
                                size: 16,
                                color: Colors.white,
                                strokeWidth: 5,
                                strokeColor: Colors.deepOrange,
                              );
                            }
                          },
                        ),
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
                            '${widget.weekDays[flSpot.x.toInt()]} \n${flSpot.y} k calories',
                            const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      }),
                  touchCallback: (LineTouchResponse lineTouch) {
                    final desiredTouch = lineTouch.touchInput is! PointerExitEvent &&
                        lineTouch.touchInput is! PointerUpEvent;

                    if (desiredTouch && lineTouch.lineBarSpots != null) {
                      final value = lineTouch.lineBarSpots[0].x;

                      if (value == 0 || value == 6) {
                        setState(() {
                          touchedValue = -1;
                        });
                        return null;
                      }

                      setState(() {
                        touchedValue = value;
                      });
                    } else {
                      setState(() {
                        touchedValue = -1;
                      });
                    }
                  }),
              extraLinesData: ExtraLinesData(horizontalLines: [
                HorizontalLine(
                  y: 1.8,
                  color: Colors.green.withOpacity(0.8),
                  strokeWidth: 3,
                  dashArray: [20, 2],
                ),
              ]),
              lineBarsData: [
                LineChartBarData(
                  isStepLineChart: true,
                  spots: widget.yValues.asMap().entries.map((e) {
                    return FlSpot(e.key.toDouble(), e.value);
                  }).toList(),
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
                      flLineStyle: FlLine(
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
                      getDotPainter: (spot, percent, barData, index) {
                        if (index % 2 == 0) {
                          return FlDotCirclePainter(
                              radius: 6,
                              color: Colors.white,
                              strokeWidth: 3,
                              strokeColor: Colors.deepOrange);
                        } else {
                          return FlDotSquarePainter(
                            size: 12,
                            color: Colors.white,
                            strokeWidth: 3,
                            strokeColor: Colors.deepOrange,
                          );
                        }
                      },
                      checkToShowDot: (spot, barData) {
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
                    return FlLine(
                      color: Colors.deepOrange,
                      strokeWidth: 2,
                    );
                  } else {
                    return FlLine(
                      color: Colors.grey,
                      strokeWidth: 0.5,
                    );
                  }
                },
                getDrawingVerticalLine: (value) {
                  if (value == 0) {
                    return FlLine(
                      color: Colors.black,
                      strokeWidth: 2,
                    );
                  } else {
                    return FlLine(
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
                  reservedSize: 30,
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
                  getTextStyles: (value) => const TextStyle(color: Colors.black, fontSize: 10),
                ),
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTitles: (value) {
                    return widget.weekDays[value.toInt()];
                  },
                  getTextStyles: (value) {
                    final isTouched = value == touchedValue;
                    return TextStyle(
                      color: isTouched ? Colors.deepOrange : Colors.deepOrange.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
