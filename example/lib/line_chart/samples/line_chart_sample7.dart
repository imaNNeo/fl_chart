import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample7 extends StatelessWidget {
  const LineChartSample7({Key? key}) : super(key: key);

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 10,
      color: Colors.purple,
      fontWeight: FontWeight.bold,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Jan';
        break;
      case 1:
        text = 'Feb';
        break;
      case 2:
        text = 'Mar';
        break;
      case 3:
        text = 'Apr';
        break;
      case 4:
        text = 'May';
        break;
      case 5:
        text = 'Jun';
        break;
      case 6:
        text = 'Jul';
        break;
      case 7:
        text = 'Aug';
        break;
      case 8:
        text = 'Sep';
        break;
      case 9:
        text = 'Oct';
        break;
      case 10:
        text = 'Nov';
        break;
      case 11:
        text = 'Dec';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '\$ ${value + 0.5}',
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.6,
      child: Padding(
        padding: const EdgeInsets.only(left: 28, right: 18),
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(enabled: false),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 4),
                  FlSpot(1, 3.5),
                  FlSpot(2, 4.5),
                  FlSpot(3, 1),
                  FlSpot(4, 4),
                  FlSpot(5, 6),
                  FlSpot(6, 6.5),
                  FlSpot(7, 6),
                  FlSpot(8, 4),
                  FlSpot(9, 6),
                  FlSpot(10, 6),
                  FlSpot(11, 7),
                ],
                isCurved: true,
                barWidth: 2,
                color: Colors.green,
                dotData: FlDotData(
                  show: false,
                ),
              ),
              LineChartBarData(
                spots: const [
                  FlSpot(0, 0),
                  FlSpot(1, 3),
                  FlSpot(2, 4),
                  FlSpot(3, 5),
                  FlSpot(4, 8),
                  FlSpot(5, 3),
                  FlSpot(6, 5),
                  FlSpot(7, 8),
                  FlSpot(8, 4),
                  FlSpot(9, 7),
                  FlSpot(10, 7),
                  FlSpot(11, 8),
                ],
                isCurved: true,
                barWidth: 2,
                color: Colors.black,
                dotData: FlDotData(
                  show: false,
                ),
              ),
              LineChartBarData(
                spots: const [
                  FlSpot(0, 7),
                  FlSpot(1, 3),
                  FlSpot(2, 4),
                  FlSpot(3, 0),
                  FlSpot(4, 3),
                  FlSpot(5, 4),
                  FlSpot(6, 5),
                  FlSpot(7, 3),
                  FlSpot(8, 2),
                  FlSpot(9, 4),
                  FlSpot(10, 1),
                  FlSpot(11, 3),
                ],
                isCurved: false,
                barWidth: 2,
                color: Colors.red,
                dotData: FlDotData(
                  show: false,
                ),
              ),
            ],
            betweenBarsData: [
              BetweenBarsData(
                fromIndex: 0,
                toIndex: 2,
                color: Colors.red.withOpacity(0.3),
              )
            ],
            minY: 0,
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: bottomTitleWidgets,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: leftTitleWidgets,
                  interval: 1,
                  reservedSize: 36,
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
              drawVerticalLine: false,
              horizontalInterval: 1,
              checkToShowHorizontalLine: (double value) {
                return value == 1 || value == 6 || value == 4 || value == 5;
              },
            ),
          ),
        ),
      ),
    );
  }
}
