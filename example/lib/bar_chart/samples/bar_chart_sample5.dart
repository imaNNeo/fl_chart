import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample5 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartSample5State();
}

class BarChartSample5State extends State<BarChartSample5> {
  final Color dark = const Color(0xff3b8c75);
  final Color normal = const Color(0xff64caad);
  final Color light = const Color(0xff73e8c9);

  static const double barWidth = 22;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
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
              groupsSpace: 12,
              barTouchData: const BarTouchData(
                enabled: false,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  textStyle: const TextStyle(color: Colors.white, fontSize: 10),
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
                  textStyle: const TextStyle(color: Colors.white, fontSize: 10),
                  rotateAngle: 45,
                  getTitles: (double value) {
                    if (value == 0) {
                      return '';
                    }
                    return '${value.toInt()}0k';
                  },
                  interval: 5,
                  margin: 8,
                  reservedSize: 30,
                ),
                rightTitles: SideTitles(
                  showTitles: true,
                  textStyle: const TextStyle(color: Colors.white, fontSize: 10),
                  rotateAngle: 90,
                  getTitles: (double value) {
                    if (value == 0) {
                      return '';
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
                    return const FlLine(color: Color(0xff363753), strokeWidth: 3);
                  }
                  return const FlLine(
                    color: Color(0xff2a2747),
                    strokeWidth: 0.8,
                  );
                },
              ),
              borderData: FlBorderData(
                show: false,
              ),
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      y: 15.1,
                      width: barWidth,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                      rodStackItem: const [
                        BarChartRodStackItem(0, 2, Color(0xff2bdb90)),
                        BarChartRodStackItem(2, 5, Color(0xffffdd80)),
                        BarChartRodStackItem(5, 7.5, Color(0xffff4d94)),
                        BarChartRodStackItem(7.5, 15.5, Color(0xff19bfff)),
                      ],
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      y: 14,
                      width: barWidth,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                      rodStackItem: const [
                        BarChartRodStackItem(0, 1.8, Color(0xff2bdb90)),
                        BarChartRodStackItem(1.8, 4.5, Color(0xffffdd80)),
                        BarChartRodStackItem(4.5, 7.5, Color(0xffff4d94)),
                        BarChartRodStackItem(7.5, 14, Color(0xff19bfff)),
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
                          topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                      rodStackItem: const [
                        BarChartRodStackItem(0, 1.5, Color(0xff2bdb90)),
                        BarChartRodStackItem(1.5, 3.5, Color(0xffffdd80)),
                        BarChartRodStackItem(3.5, 7, Color(0xffff4d94)),
                        BarChartRodStackItem(7, 13, Color(0xff19bfff)),
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
                          topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                      rodStackItem: const [
                        BarChartRodStackItem(0, 1.5, Color(0xff2bdb90)),
                        BarChartRodStackItem(1.5, 3, Color(0xffffdd80)),
                        BarChartRodStackItem(3, 7, Color(0xffff4d94)),
                        BarChartRodStackItem(7, 13.5, Color(0xff19bfff)),
                      ],
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 4,
                  barRods: [
                    BarChartRodData(
                      y: 18,
                      width: barWidth,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                      rodStackItem: const [
                        BarChartRodStackItem(0, 2, Color(0xff2bdb90)),
                        BarChartRodStackItem(2, 4, Color(0xffffdd80)),
                        BarChartRodStackItem(4, 9, Color(0xffff4d94)),
                        BarChartRodStackItem(9, 18, Color(0xff19bfff)),
                      ],
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 5,
                  barRods: [
                    BarChartRodData(
                      y: 17,
                      width: barWidth,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                      rodStackItem: const [
                        BarChartRodStackItem(0, 1.2, Color(0xff2bdb90)),
                        BarChartRodStackItem(1.2, 2.7, Color(0xffffdd80)),
                        BarChartRodStackItem(2.7, 7, Color(0xffff4d94)),
                        BarChartRodStackItem(7, 17, Color(0xff19bfff)),
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
                          topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                      rodStackItem: const [
                        BarChartRodStackItem(0, 1.2, Color(0xff2bdb90)),
                        BarChartRodStackItem(1.2, 6, Color(0xffffdd80)),
                        BarChartRodStackItem(6, 11, Color(0xffff4d94)),
                        BarChartRodStackItem(11, 17, Color(0xff19bfff)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
