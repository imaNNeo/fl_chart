import 'package:example/line_chart/samples/line_chart_sample1.dart';
import 'package:example/line_chart/samples/line_chart_sample2.dart';
import 'package:flutter/material.dart';

class LineChartPage extends StatelessWidget {
  const LineChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xff262545),
      child: ListView(
        children: const <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: 36,
                top: 24,
              ),
              child: Text(
                'Line Chart',
                style: TextStyle(
                  color: Color(
                    0xff6f6f97,
                  ),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 28,
              right: 28,
            ),
            child: LineChartSample1(),
          ),
          SizedBox(
            height: 22,
          ),
          Padding(
            padding: EdgeInsets.only(left: 28, right: 28),
            child: LineChartSample2(),
          ),
          SizedBox(height: 22),
        ],
      ),
    );
  }
}
