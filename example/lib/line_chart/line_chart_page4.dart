import 'package:example/bar_chart/samples/bar_chart_sample3.dart';
import 'package:flutter/material.dart';

class LineChartPage4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          BarChartSample3(),
        ],
      ),
    );
  }
}
