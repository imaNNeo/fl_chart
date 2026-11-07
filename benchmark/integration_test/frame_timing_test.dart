// Real frame times (UI and raster thread) on a device, in profile mode.
//
// Run from benchmark/:
//   BENCH_LABEL=main flutter drive --profile -d macos \
//     --driver=test_driver/perf_driver.dart \
//     --target=integration_test/frame_timing_test.dart
// It writes results/<label>.device.json. Compare two runs with
//   dart run tool/compare.dart results/main.device.json results/my-branch.device.json
import 'package:fl_chart_benchmark/fl_chart_benchmark.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

const _only = String.fromEnvironment('BENCH_ONLY');
const _frames = int.fromEnvironment('BENCH_FRAMES', defaultValue: 400);

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final only = _only.isEmpty ? null : _only.split(',').toSet();

  for (final scenario in createScenarios()) {
    if (only != null && !only.contains(scenario.name)) continue;
    testWidgets(scenario.name, (tester) async {
      await tester.pumpWidget(hostScenario(scenario));
      await scenario.setUp(tester);
      await tester.pumpAndSettle();

      const frameInterval = Duration(milliseconds: 16);
      for (var i = 0; i < 60; i++) {
        await scenario.step(tester, i);
        await tester.pump(frameInterval);
      }

      await binding.watchPerformance(() async {
        for (var i = 0; i < _frames; i++) {
          await scenario.step(tester, 60 + i);
          await tester.pump(frameInterval);
        }
      }, reportKey: scenario.name);

      await scenario.tearDown(tester);
    });
  }
}
