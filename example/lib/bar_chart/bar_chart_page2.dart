import 'package:example/bar_chart/samples/bar_chart_sample2.dart';
import 'package:flutter/material.dart';

class BarChartPage2 extends StatelessWidget {
  const BarChartPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xff132240),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(28),
          child: BarChartSample2(),
        ),
      ),
    );
  }
}
