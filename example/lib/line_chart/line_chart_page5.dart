import 'package:example/line_chart/samples/line_chart_sample11.dart';
import 'package:flutter/material.dart';

class LineChartPage5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          children: <Widget>[
            const Text(
              'LineChart (Left titles alignment to the left and '
              'Right titles alignment to the right example)',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 52),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text('Without alignment', style: TextStyle(color: Colors.black)),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: LineChartSample11(),
              ),
              decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(color: Colors.black, width: 0.5),
                    right: BorderSide(color: Colors.black, width: 0.5)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text('With alignment', style: TextStyle(color: Colors.black)),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: LineChartSample11(
                  alignYMarksLeft: true,
                  alignYMarksRight: true,
                ),
              ),
              decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(color: Colors.black, width: 0.5),
                    right: BorderSide(color: Colors.black, width: 0.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
