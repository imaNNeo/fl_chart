import 'package:fl_chart/chart/line_chart/line_chart_data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart_widget.dart';
import 'package:fl_chart/chart/line_chart/line_chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlChart Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'fl_chart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(child: FlChartWidget(
          flChart: LineChart(
            LineChartData(
              spots: [
                LineChartSpot(0, 1),
                LineChartSpot(1, 4),
                LineChartSpot(2, 1),
                LineChartSpot(3, 5),
                LineChartSpot(4, 3),
                LineChartSpot(5, 8),
                LineChartSpot(6, 4),
                LineChartSpot(7, 2),
                LineChartSpot(8, 4),
              ],
              curveSmoothness: 0.35,
              isCurved: true,
              showGridLines: true,
              gridData: LineChartGridData(
                drawHorizontalGrid: false,
              )
            )
          ),
        ), width: 300, height: 150,),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
