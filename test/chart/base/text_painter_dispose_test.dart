import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_renderer.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_renderer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _CreatedTextPainter {
  _CreatedTextPainter(this.text, this.stack);

  final String? text;
  final String stack;

  String get site => stack.split('\n').firstWhere(
        (frame) => frame.contains('package:fl_chart/'),
        orElse: () => '<no fl_chart frame>',
      );

  @override
  String toString() => '"$text" created at $site';
}

/// Records every [TextPainter] created while a test runs, through the
/// [FlutterMemoryAllocations] events that [TextPainter] dispatches in debug
/// mode, and forgets each one once it is disposed.
class _TextPainterTracker {
  final created = <_CreatedTextPainter>[];
  final undisposed = Map<Object, _CreatedTextPainter>.identity();

  void onEvent(ObjectEvent event) {
    if (event is ObjectCreated && event.className == 'TextPainter') {
      final record = _CreatedTextPainter(
        (event.object as TextPainter).text?.toPlainText(),
        StackTrace.current.toString(),
      );
      created.add(record);
      undisposed[event.object] = record;
    } else if (event is ObjectDisposed) {
      undisposed.remove(event.object);
    }
  }

  void expectCreatedIn(String frame, {String? text}) {
    expect(
      created.any(
        (record) =>
            record.stack.contains(frame) &&
            (text == null || record.text == text),
      ),
      isTrue,
      reason: 'expected a TextPainter${text == null ? '' : ' "$text"'} '
          'created in $frame, got: $created',
    );
  }

  void expectAllDisposed() {
    final leaked = undisposed.values.toList();
    expect(
      leaked,
      isEmpty,
      reason: '${leaked.length} TextPainter(s) not disposed',
    );
  }
}

_TextPainterTracker _trackTextPainters() {
  final tracker = _TextPainterTracker();
  final listener = tracker.onEvent;
  FlutterMemoryAllocations.instance.addListener(listener);
  addTearDown(() => FlutterMemoryAllocations.instance.removeListener(listener));
  return tracker;
}

Widget _wrap(Widget child) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Center(
          child: SizedBox(width: 300, height: 300, child: child),
        ),
      ),
    );

Future<void> _pumpAndUnmount(WidgetTester tester, Widget chart) async {
  await tester.pumpWidget(_wrap(chart));
  await tester.pumpWidget(const SizedBox());
}

FlTransformationConfig _zoomedIn(
  TransformationController controller,
  FlScaleAxis scaleAxis,
) {
  controller.value = Matrix4.diagonal3Values(5, 5, 1);
  return FlTransformationConfig(
    scaleAxis: scaleAxis,
    maxScale: 10,
    transformationController: controller,
  );
}

LineChartData _lineData({
  required FlSpot tooltipSpot,
  GetLineTooltipColor getTooltipColor = defaultLineTooltipColor,
  bool showExtras = true,
}) {
  final bar = LineChartBarData(
    spots: [
      const FlSpot(
        0,
        1,
        yError: FlErrorRange(lowerBy: 0.5, upperBy: 0.5),
      ),
      const FlSpot(5, 4),
      tooltipSpot,
    ],
    errorIndicatorData: showExtras
        ? FlErrorIndicatorData(
            painter: (_) => FlSimpleErrorPainter(showErrorTexts: true),
          )
        : const FlErrorIndicatorData(show: false),
  );
  return LineChartData(
    minX: 0,
    maxX: 10,
    minY: 0,
    maxY: 5,
    lineBarsData: [bar],
    showingTooltipIndicators: [
      ShowingTooltipIndicators([LineBarSpot(bar, 0, tooltipSpot)]),
    ],
    extraLinesData: showExtras
        ? ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: 3,
                label: HorizontalLineLabel(
                  show: true,
                  labelResolver: (_) => 'h-line',
                ),
              ),
            ],
            verticalLines: [
              VerticalLine(
                x: 7,
                label: VerticalLineLabel(
                  show: true,
                  labelResolver: (_) => 'v-line',
                ),
              ),
            ],
          )
        : const ExtraLinesData(),
    lineTouchData: LineTouchData(
      handleBuiltInTouches: false,
      touchTooltipData: LineTouchTooltipData(
        getTooltipItems: (spots) => spots
            .map((_) => const LineTooltipItem('tt-line', TextStyle()))
            .toList(),
        getTooltipColor: getTooltipColor,
      ),
    ),
  );
}

BarTouchData _barTouchData({
  GetBarTooltipColor? getTooltipColor,
}) =>
    BarTouchData(
      handleBuiltInTouches: false,
      touchTooltipData: BarTouchTooltipData(
        getTooltipItem: (group, groupIndex, rod, rodIndex) =>
            BarTooltipItem('tt-bar', const TextStyle()),
        getTooltipColor: getTooltipColor,
      ),
    );

ScatterTouchData _scatterTouchData({
  GetScatterTooltipColor? getTooltipColor,
}) =>
    ScatterTouchData(
      handleBuiltInTouches: false,
      touchTooltipData: ScatterTouchTooltipData(
        getTooltipItems: (_) => ScatterTooltipItem('tt-scatter'),
        getTooltipColor: getTooltipColor,
      ),
    );

void main() {
  group('TextPainters created by the charts are disposed', () {
    testWidgets('control: a Text widget leaves nothing undisposed',
        (tester) async {
      final tracker = _trackTextPainters();

      await _pumpAndUnmount(tester, const Text('x'));

      tracker
        ..expectCreatedIn('', text: 'x')
        ..expectAllDisposed();
    });

    testWidgets('LineChart', (tester) async {
      final tracker = _trackTextPainters();

      await _pumpAndUnmount(
        tester,
        LineChart(_lineData(tooltipSpot: const FlSpot(10, 2))),
      );

      tracker
        ..expectCreatedIn('LineChartPainter.drawTouchTooltip', text: 'tt-line')
        ..expectCreatedIn(
          'AxisChartPainter.drawHorizontalLines',
          text: 'h-line',
        )
        ..expectCreatedIn('AxisChartPainter.drawVerticalLines', text: 'v-line')
        ..expectCreatedIn('FlSimpleErrorPainter._drawErrorText')
        ..expectAllDisposed();
    });

    testWidgets('BarChart', (tester) async {
      final tracker = _trackTextPainters();

      await _pumpAndUnmount(
        tester,
        BarChart(
          BarChartData(
            maxY: 10,
            barGroups: [
              BarChartGroupData(
                x: 0,
                showingTooltipIndicators: [0],
                barRods: [
                  BarChartRodData(
                    toY: 8,
                    width: 20,
                    label: const BarChartRodLabel(text: 'rod'),
                    rodStackItems: [
                      BarChartRodStackItem(0, 8, Colors.red, label: 'stack'),
                    ],
                  ),
                ],
              ),
            ],
            barTouchData: _barTouchData(),
          ),
        ),
      );

      tracker
        ..expectCreatedIn('BarChartPainter.drawBars', text: 'stack')
        ..expectCreatedIn('BarChartPainter.drawBarLabels', text: 'rod')
        ..expectCreatedIn('BarChartPainter.drawTouchTooltip', text: 'tt-bar')
        ..expectCreatedIn('BarChartPainter.drawTouchTooltip', text: 'rod')
        ..expectAllDisposed();
    });

    testWidgets('PieChart', (tester) async {
      final tracker = _trackTextPainters();

      await _pumpAndUnmount(
        tester,
        PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(value: 1, title: 'pie'),
              PieChartSectionData(value: 2, title: 'pie'),
            ],
          ),
        ),
      );

      tracker
        ..expectCreatedIn('PieChartPainter.drawTexts', text: 'pie')
        ..expectAllDisposed();
    });

    testWidgets('ScatterChart', (tester) async {
      final tracker = _trackTextPainters();

      await _pumpAndUnmount(
        tester,
        ScatterChart(
          ScatterChartData(
            minX: 0,
            maxX: 10,
            minY: 0,
            maxY: 10,
            scatterSpots: [ScatterSpot(5, 5)],
            showingTooltipIndicators: [0],
            scatterLabelSettings: ScatterLabelSettings(
              showLabel: true,
              getLabelFunction: (_, __) => 'spot',
            ),
            scatterTouchData: _scatterTouchData(),
          ),
        ),
      );

      tracker
        ..expectCreatedIn('ScatterChartPainter.drawSpots', text: 'spot')
        ..expectCreatedIn(
          'ScatterChartPainter.drawTouchTooltip',
          text: 'tt-scatter',
        )
        ..expectAllDisposed();
    });

    testWidgets('CandlestickChart', (tester) async {
      final tracker = _trackTextPainters();

      await _pumpAndUnmount(
        tester,
        CandlestickChart(
          CandlestickChartData(
            minX: 0,
            maxX: 10,
            minY: 0,
            maxY: 10,
            candlestickSpots: [
              CandlestickSpot(x: 5, open: 4, high: 8, low: 2, close: 6),
            ],
            showingTooltipIndicators: [0],
            touchedPointIndicator: AxisSpotIndicator(
              x: 5,
              y: 6,
              painter: AxisLinesIndicatorPainter(
                horizontalLineProvider: (y) => HorizontalLine(
                  y: y,
                  label: HorizontalLineLabel(
                    show: true,
                    labelResolver: (_) => 'indicator-h',
                  ),
                ),
                verticalLineProvider: (x) => VerticalLine(
                  x: x,
                  label: VerticalLineLabel(
                    show: true,
                    labelResolver: (_) => 'indicator-v',
                  ),
                ),
              ),
            ),
            candlestickTouchData: CandlestickTouchData(
              handleBuiltInTouches: false,
              touchTooltipData: CandlestickTouchTooltipData(
                getTooltipItems: (_, __, ___) =>
                    CandlestickTooltipItem('tt-candle'),
              ),
            ),
          ),
        ),
      );

      tracker
        ..expectCreatedIn(
          'CandlestickChartPainter.drawTouchTooltip',
          text: 'tt-candle',
        )
        ..expectCreatedIn(
          'AxisLinesIndicatorPainter._drawHorizontalLine',
          text: 'indicator-h',
        )
        ..expectCreatedIn(
          'AxisLinesIndicatorPainter._drawVerticalLine',
          text: 'indicator-v',
        )
        ..expectAllDisposed();
    });

    testWidgets('GaugeChart', (tester) async {
      final tracker = _trackTextPainters();

      await _pumpAndUnmount(
        tester,
        GaugeChart(
          GaugeChartData(
            rings: const [
              GaugeProgressRing(value: 0.4, color: Colors.red, width: 8),
            ],
            ticks: GaugeTicks(
              labelBuilder: (_) => 'tick',
              labelStyle: const TextStyle(fontSize: 10),
            ),
            markers: const [
              // One marker on each half of the gauge, so the label is drawn
              // both flipped and upright.
              GaugeMarker(
                value: 0.1,
                painter: GaugeMarkerLinePainter(
                  label: 'marker-left',
                  labelStyle: TextStyle(fontSize: 10),
                ),
              ),
              GaugeMarker(
                value: 0.9,
                painter: GaugeMarkerLinePainter(
                  label: 'marker-right',
                  labelStyle: TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      );

      tracker
        ..expectCreatedIn('GaugeChartPainter.drawTicks', text: 'tick')
        ..expectCreatedIn('GaugeMarkerLinePainter.draw', text: 'marker-left')
        ..expectCreatedIn('GaugeMarkerLinePainter.draw', text: 'marker-right')
        ..expectAllDisposed();
    });

    testWidgets('RadarChart', (tester) async {
      final tracker = _trackTextPainters();

      await _pumpAndUnmount(
        tester,
        RadarChart(
          RadarChartData(
            dataSets: [
              RadarDataSet(
                dataEntries: const [
                  RadarEntry(value: 1),
                  RadarEntry(value: 2),
                  RadarEntry(value: 3),
                ],
              ),
            ],
            ticksTextStyle: const TextStyle(fontSize: 10),
            getTitle: (index, _) => RadarChartTitle(text: 'title$index'),
          ),
        ),
      );

      expect(
        tracker.created
            .where((record) => record.stack.contains('RadarChartPainter')),
        hasLength(2),
      );
      tracker.expectAllDisposed();
    });
  });

  group('TextPainters are disposed on the early exits', () {
    testWidgets('BarChart tooltip outside of the zoomed chart', (tester) async {
      final tracker = _trackTextPainters();
      final controller = TransformationController();
      addTearDown(controller.dispose);
      var tooltipColorCalls = 0;

      await tester.pumpWidget(
        _wrap(
          BarChart(
            BarChartData(
              maxY: 10,
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  showingTooltipIndicators: [0],
                  barRods: [BarChartRodData(toY: 1)],
                ),
              ],
              barTouchData: _barTouchData(
                getTooltipColor: (_) {
                  tooltipColorCalls++;
                  return Colors.black;
                },
              ),
            ),
            transformationConfig: _zoomedIn(controller, FlScaleAxis.vertical),
          ),
        ),
      );
      expect(
        tester.widget<BarChartLeaf>(find.byType(BarChartLeaf)).chartVirtualRect,
        isNotNull,
      );
      await tester.pumpWidget(const SizedBox());

      tracker.expectCreatedIn(
        'BarChartPainter.drawTouchTooltip',
        text: 'tt-bar',
      );
      expect(tooltipColorCalls, 0);
      tracker.expectAllDisposed();
    });

    testWidgets('LineChart tooltip outside of the zoomed chart',
        (tester) async {
      final tracker = _trackTextPainters();
      final controller = TransformationController();
      addTearDown(controller.dispose);
      var tooltipColorCalls = 0;

      await tester.pumpWidget(
        _wrap(
          LineChart(
            _lineData(
              tooltipSpot: const FlSpot(10, 0),
              showExtras: false,
              getTooltipColor: (_) {
                tooltipColorCalls++;
                return Colors.black;
              },
            ),
            transformationConfig: _zoomedIn(controller, FlScaleAxis.free),
          ),
        ),
      );
      expect(
        tester
            .widget<LineChartLeaf>(find.byType(LineChartLeaf))
            .chartVirtualRect,
        isNotNull,
      );
      await tester.pumpWidget(const SizedBox());

      tracker.expectCreatedIn(
        'LineChartPainter.drawTouchTooltip',
        text: 'tt-line',
      );
      expect(tooltipColorCalls, 0);
      tracker.expectAllDisposed();
    });

    testWidgets('ScatterChart tooltip on a spot outside of the chart',
        (tester) async {
      final tracker = _trackTextPainters();
      var tooltipColorCalls = 0;

      await _pumpAndUnmount(
        tester,
        ScatterChart(
          ScatterChartData(
            minX: 0,
            maxX: 10,
            minY: 0,
            maxY: 10,
            scatterSpots: [ScatterSpot(30, 5)],
            showingTooltipIndicators: [0],
            scatterTouchData: _scatterTouchData(
              getTooltipColor: (_) {
                tooltipColorCalls++;
                return Colors.black;
              },
            ),
          ),
        ),
      );

      tracker.expectCreatedIn(
        'ScatterChartPainter.drawTouchTooltip',
        text: 'tt-scatter',
      );
      expect(tooltipColorCalls, 0);
      tracker.expectAllDisposed();
    });

    testWidgets('BarChart stack item label taller than its segment',
        (tester) async {
      final tracker = _trackTextPainters();

      await tester.pumpWidget(
        _wrap(
          BarChart(
            BarChartData(
              maxY: 100,
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: 2,
                      rodStackItems: [
                        BarChartRodStackItem(
                          0,
                          2,
                          Colors.red,
                          label: 'stack',
                          labelStyle: const TextStyle(fontSize: 40),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
              barTouchData: const BarTouchData(handleBuiltInTouches: false),
            ),
          ),
        ),
      );
      expect(
        tester.renderObject(find.byType(BarChartLeaf)),
        paintsExactlyCountTimes(#drawParagraph, 0),
      );
      await tester.pumpWidget(const SizedBox());

      tracker
        ..expectCreatedIn('BarChartPainter.drawBars', text: 'stack')
        ..expectAllDisposed();
    });
  });
}
