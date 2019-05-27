import 'package:fl_chart/chart/bar_chart/bar_chart.dart';
import 'package:fl_chart/chart/bar_chart/bar_chart_data.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_data.dart';
import 'package:fl_chart/fl_chart_widget.dart';
import 'package:flutter/material.dart';

class BarChartPage2 extends StatelessWidget {
  final Color leftBarColor = Color(0xff53fdd7);
  final Color rightBarColor = Color(0xffff5182);
  final double width = 7;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff132240),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: AspectRatio(
            aspectRatio: 1,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              color: Color(0xff2c4260),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        makeTransactionsIcon(),
                        SizedBox(
                          width: 38,
                        ),
                        Text(
                          "Transactions",
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "state",
                          style: TextStyle(color: Color(0xff77839a), fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 38,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FlChartWidget(
                          flChart: BarChart(BarChartData(
                            titlesData: FlTitlesData(
                                show: true,
                                showHorizontalTitles: true,
                                showVerticalTitles: true,
                                verticalTitlesTextStyle: TextStyle(
                                    color: Color(0xff7589a2),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                                verticalTitleMargin: 32,
                                verticalTitlesReservedWidth: 14,
                                getVerticalTitles: (value) {
                                  if (value == 0) {
                                    return "1K";
                                  } else if (value == 10) {
                                    return "5K";
                                  } else if (value == 19) {
                                    return "10K";
                                  } else {
                                    return "";
                                  }
                                },
                                horizontalTitlesTextStyle: TextStyle(
                                    color: Color(0xff7589a2),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                                horizontalTitleMargin: 20,
                                getHorizontalTitles: (double value) {
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
                                  }
                                },
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            barGroups: [
                              makeGroupData(0, 5, 12),
                              makeGroupData(1, 16, 12),
                              makeGroupData(2, 18, 5),
                              makeGroupData(3, 20, 16),
                              makeGroupData(4, 17, 6),
                              makeGroupData(5, 19, 1.5),
                              makeGroupData(6, 10, 1.5),
                            ],
                          )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        color: leftBarColor,
        width: width,
        isRound: true,
      ),
      BarChartRodData(
        y: y2,
        color: rightBarColor,
        width: width,
        isRound: true,
      ),
    ]);
  }

  Widget makeTransactionsIcon() {
    double width = 4.5;
    double space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        SizedBox(
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
