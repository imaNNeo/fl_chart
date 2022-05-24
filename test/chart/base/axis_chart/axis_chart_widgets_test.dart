import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'SideTitleWidget left',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SideTitleWidget(
              axisSide: AxisSide.left,
              child: Text("1s"),
            ),
          ),
        ),
      );
      expect(find.byType(Container), findsOneWidget);
      expect(find.text('1s'), findsOneWidget);
    },
  );

  testWidgets(
    'SideTitleWidget top',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SideTitleWidget(
              axisSide: AxisSide.top,
              child: Text("1s"),
            ),
          ),
        ),
      );
      expect(find.byType(Container), findsOneWidget);
      expect(find.text('1s'), findsOneWidget);
    },
  );

  testWidgets(
    'SideTitleWidget right',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SideTitleWidget(
              axisSide: AxisSide.right,
              child: Text("1s"),
            ),
          ),
        ),
      );
      expect(find.byType(Container), findsOneWidget);
      expect(find.text('1s'), findsOneWidget);
    },
  );

  testWidgets(
    'SideTitleWidget bottom',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SideTitleWidget(
              axisSide: AxisSide.bottom,
              child: Text("1s"),
            ),
          ),
        ),
      );
      expect(find.byType(Container), findsOneWidget);
      expect(find.text('1s'), findsOneWidget);
    },
  );
}
