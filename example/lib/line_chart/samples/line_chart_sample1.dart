import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
                child: FlChart(
                  chart: LineChart(
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

}