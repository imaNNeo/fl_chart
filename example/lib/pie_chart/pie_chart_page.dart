import 'package:example/pie_chart/samples/pie_chart_sample1.dart';
import 'package:example/pie_chart/samples/pie_chart_sample2.dart';
import 'package:example/pie_chart/samples/pie_chart_sample3.dart';
import 'package:flutter/material.dart';

class PieChartPage extends StatelessWidget {
  const PieChartPage({super.key});

  Color get barColor => Colors.white;
  Color get barBackgroundColor => const Color(0xff72d8bf);
  double get width => 22;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xffeceaeb),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: ListView(
          children: const <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  'Pie Chart',
                  style: TextStyle(
                    color: Color(
                      0xff333333,
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
            PieChartSample1(),
            SizedBox(
              height: 12,
            ),
            PieChartSample2(),
            SizedBox(
              height: 12,
            ),
            PieChartSample3(),
          ],
        ),
      ),
    );
  }
}
