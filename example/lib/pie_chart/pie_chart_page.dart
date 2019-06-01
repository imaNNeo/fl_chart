import 'package:fl_chart/chart/bar_chart/bar_chart_data.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_data.dart';
import 'package:fl_chart/chart/pie_chart/pie_chart.dart';
import 'package:fl_chart/chart/pie_chart/pie_chart_data.dart';
import 'package:fl_chart/fl_chart_widget.dart';
import 'package:flutter/material.dart';

import 'samples/pie_chart_sample1.dart';
import 'samples/pie_chart_sample2.dart';

class PieChartPage extends StatelessWidget {
  final Color barColor = Colors.white;
  final Color barBackgroundColor = Color(0xff72d8bf);
  final double width = 22;


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffeceaeb),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: ListView(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Pie Chart",
                  style: TextStyle(
                      color: Color(
                        0xff333333,
                      ),
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            PieChartSample1(),
            SizedBox(
              height: 12,
            ),
            PieChartSample2(),
          ],
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
