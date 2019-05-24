import 'package:fl_chart/chart/bar_chart/bar_chart_data.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_data.dart';
import 'package:fl_chart/chart/pie_chart/pie_chart.dart';
import 'package:fl_chart/chart/pie_chart/pie_chart_data.dart';
import 'package:fl_chart/fl_chart_widget.dart';
import 'package:flutter/material.dart';

class PieChartPage extends StatelessWidget {

  final Color barColor = Colors.white;
  final Color barBackgroundColor = Color(0xff72d8bf);
  final double width = 22;

  final pieChartSections = [
    PieChartSectionData(
      color: Color(0xff0293ee),
      value: 25,
      title: "25%",
      widthRadius: 80,
      titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff044d7c)),
      titlePositionPercentageOffset: 0.55,
    ),
    PieChartSectionData(
      color: Color(0xfff8b250),
      value: 25,
      title: "25%",
      widthRadius: 65,
      titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff90672d)),
      titlePositionPercentageOffset: 0.55,
    ),
    PieChartSectionData(
      color: Color(0xff845bef),
      value: 25,
      title: "25%",
      widthRadius: 60,
      titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff4c3788)),
      titlePositionPercentageOffset: 0.6,
    ),
    PieChartSectionData(
      color: Color(0xff13d38e),
      value: 25,
      title: "25%",
      widthRadius: 70,
      titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff0c7f55)),
      titlePositionPercentageOffset: 0.55,
    ),
  ]

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Color(0xffeceaeb),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text("Pie Chart", style: TextStyle(color: Color(0xff333333,), fontSize: 32, fontWeight: FontWeight.bold),),
              ),
            ),
            SizedBox(height: 8,),
            AspectRatio(
              aspectRatio: 1.3,
              child: Card(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 28,),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        makeIndicator(Color(0xff0293ee), "One"),
                        makeIndicator(Color(0xfff8b250), "Two"),
                        makeIndicator(Color(0xff845bef), "Three"),
                        makeIndicator(Color(0xff13d38e), "Four"),
                      ],
                    ),
                    SizedBox(height: 18,),
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
                              sectionsSpace: 0,
                              centerSpaceRadius: 0,
                              sections: pieChartSections
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget makeIndicator(Color color, String text) {
    return Row(
      children: <Widget>[
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(width: 4,),
        Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff505050)),)
      ],
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
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
      ]
    );
  }

}