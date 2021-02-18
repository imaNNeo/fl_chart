import 'package:flutter/material.dart';

import '../bar_chart/samples/bar_chart_sample3.dart';
import '../bar_chart/samples/bar_chart_sample4.dart';
import '../bar_chart/samples/bar_chart_sample5.dart';

class LineChartPage4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          BarChartSample3(),
          const SizedBox(
            height: 18,
          ),
          BarChartSample4(),
          const SizedBox(
            height: 18,
          ),
          BarChartSample5(),
        ],
      ),
    );
  }
}
