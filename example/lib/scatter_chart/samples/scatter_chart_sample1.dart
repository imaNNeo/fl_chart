import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ScatterChartSample1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScatterChartSample1State();
}

class _ScatterChartSample1State extends State {
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        color: Color(0xff222222),
        child: ScatterChart(
          ScatterChartData(
              scatterSpots: [
                ScatterSpot(4, 4, color: Colors.green,),
                ScatterSpot(2, 5, color: Colors.yellow, radius: 12,),
                ScatterSpot(4, 5, color: Colors.purpleAccent, radius: 8,),
                ScatterSpot(8, 6, color: Colors.orange, radius: 20,),
                ScatterSpot(5, 7, color: Colors.brown, radius: 14,),
                ScatterSpot(7, 2, color: Colors.lightGreenAccent, radius: 18,),
                ScatterSpot(3, 2, color: Colors.red, radius: 36,),
                ScatterSpot(2, 8, color: Colors.tealAccent, radius: 22,),
              ],
              minX: 0,
              maxX: 10,
              minY: 0,
              maxY: 10,
              borderData: FlBorderData(
                show: false,
              ),
              gridData: FlGridData(
                show: true,
                drawHorizontalGrid: true,
                checkToShowHorizontalGrid: (value) => true,
                getDrawingHorizontalGridLine: (value) => FlLine(color: Colors.white.withOpacity(0.1)),
                drawVerticalGrid: true,
                checkToShowVerticalGrid: (value) => true,
                getDrawingVerticalGridLine: (value) => FlLine(color: Colors.white.withOpacity(0.1)),
              ),
              titlesData: const FlTitlesData(
                show: false,
              )),
        ),
      ),
    );
  }
}
