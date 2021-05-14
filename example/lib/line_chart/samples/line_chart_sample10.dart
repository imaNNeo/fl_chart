import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class LineChartSample10 extends StatefulWidget {
  @override
  _LineChartSample10State createState() => _LineChartSample10State();
}

class _LineChartSample10State extends State<LineChartSample10> {
  final Color sinColor = Colors.redAccent;
  final Color cosColor = Colors.blueAccent;

  final limitCount = 100;
  final sinPoints = <FlSpot>[];
  final cosPoints = <FlSpot>[];

  double xValue = 0;
  double step = 0.05;

  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 40), (timer) {
      while (sinPoints.length > limitCount) {
        sinPoints.removeAt(0);
        cosPoints.removeAt(0);
      }
      setState(() {
        sinPoints.add(FlSpot(xValue, math.sin(xValue)));
        cosPoints.add(FlSpot(xValue, math.cos(xValue)));
      });
      xValue += step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return cosPoints.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'x: ${xValue.toStringAsFixed(1)}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'sin: ${sinPoints.last.y.toStringAsFixed(1)}',
                style: TextStyle(
                  color: sinColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'cos: ${cosPoints.last.y.toStringAsFixed(1)}',
                style: TextStyle(
                  color: cosColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                width: 300,
                height: 300,
                child: LineChart(
                  LineChartData(
                    minY: -1,
                    maxY: 1,
                    minX: sinPoints.first.x,
                    maxX: sinPoints.last.x,
                    lineTouchData: LineTouchData(enabled: false),
                    clipData: FlClipData.all(),
                    gridData: FlGridData(
                      show: true,
                    ),
                    lineBarsData: [
                      sinLine(sinPoints),
                      cosLine(cosPoints),
                    ],
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        : Container();
  }

  LineChartBarData sinLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(
        show: false,
      ),
      colors: [sinColor.withOpacity(0), sinColor],
      colorStops: [0.1, 1.0],
      barWidth: 4,
      isCurved: false,
    );
  }

  LineChartBarData cosLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(
        show: false,
      ),
      colors: [cosColor.withOpacity(0), cosColor],
      colorStops: [0.1, 1.0],
      barWidth: 4,
      isCurved: false,
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
