import 'package:example/radar_chart/samples/radar_chart_sample1.dart';
import 'package:flutter/material.dart';

class RadarChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff231f49),
      child: ListView(
        children: [
          RadarChartSample1(),
        ],
      ),
    );
  }
}
