import 'package:flutter/material.dart';

import 'samples/line_chart_sample6.dart';
import 'samples/line_chart_sample9.dart';

class LineChartPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          children: <Widget>[
            const Text(
              'LineChart (reversed)',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(
              height: 52,
            ),
            LineChartSample6(),
            const SizedBox(
              height: 52,
            ),
            const Text(
              'LineChart (positive and negative values)',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(
              height: 52,
            ),
            LineChartSample9(),
          ],
        ),
      ),
    );
  }
}
