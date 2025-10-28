import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart_app/util/app_utils.dart';
import 'package:flutter/material.dart';

class BarChartSample5 extends StatefulWidget {
  const BarChartSample5({super.key});

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

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.white, fontSize: 10);
    String text = switch (value.toInt()) {
      0 => 'Mon',
      1 => 'Tue',
      2 => 'Wed',
      3 => 'Thu',
      4 => 'Fri',
      5 => 'Sat',
      6 => 'Sun',
      _ => '',
    };
    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: style),
    );
  }

  Widget topTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.white, fontSize: 10);
    String text = switch (value.toInt()) {
      0 => 'Mon',
      1 => 'Tue',
      2 => 'Wed',
      3 => 'Thu',
      4 => 'Fri',
      5 => 'Sat',
      6 => 'Sun',
      _ => '',
    };
    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.white, fontSize: 10);
    String text;
    if (value == 0) {
      text = '0';
    } else {
      text = '${value.toInt()}0k';
    }
    return SideTitleWidget(
      angle: AppUtils().degreeToRadian(value < 0 ? -45 : 45),
      meta: meta,
      space: 4,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget rightTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.white, fontSize: 10);
    String text;
    if (value == 0) {
      text = '0';
    } else {
      text = '${value.toInt()}0k';
    }
    return SideTitleWidget(
      angle: AppUtils().degreeToRadian(90),
      meta: meta,
      space: 0,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  BarChartGroupData generateGroup(
    int x,
    double value1,
    double value2,
    double value3,
    double value4,
  ) {
    final isTop = value1 > 0;
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
              null,
              gradient: LinearGradient(colors: [
                AppColors.contentColorWhite.withValues(alpha: 0.8),
                AppColors.contentColorGreen.withValues(alpha: 0.5),
                AppColors.contentColorCyan.withValues(alpha: 0.2),
              ], stops: const [
                0.1,
                0.4,
                0.9
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              label: isTouched ? 'A' : null,
              borderSide: BorderSide(
                color: Colors.white,
                width: isTouched ? 2 : 0,
              ),
            ),
            BarChartRodStackItem(
              value1,
              value1 + value2,
              AppColors.contentColorYellow,
              label: isTouched ? 'B' : null,
              borderSide: BorderSide(
                color: Colors.white,
                width: isTouched ? 2 : 0,
              ),
            ),
            BarChartRodStackItem(
              value1 + value2,
              value1 + value2 + value3,
              null,
              gradient: LinearGradient(
                colors: [
                  AppColors.contentColorPurple,
                  AppColors.contentColorRed.withValues(alpha: 0.9),
                  AppColors.contentColorOrange.withValues(alpha: 0.8),
                ],
                stops: const [0, 0.5, 1],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              label: isTouched ? 'C' : null,
              borderSide: BorderSide(
                color: Colors.white,
                width: isTouched ? 2 : 0,
              ),
            ),
            BarChartRodStackItem(
              value1 + value2 + value3,
              value1 + value2 + value3 + value4,
              AppColors.contentColorBlue,
              label: isTouched ? 'D' : null,
              borderSide: BorderSide(
                color: Colors.white,
                width: isTouched ? 2 : 0,
              ),
            ),
          ],
        ),
        BarChartRodData(
          toY: -sum,
          width: barWidth,
          color: Colors.transparent,
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
              null,
              gradient: LinearGradient(colors: [
                AppColors.contentColorWhite.withValues(
                    alpha: isTouched ? shadowOpacity * 2 : shadowOpacity),
                AppColors.contentColorGreen.withValues(
                    alpha: isTouched ? shadowOpacity * 2 : shadowOpacity),
                AppColors.contentColorCyan.withValues(
                    alpha: isTouched ? shadowOpacity * 2 : shadowOpacity),
              ], stops: const [
                0.1,
                0.4,
                0.9
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              label: isTouched ? 'A' : null,
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            BarChartRodStackItem(
              -value1,
              -(value1 + value2),
              AppColors.contentColorYellow.withValues(
                  alpha: isTouched ? shadowOpacity * 2 : shadowOpacity),
              label: isTouched ? 'B' : null,
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            BarChartRodStackItem(
              -(value1 + value2),
              -(value1 + value2 + value3),
              null,
              gradient: LinearGradient(
                colors: [
                  AppColors.contentColorPurple.withValues(
                      alpha: isTouched ? shadowOpacity * 2 : shadowOpacity),
                  AppColors.contentColorRed.withValues(
                      alpha: isTouched
                          ? (shadowOpacity * 2) - 0.1
                          : shadowOpacity),
                  AppColors.contentColorOrange.withValues(
                      alpha: isTouched
                          ? (shadowOpacity * 2) - 0.2
                          : shadowOpacity),
                ],
                stops: const [0, 0.5, 1],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              label: isTouched ? 'C' : null,
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            BarChartRodStackItem(
              -(value1 + value2 + value3),
              -(value1 + value2 + value3 + value4),
              AppColors.contentColorBlue.withValues(
                  alpha: isTouched ? shadowOpacity * 2 : shadowOpacity),
              label: isTouched ? 'D' : null,
              borderSide: const BorderSide(color: Colors.transparent),
            ),
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
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
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
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  getTitlesWidget: topTitles,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  getTitlesWidget: bottomTitles,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: leftTitles,
                  interval: 5,
                  reservedSize: 42,
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: rightTitles,
                  interval: 5,
                  reservedSize: 42,
                ),
              ),
            ),
            gridData: FlGridData(
              show: true,
              checkToShowHorizontalLine: (value) => value % 5 == 0,
              getDrawingHorizontalLine: (value) {
                if (value == 0) {
                  return FlLine(
                    color: AppColors.borderColor.withValues(alpha: 0.1),
                    strokeWidth: 3,
                  );
                }
                return FlLine(
                  color: AppColors.borderColor.withValues(alpha: 0.05),
                  strokeWidth: 0.8,
                );
              },
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: mainItems.entries
                .map(
                  (e) => generateGroup(
                    e.key,
                    e.value[0],
                    e.value[1],
                    e.value[2],
                    e.value[3],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
