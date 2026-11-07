// CPU benchmarks: build, layout and paint time per frame, plus how often the
// charts repaint and how many widgets rebuild.
//
// Run from benchmark/:
//   flutter test test/cpu_benchmark_test.dart --dart-define=BENCH_LABEL=main
// Then compare two runs:
//   dart run tool/compare.dart results/main.json results/my-branch.json
//
// More options, each a --dart-define:
//   BENCH_ONLY=line_hover,pie_hover  runs only those scenarios
//   BENCH_FRAMES=400                 timed frames per round
//   BENCH_ROUNDS=3                   rounds per scenario, the fastest is kept
import 'package:fl_chart_benchmark/fl_chart_benchmark.dart';
import 'package:flutter_test/flutter_test.dart';

const _label = String.fromEnvironment('BENCH_LABEL', defaultValue: 'local');
const _only = String.fromEnvironment('BENCH_ONLY');
const _frames = int.fromEnvironment('BENCH_FRAMES', defaultValue: 400);
const _rounds = int.fromEnvironment('BENCH_ROUNDS', defaultValue: 3);

void main() {
  final results = <ScenarioResult>[];
  final only = _only.isEmpty ? null : _only.split(',').toSet();

  for (final scenario in createScenarios()) {
    if (only != null && !only.contains(scenario.name)) continue;
    testWidgets(scenario.name, (tester) async {
      results.add(
        await runScenario(
          tester,
          () => createScenario(scenario.name),
          frames: _frames,
          rounds: _rounds,
        ),
      );
    });
  }

  tearDownAll(() => writeResults(_label, results));
}
