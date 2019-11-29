import 'package:example/scatter_chart/samples/scatter_chart_sample1.dart';
import 'package:flutter/material.dart';

class ScatterChartPage extends StatelessWidget {
  final Color barColor = Colors.white;
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final double width = 22;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: ScatterChartSample1(),
          )
        ],
      ),
    );
  }
}
