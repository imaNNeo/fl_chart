import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StackedPieDemo extends StatelessWidget {
  const StackedPieDemo({super.key});

  StackedPieChartSectionData createSectionData(
    double weight,
    double a,
    double b, {
    double radius = 100,
  }) =>
      StackedPieChartSectionData(
        weight: weight,
        segments: [
          StackedPieChartSegmentData(
            value: a,
            color: Colors.lightBlue,
          ),
          StackedPieChartSegmentData(
            value: b,
            color: Colors.redAccent,
          ),
        ],
        radius: radius,
      );

  @override
  Widget build(BuildContext context) {
    return StackedPieChart(
      StackedPieChartData(
        sections: [
          createSectionData(60, 90, 10),
          createSectionData(60, 70, 30),
          createSectionData(60, 100, 0),
          createSectionData(30, 90, 10),
          createSectionData(30, 60, 40),
          createSectionData(30, 100, 0),
          createSectionData(30, 10, 90),
          createSectionData(30, 60, 40),
          createSectionData(30, 0, 100),
        ],
      ),
    );
  }
}
