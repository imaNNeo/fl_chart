import 'package:fl_chart/fl_chart_widget.dart';
import 'package:flutter/material.dart';

class LineChartSample3 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 140,
      child: FlChartWidget(
        flChart: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(0, 1.3),
                  FlSpot(1, 1),
                  FlSpot(2, 1.8),
                  FlSpot(3, 1.5),
                  FlSpot(4, 2.2),
                  FlSpot(5, 1.8),
                  FlSpot(6, 3),
                ],
                isCurved: false,
                barWidth: 4,
                colors: [
                  Colors.orange,
                ],
                belowBarData: BelowBarData(
                  show: true,
                  colors: [
                    Colors.orange.withOpacity(0.5),
                    Colors.orange.withOpacity(0.0),
                  ],
                  gradientColorStops: [0.5, 1.0],
                  gradientFrom: Offset(0, 0),
                  gradientTo: Offset(0, 1),
                ),
                dotData: FlDotData(
                  show: true,
                  dotColor: Colors.deepOrange,
                  dotSize: 6,
                  checkToShowDot: (spot) {
                    return spot.x != 0 && spot.x != 6;
                  }),
              ),
            ],
            gridData: FlGridData(
              show: true,
              drawHorizontalGrid: true,
              drawVerticalGrid: true,
            ),
            titlesData: FlTitlesData(
              show: true,
              getHorizontalTitles: (value) {
                switch (value.toInt()) {
                  case 0:
                    return 'Sat';

                  case 1:
                    return 'Sun';

                  case 2:
                    return 'Mon';

                  case 3:
                    return 'Tue';

                  case 4:
                    return 'Wed';

                  case 5:
                    return 'Thu';

                  case 6:
                    return 'Fri';
                }

                return '';
              },
              getVerticalTitles: (value) {
                switch (value.toInt()) {
                  case 0:
                    return "";
                  case 1:
                    return "1k colories";
                  case 2:
                    return "2k colories";
                  case 3:
                    return "3k colories";
                }

                return "";
              },
              horizontalTitlesTextStyle: TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
              ),
              verticalTitlesTextStyle: TextStyle(color: Colors.black, fontSize: 10)),
          ),
        ),
      ),
    );
  }

}