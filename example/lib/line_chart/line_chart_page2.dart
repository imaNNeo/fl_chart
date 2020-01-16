import 'package:example/line_chart/samples/line_chart_sample7.dart';
import 'package:flutter/material.dart';

import 'samples/line_chart_sample3.dart';
import 'samples/line_chart_sample4.dart';
import 'samples/line_chart_sample5.dart';
import 'samples/line_chart_sample8.dart';

class LineChartPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child:
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 32),
            children: <Widget>[
            Text(
              'LineChart',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            LineChartSample3(),
            LineChartSample4(),
            LineChartSample7(),
            LineChartSample5(),
            const SizedBox(
              height: 22,
            ),
            Text(
              'Range annotations',
              style: TextStyle(
                color: const Color(
                  0xff6f6f97,
                ),
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
            LineChartSample8(),
          ],
        )
      ),
    );
  }
}
