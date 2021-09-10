import 'package:example/radar_chart/samples/radar_chart_sample1.dart';
import 'package:flutter/material.dart';

class RadarChartPage extends StatelessWidget {
  const RadarChartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff231f49),
      child: ListView(
        children: const [
          RadarChartSample1(),
        ],
      ),
    );
  }
}
