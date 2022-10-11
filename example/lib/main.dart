import 'package:example/bar_chart/bar_chart_page.dart';
import 'package:example/bar_chart/bar_chart_page2.dart';
import 'package:example/bar_chart/bar_chart_page3.dart';
import 'package:example/line_chart/line_chart_page.dart';
import 'package:example/line_chart/line_chart_page2.dart';
import 'package:example/line_chart/line_chart_page3.dart';
import 'package:example/line_chart/line_chart_page4.dart';
import 'package:example/pie_chart/pie_chart_page.dart';
import 'package:example/radar_chart/radar_chart_page.dart';
import 'package:example/scatter_chart/scatter_chart_page.dart';
import 'package:example/utils/platform_info.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlChart Demo',
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
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPage = 0;

  final _controller = PageController();
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
      body: SafeArea(
        child: PageView(
          physics: isDesktopOrWeb
              ? const NeverScrollableScrollPhysics()
              : const AlwaysScrollableScrollPhysics(),
          controller: _controller,
          children: _pages,
        ),
      ),
      bottomNavigationBar: isDesktopOrWeb
          ? Container(
              padding: const EdgeInsets.all(16),
              color: Colors.transparent,
              child: Row(
                children: [
                  Visibility(
                    visible: _currentPage != 0,
                    child: FloatingActionButton(
                      onPressed: () => _controller.previousPage(
                        duration: _duration,
                        curve: _curve,
                      ),
                      child: const Icon(Icons.chevron_left_rounded),
                    ),
                  ),
                  const Spacer(),
                  Visibility(
                    visible: _currentPage != _pages.length - 1,
                    child: FloatingActionButton(
                      onPressed: () => _controller.nextPage(
                        duration: _duration,
                        curve: _curve,
                      ),
                      child: const Icon(Icons.chevron_right_rounded),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
