import 'package:example/radar_chart/samples/radar_chart_sample1.dart';
import 'package:flutter/material.dart';

class RadarChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      padding: const EdgeInsets.all(28.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'RadarChart',
            style: TextStyle(
              color: Color(0xff333333),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          RadarChartSample(),
        ],
      ),
    );
  }
}
