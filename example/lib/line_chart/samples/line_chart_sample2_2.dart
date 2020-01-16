import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample2_2 extends StatefulWidget {
  @override
  _LineChartSample2_2State createState() => _LineChartSample2_2State();
}

class _LineChartSample2_2State extends State<LineChartSample2_2> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(18),
                ),
                color: const Color(0xff232d37)),
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
            x2: 4,
            color: Colors.orange
          ),
          VerticalRangeAnnotation(
            x1: 8,
            x2: 10,
            color: Colors.yellow
          ),
        ],
        horizontalRangeAnnotations: [
          HorizontalRangeAnnotation(
            y1: 1,
            y2: 2,
            color: Colors.red
          ),
          HorizontalRangeAnnotation(
            y1: 4,
            y2: 5,
            color: Colors.blue
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
      //       strokeWidth: 1,
      //     ),
      //     HorizontalLine(
      //       x: 8.5,
      //       color: Color.fromRGBO(197, 210, 214, 1),
      //       strokeWidth: 1,
      //     ),
      //   ],
      // ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
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
              color: const Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
              interval: 2,
          margin: 8,
        ),
        leftTitles: SideTitles(
          interval: 2,
          showTitles: true,
          textStyle: TextStyle(
            color: const Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
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
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
