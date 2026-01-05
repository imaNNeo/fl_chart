import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/presentation/resources/app_colors.dart';
import 'package:flutter/material.dart';

class PieChartSample4 extends StatefulWidget {
  const PieChartSample4({super.key});

  @override
  State<PieChartSample4> createState() => _PieChartSample4State();
}

class _PieChartSample4State extends State<PieChartSample4> {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              },
            ),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 2,
            centerSpaceRadius: 0,
            sections: showingSections(),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      final value = 90.0;
      final scaleFactor = isTouched ? 1.05 : 1.0;

      return switch (i) {
        0 => PieChartSectionData(
            color: AppColors.contentColorGreen,
            value: value,
            title: 'A',
            radius: 30 * scaleFactor,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            titlePositionPercentageOffset: 0.75,
            segments: [
              PieChartStackSegmentData(
                radius: 70 * scaleFactor,
                color: AppColors.contentColorRed,
              )
            ],
            segmentsSpace: 2,
          ),
        1 => PieChartSectionData(
            color: AppColors.contentColorGreen,
            value: value,
            title: 'B',
            radius: 65 * scaleFactor,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            titlePositionPercentageOffset: 0.75,
            segments: [
              PieChartStackSegmentData(
                radius: 35 * scaleFactor,
                color: AppColors.contentColorRed,
              )
            ],
            segmentsSpace: 2,
          ),
        2 => PieChartSectionData(
            color: AppColors.contentColorGreen,
            value: value,
            title: 'C',
            radius: 50 * scaleFactor,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            titlePositionPercentageOffset: 0.75,
            segments: [
              PieChartStackSegmentData(
                radius: 50 * scaleFactor,
                color: AppColors.contentColorRed,
              )
            ],
            segmentsSpace: 2,
          ),
        3 => PieChartSectionData(
            color: AppColors.contentColorGreen,
            value: value,
            title: 'D',
            radius: 90 * scaleFactor,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            titlePositionPercentageOffset: 0.75,
            segments: [
              PieChartStackSegmentData(
                radius: 10 * scaleFactor,
                color: AppColors.contentColorRed,
              )
            ],
            segmentsSpace: 2,
          ),
        4 => PieChartSectionData(
            color: AppColors.contentColorGreen,
            value: value,
            title: 'E',
            radius: 70 * scaleFactor,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            titlePositionPercentageOffset: 0.75,
            segments: [
              PieChartStackSegmentData(
                radius: 30 * scaleFactor,
                color: AppColors.contentColorRed,
              )
            ],
            segmentsSpace: 2,
          ),
        _ => throw StateError('Invalid'),
      };
    });
  }
}
