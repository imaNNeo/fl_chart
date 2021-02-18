import 'package:flutter/material.dart';

import 'samples/line_chart_sample3.dart';
import 'samples/line_chart_sample4.dart';
import 'samples/line_chart_sample5.dart';
import 'samples/line_chart_sample7.dart';
import 'samples/line_chart_sample8.dart';

class LineChartPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: <Widget>[
              const Text(
                'LineChart',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              LineChartSample3(),
              LineChartSample4(),
              LineChartSample7(),
              LineChartSample5(),
              LineChartSample8(),
            ],
          ),
        ),
      ),
    );
  }
}
