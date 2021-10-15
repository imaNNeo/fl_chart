import 'package:flutter/material.dart';

import 'samples/line_chart_sample10.dart';

class LineChartPage4 extends StatelessWidget {
  const LineChartPage4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          children: const <Widget>[
            Text(
              'LineChart (real time)',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(
              height: 52,
            ),
            LineChartSample10(),
            SizedBox(
              height: 52,
            ),
          ],
        ),
      ),
    );
  }
}
