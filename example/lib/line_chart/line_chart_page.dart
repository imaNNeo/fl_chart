import 'package:flutter/material.dart';

import 'samples/line_chart_sample1.dart';
import 'samples/line_chart_sample2.dart';
import 'samples/line_chart_sample2_2.dart';

class LineChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff262545),
      child: ListView(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 36.0,
                top: 24,
              ),
              child: Text(
                'Line Chart',
                style: TextStyle(
                    color: const Color(
                      0xff6f6f97,
                    ),
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 28,
              right: 28,
            ),
            child: LineChartSample1(),
          ),
          const SizedBox(
            height: 22,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0, right: 28),
            child: LineChartSample2(),
          ),
          const SizedBox(
            height: 22,
          ),
            Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 36.0,
              ),
              child: Text(
                'Range annotations',
                style: TextStyle(
                    color: const Color(
                      0xff6f6f97,
                    ),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0, right: 28),
            child: LineChartSample2_2(),
          ),
        ],
      ),
    );
  }
}
