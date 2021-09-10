import 'package:flutter/material.dart';

import '../bar_chart/samples/bar_chart_sample3.dart';
import '../bar_chart/samples/bar_chart_sample4.dart';
import '../bar_chart/samples/bar_chart_sample5.dart';

class BarChartPage3 extends StatelessWidget {
  const BarChartPage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const <Widget>[
          BarChartSample3(),
          SizedBox(
            height: 18,
          ),
          BarChartSample4(),
          SizedBox(
            height: 18,
          ),
          BarChartSample5(),
        ],
      ),
    );
  }
}
