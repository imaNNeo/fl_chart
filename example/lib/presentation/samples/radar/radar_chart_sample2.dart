import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart_app/util/extensions/color_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' show pi;

class RadarChartSample2 extends StatefulWidget {
  RadarChartSample2({super.key});

  final gridColor = AppColors.contentColorPurple.lighten(80);
  final titleColor = AppColors.contentColorPurple.lighten(80);
  final fashionColor = AppColors.contentColorRed;
  final artColor = AppColors.contentColorCyan;
  final boxingColor = AppColors.contentColorGreen;
  final entertainmentColor = AppColors.contentColorWhite;
  final offRoadColor = AppColors.contentColorYellow;

  @override
  State<RadarChartSample2> createState() => _RadarChartSample2State();
}

class _RadarChartSample2State extends State<RadarChartSample2> {
  int selectedDataSetIndex = -1;
  double angleValue = 0;
  bool relativeAngleMode = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Title configuration',
            style: TextStyle(
              color: AppColors.mainTextColor2,
            ),
          ),
          Row(
            children: [
              const Text(
                'Angle',
                style: TextStyle(
                  color: AppColors.mainTextColor2,
                ),
              ),
              Slider(
                value: angleValue,
                max: 360,
                onChanged: (double value) => setState(() => angleValue = value),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: relativeAngleMode,
                onChanged: (v) => setState(() => relativeAngleMode = v!),
              ),
              const Text('Relative'),
            ],
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedDataSetIndex = -1;
              });
            },
            child: Text(
              'Categories'.toUpperCase(),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w300,
                color: AppColors.mainTextColor1,
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
                          color: isSelected
                              ? AppColors.pageBackground
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(46),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 6,
                        ),
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
                                color:
                                    isSelected ? value.color : widget.gridColor,
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
            aspectRatio: 1.0,
            child: RadarChart(
              RadarChartData(
                elevation: 10,
                radarShape: RadarShape.polygon,
                radarBackgroundColor: Colors.amber,
                radarShadowColor: Colors.white,
                radarTouchData: RadarTouchData(
                  touchCallback: (FlTouchEvent event, response) {
                    if (!event.isInterestedForInteractions) {
                      setState(() {
                        selectedDataSetIndex = -1;
                      });
                      return;
                    }
                    setState(() {
                      selectedDataSetIndex =
                          response?.touchedSpot?.touchedDataSetIndex ?? -1;
                    });
                  },
                ),
                dataSets: showingDataSets(),
                borderData: FlBorderData(show: false),
                radarBorderData: const BorderSide(color: Colors.transparent),
                titlePositionPercentageOffset: 0.1,
                titleTextStyle:
                    TextStyle(color: widget.titleColor, fontSize: 14),
                getTitle: (index, angle) {
                  final usedAngle =
                      relativeAngleMode ? angle + angleValue : angleValue;
                  switch (index) {
                    case 0:
                      return RadarChartTitle(
                        text: 'Mobile or Tablet',
                        children: [
                          const TextSpan(
                            text: "\n(or sth else..",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.red,
                                fontWeight: FontWeight.w700),
                          ),
                          const TextSpan(
                            text: "or watever)",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.green,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                        angle: usedAngle,
                      );
                    case 5:
                      return RadarChartTitle(text: '55555', angle: usedAngle);
                    case 4:
                      return RadarChartTitle(text: '4444', angle: usedAngle);
                    case 3:
                      return RadarChartTitle(text: '333', angle: usedAngle);
                    case 2:
                      return RadarChartTitle(
                        text: 'Desktop',
                        angle: usedAngle,
                      );
                    case 1:
                      return RadarChartTitle(text: 'TV', angle: usedAngle);
                    default:
                      return const RadarChartTitle(text: '');
                  }
                },
                tickCount: 1,
                ticksTextStyle:
                    const TextStyle(color: Colors.transparent, fontSize: 10),
                tickBorderData: const BorderSide(color: Colors.transparent),
                gridBorderData: BorderSide(color: widget.gridColor, width: 2),
              ),
              swapAnimationDuration: const Duration(milliseconds: 400),
            ),
          ),
        ],
      ),
    );
  }

  List<RadarDataSet> showingDataSets() {
    return rawDataSets().asMap().entries.map((entry) {
      final index = entry.key;
      final rawDataSet = entry.value;

      final isSelected = index == selectedDataSetIndex
          ? true
          : selectedDataSetIndex == -1
              ? true
              : false;

      return RadarDataSet(
        fillColor: isSelected
            ? rawDataSet.color.withOpacity(0.75)
            : rawDataSet.color.withOpacity(0.15),
        borderColor:
            isSelected ? rawDataSet.color : rawDataSet.color.withOpacity(0.2),
        entryRadius: isSelected ? 3 : 2,
        gradient: SweepGradient(
          startAngle: 3 * pi / 2,
          endAngle: 7 * pi / 2,
          tileMode: TileMode.repeated,
          colors: isSelected
              ? [
                  rawDataSet.color.withOpacity(0.9),
                  rawDataSet.color.withOpacity(0.8),
                  rawDataSet.color.withOpacity(0.7),
                  rawDataSet.color.withOpacity(0.6),
                  rawDataSet.color.withOpacity(0.5),
                  rawDataSet.color.withOpacity(0.4),
                ]
              : List.filled(6, Colors.grey.withOpacity(0.2)),
          stops: const [0, 0.16, 0.32, 0.48, 0.64, 0.8],
        ),
        dataEntries:
            rawDataSet.values.map((e) => RadarEntry(value: e)).toList(),
        borderWidth: isSelected ? 1.3 : 0.3,
      );
    }).toList();
  }

  List<RawDataSet> rawDataSets() {
    return [
      RawDataSet(
        title: 'Fashion',
        color: Colors.grey, //widget.fashionColor,
        values: [
          300,
          50,
          250,
          250,
          250,
          250,
        ],
      ),
      // RawDataSet(
      //   title: 'Art & Tech',
      //   color: widget.artColor,
      //   values: [
      //     250,
      //     100,
      //     200,
      //   ],
      // ),
      // RawDataSet(
      //   title: 'Entertainment',
      //   color: widget.entertainmentColor,
      //   values: [
      //     200,
      //     150,
      //     50,
      //   ],
      // ),
      // RawDataSet(
      //   title: 'Off-road Vehicle',
      //   color: widget.offRoadColor,
      //   values: [
      //     150,
      //     200,
      //     150,
      //   ],
      // ),
      RawDataSet(
        title: 'Boxing',
        color: widget.boxingColor,
        values: [
          150,
          150,
          150,
          150,
          150,
          150,
        ],
      ),
    ];
  }
}

class RawDataSet {
  RawDataSet({
    required this.title,
    required this.color,
    required this.values,
  });

  final String title;
  final Color color;
  final List<double> values;
}
