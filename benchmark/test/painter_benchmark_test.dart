// Painter benchmarks: each chart's painter called directly, timing the paint
// (recording a picture) and the raster of that picture.
//
// Run from benchmark/:
//   flutter test test/painter_benchmark_test.dart --dart-define=BENCH_LABEL=main
// Then compare two runs:
//   dart run tool/compare.dart results/main.painters.json results/my-branch.painters.json
//
// BENCH_ONLY=line_paint,pie_paint runs only those cases.
import 'package:fl_chart_benchmark/fl_chart_benchmark.dart';
import 'package:flutter_test/flutter_test.dart';

const _label = String.fromEnvironment('BENCH_LABEL', defaultValue: 'local');
const _only = String.fromEnvironment('BENCH_ONLY');
const _rounds = int.fromEnvironment('BENCH_ROUNDS', defaultValue: 3);

void main() {
  final results = <PainterResult>[];
  final only = _only.isEmpty ? null : _only.split(',').toSet();

  for (final paintCase in createPainterCases()) {
    if (only != null && !only.contains(paintCase.name)) continue;
    testWidgets(paintCase.name, (tester) async {
      results.add(await runPainterCase(tester, paintCase, rounds: _rounds));
    });
  }

  tearDownAll(() => writePainterResults(_label, results));
}
