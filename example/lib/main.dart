import 'dart:ui';

import 'package:example/radar_chart/radar_chart_page.dart';
import 'package:example/scatter_chart/scatter_chart_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'bar_chart/bar_chart_page.dart';
import 'bar_chart/bar_chart_page2.dart';
import 'bar_chart/bar_chart_page3.dart';
import 'line_chart/line_chart_page.dart';
import 'line_chart/line_chart_page2.dart';
import 'line_chart/line_chart_page3.dart';
import 'line_chart/line_chart_page4.dart';
import 'pie_chart/pie_chart_page.dart';
import 'utils/platform_info.dart';
import 'scatter_chart/scatter_chart_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController(initialScrollOffset: 10);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
              },
            ),
            child: AspectRatio(
              aspectRatio: 2,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: scrollController,
                child: const Chart(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Chart extends StatelessWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: LineChart(
        LineChartData(
            minY: 0,
            maxY: 10,
            lineChartScrollData: LineChartScrollData(
              isEnabled: true,
            ),
            lineTouchData: LineTouchData(
                enabled: true,
                touchCallback: (FlTouchEvent event, LineTouchResponse? reponse) {
                  if (event is FlDragEvent) {}
                }),
            lineBarsData: [
              LineChartBarData(spots: const [
                FlSpot(0, 4),
                FlSpot(1, 2),
                FlSpot(2, 6),
                FlSpot(3, 4),
                FlSpot(4, 7),
                FlSpot(5, 8),
                FlSpot(6, 4),
                FlSpot(7, 2),
                FlSpot(8, 1),
                FlSpot(9, 3),
                FlSpot(10, 4),
                FlSpot(11, 2),
                FlSpot(12, 6),
                FlSpot(13, 4),
                FlSpot(14, 7),
                FlSpot(15, 8),
                FlSpot(16, 4),
                FlSpot(17, 2),
                FlSpot(18, 1),
                FlSpot(19, 3),
                FlSpot(20, 4),
                FlSpot(21, 2),
                FlSpot(22, 6),
                FlSpot(23, 4),
                FlSpot(24, 7),
                FlSpot(25, 8),
                FlSpot(26, 4),
                FlSpot(27, 2),
                FlSpot(28, 1),
                FlSpot(29, 3),
                FlSpot(30, 4),
                FlSpot(31, 2),
                FlSpot(32, 6),
                FlSpot(33, 4),
                FlSpot(34, 7),
                FlSpot(35, 8),
                FlSpot(36, 4),
                FlSpot(37, 2),
                FlSpot(38, 1),
                FlSpot(39, 3),
                FlSpot(40, 4),
                FlSpot(41, 2),
                FlSpot(42, 6),
                FlSpot(43, 4),
                FlSpot(44, 7),
                FlSpot(45, 8),
                FlSpot(46, 4),
                FlSpot(47, 2),
                FlSpot(48, 1),
                FlSpot(49, 3),
                FlSpot(50, 4),
                FlSpot(51, 2),
                FlSpot(52, 6),
                FlSpot(53, 4),
                FlSpot(54, 7),
                FlSpot(55, 8),
                FlSpot(56, 4),
                FlSpot(57, 2),
                FlSpot(58, 1),
                FlSpot(59, 3),
              ])
            ]),
      ),
    );
  }
}
