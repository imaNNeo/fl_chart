import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_painter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'line_chart_painter_test.mocks.dart';

void main() {
  testWidgets('paints extra line labels after all extra lines', (tester) async {
    await tester.pumpWidget(const SizedBox());
    final data = LineChartData(
      minX: 0,
      maxX: 10,
      minY: 0,
      maxY: 10,
      extraLinesData: ExtraLinesData(
        horizontalLines: [
          HorizontalLine(y: 5, label: HorizontalLineLabel(show: true)),
        ],
        verticalLines: [
          VerticalLine(x: 5, label: VerticalLineLabel(show: true)),
          VerticalLine(x: 6),
        ],
      ),
    );
    final canvas = MockCanvasWrapper();
    when(canvas.size).thenReturn(const Size(100, 100));
    when(canvas.canvas).thenReturn(MockCanvas());
    final calls = <String>[];
    when(canvas.drawDashedLine(any, any, any, any)).thenAnswer((_) {
      calls.add('line');
    });
    when(canvas.drawText(any, any)).thenAnswer((_) {
      calls.add('label');
    });

    LineChartPainter().drawExtraLines(
      tester.element(find.byType(SizedBox)),
      canvas,
      PaintHolder<LineChartData>(data, data, TextScaler.noScaling),
    );

    expect(calls, ['line', 'line', 'line', 'label', 'label']);
  });
}
