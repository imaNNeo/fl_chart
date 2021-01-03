import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RadarChartSample extends StatefulWidget {
  @override
  _RadarChartSampleState createState() => _RadarChartSampleState();
}

class _RadarChartSampleState extends State<RadarChartSample> {
  int touchedDataSetIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: RadarChart(
          RadarChartData(
              titleCount: 3,
              fillColor: Colors.grey,
              dataSets: showingDataSets(),
              tickCount: 4,
              getTitle: (index) => '$index + values',
              gridData: const BorderSide(color: Colors.black, width: 1.5),
              titlePositionPercentageOffset: 0.3,
              ticksTextStyle: const TextStyle(
                color: Colors.deepPurple,
                fontSize: 10,
              ),
              titleTextStyle: const TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
              radarTouchData: RadarTouchData(touchCallback: (response) {
                log('response type: ${response.touchInput}');

                if (response.touchedSpot != null &&
                    response.touchInput is! FlPanEnd &&
                    response.touchInput is! FlLongPressEnd) {
                  setState(() {
                    touchedDataSetIndex = response?.touchedSpot?.touchedDataSetIndex ?? -1;
                  });
                } else {
                  setState(() {
                    touchedDataSetIndex = -1;
                  });
                }
              })),
        ),
      ),
    );
  }

  List<RadarDataSet> showingDataSets() {
    return [
      RadarDataSet(
        dataEntries: [
          const RadarEntry(value: 5),
          const RadarEntry(value: 28),
          const RadarEntry(value: 25),
        ],
        borderWidth: touchedDataSetIndex == 0 ? 4 : 3,
        color: Colors.red,
        entryRadius: (touchedDataSetIndex == 0) ? 6.0 : 3.0,
      ),
      RadarDataSet(
        dataEntries: [
          const RadarEntry(value: 18),
          const RadarEntry(value: 20),
          const RadarEntry(value: 30),
        ],
        borderWidth: touchedDataSetIndex == 1 ? 4 : 3,
        color: Colors.orange,
        entryRadius: (touchedDataSetIndex == 1) ? 6.0 : 3.0,
      ),
    ];
  }
}
