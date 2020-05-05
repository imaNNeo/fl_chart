import 'package:flutter/material.dart';

import 'samples/line_chart_sample9.dart';

class LineChartPage5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'LineChart (Dual Axis)',
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
