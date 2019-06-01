import 'package:fl_chart/chart/bar_chart/bar_chart.dart';
import 'package:fl_chart/chart/bar_chart/bar_chart_data.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_data.dart';
import 'package:fl_chart/fl_chart_widget.dart';
import 'package:flutter/material.dart';

class BarChartSample1 extends StatelessWidget {

  final Color barColor = Colors.white;
  final Color barBackgroundColor = Color(0xff72d8bf);
  final double width = 22;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Color(0xff81e5cd),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                "Mingguan",
                style: TextStyle(
                  color: Color(0xff0f4a3c), fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "Grafik konsumsi kalori",
                style: TextStyle(
                  color: Color(0xff379982), fontSize: 18, fontWeight: FontWeight.bold),
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
                        showVerticalTitles: false,
                        horizontalTitlesTextStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        horizontalTitleMargin: 16,
                        getHorizontalTitles: (double value) {
                          switch (value.toInt()) {
                            case 0:
                              return 'M';
                            case 1:
                              return 'T';
                            case 2:
                              return 'W';
                            case 3:
                              return 'T';
                            case 4:
                              return 'F';
                            case 5:
                              return 'S';
                            case 6:
                              return 'S';
                          }
                        }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: [
                        makeGroupData(0, 5),
                        makeGroupData(1, 6.5),
                        makeGroupData(2, 5),
                        makeGroupData(3, 7.5),
                        makeGroupData(4, 9),
                        makeGroupData(5, 11.5),
                        makeGroupData(6, 6.5),
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
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        y: y,
        color: barColor,
        width: width,
        isRound: true,
        backDrawRodData: BackgroundBarChartRodData(
          show: true,
          y: 20,
          color: barBackgroundColor,
        ),
      ),
    ]);
  }

}