import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample5 extends StatefulWidget {
  const BarChartSample5({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BarChartSample5State();
}

class BarChartSample5State extends State<BarChartSample5> {
  static const double barWidth = 22;
  static const shadowOpacity = 0.2;
  static const mainItems = <int, List<double>>{
    0: [2, 3, 2.5, 8],
    1: [-1.8, -2.7, -3, -6.5],
    2: [1.5, 2, 3.5, 6],
    3: [1.5, 1.5, 4, 6.5],
    4: [-2, -2, -5, -9],
    5: [-1.2, -1.5, -4.3, -10],
    6: [1.2, 4.8, 5, 5],
  };
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  BarChartGroupData generateGroup(
    int x,
    double value1,
    double value2,
    double value3,
    double value4,
  ) {
    bool isTop = value1 > 0;
    final sum = value1 + value2 + value3 + value4;
    final isTouched = touchedIndex == x;
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      showingTooltipIndicators: isTouched ? [0] : [],
      barRods: [
        BarChartRodData(
          toY: sum,
          width: barWidth,
          borderRadius: isTop
              ? const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                )
              : const BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
          rodStackItems: [
            BarChartRodStackItem(
              0,
              value1,
              const Color(0xff2bdb90),
              BorderSide(
                color: Colors.white,
                width: isTouched ? 2 : 0,
              ),
            ),
            BarChartRodStackItem(
              value1,
              value1 + value2,
              const Color(0xffffdd80),
              BorderSide(
                color: Colors.white,
                width: isTouched ? 2 : 0,
              ),
            ),
            BarChartRodStackItem(
              value1 + value2,
              value1 + value2 + value3,
              const Color(0xffff4d94),
              BorderSide(
                color: Colors.white,
                width: isTouched ? 2 : 0,
              ),
            ),
            BarChartRodStackItem(
              value1 + value2 + value3,
              value1 + value2 + value3 + value4,
              const Color(0xff19bfff),
              BorderSide(
                color: Colors.white,
                width: isTouched ? 2 : 0,
              ),
            ),
          ],
        ),
        BarChartRodData(
          toY: -sum,
          width: barWidth,
          colors: [Colors.transparent],
          borderRadius: isTop
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
          rodStackItems: [
            BarChartRodStackItem(
                0,
                -value1,
                const Color(0xff2bdb90)
                    .withOpacity(isTouched ? shadowOpacity * 2 : shadowOpacity),
                const BorderSide(color: Colors.transparent)),
            BarChartRodStackItem(
                -value1,
                -(value1 + value2),
                const Color(0xffffdd80)
                    .withOpacity(isTouched ? shadowOpacity * 2 : shadowOpacity),
                const BorderSide(color: Colors.transparent)),
            BarChartRodStackItem(
                -(value1 + value2),
                -(value1 + value2 + value3),
                const Color(0xffff4d94)
                    .withOpacity(isTouched ? shadowOpacity * 2 : shadowOpacity),
                const BorderSide(color: Colors.transparent)),
            BarChartRodStackItem(
                -(value1 + value2 + value3),
                -(value1 + value2 + value3 + value4),
                const Color(0xff19bfff)
                    .withOpacity(isTouched ? shadowOpacity * 2 : shadowOpacity),
                const BorderSide(color: Colors.transparent)),
          ],
        ),
      ],
    );
  }

  bool isShadowBar(int rodIndex) => rodIndex == 1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.8,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: const Color(0xff020227),
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              maxY: 20,
              minY: -20,
              groupsSpace: 12,
              barTouchData: BarTouchData(
                handleBuiltInTouches: false,
                touchCallback: (FlTouchEvent event, barTouchResponse) {
                  if (!event.isInterestedForInteractions ||
                      barTouchResponse == null ||
                      barTouchResponse.spot == null) {
                    setState(() {
                      touchedIndex = -1;
                    });
                    return;
                  }
                  final rodIndex = barTouchResponse.spot!.touchedRodDataIndex;
                  if (isShadowBar(rodIndex)) {
                    setState(() {
                      touchedIndex = -1;
                    });
                    return;
                  }
                  setState(() {
                    touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                  });
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                topTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (context, value) =>
                      const TextStyle(color: Colors.white, fontSize: 10),
                  margin: 10,
                  rotateAngle: 0,
                  getTitles: (double value) {
                    switch (value.toInt()) {
                      case 0:
                        return 'Mon';
                      case 1:
                        return 'Tue';
                      case 2:
                        return 'Wed';
                      case 3:
                        return 'Thu';
                      case 4:
                        return 'Fri';
                      case 5:
                        return 'Sat';
                      case 6:
                        return 'Sun';
                      default:
                        return '';
                    }
                  },
                ),
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (context, value) =>
                      const TextStyle(color: Colors.white, fontSize: 10),
                  margin: 10,
                  rotateAngle: 0,
                  getTitles: (double value) {
                    switch (value.toInt()) {
                      case 0:
                        return 'Mon';
                      case 1:
                        return 'Tue';
                      case 2:
                        return 'Wed';
                      case 3:
                        return 'Thu';
                      case 4:
                        return 'Fri';
                      case 5:
                        return 'Sat';
                      case 6:
                        return 'Sun';
                      default:
                        return '';
                    }
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (context, value) =>
                      const TextStyle(color: Colors.white, fontSize: 10),
                  rotateAngle: 45,
                  getTitles: (double value) {
                    if (value == 0) {
                      return '0';
                    }
                    return '${value.toInt()}0k';
                  },
                  interval: 5,
                  margin: 8,
                  reservedSize: 30,
                ),
                rightTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (context, value) =>
                      const TextStyle(color: Colors.white, fontSize: 10),
                  rotateAngle: 90,
                  getTitles: (double value) {
                    if (value == 0) {
                      return '0';
                    }
                    return '${value.toInt()}0k';
                  },
                  interval: 5,
                  margin: 8,
                  reservedSize: 30,
                ),
              ),
              gridData: FlGridData(
                show: true,
                checkToShowHorizontalLine: (value) => value % 5 == 0,
                getDrawingHorizontalLine: (value) {
                  if (value == 0) {
                    return FlLine(
                        color: const Color(0xff363753), strokeWidth: 3);
                  }
                  return FlLine(
                    color: const Color(0xff2a2747),
                    strokeWidth: 0.8,
                  );
                },
              ),
              borderData: FlBorderData(
                show: false,
              ),
<<<<<<< HEAD
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      y: 15.1,
                      width: barWidth,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6)),
                      rodStackItems: [
                        BarChartRodStackItem(
                            0,
                            2,
                            [const Color(0xff2bdb90)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 0 ? 2 : 0)),
                        BarChartRodStackItem(
                            2,
                            5,
                            [const Color(0xffffdd80)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 0 ? 2 : 0)),
                        BarChartRodStackItem(
                            5,
                            7.5,
                            [const Color(0xffff4d94)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 0 ? 2 : 0)),
                        BarChartRodStackItem(
                            7.5,
                            15.5,
                            [const Color(0xff19bfff)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 0 ? 2 : 0)),
                      ],
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      y: -14,
                      width: barWidth,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(6),
                          bottomRight: Radius.circular(6)),
                      rodStackItems: [
                        BarChartRodStackItem(
                            0,
                            -1.8,
                            [const Color(0xff2bdb90)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 1 ? 2 : 0)),
                        BarChartRodStackItem(
                            -1.8,
                            -4.5,
                            [const Color(0xffffdd80)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 1 ? 2 : 0)),
                        BarChartRodStackItem(
                            -4.5,
                            -7.5,
                            [const Color(0xffff4d94)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 1 ? 2 : 0)),
                        BarChartRodStackItem(
                            -7.5,
                            -14,
                            [const Color(0xff19bfff)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 1 ? 2 : 0)),
                      ],
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 2,
                  barRods: [
                    BarChartRodData(
                      y: 13,
                      width: barWidth,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6)),
                      rodStackItems: [
                        BarChartRodStackItem(
                            0,
                            1.5,
                            [const Color(0xff2bdb90)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 2 ? 2 : 0)),
                        BarChartRodStackItem(
                            1.5,
                            3.5,
                            [const Color(0xffffdd80)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 2 ? 2 : 0)),
                        BarChartRodStackItem(
                            3.5,
                            7,
                            [const Color(0xffff4d94)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 2 ? 2 : 0)),
                        BarChartRodStackItem(
                            7,
                            13,
                            [const Color(0xff19bfff)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 2 ? 2 : 0)),
                      ],
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 3,
                  barRods: [
                    BarChartRodData(
                      y: 13.5,
                      width: barWidth,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6)),
                      rodStackItems: [
                        BarChartRodStackItem(
                            0,
                            1.5,
                            [const Color(0xff2bdb90)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 3 ? 2 : 0)),
                        BarChartRodStackItem(
                            1.5,
                            3,
                            [const Color(0xffffdd80)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 3 ? 2 : 0)),
                        BarChartRodStackItem(
                            3,
                            7,
                            [const Color(0xffff4d94)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 3 ? 2 : 0)),
                        BarChartRodStackItem(
                            7,
                            13.5,
                            [const Color(0xff19bfff)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 3 ? 2 : 0)),
                      ],
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 4,
                  barRods: [
                    BarChartRodData(
                      y: -18,
                      width: barWidth,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(6),
                          bottomRight: Radius.circular(6)),
                      rodStackItems: [
                        BarChartRodStackItem(
                            0,
                            -2,
                            [const Color(0xff2bdb90)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 4 ? 2 : 0)),
                        BarChartRodStackItem(
                            -2,
                            -4,
                            [const Color(0xffffdd80)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 4 ? 2 : 0)),
                        BarChartRodStackItem(
                            -4,
                            -9,
                            [const Color(0xffff4d94)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 4 ? 2 : 0)),
                        BarChartRodStackItem(
                            -9,
                            -18,
                            [const Color(0xff19bfff)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 4 ? 2 : 0)),
                      ],
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 5,
                  barRods: [
                    BarChartRodData(
                      y: -17,
                      width: barWidth,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(6),
                          bottomRight: Radius.circular(6)),
                      rodStackItems: [
                        BarChartRodStackItem(
                            0,
                            -1.2,
                            [const Color(0xff2bdb90)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 5 ? 2 : 0)),
                        BarChartRodStackItem(
                            -1.2,
                            -2.7,
                            [const Color(0xffffdd80)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 5 ? 2 : 0)),
                        BarChartRodStackItem(
                            -2.7,
                            -7,
                            [const Color(0xffff4d94)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 5 ? 2 : 0)),
                        BarChartRodStackItem(
                            -7,
                            -17,
                            [const Color(0xff19bfff)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 5 ? 2 : 0)),
                      ],
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 6,
                  barRods: [
                    BarChartRodData(
                      y: 16,
                      width: barWidth,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6)),
                      rodStackItems: [
                        BarChartRodStackItem(
                            0,
                            1.2,
                            [const Color(0xff2bdb90)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 6 ? 2 : 0)),
                        BarChartRodStackItem(
                            1.2,
                            6,
                            [const Color(0xffffdd80)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 6 ? 2 : 0)),
                        BarChartRodStackItem(
                            6,
                            11,
                            [const Color(0xffff4d94)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 6 ? 2 : 0)),
                        BarChartRodStackItem(
                            11,
                            17,
                            [const Color(0xff19bfff)],
                            BorderSide(
                                color: Colors.white,
                                width: touchedIndex == 6 ? 2 : 0)),
                      ],
                    ),
                  ],
                ),
              ],
=======
              barGroups: mainItems.entries
                  .map((e) => generateGroup(
                      e.key, e.value[0], e.value[1], e.value[2], e.value[3]))
                  .toList(),
>>>>>>> origin/dev
            ),
          ),
        ),
      ),
    );
  }
}
