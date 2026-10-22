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

  static const _blueDotPattern = DotPattern(
    color: Color(0x59ffffff), // white at ~35% opacity
    spacing: 8,
    dotRadius: 1.5,
  );

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final radius = 56.0;
      final fontSize = isTouched ? 18.0 : 14.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      // Even indices (0, 2): blue section with dots + purple segment
      // Odd indices  (1, 3): purple section + blue segment with dots
      final isBlueSection = i.isEven;

      return PieChartSectionData(
        color: isBlueSection
            ? AppColors.contentColorBlue
            : AppColors.contentColorPurple,
        value: 20,
        title: '20%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: AppColors.contentColorWhite,
          shadows: shadows,
        ),
        pattern: isBlueSection ? _blueDotPattern : const DotPattern.disabled(),
        segments: [
          PieChartStackSegmentData(
            fromRadius: radius * 0.6,
            toRadius: radius,
            // Fully opaque so section dots don't bleed through
            color: isBlueSection
                ? AppColors.contentColorPurple
                : AppColors.contentColorBlue,
            pattern:
                isBlueSection ? const DotPattern.disabled() : _blueDotPattern,
          ),
        ],
      );
    });
  }
}
