import 'dart:math';

import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ScatterChartSample2 extends StatefulWidget {
  const ScatterChartSample2({super.key});

  @override
  State<StatefulWidget> createState() => _ScatterChartSample2State();
}

class _ScatterChartSample2State extends State {
  int touchedIndex = -1;

  Color greyColor = Colors.grey;
  final _availableColors = [
    AppColors.contentColorGreen,
    AppColors.contentColorYellow,
    AppColors.contentColorPink,
    AppColors.contentColorOrange,
    AppColors.contentColorPurple,
    AppColors.contentColorBlue,
    AppColors.contentColorRed,
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
    AppColors.contentColorGreen,
    AppColors.contentColorPink,
  ];

  List<int> selectedSpots = [];

  PainterType _currentPaintType = PainterType.circle;

  static FlDotPainter _getPaint(PainterType type, double size, Color color) {
    switch (type) {
      case PainterType.circle:
        return FlDotCirclePainter(
          color: color,
          radius: size,
        );
      case PainterType.square:
        return FlDotSquarePainter(
          color: color,
          size: size * 2,
          strokeWidth: 0,
        );
      case PainterType.cross:
        return FlDotCrossPainter(
          color: color,
          size: size * 2,
          width: max(size / 5, 2),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // (x, y, size)
    final data = [
      (4.0, 4.0, 4.0),
      (2.0, 5.0, 12.0),
      (4.0, 5.0, 8.0),
      (8.0, 6.0, 20.0),
      (5.0, 7.0, 14.0),
      (7.0, 2.0, 18.0),
      (3.0, 2.0, 36.0),
      (2.0, 8.0, 22.0),
      (8.0, 8.0, 32.0),
      (5.0, 2.5, 24.0),
      (3.0, 7.0, 18.0),
    ];
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          ScatterChart(
            ScatterChartData(
              scatterSpots: data.asMap().entries.map((e) {
                final index = e.key;
                final (double x, double y, double size) = e.value;
                return ScatterSpot(
                  x,
                  y,
                  dotPainter: _getPaint(
                    _currentPaintType,
                    size,
                    selectedSpots.contains(index)
                        ? _availableColors[index % _availableColors.length]
                        : AppColors.contentColorWhite.withOpacity(0.5),
                  ),
                );
              }).toList(),
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
                getDrawingHorizontalLine: (value) => const FlLine(
                  color: AppColors.gridLinesColor,
                ),
                drawVerticalLine: true,
                checkToShowVerticalLine: (value) => true,
                getDrawingVerticalLine: (value) => const FlLine(
                  color: AppColors.gridLinesColor,
                ),
              ),
              titlesData: const FlTitlesData(
                show: false,
              ),
              showingTooltipIndicators: selectedSpots,
              scatterTouchData: ScatterTouchData(
                enabled: true,
                handleBuiltInTouches: false,
                mouseCursorResolver:
                    (FlTouchEvent touchEvent, ScatterTouchResponse? response) {
                  return response == null || response.touchedSpot == null
                      ? MouseCursor.defer
                      : SystemMouseCursors.click;
                },
                touchTooltipData: ScatterTouchTooltipData(
                  tooltipBgColor: Colors.black,
                  getTooltipItems: (ScatterSpot touchedBarSpot) {
                    return ScatterTooltipItem(
                      'X: ',
                      textStyle: TextStyle(
                        height: 1.2,
                        color: Colors.grey[100],
                        fontStyle: FontStyle.italic,
                      ),
                      bottomMargin: 10,
                      children: [
                        TextSpan(
                          text: '${touchedBarSpot.x.toInt()} \n',
                          style: const TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'Y: ',
                          style: TextStyle(
                            height: 1.2,
                            color: Colors.grey[100],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        TextSpan(
                          text: touchedBarSpot.y.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                touchCallback:
                    (FlTouchEvent event, ScatterTouchResponse? touchResponse) {
                  if (touchResponse == null ||
                      touchResponse.touchedSpot == null) {
                    return;
                  }
                  if (event is FlTapUpEvent) {
                    final sectionIndex = touchResponse.touchedSpot!.spotIndex;
                    setState(() {
                      if (selectedSpots.contains(sectionIndex)) {
                        selectedSpots.remove(sectionIndex);
                      } else {
                        selectedSpots.add(sectionIndex);
                      }
                    });
                  }
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton(
                value: _currentPaintType,
                items: PainterType.values
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name),
                        ))
                    .toList(),
                onChanged: (PainterType? value) {
                  setState(() {
                    _currentPaintType = value!;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum PainterType {
  circle,
  square,
  cross,
}
