import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
  @override
  Widget build(BuildContext context) {
    final mainColors = [
      Colors.purple,
      Colors.cyanAccent,
      Colors.green,
      Colors.yellow,
      Colors.red,
    ];
    final transparentColors = mainColors.map((e) => e.withOpacity(0.6)).toList();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 38),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 14),
                        const FlSpot(1, 7),
                        const FlSpot(2, 3),
                        const FlSpot(3, 2),
                        const FlSpot(4, 6),
                        const FlSpot(5, 9),
                        const FlSpot(6, 3.5),
                        const FlSpot(7, 5),
                      ],
                      isCurved: true,
                      belowBarData: BarAreaData(
                        show: true,
                        gradientFrom: const Offset(0, 0),
                        gradientTo: const Offset(0, 1),
                        colors: transparentColors,
                        gradientColorStops: [
                          0.15,
                          0.35,
                          0.55,
                          0.75,
                          1.0,
                        ],
                      ),
                      colors: mainColors,
                      gradientFrom: const Offset(0, 0),
                      gradientTo: const Offset(0, 1),
                      barWidth: 8
                    ),
                  ],
                  minY: 0,
                  titlesData: FlTitlesData(
                    show: true,
                    leftTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 40,
                    ),
                    rightTitles: SideTitles(showTitles: false),
                    topTitles: SideTitles(showTitles: false),
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
