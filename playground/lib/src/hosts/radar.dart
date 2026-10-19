import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../hosts.dart';
import '../theme.dart';

/// The hosts of the radar chart classes.
final radarHosts = <String, Host>{
  'RadarChartData': Host(
    instance: sampleRadarChart,
    build: (data) => RadarChart(data as RadarChartData),
    note: 'Hover or touch the entries.',
  ),
  'RadarDataSet': Host(
    instance: () => sampleDataSets().first,
    build: (dataSet) => RadarChart(
      sampleRadarChart(
        dataSets: [...sampleDataSets()]..[0] = dataSet as RadarDataSet,
      ),
    ),
    note: 'The cyan data set.',
  ),
  'RadarEntry': Host(
    instance: () => const RadarEntry(value: 5),
    build: (entry) {
      final [first, second] = sampleDataSets();
      return RadarChart(
        sampleRadarChart(
          dataSets: [
            first.copyWith(
              dataEntries: [...first.dataEntries]..[2] = entry as RadarEntry,
            ),
            second,
          ],
        ),
      );
    },
    note: 'The "Range" entry of the cyan data set.',
  ),
  'RadarTouchData': Host(
    instance: RadarTouchData.new,
    build: (touch) =>
        RadarChart(sampleRadarChart(radarTouchData: touch as RadarTouchData)),
    note: 'Hover or touch the entries.',
  ),
  'RadarChartTitle': Host(
    instance: () => const RadarChartTitle(text: 'Speed'),
    build: (title) => RadarChart(
      sampleRadarChart(
        getTitle: (index, angle) => index == 0
            ? title as RadarChartTitle
            : RadarChartTitle(text: _titles[index]),
      ),
    ),
    note: 'The title of the "Speed" axis.',
  ),
};

const _titles = ['Speed', 'Power', 'Range', 'Cost', 'Comfort', 'Safety'];

List<RadarDataSet> sampleDataSets() => [
  for (final (values, color) in [
    ([4.0, 3.0, 5.0, 2.0, 4.0, 3.0], AppColors.primary),
    ([3.0, 5.0, 2.0, 4.0, 2.0, 5.0], AppColors.secondary),
  ])
    RadarDataSet(
      dataEntries: [for (final value in values) RadarEntry(value: value)],
      fillColor: color.withValues(alpha: 0.25),
      borderColor: color,
      entryRadius: 3,
    ),
];

/// The chart the radar demos live in, styled like the website.
RadarChartData sampleRadarChart({
  List<RadarDataSet>? dataSets,
  RadarTouchData? radarTouchData,
  GetTitleByIndexFunction? getTitle,
}) => RadarChartData(
  dataSets: dataSets ?? sampleDataSets(),
  radarTouchData: radarTouchData,
  radarBorderData: const BorderSide(color: Colors.white24),
  gridBorderData: const BorderSide(color: Colors.white24),
  tickBorderData: const BorderSide(color: Colors.white10),
  tickCount: 3,
  ticksTextStyle: const TextStyle(color: AppColors.muted, fontSize: 10),
  titleTextStyle: const TextStyle(color: Colors.white, fontSize: 12),
  getTitle: getTitle ?? (index, angle) => RadarChartTitle(text: _titles[index]),
);
