import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample6 extends StatelessWidget {
  static const double _minX = 0;
  static const double _maxX = 5;
  static const double _minY = 100;
  static const double _maxY = 500;

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> spots = _getSeriesSpots();

    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            color: Colors.white
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              height: 27,
            ),
            Text('Monthly spending', style: TextStyle(color: Colors.black54, fontSize: 16,), textAlign: TextAlign.center,),
            const SizedBox(
              height: 4,
            ),
            Text('Cafés, Restaurants and Fast Food', style: TextStyle(color: Colors.black45, fontSize: 12, letterSpacing: 2), textAlign: TextAlign.center,),
            const SizedBox(
              height: 17,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 25.0, left: 25.0),
                child: FlChart(
                  chart: LineChart(
                    LineChartData(
                      gridData: const FlGridData(
                        show: false,
                      ),
                      extraLinesData: ExtraLinesData(
                        show: true,
                        horizontalLines: [
                          HorizontalLine(
                            y: _getChartAverage(),
                            color: Colors.black26,
                          )
                        ],
                      ),
                      titlesData: FlTitlesData(
                        horizontalTitlesTextStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                        getHorizontalTitles: (index) {
                          switch (index.toInt()) {
                            case 0:
                              return 'Jan';
                            case 1:
                              return 'Feb';
                            case 2:
                              return 'Mar';
                            case 3:
                              return 'Apr';
                            case 4:
                              return 'May';
                            case 5:
                              return 'Jun';
                            default:
                              return '';
                          }
                        },
                        showVerticalTitles: false,
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      minX: _minX,
                      maxX: _maxX,
                      minY: _minY,
                      maxY: _maxY,
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          colors: [
                            const Color(0xff3badc4),
                          ],
                          barWidth: 2,
                          isStrokeCapRound: false,
                          dotData: const FlDotData(
                            show: false,
                          ),
                          belowBarData: BelowBarData(
                            show: true,
                            colors: [Colors.white],
                            verticalLines: _getDataPointLines(spots),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _getSeriesSpots() {
    final Random rnd = Random(4);
    final List<FlSpot> spots = [];
    for (double index = 0; index <= _maxX; index++) {
      spots.add(FlSpot(index, _minY + (_maxY - _minY) * rnd.nextDouble()));
    }
    return spots;
  }

  double _getChartAverage() {
    final List<FlSpot> spots = _getSeriesSpots();
    final double sum = spots
        .map((item) => item.y)
        .reduce((value, element) => value + element);
    return sum / spots.length;
  }

  List<VerticalLine> _getDataPointLines(List<FlSpot> spots) {
    return spots.map((spot) => VerticalLine(color: Colors.black26, x: spot.x)).toList();
  }
}