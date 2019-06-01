import 'package:fl_chart/chart/base/fl_chart/fl_chart_data.dart';
import 'package:fl_chart/chart/pie_chart/pie_chart.dart';
import 'package:fl_chart/chart/pie_chart/pie_chart_data.dart';
import 'package:fl_chart/fl_chart_widget.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class PieChartSample1 extends StatelessWidget {

  final pieChartSections = [
    PieChartSectionData(
      color: Color(0xff0293ee),
      value: 25,
      title: "",
      radius: 80,
      titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff044d7c)),
      titlePositionPercentageOffset: 0.55,
    ),
    PieChartSectionData(
      color: Color(0xfff8b250),
      value: 25,
      title: "",
      radius: 65,
      titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff90672d)),
      titlePositionPercentageOffset: 0.55,
    ),
    PieChartSectionData(
      color: Color(0xff845bef),
      value: 25,
      title: "",
      radius: 60,
      titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff4c3788)),
      titlePositionPercentageOffset: 0.6,
    ),
    PieChartSectionData(
      color: Color(0xff13d38e),
      value: 25,
      title: "",
      radius: 70,
      titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff0c7f55)),
      titlePositionPercentageOffset: 0.55,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 28,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Indicator(color: Color(0xff0293ee), text: "One", isSquare: false),
                Indicator(color: Color(0xfff8b250), text: "Two", isSquare: false),
                Indicator(color: Color(0xff845bef), text: "Three", isSquare: false),
                Indicator(color: Color(0xff13d38e), text: "Four", isSquare: false),
              ],
            ),
            SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: FlChartWidget(
                  flChart: PieChart(
                    PieChartData(
                      startDegreeOffset: 180,
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 12,
                      centerSpaceRadius: 0,
                      sections: pieChartSections),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}