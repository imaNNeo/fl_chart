import 'package:fl_chart/chart/base/fl_axis_chart/fl_axis_chart_data.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_data.dart';
import 'package:fl_chart/chart/line_chart/line_chart.dart';
import 'package:fl_chart/chart/line_chart/line_chart_data.dart';
import 'package:fl_chart/fl_chart_widget.dart';
import 'package:flutter/material.dart';

class LineChartPage2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff262545),
      child: ListView(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 36.0, top: 24,),
              child: Text(
                "Line Chart",
                style: TextStyle(
                  color: Color(
                    0xff6f6f97,
                  ),
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28, right: 28,),
            child: sample1(),
          ),
          SizedBox(
            height: 22,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0, right: 28),
            child: sample2(),
          ),
        ],
      ),
    );
  }

  Widget sample1() {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          gradient: LinearGradient(
            colors: [
            Color(0xff2c274c),
            Color(0xff46426c),
          ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 37,
            ),
            Text("Unfold Shop 2018", style: TextStyle(color: Color(0xff827daa), fontSize: 16,), textAlign: TextAlign.center,),
            SizedBox(
              height: 4,
            ),
            Text("Monthly Sales", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2), textAlign: TextAlign.center,),
            SizedBox(
              height: 37,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                child: FlChartWidget(
                  flChart: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: false,
                      ),
                      titlesData: FlTitlesData(
                        horizontalTitlesTextStyle: TextStyle(
                          color: Color(0xff72719b),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        horizontalTitleMargin: 10,
                        getHorizontalTitles: (value) {
                          switch(value.toInt()) {
                            case 2:
                              return "SEPT";
                            case 7:
                              return "OCT";
                            case 12:
                              return "DEC";
                          }
                          return "";
                        },
                        verticalTitlesTextStyle: TextStyle(
                          color: Color(0xff75729e),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        getVerticalTitles: (value) {
                          switch(value.toInt()) {
                            case 1: return "1m";
                            case 2: return "2m";
                            case 3: return "3m";
                            case 4: return "5m";
                          }
                          return "";
                        },
                        verticalTitleMargin: 8,
                        verticalTitlesReservedWidth: 30,
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xff4e4965),
                            width: 4,
                          ),
                          left: BorderSide(
                            color: Colors.transparent,
                          ),
                          right: BorderSide(
                            color: Colors.transparent,
                          ),
                          top: BorderSide(
                            color: Colors.transparent,
                          ),
                        )
                      ),
                      minX: 0,
                      maxX: 14,
                      maxY: 4,
                      minY: 0,
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(1, 1),
                            FlSpot(3, 1.5),
                            FlSpot(5, 1.4),
                            FlSpot(7, 3.4),
                            FlSpot(10, 2),
                            FlSpot(12, 2.2),
                            FlSpot(13, 1.8),
                          ],
                          isCurved: true,
                          colors: [
                            Color(0xff4af699),
                          ],
                          barWidth: 8,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: false,
                          ),
                          belowBarData: BelowBarData(
                            show: false,
                          ),
                        ),
                        LineChartBarData(
                          spots: [
                            FlSpot(1, 1),
                            FlSpot(3, 2.8),
                            FlSpot(7, 1.2),
                            FlSpot(10, 2.8),
                            FlSpot(12, 2.6),
                            FlSpot(13, 3.9),
                          ],
                          isCurved: true,
                          colors: [
                            Color(0xffaa4cfc),
                          ],
                          barWidth: 8,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: false,
                          ),
                          belowBarData: BelowBarData(
                            show: false,
                          ),
                        ),
                        LineChartBarData(
                          spots: [
                            FlSpot(1, 2.8),
                            FlSpot(3, 1.9),
                            FlSpot(6, 3),
                            FlSpot(10, 1.3),
                            FlSpot(13, 2.5),
                          ],
                          isCurved: true,
                          colors: [
                            Color(0xff27b6fc),
                          ],
                          barWidth: 8,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: false,
                          ),
                          belowBarData: BelowBarData(
                            show: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

  Widget sample2() {
    List<Color> gradientColors = [
      Color(0xff23b6e6),
      Color(0xff02d39a),
    ];
    return AspectRatio(
      aspectRatio: 1.70,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          color: Color(0xff232d37)
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
          child: FlChartWidget(
            flChart: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawHorizontalGrid: true,
                  verticalGridColor: Color(0xff37434d),
                  verticalGridLineWidth: 1,
                  horizontalGridColor: Color(0xff37434d),
                  horizontalGridLineWidth: 1,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  horizontalTitlesTextStyle: TextStyle(
                    color: Color(0xff68737d),
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                  getHorizontalTitles: (value) {
                    switch(value.toInt()) {
                      case 2: return "MAR";
                      case 5: return "JUN";
                      case 8: return "SEP";
                    }

                    return "";
                  },
                  verticalTitlesTextStyle: TextStyle(
                    color: Color(0xff67727d),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  getVerticalTitles: (value) {
                    switch(value.toInt()) {
                      case 1: return "10k";
                      case 3: return "30k";
                      case 5: return "50k";
                    }
                    return "";
                  },
                  verticalTitlesReservedWidth: 28,
                  verticalTitleMargin: 12,
                  horizontalTitleMargin: 8,
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Color(0xff37434d), width: 1)
                ),
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 6,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 3),
                      FlSpot(2.6, 2),
                      FlSpot(4.9, 5),
                      FlSpot(6.8, 3.1),
                      FlSpot(8, 4),
                      FlSpot(9.5, 3),
                      FlSpot(11, 4),
                    ],
                    isCurved: true,
                    colors: gradientColors,
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: false,
                    ),
                    belowBarData: BelowBarData(
                      show: true,
                      colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
