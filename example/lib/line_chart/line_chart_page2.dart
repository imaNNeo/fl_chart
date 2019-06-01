import 'package:fl_chart/chart/base/fl_axis_chart/fl_axis_chart_data.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_data.dart';
import 'package:fl_chart/chart/line_chart/line_chart.dart';
import 'package:fl_chart/chart/line_chart/line_chart_data.dart';
import 'package:fl_chart/fl_chart_widget.dart';
import 'package:flutter/material.dart';

import 'samples/line_chart_sample1.dart';
import 'samples/line_chart_sample2.dart';
import 'samples/line_chart_sample3.dart';

class LineChartPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "LineChart",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            LineChartSample1(),
            LineChartSample2(),
            LineChartSample3(),
          ],
        ),
      ),
    );
  }
}
