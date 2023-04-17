import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample4 extends StatelessWidget {
  LineChartSample4({
    super.key,
    Color? mainLineColor,
    Color? belowLineColor,
    Color? aboveLineColor,
  })  : mainLineColor =
            mainLineColor ?? AppColors.contentColorYellow.withOpacity(1),
        belowLineColor =
            belowLineColor ?? AppColors.contentColorPink.withOpacity(1),
        aboveLineColor =
            aboveLineColor ?? AppColors.contentColorPurple.withOpacity(0.7);

  final Color mainLineColor;
  final Color belowLineColor;
  final Color aboveLineColor;

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
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
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: mainLineColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: AppColors.mainTextColor3,
      fontSize: 12,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text('\$ ${value + 0.5}', style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    const cutOffYValue = 5.0;

    return AspectRatio(
      aspectRatio: 2,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          right: 28,
          top: 22,
          bottom: 12,
        ),
        child: LineChart(
          LineChartData(
            lineTouchData: const LineTouchData(enabled: false),
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
                barWidth: 8,
                color: mainLineColor,
                belowBarData: BarAreaData(
                  show: true,
                  color: belowLineColor,
                  cutOffY: cutOffYValue,
                  applyCutOffY: true,
                ),
                aboveBarData: BarAreaData(
                  show: true,
                  color: aboveLineColor,
                  cutOffY: cutOffYValue,
                  applyCutOffY: true,
                ),
                dotData: const FlDotData(
                  show: false,
                ),
              ),
            ],
            minY: 0,
            titlesData: FlTitlesData(
              show: true,
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                axisNameWidget: Text(
                  '2019',
                  style: TextStyle(
                    fontSize: 10,
                    color: mainLineColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 18,
                  interval: 1,
                  getTitlesWidget: bottomTitleWidgets,
                ),
              ),
              leftTitles: AxisTitles(
                axisNameSize: 20,
                axisNameWidget: const Text(
                  'Value',
                  style: TextStyle(
                    color: AppColors.mainTextColor2,
                  ),
                ),
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 40,
                  getTitlesWidget: leftTitleWidgets,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: AppColors.borderColor,
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
