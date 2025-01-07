import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TitleMeta getTitleMeta(AxisSide axisSide) => TitleMeta(
        min: 0,
        max: 10,
        parentAxisSize: 100,
        axisPosition: 10,
        appliedInterval: 10,
        sideTitles: const SideTitles(),
        formattedValue: '12',
        axisSide: axisSide,
        rotationQuarterTurns: 0,
      );

  group(
    'SideTitle without FitInside enabled',
    () {
      testWidgets(
        'SideTitleWidget left',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SideTitleWidget(
                  meta: getTitleMeta(AxisSide.left),
                  child: const Text('1s'),
                ),
              ),
            ),
          );
          expect(find.byType(Transform), findsAtLeastNWidgets(2));
          expect(find.byType(Container), findsOneWidget);
          expect(find.text('1s'), findsOneWidget);
        },
      );

      testWidgets(
        'SideTitleWidget top',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SideTitleWidget(
                  meta: getTitleMeta(AxisSide.top),
                  child: const Text('1s'),
                ),
              ),
            ),
          );
          expect(find.byType(Transform), findsAtLeastNWidgets(2));
          expect(find.byType(Container), findsOneWidget);
          expect(find.text('1s'), findsOneWidget);
        },
      );

      testWidgets(
        'SideTitleWidget right',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SideTitleWidget(
                  meta: getTitleMeta(AxisSide.right),
                  child: const Text('1s'),
                ),
              ),
            ),
          );
          expect(find.byType(Transform), findsAtLeastNWidgets(2));
          expect(find.byType(Container), findsOneWidget);
          expect(find.text('1s'), findsOneWidget);
        },
      );

      testWidgets(
        'SideTitleWidget bottom',
        (WidgetTester tester) async {
          const widgetKey = Key('SideTitleWidget');
          final sideTitleWidget = SideTitleWidget(
            key: widgetKey,
            meta: getTitleMeta(AxisSide.bottom),
            child: const Text('1s'),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: sideTitleWidget,
              ),
            ),
          );

          final element =
              tester.element(find.byKey(widgetKey)) as StatefulElement;
          final state = element.state as State<SideTitleWidget>;
          expect(state.widget, equals(sideTitleWidget));
          expect(element.renderObject!.attached, isTrue);

          expect(find.byType(Transform), findsAtLeastNWidgets(2));
          expect(find.byType(Container), findsOneWidget);
          expect(find.text('1s'), findsOneWidget);

          await tester.pump();
        },
      );
    },
  );
  group(
    'SideTitle with FitInside enabled',
    () {
      testWidgets(
        'SideTitleWidget left with FitInsideEnabled on Top Side',
        (WidgetTester tester) async {
          const widgetKey = Key('SideTitleWidget');
          final sideTitleWidget = SideTitleWidget(
            key: widgetKey,
            meta: getTitleMeta(AxisSide.left),
            fitInside: const SideTitleFitInsideData(
              enabled: true,
              axisPosition: 0,
              parentAxisSize: 100,
              distanceFromEdge: 0,
            ),
            child: const Text('A Long Text'),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: sideTitleWidget,
              ),
            ),
          );

          final element =
              tester.element(find.byKey(widgetKey)) as StatefulElement;
          final state = element.state as State<SideTitleWidget>;
          expect(state.widget, equals(sideTitleWidget));
          expect(element.renderObject!.attached, isTrue);

          expect(find.byType(Transform), findsAtLeastNWidgets(2));
          expect(find.byType(Container), findsOneWidget);
          expect(find.text('A Long Text'), findsOneWidget);
        },
      );

      testWidgets(
        'SideTitleWidget left with FitInsideEnabled on Bottom Side',
        (WidgetTester tester) async {
          const widgetKey = Key('SideTitleWidget');
          final sideTitleWidget = SideTitleWidget(
            key: widgetKey,
            meta: getTitleMeta(AxisSide.left),
            fitInside: const SideTitleFitInsideData(
              enabled: true,
              axisPosition: 100,
              parentAxisSize: 100,
              distanceFromEdge: 0,
            ),
            child: const Text('A Long Text'),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: sideTitleWidget,
              ),
            ),
          );

          final element =
              tester.element(find.byKey(widgetKey)) as StatefulElement;
          final state = element.state as State<SideTitleWidget>;
          expect(state.widget, equals(sideTitleWidget));
          expect(element.renderObject!.attached, isTrue);

          expect(find.byType(Transform), findsAtLeastNWidgets(2));
          expect(find.byType(Container), findsOneWidget);
          expect(find.text('A Long Text'), findsOneWidget);
        },
      );

      testWidgets(
        'SideTitleWidget bottom with FitInsideEnabled on Left Side',
        (WidgetTester tester) async {
          const widgetKey = Key('SideTitleWidget');
          final sideTitleWidget = SideTitleWidget(
            key: widgetKey,
            meta: getTitleMeta(AxisSide.bottom),
            fitInside: const SideTitleFitInsideData(
              enabled: true,
              axisPosition: 0,
              parentAxisSize: 100,
              distanceFromEdge: 0,
            ),
            child: const Text('A Long Text'),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: sideTitleWidget,
              ),
            ),
          );

          final element =
              tester.element(find.byKey(widgetKey)) as StatefulElement;
          final state = element.state as State<SideTitleWidget>;
          expect(state.widget, equals(sideTitleWidget));
          expect(element.renderObject!.attached, isTrue);

          expect(find.byType(Transform), findsAtLeastNWidgets(2));
          expect(find.byType(Container), findsOneWidget);
          expect(find.text('A Long Text'), findsOneWidget);
        },
      );

      testWidgets(
        'SideTitleWidget bottom with FitInsideEnabled on Right Side',
        (WidgetTester tester) async {
          const widgetKey = Key('SideTitleWidget');
          final sideTitleWidget = SideTitleWidget(
            key: widgetKey,
            meta: getTitleMeta(AxisSide.bottom),
            fitInside: const SideTitleFitInsideData(
              enabled: true,
              axisPosition: 100,
              parentAxisSize: 100,
              distanceFromEdge: 0,
            ),
            child: const Text('A Long Text'),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: sideTitleWidget,
              ),
            ),
          );

          final element =
              tester.element(find.byKey(widgetKey)) as StatefulElement;
          final state = element.state as State<SideTitleWidget>;
          expect(state.widget, equals(sideTitleWidget));
          expect(element.renderObject!.attached, isTrue);

          expect(find.byType(Transform), findsAtLeastNWidgets(2));
          expect(find.byType(Container), findsOneWidget);
          expect(find.text('A Long Text'), findsOneWidget);
        },
      );
    },
  );
}
