import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample4 extends StatefulWidget {
  const BarChartSample4({super.key});

  @override
  State<StatefulWidget> createState() => BarChartSample4State();
}

class BarChartSample4State extends State<BarChartSample4> {
  final Color dark = const Color(0xff3b8c75);
  final Color normal = const Color(0xff64caad);
  final Color light = const Color(0xff73e8c9);

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Color(0xff939393), fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Apr';
        break;
      case 1:
        text = 'May';
        break;
      case 2:
        text = 'Jun';
        break;
      case 3:
        text = 'Jul';
        break;
      case 4:
        text = 'Aug';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(
      color: Color(
        0xff939393,
      ),
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
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
          padding: const EdgeInsets.only(top: 16),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              barTouchData: BarTouchData(
                enabled: false,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: bottomTitles,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: leftTitles,
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                checkToShowHorizontalLine: (value) => value % 10 == 0,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: const Color(0xffe7e8ec),
                  strokeWidth: 1,
                ),
                drawVerticalLine: false,
              ),
              borderData: FlBorderData(
                show: false,
              ),
              groupsSpace: 4,
              barGroups: getData(),
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> getData() {
    return [
      BarChartGroupData(
        x: 0,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: 17000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 2000000000, dark),
              BarChartRodStackItem(2000000000, 12000000000, normal),
              BarChartRodStackItem(12000000000, 17000000000, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 24000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 13000000000, dark),
              BarChartRodStackItem(13000000000, 14000000000, normal),
              BarChartRodStackItem(14000000000, 24000000000, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 23000000000.5,
            rodStackItems: [
              BarChartRodStackItem(0, 6000000000.5, dark),
              BarChartRodStackItem(6000000000.5, 18000000000, normal),
              BarChartRodStackItem(18000000000, 23000000000.5, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 29000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 9000000000, dark),
              BarChartRodStackItem(9000000000, 15000000000, normal),
              BarChartRodStackItem(15000000000, 29000000000, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 32000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 2000000000.5, dark),
              BarChartRodStackItem(2000000000.5, 17000000000.5, normal),
              BarChartRodStackItem(17000000000.5, 32000000000, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: 31000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 11000000000, dark),
              BarChartRodStackItem(11000000000, 18000000000, normal),
              BarChartRodStackItem(18000000000, 31000000000, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 35000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 14000000000, dark),
              BarChartRodStackItem(14000000000, 27000000000, normal),
              BarChartRodStackItem(27000000000, 35000000000, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 31000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 8000000000, dark),
              BarChartRodStackItem(8000000000, 24000000000, normal),
              BarChartRodStackItem(24000000000, 31000000000, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 15000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 6000000000.5, dark),
              BarChartRodStackItem(6000000000.5, 12000000000.5, normal),
              BarChartRodStackItem(12000000000.5, 15000000000, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 17000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 9000000000, dark),
              BarChartRodStackItem(9000000000, 15000000000, normal),
              BarChartRodStackItem(15000000000, 17000000000, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: 34000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 6000000000, dark),
              BarChartRodStackItem(6000000000, 23000000000, normal),
              BarChartRodStackItem(23000000000, 34000000000, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 32000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 7000000000, dark),
              BarChartRodStackItem(7000000000, 24000000000, normal),
              BarChartRodStackItem(24000000000, 32000000000, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 14000000000.5,
            rodStackItems: [
              BarChartRodStackItem(0, 1000000000.5, dark),
              BarChartRodStackItem(1000000000.5, 12000000000, normal),
              BarChartRodStackItem(12000000000, 14000000000.5, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 20000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 4000000000, dark),
              BarChartRodStackItem(4000000000, 15000000000, normal),
              BarChartRodStackItem(15000000000, 20000000000, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 24000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 4000000000, dark),
              BarChartRodStackItem(4000000000, 15000000000, normal),
              BarChartRodStackItem(15000000000, 24000000000, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: 14000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 1000000000.5, dark),
              BarChartRodStackItem(1000000000.5, 12000000000, normal),
              BarChartRodStackItem(12000000000, 14000000000, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 27000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 7000000000, dark),
              BarChartRodStackItem(7000000000, 25000000000, normal),
              BarChartRodStackItem(25000000000, 27000000000, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 29000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 6000000000, dark),
              BarChartRodStackItem(6000000000, 23000000000, normal),
              BarChartRodStackItem(23000000000, 29000000000, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 16000000000.5,
            rodStackItems: [
              BarChartRodStackItem(0, 9000000000, dark),
              BarChartRodStackItem(9000000000, 15000000000, normal),
              BarChartRodStackItem(15000000000, 16000000000.5, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 15000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 7000000000, dark),
              BarChartRodStackItem(7000000000, 12000000000.5, normal),
              BarChartRodStackItem(12000000000.5, 15000000000, light),
            ],
            borderRadius: BorderRadius.zero,
          ),
        ],
      ),
    ];
  }
}
