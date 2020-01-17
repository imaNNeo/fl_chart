import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample8 extends StatefulWidget {
  @override
  _LineChartSample8State createState() => _LineChartSample8State();
}

class _LineChartSample8State extends State<LineChartSample8> {
  List<Color> gradientColors = [
    Color(0xffEEF3FE),
    Color(0xffEEF3FE),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
              child: LineChart(
                mainData(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    return LineChartData(
      rangeAnnotations: RangeAnnotations(
        verticalRangeAnnotations: [
          VerticalRangeAnnotation(
            x1: 2,
            x2: 5,
            color: Color(0xffD5DAE5),
          ),
          VerticalRangeAnnotation(
            x1: 8,
            x2: 9,
            color: Color(0xffD5DAE5),
          ),
        ],
        horizontalRangeAnnotations: [
          HorizontalRangeAnnotation(
            y1: 2,
            y2: 3,
            color: Color(0xffEEF3FE),
          ),
        ]
      ),
      // uncomment to see ExtraLines with RangeAnnotations
      // extraLinesData: ExtraLinesData(
      //   extraLinesOnTop: true,
      //   showHorizontalLines: true,
      //   horizontalLines: [
      //     HorizontalLine(
      //       x: 2.5,
      //       color: Color.fromRGBO(197, 210, 214, 1),
      //       strokeWidth: 2,
      //     ),
      //     HorizontalLine(
      //       x: 8.5,
      //       color: Color.fromRGBO(197, 210, 214, 1),
      //       strokeWidth: 2,
      //     ),
      //   ],
      // ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color.fromRGBO(225, 227, 234, 1),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color.fromRGBO(225, 227, 234, 1),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: TextStyle(
              color: Colors.black87,
              fontSize: 10),
              interval: 2,
          margin: 8,
        ),
        leftTitles: SideTitles(
          interval: 2,
          showTitles: true,
          textStyle: TextStyle(
            color: Colors.black87,
            fontSize: 10,
          ),
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 1),
            FlSpot(2, 1),
            FlSpot(4.9, 5),
            FlSpot(6.8, 5),
            FlSpot(8, 1),
            FlSpot(9.5, 2),
            FlSpot(11, 4),
          ],
          isCurved: true,
          colors: [Color(0xff0F2BF6),Color(0xff0F2BF6)],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
            colors:
                gradientColors.map((color) => color.withOpacity(0.5)).toList(),
          ),
        ),
      ],
    );
  }
}
