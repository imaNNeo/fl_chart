import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../hosts.dart';
import '../theme.dart';

/// The hosts of the gauge chart classes.
final gaugeHosts = <String, Host>{
  'GaugeChartData': Host(
    instance: sampleGaugeChart,
    build: (data) => GaugeChart(data as GaugeChartData),
  ),
  'GaugeProgressRing': Host(
    instance: () => sampleRings().first as GaugeProgressRing,
    build: (ring) =>
        GaugeChart(sampleGaugeChart(rings: [ring as GaugeProgressRing])),
    note: 'The inner ring, alone.',
  ),
  'GaugeZonesRing': Host(
    instance: () => sampleRings().last as GaugeZonesRing,
    build: (ring) =>
        GaugeChart(sampleGaugeChart(rings: [ring as GaugeZonesRing])),
    note: 'The outer ring, alone.',
  ),
  'GaugeZone': Host(
    instance: () => sampleZones().first,
    build: (zone) => GaugeChart(
      sampleGaugeChart(
        rings: [
          GaugeZonesRing(
            width: 22,
            zones: [...sampleZones()]..[0] = zone as GaugeZone,
          ),
        ],
      ),
    ),
    note: 'The first (green) zone of a single zones ring.',
  ),
  'GaugeTicks': Host(
    instance: () => GaugeTicks(
      count: 6,
      labelBuilder: (value) => value.toStringAsFixed(0),
      labelStyle: const TextStyle(color: AppColors.muted, fontSize: 11),
      painter: const GaugeTickLinePainter(color: AppColors.muted),
    ),
    build: (ticks) => GaugeChart(sampleGaugeChart(ticks: ticks as GaugeTicks)),
  ),
  'GaugePointer': Host(
    instance: () => const GaugePointer(
      value: 72,
      painter: GaugePointerNeedlePainter(color: AppColors.primary),
    ),
    build: (pointer) =>
        GaugeChart(sampleGaugeChart(pointers: [pointer as GaugePointer])),
  ),
  'GaugeMarker': Host(
    instance: () => const GaugeMarker(
      value: 80,
      painter: GaugeMarkerLinePainter(
        color: Colors.white,
        length: 26,
        label: 'target',
        labelStyle: TextStyle(color: AppColors.muted, fontSize: 11),
      ),
    ),
    build: (marker) =>
        GaugeChart(sampleGaugeChart(markers: [marker as GaugeMarker])),
  ),
  'GaugeTouchData': Host(
    instance: GaugeTouchData.new,
    build: (touch) =>
        GaugeChart(sampleGaugeChart(touchData: touch as GaugeTouchData)),
    note: 'Hover or touch the rings.',
  ),
};

List<GaugeZone> sampleZones() => const [
  GaugeZone(from: 0, to: 45, color: Color(0xFF4CD964)),
  GaugeZone(from: 45, to: 80, color: Colors.amber),
  GaugeZone(from: 80, to: 100, color: Color(0xFFFF6B6B)),
];

List<GaugeRing> sampleRings() => [
  GaugeProgressRing(
    value: 72,
    color: AppColors.primary,
    backgroundColor: AppColors.primary.withValues(alpha: 0.15),
    strokeCap: StrokeCap.round,
  ),
  GaugeZonesRing(zones: sampleZones()),
];

/// The chart the gauge demos live in, styled like the website.
GaugeChartData sampleGaugeChart({
  List<GaugeRing>? rings,
  GaugeTicks? ticks,
  List<GaugePointer> pointers = const [],
  List<GaugeMarker> markers = const [],
  GaugeTouchData? touchData,
}) => GaugeChartData(
  rings: rings ?? sampleRings(),
  minValue: 0,
  maxValue: 100,
  defaultRingWidth: 22,
  ringsSpace: 6,
  ticks: ticks,
  pointers: pointers,
  markers: markers,
  touchData: touchData,
);
