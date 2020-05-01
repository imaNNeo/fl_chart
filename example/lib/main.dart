import 'package:flutter/material.dart';

import 'bar_chart/bar_chart_page.dart';
import 'bar_chart/bar_chart_page2.dart';
import 'line_chart/line_chart_page.dart';
import 'line_chart/line_chart_page2.dart';
import 'line_chart/line_chart_page3.dart';
import 'line_chart/line_chart_page4.dart';
import 'pie_chart/pie_chart_page.dart';
import 'scatter_chart/scatter_chart_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlChart Demo',
      showPerformanceOverlay: false,
      theme: ThemeData(
        primaryColor: const Color(0xff262545),
        primaryColorDark: const Color(0xff201f39),
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(title: 'fl_chart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          children: <Widget>[
            LineChartPage(),
            BarChartPage(),
            BarChartPage2(),
            PieChartPage(),
            LineChartPage2(),
            LineChartPage3(),
            LineChartPage4(),
            ScatterChartPage(),
          ],
        ),
      ),
    );
  }
}
