import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample4 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartSample4State();
}

class BarChartSample4State extends State<BarChartSample4> {
  final Color dark = const Color(0xff3b8c75);
  final Color normal = const Color(0xff64caad);
  final Color light = const Color(0xff73e8c9);

  List<BarChartGroupData> data = [];

  @override
  void initState() {
    super.initState();
    data = [
      BarChartGroupData(
        x: 0,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 17,
              rodStackItem: [
                BarChartRodStackItem(0, 2, dark),
                BarChartRodStackItem(2, 12, normal),
                BarChartRodStackItem(12, 17, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 24,
              rodStackItem: [
                BarChartRodStackItem(0, 13, dark),
                BarChartRodStackItem(13, 14, normal),
                BarChartRodStackItem(14, 24, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 23.5,
              rodStackItem: [
                BarChartRodStackItem(0, 6.5, dark),
                BarChartRodStackItem(6.5, 18, normal),
                BarChartRodStackItem(18, 23.5, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 29,
              rodStackItem: [
                BarChartRodStackItem(0, 9, dark),
                BarChartRodStackItem(9, 15, normal),
                BarChartRodStackItem(15, 29, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 32,
              rodStackItem: [
                BarChartRodStackItem(0, 2.5, dark),
                BarChartRodStackItem(2.5, 17.5, normal),
                BarChartRodStackItem(17.5, 32, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 31,
              rodStackItem: [
                BarChartRodStackItem(0, 11, dark),
                BarChartRodStackItem(11, 18, normal),
                BarChartRodStackItem(18, 31, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 35,
              rodStackItem: [
                BarChartRodStackItem(0, 14, dark),
                BarChartRodStackItem(14, 27, normal),
                BarChartRodStackItem(27, 35, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 31,
              rodStackItem: [
                BarChartRodStackItem(0, 8, dark),
                BarChartRodStackItem(8, 24, normal),
                BarChartRodStackItem(24, 31, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 15,
              rodStackItem: [
                BarChartRodStackItem(0, 6.5, dark),
                BarChartRodStackItem(6.5, 12.5, normal),
                BarChartRodStackItem(12.5, 15, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 17,
              rodStackItem: [
                BarChartRodStackItem(0, 9, dark),
                BarChartRodStackItem(9, 15, normal),
                BarChartRodStackItem(15, 17, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 34,
              rodStackItem: [
                BarChartRodStackItem(0, 6, dark),
                BarChartRodStackItem(6, 23, normal),
                BarChartRodStackItem(23, 34, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 32,
              rodStackItem: [
                BarChartRodStackItem(0, 7, dark),
                BarChartRodStackItem(7, 24, normal),
                BarChartRodStackItem(24, 32, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 14.5,
              rodStackItem: [
                BarChartRodStackItem(0, 0.5, dark),
                BarChartRodStackItem(0.5, 12, normal),
                BarChartRodStackItem(12, 14.5, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 20,
              rodStackItem: [
                BarChartRodStackItem(0, 4, dark),
                BarChartRodStackItem(4, 15, normal),
                BarChartRodStackItem(15, 20, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 24,
              rodStackItem: [
                BarChartRodStackItem(0, 4, dark),
                BarChartRodStackItem(4, 15, normal),
                BarChartRodStackItem(15, 24, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 14,
              rodStackItem: [
                BarChartRodStackItem(0, 0.5, dark),
                BarChartRodStackItem(0.5, 12, normal),
                BarChartRodStackItem(12, 14, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 27,
              rodStackItem: [
                BarChartRodStackItem(0, 7, dark),
                BarChartRodStackItem(7, 25, normal),
                BarChartRodStackItem(25, 27, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 29,
              rodStackItem: [
                BarChartRodStackItem(0, 6, dark),
                BarChartRodStackItem(6, 23, normal),
                BarChartRodStackItem(23, 29, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 16.5,
              rodStackItem: [
                BarChartRodStackItem(0, 9, dark),
                BarChartRodStackItem(9, 15, normal),
                BarChartRodStackItem(15, 16.5, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 15,
              rodStackItem: [
                BarChartRodStackItem(0, 7, dark),
                BarChartRodStackItem(7, 12.5, normal),
                BarChartRodStackItem(12.5, 15, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 4,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 34,
              rodStackItem: [
                BarChartRodStackItem(0, 9, dark),
                BarChartRodStackItem(9, 24, normal),
                BarChartRodStackItem(24, 34, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 35,
              rodStackItem: [
                BarChartRodStackItem(0, 14.5, dark),
                BarChartRodStackItem(14.5, 27, normal),
                BarChartRodStackItem(27, 35, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 31,
              rodStackItem: [
                BarChartRodStackItem(0, 1, dark),
                BarChartRodStackItem(1, 17, normal),
                BarChartRodStackItem(17, 31, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 32,
              rodStackItem: [
                BarChartRodStackItem(0, 2, dark),
                BarChartRodStackItem(2, 16.5, normal),
                BarChartRodStackItem(16.5, 32, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 29,
              rodStackItem: [
                BarChartRodStackItem(0, 9, dark),
                BarChartRodStackItem(9, 15, normal),
                BarChartRodStackItem(15, 29, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.66,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              maxY: 35,
              barTouchData: const BarTouchData(
                enabled: false,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  textStyle: const TextStyle(color: Color(0xff939393), fontSize: 10),
                  margin: 10,
                  getTitles: (double value) {
                    switch (value.toInt()) {
                      case 0:
                        return 'Apr';
                      case 1:
                        return 'May';
                      case 2:
                        return 'Jun';
                      case 3:
                        return 'Jul';
                      case 4:
                        return 'Aug';
                      default:
                        return '';
                    }
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  textStyle: const TextStyle(
                      color: Color(
                        0xff939393,
                      ),
                      fontSize: 10),
                  getTitles: (double value) {
                    return value.toInt().toString();
                  },
                  interval: 10,
                  margin: 0,
                ),
              ),
              gridData: FlGridData(
                show: true,
                checkToShowHorizontalLine: (value) => value % 10 == 0,
                getDrawingHorizontalLine: (value) => const FlLine(
                  color: Color(0xffe7e8ec),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              groupsSpace: 4,
              barGroups: data,
            ),
          ),
        ),
      ),
    );
  }
}
