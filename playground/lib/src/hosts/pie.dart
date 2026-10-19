import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../hosts.dart';
import '../theme.dart';

/// The hosts of the pie chart classes.
final pieHosts = <String, Host>{
  'PieChartData': Host(
    instance: samplePieChart,
    build: (data) => PieChart(data as PieChartData),
    note: 'Hover or touch the sections.',
  ),
  'PieChartSectionData': Host(
    instance: () => sampleSections().first,
    build: (section) => PieChart(
      samplePieChart(
        sections: [...sampleSections()]..[0] = section as PieChartSectionData,
      ),
    ),
    note: 'The section A.',
  ),
  'PieChartStackSegmentData': Host(
    instance: () => PieChartStackSegmentData(
      fromRadius: 40,
      toRadius: 60,
      color: Colors.white30,
    ),
    build: (segment) => PieChart(
      samplePieChart(
        sections: [
          for (final section in sampleSections())
            section.copyWith(segments: [segment as PieChartStackSegmentData]),
        ],
      ),
    ),
    note: 'A segment of every section.',
  ),
  'PieTouchData': Host(
    instance: PieTouchData.new,
    build: (touch) =>
        PieChart(samplePieChart(pieTouchData: touch as PieTouchData)),
    note: 'Hover or touch the sections.',
  ),
};

List<PieChartSectionData> sampleSections() => [
  for (final (title, value, color) in [
    ('A', 35.0, AppColors.primary),
    ('B', 25.0, AppColors.secondary),
    ('C', 22.0, Colors.amber),
    ('D', 18.0, Colors.pinkAccent),
  ])
    PieChartSectionData(
      value: value,
      title: title,
      color: color,
      radius: 60,
      titleStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
];

/// The chart the pie demos live in.
PieChartData samplePieChart({
  List<PieChartSectionData>? sections,
  PieTouchData? pieTouchData,
}) => PieChartData(
  sections: sections ?? sampleSections(),
  centerSpaceRadius: 40,
  pieTouchData: pieTouchData,
);
