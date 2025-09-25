import 'package:fl_chart_app/presentation/samples/stacked_pie/stacked_pie_demo.dart';
import 'package:flutter/material.dart';

class StackedPieChartSample1 extends StatefulWidget {
  const StackedPieChartSample1({super.key});

  @override
  State<StackedPieChartSample1> createState() => _StackedPieChartSample1State();
}

class _StackedPieChartSample1State extends State<StackedPieChartSample1> {
  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 1.0,
      child: Column(
        children: <Widget>[
          SizedBox(height: 28),
          Expanded(
            child: StackedPieDemo(),
          ),
          SizedBox(height: 28),
        ],
      ),
    );
  }
}
