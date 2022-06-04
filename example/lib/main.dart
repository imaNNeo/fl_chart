import 'package:example/radar_chart/radar_chart_page.dart';
import 'package:example/scatter_chart/scatter_chart_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
  int _currentPage = 0;

  final _controller = PageController(initialPage: 0);
  final _duration = const Duration(milliseconds: 300);
  final _curve = Curves.easeInOutCubic;
  final _pages = const [
    LineChartPage(),
    BarChartPage(),
    BarChartPage2(),
    PieChartPage(),
    LineChartPage2(),
    LineChartPage3(),
    LineChartPage4(),
    BarChartPage3(),
    ScatterChartPage(),
    RadarChartPage(),
  ];

  bool get isDesktopOrWeb => PlatformInfo().isDesktopOrWeb();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: RadarChart(
                RadarChartData(
                  dataSets: [
                    RadarDataSet(
                      dataEntries: [
                        const RadarEntry(value: 210.0),
                        const RadarEntry(value: 60.0),
                        const RadarEntry(value: 150.0),
                        const RadarEntry(value: 150.0),
                        const RadarEntry(value: 160.0),
                        const RadarEntry(value: 150.0),
                        const RadarEntry(value: 110.0),
                        const RadarEntry(value: 190.0),
                        const RadarEntry(value: 200.0),
                      ],
                      borderColor: Colors.greenAccent,
                      fillColor: Colors.greenAccent.withOpacity(0.3),
                      entryRadius: 0,
                    ),
                    RadarDataSet(
                      dataEntries: [
                        const RadarEntry(value: 120.0),
                        const RadarEntry(value: 160.0),
                        const RadarEntry(value: 117.0),
                        const RadarEntry(value: 117.0),
                        const RadarEntry(value: 210.0),
                        const RadarEntry(value: 120.0),
                        const RadarEntry(value: 210.0),
                        const RadarEntry(value: 105.0),
                        const RadarEntry(value: 210.0),
                      ],
                      borderColor: Colors.redAccent,
                      fillColor: Colors.redAccent.withOpacity(0.3),
                      entryRadius: 0,
                    ),
                  ],
                  tickCount: 5,
                  getTitle: (index) {
                    switch (index) {
                      case 0: return "Party A";
                      case 1: return "Party B";
                      case 2: return "Party C";
                      case 3: return "Party D";
                      case 4: return "Party E";
                      case 5: return "Party F";
                      case 6: return "Party G";
                      case 7: return "Party H";
                      case 8: return "Party I";
                      default: throw StateError("Invalid index");
                    }
                  },
                  titleTextStyle: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
