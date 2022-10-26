import 'package:example/scatter_chart/samples/scatter_chart_sample1.dart';
import 'package:example/scatter_chart/samples/scatter_chart_sample2.dart';
import 'package:flutter/material.dart';

class ScatterChartPage extends StatelessWidget {
  const ScatterChartPage({super.key});

  Color get barColor => Colors.white;
  Color get barBackgroundColor => const Color(0xff72d8bf);
  double get width => 22;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: ListView(
        children: const <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 22,
            ),
            child: Text(
              'Scatter Charts',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 9,
          ),
          Padding(
            padding: EdgeInsets.only(left: 18, right: 18, bottom: 18),
            child: ScatterChartSample1(),
          ),
          Padding(
            padding: EdgeInsets.only(left: 18, right: 18, bottom: 18),
            child: ScatterChartSample2(),
          )
        ],
      ),
    );
  }
}
