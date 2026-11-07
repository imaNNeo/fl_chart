# fl_chart benchmarks

Before/after performance numbers for changes to `lib/`. The package depends on
fl_chart by path (`../`), so it always measures the fl_chart code that is
checked out.

There are three suites, each one measures a different thing:

| Suite | Runs on | Measures |
| --- | --- | --- |
| CPU (`test/cpu_benchmark_test.dart`) | `flutter test`, any machine | Per frame: wall time, build/layout/paint time, how often the chart repaints, how many widgets rebuild |
| Painter (`test/painter_benchmark_test.dart`) | `flutter test`, any machine | Each chart's painter called directly: time to record one paint, and time to rasterize it (software renderer) |
| Device (`integration_test/frame_timing_test.dart`) | `flutter drive --profile` on macOS, Linux, a phone | Real UI and raster thread frame times, the numbers DevTools shows |

The scenarios (`lib/src/scenarios.dart`) are the same in the CPU and device
suites: hovering a line, bar, scatter and pie chart with a mouse, an implicit
animation, a parent that rebuilds with the same data, and panning zoomed line
and candlestick charts.

## Before/after in four commands

From the repo root:

```bash
git checkout main
make benchmark label=main
git checkout my-branch
make benchmark label=my-branch
make benchmarkCompare before=main after=my-branch
```

Results go to `benchmark/results/` (git-ignored, so they survive the
checkouts). `benchmarkCompare` prints Markdown tables, ready to paste in a PR.

For real frame times, run the device suite the same way:

```bash
make benchmarkDevice label=main            # device=macos by default
make benchmarkDevice label=my-branch
cd benchmark && dart run tool/compare.dart results/main.device.json results/my-branch.device.json
```

## Reading the numbers

- The CPU and painter suites run in debug mode (that is how `flutter test`
  runs), so the absolute times are higher than in a release build. Compare runs
  on the same machine with each other, not with a 16 ms budget.
- Each scenario runs 3 rounds and keeps the fastest. Timings still move by about
  15% between runs on a busy machine. Treat smaller changes as noise, or run
  again with `BENCH_ROUNDS=5`.
- The counts (chart paints per frame, rebuilds per frame) don't depend on the
  machine. They show directly whether a change skips work.
- The painter suite's raster time comes from the software renderer of
  `flutter test`. It shows how much there is to draw, but GPU-only costs, such
  as offscreen layers (`saveLayer`), only show in the device suite.

## Options

Pass these to the `flutter test` suites as `--dart-define=NAME=value`, and to
the device suite as `--dart-define` too (except `BENCH_LABEL`, which the device
driver reads from the environment):

| Option | Default | |
| --- | --- | --- |
| `BENCH_LABEL` | `local` | Name of the results file |
| `BENCH_ONLY` | all | Comma-separated scenario names |
| `BENCH_FRAMES` | 400 | Timed frames per round (CPU and device suites) |
| `BENCH_ROUNDS` | 3 | Rounds per scenario, the fastest is kept |

## Adding a scenario

Add a `Scenario` subclass to `lib/src/scenarios.dart` and list it in
`createScenarios()`. Keep the names stable: they are the keys of the results
files. `flutter run` in this folder shows every scenario's chart in a tab, to
profile it by hand in DevTools.
