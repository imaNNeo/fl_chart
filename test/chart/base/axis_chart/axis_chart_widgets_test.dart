import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'SideTitleWidget',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SideTitleWidget(
                axisSide: AxisSide.left,
                child: Text("1s"),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(Container), findsOneWidget);
      expect(find.text('1s'), findsOneWidget);
    },
  );
}
