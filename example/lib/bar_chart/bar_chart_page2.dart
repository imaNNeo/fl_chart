import 'package:example/bar_chart/samples/bar_chart_sample2.dart';
import 'package:flutter/material.dart';

class BarChartPage2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff132240),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: BarChartSample2(),
        ),
      ),
    );
  }
}
