import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'FlChart Demo',
      showPerformanceOverlay: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<ShowingTooltipIndicators> _showingTouchedTooltips = [];

  final Map<int, List<int>> _showingTouchedIndicators = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 200,
            height: 100,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    colors: [Colors.green],
                    spots: const [
                      FlSpot(0, 0),
                      FlSpot(1, 1),
                      FlSpot(2, 1),
                    ],
                    showingIndicators: _showingTouchedIndicators[0] ?? [],
                  ),
                  LineChartBarData(
                    colors: [Colors.red],
                    spots: const [
                      FlSpot(0, 3),
                      FlSpot(1, 2),
                      FlSpot(2, 0),
                    ],
                    showingIndicators: _showingTouchedIndicators[1] ?? [],
                  ),
                ],
                showingTooltipIndicators: _showingTouchedTooltips,
                lineTouchData: LineTouchData(
                  enabled: true,
                  handleBuiltInTouches: false,
                  touchCallback: (event, touchResponse) {
                    if (!event.isInterestedForInteractions ||
                        touchResponse?.lineBarSpots == null ||
                        touchResponse!.lineBarSpots!.isEmpty) {
                      setState(() {
                        _showingTouchedTooltips.clear();
                        _showingTouchedIndicators.clear();
                      });
                      return;
                    }

                    const showOnlyOnLineIndex = 0;
                    setState(() {
                      final sortedLineSpots = List.of(
                          touchResponse.lineBarSpots!.where((element) =>
                              element.barIndex == showOnlyOnLineIndex));
                      sortedLineSpots
                          .sort((spot1, spot2) => spot2.y.compareTo(spot1.y));

                      _showingTouchedIndicators.clear();

                      final touchedBarSpot =
                          touchResponse.lineBarSpots![showOnlyOnLineIndex];
                      final barPos = touchedBarSpot.barIndex;
                      _showingTouchedIndicators[barPos] = [
                        touchedBarSpot.spotIndex
                      ];

                      _showingTouchedTooltips.clear();
                      _showingTouchedTooltips
                          .add(ShowingTooltipIndicators(sortedLineSpots));
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
