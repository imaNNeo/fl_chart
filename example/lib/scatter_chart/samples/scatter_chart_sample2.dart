import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ScatterChartSample2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScatterChartSample2State();
}

class _ScatterChartSample2State extends State {
  int touchedIndex;

  Color greyColor = Colors.grey;

  List<int> selectedSpots = [];

  int lastPanStartOnIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        color: const Color(0xff222222),
        child: ScatterChart(
          ScatterChartData(
            scatterSpots: [
              ScatterSpot(
                4,
                4,
                color: selectedSpots.contains(0) ? Colors.green : greyColor,
              ),
              ScatterSpot(
                2,
                5,
                color: selectedSpots.contains(1) ? Colors.yellow : greyColor,
                radius: 12,
              ),
              ScatterSpot(
                4,
                5,
                color: selectedSpots.contains(2) ? Colors.purpleAccent : greyColor,
                radius: 8,
              ),
              ScatterSpot(
                8,
                6,
                color: selectedSpots.contains(3) ? Colors.orange : greyColor,
                radius: 20,
              ),
              ScatterSpot(
                5,
                7,
                color: selectedSpots.contains(4) ? Colors.brown : greyColor,
                radius: 14,
              ),
              ScatterSpot(
                7,
                2,
                color: selectedSpots.contains(5) ? Colors.lightGreenAccent : greyColor,
                radius: 18,
              ),
              ScatterSpot(
                3,
                2,
                color: selectedSpots.contains(6) ? Colors.red : greyColor,
                radius: 36,
              ),
              ScatterSpot(
                2,
                8,
                color: selectedSpots.contains(7) ? Colors.tealAccent : greyColor,
                radius: 22,
              ),
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
              drawHorizontalLine: true,
              checkToShowHorizontalLine: (value) => true,
              getDrawingHorizontalLine: (value) => FlLine(color: Colors.white.withOpacity(0.1)),
              drawVerticalLine: true,
              checkToShowVerticalLine: (value) => true,
              getDrawingVerticalLine: (value) => FlLine(color: Colors.white.withOpacity(0.1)),
            ),
            titlesData: FlTitlesData(
              show: false,
            ),
            showingTooltipIndicators: selectedSpots,
            scatterTouchData: ScatterTouchData(
              enabled: true,
              handleBuiltInTouches: false,
              touchTooltipData: ScatterTouchTooltipData(
                tooltipBgColor: Colors.black,
              ),
              touchCallback: (ScatterTouchResponse touchResponse) {
                if (touchResponse.touchInput is FlPanStart) {
                  lastPanStartOnIndex = touchResponse.touchedSpotIndex;
                } else if (touchResponse.touchInput is FlPanEnd) {
                  final FlPanEnd flPanEnd = touchResponse.touchInput;

                  if (flPanEnd.velocity.pixelsPerSecond <= const Offset(4, 4)) {
                    // Tap happened
                    setState(() {
                      if (selectedSpots.contains(lastPanStartOnIndex)) {
                        selectedSpots.remove(lastPanStartOnIndex);
                      } else {
                        selectedSpots.add(lastPanStartOnIndex);
                      }
                    });
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
