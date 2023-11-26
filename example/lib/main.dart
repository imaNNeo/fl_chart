import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      360 * 1,
                      (index) => FlSpot(
                        index.toDouble(),
                        sin(radians(index.toDouble())),
                      ),
                    ),
                  ),
                ],
                horizontalZoomConfig: const ZoomConfig(
                  enabled: true,
                  amount: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
