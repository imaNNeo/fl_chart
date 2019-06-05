import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class PieChartSample2 extends StatelessWidget {

  final pieChartSections = [
    PieChartSectionData(
      color: Color(0xff0293ee),
      value: 40,
      title: "40%",
      radius: 50,
      titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff)),
    ),
    PieChartSectionData(
      color: Color(0xfff8b250),
      value: 30,
      title: "30%",
      radius: 50,
      titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff)),
    ),
    PieChartSectionData(
      color: Color(0xff845bef),
      value: 15,
      title: "15%",
      radius: 50,
      titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff)),
    ),
    PieChartSectionData(
      color: Color(0xff13d38e),
      value: 15,
      title: "15%",
      radius: 50,
      titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: FlChart(
                  chart: PieChart(
                    PieChartData(
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: pieChartSections),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Indicator(color: Color(0xff0293ee), text: "First", isSquare: true,),
                SizedBox(
                  height: 4,
                ),
                Indicator(color: Color(0xfff8b250), text: "Second", isSquare: true,),
                SizedBox(
                  height: 4,
                ),
                Indicator(color: Color(0xff845bef), text: "Third", isSquare: true,),
                SizedBox(
                  height: 4,
                ),
                Indicator(color: Color(0xff13d38e), text: "Fourth", isSquare: true,),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
            SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
    );
  }

}