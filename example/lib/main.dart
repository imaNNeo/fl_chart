import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'presentation/router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<LineChartBarData> lines = [
    LineChartBarData(
      spots: const [
        FlSpot(0, 0),
        FlSpot(1, 10),
        FlSpot(2, 4),
        FlSpot(3, 9),
      ],
      isCurved: true,
    ),
    LineChartBarData(
      spots: const [
        FlSpot(0, 5),
        FlSpot(1, 3),
        FlSpot(2, 9),
        FlSpot(3, 4),
      ],
      isCurved: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 2,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: 3,
              minY: 0,
              maxY: 10,
              lineBarsData: lines,
              gridData: const FlGridData(show: false),
              lineTouchData: LineTouchData(
                handleBuiltInTouches: false,
                touchCallback: _handleTouch,
              )
            ),
          ),
        ),
      ),
    );
  }

  TouchLineBarSpot? _draggingSpot;

  void _handleTouch(FlTouchEvent event, LineTouchResponse? response) {
    print('_handleTouch 1');
    if (response == null) {
      _draggingSpot = null;
      print('_handleTouch 1 - null');
      return;
    }

    print('_handleTouch 2');
    if ((event is FlPanDownEvent ||
        event is FlPanStartEvent ||
        event is FlLongPressStart ||
        event is FlTapDownEvent) &&
        response.lineBarSpots != null &&
        response.lineBarSpots!.isNotEmpty &&
        _draggingSpot == null) {
      setState(() {
        _draggingSpot = response.lineBarSpots!.first;
      });
      print('_handleTouch 2 - $_draggingSpot');
    }

    print('_handleTouch 3');
    if (event is FlPanUpdateEvent || event is FlLongPressMoveUpdate) {
      setState(() {
        final line = lines[_draggingSpot!.barIndex];
        final newSpots = List.of(line.spots);
        newSpots[_draggingSpot!.spotIndex] = FlSpot(
          response.touchedChartPosition.dx,
          response.touchedChartPosition.dy,
        );
        lines[_draggingSpot!.barIndex] =
            lines[_draggingSpot!.barIndex].copyWith(
          spots: newSpots,
        );
      });
    }

    print('_handleTouch 4');
    if (event is FlPanEndEvent ||
        event is FlPanCancelEvent ||
        event is FlLongPressEnd ||
        event is FlTapUpEvent) {
      print('_handleTouch 4 - null');
      _draggingSpot = null;
    }
  }
}
