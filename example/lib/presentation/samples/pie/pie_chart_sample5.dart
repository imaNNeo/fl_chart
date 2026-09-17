import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/presentation/resources/app_colors.dart';
import 'package:flutter/material.dart';

class PieChartSample5 extends StatefulWidget {
  const PieChartSample5({super.key});

  @override
  State<PieChartSample5> createState() => _PieChartSample5State();
}

class _PieChartSample5State extends State<PieChartSample5> {
  int touchedIndex = -1;

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
            borderData: FlBorderData(show: false),
            sectionsSpace: 3,
            centerSpaceRadius: 24,
            sections: showingSections(),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final radius = 56.0;
      final radialOffset = isTouched ? 12.0 : 0.0;
      final fontSize = isTouched ? 18.0 : 14.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return switch (i) {
        0 => PieChartSectionData(
            color: AppColors.contentColorBlue,
            value: 40,
            title: '40%',
            radius: radius,
            radialOffset: radialOffset,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.contentColorWhite,
              shadows: shadows,
            ),
            segments: [
              PieChartStackSegmentData(
                fromRadius: 0,
                toRadius: radius,
                color: AppColors.contentColorBlue,
              ),
            ],
          ),
        1 => PieChartSectionData(
            color: AppColors.contentColorOrange,
            value: 30,
            title: '30%',
            radius: radius,
            radialOffset: radialOffset,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.contentColorWhite,
              shadows: shadows,
            ),
          ),
        2 => PieChartSectionData(
            color: AppColors.contentColorPurple,
            value: 20,
            title: '20%',
            radius: radius,
            radialOffset: radialOffset,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.contentColorWhite,
              shadows: shadows,
            ),
            segments: [
              PieChartStackSegmentData(
                fromRadius: 0,
                toRadius: radius,
                color: AppColors.contentColorPurple,
              ),
            ],
          ),
        3 => PieChartSectionData(
            color: AppColors.contentColorGreen,
            value: 10,
            title: '10%',
            radius: radius,
            radialOffset: radialOffset,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.contentColorWhite,
              shadows: shadows,
            ),
          ),
        _ => throw StateError('Invalid'),
      };
    });
  }
}
