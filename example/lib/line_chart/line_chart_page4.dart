import 'package:flutter/material.dart';

import 'samples/line_chart_sample10.dart';

class LineChartPage4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          children: <Widget>[
            const Text(
              'LineChart (real time)',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(
              height: 52,
            ),
            LineChartSample10(),
            const SizedBox(
              height: 52,
            ),
          ],
        ),
      ),
    );
  }
}
