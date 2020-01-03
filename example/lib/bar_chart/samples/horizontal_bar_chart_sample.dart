import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HorizontalBarChartSample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HorizontalBarChartSampleState();
}

class HorizontalBarChartSampleState extends State<HorizontalBarChartSample> {
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 16;

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex;

  @override
  void initState() {
    super.initState();
    final barGroup1 = makeGroupData(0, 5, 12);
    final barGroup2 = makeGroupData(1, 16, 12);
    final barGroup3 = makeGroupData(2, 18, 5);
    final barGroup4 = makeGroupData(3, 20, 16);
    final barGroup5 = makeGroupData(4, 17, 6);
    final barGroup6 = makeGroupData(5, 19, 1.5);
    final barGroup7 = makeGroupData(6, 10, 1.5);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    rawBarGroups = items;
    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 28.0, right: 28.0, bottom: 28.0),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          color: Colors.white12,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: HorizontalBarChart(
                    HorizontalBarChartData(
                      maxValue: 20,
                      gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          getDrawingVerticalLine: (i) =>
                              FlLine(color: Colors.white12)),
                      barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.grey,
                            getTooltipItem: (_a, _b, _c, _d) => null,
                          ),
                          touchCallback: (response) {
                            if (response.spot == null) {
                              setState(() {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              });
                              return;
                            }

                            touchedGroupIndex =
                                response.spot.touchedBarGroupIndex;

                            setState(() {
                              if (response.touchInput is FlLongPressEnd ||
                                  response.touchInput is FlPanEnd) {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              } else {
                                showingBarGroups = List.of(rawBarGroups);
                                if (touchedGroupIndex != -1) {
                                  double sum = 0;
                                  for (BarChartRodData rod
                                      in showingBarGroups[touchedGroupIndex]
                                          .barRods) {
                                    sum += rod.value;
                                  }
                                  final avg = sum /
                                      showingBarGroups[touchedGroupIndex]
                                          .barRods
                                          .length;

                                  showingBarGroups[touchedGroupIndex] =
                                      showingBarGroups[touchedGroupIndex]
                                          .copyWith(
                                    barRods: showingBarGroups[touchedGroupIndex]
                                        .barRods
                                        .map((rod) {
                                      return rod.copyWith(value: avg);
                                    }).toList(),
                                  );
                                }
                              }
                            });
                          }),
                      axisTitleData: FlAxisTitleData(
                          show: true,
                          leftTitle: AxisTitle(
                            showTitle: true,
                            titleText: 'DAY OF WEEK',
                            margin: 4,
                            reservedSize: 12,
                            textStyle: TextStyle(
                                color: const Color(0xff7589a2),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          topTitle: AxisTitle(
                            showTitle: true,
                            titleText: 'VOLUME',
                            margin: 4,
                            reservedSize: 12,
                            textStyle: TextStyle(
                                color: const Color(0xff7589a2),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          bottomTitle: AxisTitle(
                            showTitle: true,
                            titleText: 'Press bars to display average',
                            textAlign: TextAlign.end,
                            textStyle: TextStyle(
                                color: const Color(0xff7589a2),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          )),
                      titlesData: FlTitlesData(
                        show: true,
                        leftTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color: const Color(0xff7589a2),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          margin: 8,
                          reservedSize: 14,
                          getTitles: (double value) {
                            switch (value.toInt()) {
                              case 0:
                                return 'Mn';
                              case 1:
                                return 'Te';
                              case 2:
                                return 'Wd';
                              case 3:
                                return 'Tu';
                              case 4:
                                return 'Fr';
                              case 5:
                                return 'St';
                              case 6:
                                return 'Sn';
                              default:
                                return '';
                            }
                          },
                        ),
                        topTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color: const Color(0xff7589a2),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          margin: 8,
                          reservedSize: 16,
                          interval: 2,
                          getTitles: (value) {
                            if (value == 0) {
                              return '1K';
                            } else if (value == 10) {
                              return '5K';
                            } else if (value == 20) {
                              return '10K';
                            } else {
                              return '.';
                            }
                          },
                        ),
                      ),
                      borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: Colors.white38)),
                      barGroups: showingBarGroups,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int value, double v1, double v2) {
    return BarChartGroupData(barsSpace: 0, value: value, barRods: [
      BarChartRodData(
        value: v1,
        color: leftBarColor,
        width: width,
        borderRadius: const BorderRadius.all(Radius.zero),
        showTitle: true,
        title: value == 2 ? 'There can be text on the bars' : null,
        titleStyle: const TextStyle(color: Colors.black),
        sideTitleStyle: const TextStyle(color: Colors.white),
        backDrawRodData: BackgroundBarChartRodData(
            value: 15, color: Colors.amber.withOpacity(0.2), show: true),
      ),
      BarChartRodData(
        value: v2,
        color: rightBarColor,
        width: width,
        showTitle: true,
        title: value == 2 ? 'Text will be besides if it doesn\'t fit' : null,
      ),
    ]);
  }

  Widget makeTransactionsIcon() {
    const double width = 4.5;
    const double space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}
