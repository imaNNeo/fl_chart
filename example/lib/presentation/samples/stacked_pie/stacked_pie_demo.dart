import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StackedPieDemo extends StatefulWidget {
  const StackedPieDemo({super.key});

  @override
  State<StackedPieDemo> createState() => _StackedPieDemoState();
}

class _StackedPieDemoState extends State<StackedPieDemo> {
  int _touchedIndex = -1;
  int hacky = 0;

  Color _getSegmentColor(int index, Color color) =>
      _touchedIndex == -1 || _touchedIndex == index
          ? color
          : color.withValues(alpha: 0.5);

  StackedPieChartSectionData createSectionData(
    int index,
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
            color: _getSegmentColor(index, Colors.lightBlue),
          ),
          StackedPieChartSegmentData(
            value: b,
            color: _getSegmentColor(index, Colors.redAccent),
          ),
        ],
        radius: radius,
      );

  @override
  Widget build(BuildContext context) {
    return StackedPieChart(
      StackedPieChartData(
        pieTouchData: StackedPieTouchData(
          enabled: true,
          touchCallback: (event, response) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  event is! FlTapDownEvent) {
                return;
              }

              final userSelectedIndex =
                  response?.touchedSection?.touchedSectionIndex ?? -1;

              if (_touchedIndex == userSelectedIndex) {
                _touchedIndex = -1;
                return;
              } else {
                _touchedIndex = userSelectedIndex;
              }
            });
          },
        ),
        sections: [
          createSectionData(1, 60, 90, 10),
          createSectionData(2, 60, 70, 30),
          createSectionData(3, 60, 100, 0),
          createSectionData(4, 30, 90, 10),
          createSectionData(5, 30, 60, 40),
          createSectionData(6, 30, 100, 0),
          createSectionData(7, 30, 10, 90),
          createSectionData(8, 30, 60, 40),
          createSectionData(9, 30, 0, 100),
        ],
      ),
    );
  }
}
