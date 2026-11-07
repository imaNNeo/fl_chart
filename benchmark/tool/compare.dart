// Compares two benchmark results files and prints a Markdown table.
//
//   dart run tool/compare.dart results/main.json results/my-branch.json
//   dart run tool/compare.dart --all results/main.json results/my-branch.json
//
// Works with the CPU and painter results (test/) and the device results
// (integration_test/). Lower is better for every metric.
import 'dart:convert';
import 'dart:io';

const _cpuMetrics = {
  'frame_ms_median': 'Frame (median ms)',
  'paint_ms_per_frame': 'Paint ms/frame',
  'build_ms_per_frame': 'Build ms/frame',
  'chart_paints_per_frame': 'Chart paints/frame',
  'rebuilds_per_frame': 'Rebuilds/frame',
};

const _painterMetrics = {
  'paint_ms_median': 'Paint (median ms)',
  'raster_ms_median': 'Raster (median ms)',
};

const _deviceMetrics = {
  'average_frame_build_time_millis': 'UI thread (avg ms)',
  '90th_percentile_frame_build_time_millis': 'UI thread (p90 ms)',
  'average_frame_rasterizer_time_millis': 'Raster thread (avg ms)',
  '90th_percentile_frame_rasterizer_time_millis': 'Raster thread (p90 ms)',
};

void main(List<String> args) {
  final all = args.contains('--all');
  final files = args.where((a) => !a.startsWith('--')).toList();
  if (files.length != 2) {
    stderr.writeln(
      'Usage: dart run tool/compare.dart [--all] <before.json> <after.json>',
    );
    exit(64);
  }
  final before = _load(files[0]);
  final after = _load(files[1]);
  final beforeScenarios = before['scenarios'] as Map<String, dynamic>;
  final afterScenarios = after['scenarios'] as Map<String, dynamic>;

  final metrics = <String, String>{
    ...switch (before['kind']) {
      'device' => _deviceMetrics,
      'painter' => _painterMetrics,
      _ => _cpuMetrics,
    },
  };
  if (all) {
    for (final scenario in beforeScenarios.values) {
      for (final entry in (scenario as Map<String, dynamic>).entries) {
        if (entry.value is num) metrics.putIfAbsent(entry.key, () => entry.key);
      }
    }
  }

  stdout
    ..writeln('Before: `${before['label']}`, after: `${after['label']}`.')
    ..writeln()
    ..writeln('| Scenario | ${metrics.values.join(' | ')} |')
    ..writeln('| --- |${' --- |' * metrics.length}');

  for (final name in beforeScenarios.keys) {
    final b = beforeScenarios[name] as Map<String, dynamic>;
    final a = afterScenarios[name] as Map<String, dynamic>?;
    if (a == null) continue;
    final cells = metrics.keys.map((key) => _cell(b[key], a[key]));
    stdout.writeln('| $name | ${cells.join(' | ')} |');
  }
}

Map<String, dynamic> _load(String path) =>
    jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;

String _cell(Object? before, Object? after) {
  if (before is! num || after is! num) return '';
  final b = before.toDouble();
  final a = after.toDouble();
  final change = b == 0 ? (a == 0 ? 0.0 : double.infinity) : (a - b) / b * 100;
  final sign = change > 0 ? '+' : '';
  final percent = change.isFinite
      ? '$sign${change.toStringAsFixed(0)}%'
      : 'new';
  return '${_format(b)} → ${_format(a)} ($percent)';
}

String _format(double value) =>
    value >= 100 ? value.toStringAsFixed(0) : value.toStringAsFixed(2);
