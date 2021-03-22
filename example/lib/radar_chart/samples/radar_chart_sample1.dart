import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

const gridColor = Color(0xff68739f);
const titleColor = Color(0xff8c95db);
const fashionColor = Color(0xffe15665);
const artColor = Color(0xff63e7e5);
const boxingColor = Color(0xff83dea7);
const entertainmentColor = Colors.white70;
const offRoadColor = Color(0xFFFFF59D);

class RadarChartSample1 extends StatefulWidget {
  @override
  _RadarChartSample1State createState() => _RadarChartSample1State();
}

class _RadarChartSample1State extends State<RadarChartSample1> {
  int selectedDataSetIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedDataSetIndex = -1;
              });
            },
            child: Text(
              'Categories'.toUpperCase(),
              style: const TextStyle(
                color: titleColor,
                fontSize: 32,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rawDataSets()
                .asMap()
                .map((index, value) {
                  final isSelected = index == selectedDataSetIndex;
                  return MapEntry(
                    index,
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDataSetIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        height: 26,
                        decoration: BoxDecoration(
                          color: isSelected ? gridColor.withOpacity(0.5) : Colors.transparent,
                          borderRadius: BorderRadius.circular(46),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInToLinear,
                              padding: EdgeInsets.all(isSelected ? 8 : 6),
                              decoration: BoxDecoration(
                                color: value.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInToLinear,
                              style: TextStyle(
                                color: isSelected ? value.color : gridColor,
                              ),
                              child: Text(value.title),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })
                .values
                .toList(),
          ),
          AspectRatio(
            aspectRatio: 1.3,
            child: RadarChart(
              RadarChartData(
                radarTouchData: RadarTouchData(touchCallback: (response) {
                  if (response.touchedSpot != null &&
                      response.touchInput is! PointerUpEvent &&
                      response.touchInput is! PointerExitEvent) {
                    setState(() {
                      selectedDataSetIndex = response?.touchedSpot?.touchedDataSetIndex ?? -1;
                    });
                  } else {
                    setState(() {
                      selectedDataSetIndex = -1;
                    });
                  }
                }),
                dataSets: showingDataSets(),
                radarBackgroundColor: Colors.transparent,
                borderData: FlBorderData(show: false),
                radarBorderData: const BorderSide(color: Colors.transparent),
                titlePositionPercentageOffset: 0.2,
                titleTextStyle: const TextStyle(color: titleColor, fontSize: 14),
                getTitle: (index) {
                  switch (index) {
                    case 0:
                      return 'Mobile or Tablet';
                    case 2:
                      return 'Desktop';
                    case 1:
                      return 'TV';
                    default:
                      return '';
                  }
                },
                tickCount: 1,
                ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 10),
                tickBorderData: const BorderSide(color: Colors.transparent),
                gridBorderData: const BorderSide(color: gridColor, width: 2),
              ),
              swapAnimationDuration: const Duration(milliseconds: 400),
            ),
          ),
        ],
      ),
    );
  }

  List<RadarDataSet> showingDataSets() {
    final List<RadarDataSet> dataSets = List(rawDataSets().length);
    rawDataSets().asMap().forEach((index, rawDataSet) {
      final isSelected = index == selectedDataSetIndex
          ? true
          : selectedDataSetIndex == -1
              ? true
              : false;
      dataSets[index] = RadarDataSet(
        fillColor:
            isSelected ? rawDataSet.color.withOpacity(0.4) : rawDataSet.color.withOpacity(0.25),
        borderColor: isSelected ? rawDataSet.color : rawDataSet.color.withOpacity(0.25),
        entryRadius: isSelected ? 3 : 2,
        dataEntries: rawDataSet.values.map((e) => RadarEntry(value: e)).toList(),
        borderWidth: isSelected ? 2.3 : 2,
      );
    });
    return dataSets;
  }

  List<RawDataSet> rawDataSets() {
    return [
      RawDataSet(
        title: 'Fashion',
        color: fashionColor,
        values: [
          300,
          50,
          250,
        ],
      ),
      RawDataSet(
        title: 'Art & Tech',
        color: artColor,
        values: [
          250,
          100,
          200,
        ],
      ),
      RawDataSet(
        title: 'Entertainment',
        color: entertainmentColor,
        values: [
          200,
          150,
          50,
        ],
      ),
      RawDataSet(
        title: 'Off-road Vehicle',
        color: offRoadColor,
        values: [
          150,
          200,
          150,
        ],
      ),
      RawDataSet(
        title: 'Boxing',
        color: boxingColor,
        values: [
          100,
          250,
          100,
        ],
      ),
    ];
  }
}

class RawDataSet {
  final String title;
  final Color color;
  final List<double> values;

  RawDataSet({
    this.title,
    this.color,
    this.values,
  });
}
