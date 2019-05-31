import 'package:example/line_chart_page2.dart';
import 'package:example/pie_chart_page.dart';
import 'package:flutter/material.dart';

import 'bar_chart_page.dart';
import 'bar_chart_page2.dart';
import 'line_chart_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlChart Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff262545),
        primaryColorDark: Color(0xff201f39),
        brightness: Brightness.dark,
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
      body: SafeArea(
        child: PageView(
          children: <Widget>[
            LineChartPage2(),
            BarChartPage(),
            BarChartPage2(),
            PieChartPage(),
            LineChartPage(),
          ],
        ),
      ),
    );
  }
}
