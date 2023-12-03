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

  List<int> selectedSpots = [];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ScatterChart(
        ScatterChartData(
          scatterSpots: [
            ScatterSpot(
              4,
              4,
              dotPainter: FlDotCirclePainter(
                color: selectedSpots.contains(0)
                    ? AppColors.contentColorGreen
                    : AppColors.contentColorWhite.withOpacity(0.5),
              ),
            ),
            ScatterSpot(
              2,
              5,
              dotPainter: FlDotCirclePainter(
                color: selectedSpots.contains(1)
                    ? AppColors.contentColorYellow
                    : AppColors.contentColorWhite.withOpacity(0.5),
                radius: 12,
              ),
            ),
            ScatterSpot(
              4,
              5,
              dotPainter: FlDotCirclePainter(
                color: selectedSpots.contains(2)
                    ? AppColors.contentColorPink
                    : AppColors.contentColorWhite.withOpacity(0.5),
                radius: 8,
              ),
            ),
            ScatterSpot(
              8,
              6,
              dotPainter: FlDotCirclePainter(
                color: selectedSpots.contains(3)
                    ? AppColors.contentColorOrange
                    : AppColors.contentColorWhite.withOpacity(0.5),
                radius: 20,
              ),
            ),
            ScatterSpot(
              5,
              7,
              dotPainter: FlDotCirclePainter(
                color: selectedSpots.contains(4)
                    ? AppColors.contentColorPurple
                    : AppColors.contentColorWhite.withOpacity(0.5),
                radius: 14,
              ),
            ),
            ScatterSpot(
              7,
              2,
              dotPainter: FlDotCirclePainter(
                color: selectedSpots.contains(5)
                    ? AppColors.contentColorBlue
                    : AppColors.contentColorWhite.withOpacity(0.5),
                radius: 18,
              ),
            ),
            ScatterSpot(
              3,
              2,
              dotPainter: FlDotCirclePainter(
                color: selectedSpots.contains(6)
                    ? AppColors.contentColorRed
                    : AppColors.contentColorWhite.withOpacity(0.5),
                radius: 36,
              ),
            ),
            ScatterSpot(
              2,
              8,
              dotPainter: FlDotCirclePainter(
                color: selectedSpots.contains(7)
                    ? AppColors.contentColorCyan
                    : AppColors.contentColorWhite.withOpacity(0.5),
                radius: 22,
              ),
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
              if (touchResponse == null || touchResponse.touchedSpot == null) {
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
    );
  }
}
