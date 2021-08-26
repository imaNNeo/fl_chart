import 'package:flutter/material.dart';

import 'samples/bar_chart_sample1.dart';
import 'samples/bar_chart_sample5.dart';

class BarChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff232040),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: BarChartSample5(),
        ),
      ),
    );
  }
}
