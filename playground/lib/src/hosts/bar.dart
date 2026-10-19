import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../hosts.dart';
import '../theme.dart';

/// The hosts of the bar chart classes.
final barHosts = <String, Host>{
  'BarChartData': Host(
    instance: sampleBarChart,
    build: (data) => BarChart(data as BarChartData),
    note: 'Hover or touch the bars to see their tooltips.',
  ),
  'BarChartGroupData': Host(
    instance: () => BarChartGroupData(
      x: 2,
      barsSpace: 4,
      barRods: [
        sampleRod(5.6),
        sampleRod(3.2, color: AppColors.secondary),
      ],
    ),
    build: (group) => _chart(groups: _withGroup(group as BarChartGroupData)),
    note: 'The third group of the chart.',
  ),
  'BarChartRodData': Host(
    instance: () => sampleRod(5.6),
    build: (rod) => _chart(
      groups: _withGroup(
        BarChartGroupData(x: 2, barRods: [rod as BarChartRodData]),
      ),
    ),
    note: 'The rod of the third group.',
  ),
  'BackgroundBarChartRodData': Host(
    instance: () =>
        BackgroundBarChartRodData(show: true, toY: 7, color: Colors.white10),
    build: (background) => _chart(
      groups: [
        for (final group in sampleGroups())
          group.copyWith(
            barRods: [
              for (final rod in group.barRods)
                rod.copyWith(
                  backDrawRodData: background as BackgroundBarChartRodData,
                ),
            ],
          ),
      ],
    ),
  ),
  'BarChartRodStackItem': Host(
    instance: () => BarChartRodStackItem(0, 3, AppColors.primary),
    build: (item) => _chart(
      groups: _withGroup(
        BarChartGroupData(
          x: 2,
          barRods: [
            sampleRod(6).copyWith(
              rodStackItems: [
                item as BarChartRodStackItem,
                BarChartRodStackItem(3, 6, AppColors.secondary),
              ],
            ),
          ],
        ),
      ),
    ),
    note: 'The first item of the stacked rod of the third group.',
  ),
  'BarChartRodLabel': Host(
    instance: () => const BarChartRodLabel(text: 'Best'),
    build: (label) => _chart(groups: _withLabel(label as BarChartRodLabel)),
    note: 'The label of the highest rod.',
  ),
  'FlLabel': Host(
    instance: () => const FlLabel(text: 'Best'),
    build: (label) {
      label as FlLabel;
      return _chart(
        groups: _withLabel(
          BarChartRodLabel(
            show: label.show,
            text: label.text,
            style: label.style,
            angle: label.angle,
            textDirection: label.textDirection,
          ),
        ),
      );
    },
    note: 'Shown as the label of a rod (a BarChartRodLabel).',
  ),
  'BarTouchData': Host(
    instance: () => const BarTouchData(),
    build: (touch) => BarChart(
      sampleBarChart().copyWith(barTouchData: touch as BarTouchData),
    ),
    note: 'Hover or touch the bars.',
  ),
  'BarTouchTooltipData': Host(
    instance: () => BarTouchTooltipData(),
    build: (tooltip) => _chart(
      groups: _withTooltip(),
      barTouchData: BarTouchData(
        handleBuiltInTouches: false,
        touchTooltipData: tooltip as BarTouchTooltipData,
      ),
    ),
  ),
  'BarTooltipItem': Host(
    instance: () => BarTooltipItem(
      'Friday\n6.1',
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    build: (item) => _chart(
      groups: _withTooltip(),
      barTouchData: BarTouchData(
        handleBuiltInTouches: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) =>
              item as BarTooltipItem,
        ),
      ),
    ),
  ),
};

const _values = [4.2, 2.8, 5.6, 3.4, 6.1, 4.8, 3.9];

BarChartRodData sampleRod(double toY, {Color color = AppColors.primary}) =>
    BarChartRodData(
      toY: toY,
      color: color,
      width: 16,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
    );

List<BarChartGroupData> sampleGroups() => [
  for (final (index, value) in _values.indexed)
    BarChartGroupData(x: index, barRods: [sampleRod(value)]),
];

/// The chart the bar demos live in, styled like the website.
BarChartData sampleBarChart({
  List<BarChartGroupData>? groups,
  BarTouchData barTouchData = const BarTouchData(),
}) => BarChartData(
  barGroups: groups ?? sampleGroups(),
  barTouchData: barTouchData,
  maxY: 7,
  gridData: FlGridData(
    drawVerticalLine: false,
    horizontalInterval: 1,
    getDrawingHorizontalLine: (_) =>
        const FlLine(color: AppColors.border, strokeWidth: 1),
  ),
  borderData: FlBorderData(show: false),
  titlesData: const FlTitlesData(
    topTitles: AxisTitles(),
    rightTitles: AxisTitles(),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: true, reservedSize: 28, interval: 1),
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: true, reservedSize: 24),
    ),
  ),
);

List<BarChartGroupData> _withGroup(BarChartGroupData group) =>
    [...sampleGroups()]..[2] = group;

List<BarChartGroupData> _withLabel(BarChartRodLabel label) => [
  for (final group in sampleGroups())
    group.x == 4
        ? group.copyWith(barRods: [group.barRods.first.copyWith(label: label)])
        : group,
];

List<BarChartGroupData> _withTooltip() => [
  for (final group in sampleGroups())
    group.x == 4 ? group.copyWith(showingTooltipIndicators: [0]) : group,
];

Widget _chart({
  required List<BarChartGroupData> groups,
  BarTouchData barTouchData = const BarTouchData(handleBuiltInTouches: false),
}) => BarChart(sampleBarChart(groups: groups, barTouchData: barTouchData));
