import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:flutter/material.dart';

class RadarChartSample2 extends StatefulWidget {
  const RadarChartSample2({super.key});

  final List<SubjectScore> scores = const [
    SubjectScore(subject: 'Social Studies', value: 80),
    SubjectScore(subject: 'Math', value: 75),
    SubjectScore(subject: 'English', value: 70),
    SubjectScore(subject: 'Science', value: 65),
    SubjectScore(subject: 'Art', value: 60),
  ];

  final double _maxPoint = 100;

  @override
  State<RadarChartSample2> createState() => _RadarChartSample2State();
}

class _RadarChartSample2State extends State<RadarChartSample2> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: RadarChart(
        RadarChartDataExtended(
          dataSets: [
            RadarDataSet(
              dataEntries: widget.scores
                  .map((score) => RadarEntry(value: score.value))
                  .toList(),
            ),
            RadarDataSet(
              dataEntries: List.generate(
                widget.scores.length,
                (index) => RadarEntry(value: widget._maxPoint),
              ),
              fillColor: Colors.transparent,
              borderColor: Colors.transparent,
            ),
          ],
          radarBackgroundColor: Colors.transparent,
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: AppColors.borderColor),
          ),
          radarBorderData: const BorderSide(
            color: AppColors.borderColor,
          ),
          getTitle: (index, angle) {
            return RadarChartTitle(
              text: widget.scores[index].subject,
              positionPercentageOffset: 0.1,
            );
          },
          getVerticeLabel: (index) {
            return RadarChartVerticeLabel(
              text: widget.scores[index].value.toInt().toString(),
              positionPercentageOffset: 0,
            );
          },
          titlePositionPercentageOffset: 0.5,
          verticeLabelTextStyle: const TextStyle(
            color: AppColors.primary,
          ),
          tickBorderData: const BorderSide(
            color: AppColors.mainGridLineColor,
          ),
          gridBorderData: const BorderSide(
            color: AppColors.mainGridLineColor,
          ),
          tickCount: 4,
          ticksTextStyle: const TextStyle(
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}

class RadarChartDataExtended extends RadarChartData {
  RadarChartDataExtended({
    required List<RadarDataSet> super.dataSets,
    super.radarBackgroundColor,
    super.borderData,
    super.radarBorderData,
    super.getTitle,
    super.getVerticeLabel,
    super.titleTextStyle,
    super.titlePositionPercentageOffset,
    super.verticeLabelTextStyle,
    super.tickBorderData,
    super.gridBorderData,
    super.tickCount,
    super.ticksTextStyle,
  });

  @override
  RadarEntry get minEntry => super.maxEntry;
}

class SubjectScore {
  const SubjectScore({
    required this.subject,
    required this.value,
  });

  final String subject;
  final double value;
}
