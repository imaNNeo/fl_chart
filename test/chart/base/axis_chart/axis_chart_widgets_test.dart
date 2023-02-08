import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'SideTitle without FitInside enabled',
    () {
      testWidgets(
        'SideTitleWidget left',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: SideTitleWidget(
                  axisSide: AxisSide.left,
                  child: Text('1s'),
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
            const MaterialApp(
              home: Scaffold(
                body: SideTitleWidget(
                  axisSide: AxisSide.top,
                  child: Text('1s'),
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
            const MaterialApp(
              home: Scaffold(
                body: SideTitleWidget(
                  axisSide: AxisSide.right,
                  child: Text('1s'),
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
          const sideTitleWidget = SideTitleWidget(
            key: widgetKey,
            axisSide: AxisSide.bottom,
            child: Text('1s'),
          );

          await tester.pumpWidget(
            const MaterialApp(
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
          const sideTitleWidget = SideTitleWidget(
            key: widgetKey,
            axisSide: AxisSide.left,
            fitInside: SideTitleFitInsideData(
              enabled: true,
              axisPosition: 0,
              parentAxisSize: 100,
              distanceFromEdge: 0,
            ),
            child: Text('A Long Text'),
          );

          await tester.pumpWidget(
            const MaterialApp(
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
          const sideTitleWidget = SideTitleWidget(
            key: widgetKey,
            axisSide: AxisSide.left,
            fitInside: SideTitleFitInsideData(
              enabled: true,
              axisPosition: 100,
              parentAxisSize: 100,
              distanceFromEdge: 0,
            ),
            child: Text('A Long Text'),
          );

          await tester.pumpWidget(
            const MaterialApp(
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
          const sideTitleWidget = SideTitleWidget(
            key: widgetKey,
            axisSide: AxisSide.bottom,
            fitInside: SideTitleFitInsideData(
              enabled: true,
              axisPosition: 0,
              parentAxisSize: 100,
              distanceFromEdge: 0,
            ),
            child: Text('A Long Text'),
          );

          await tester.pumpWidget(
            const MaterialApp(
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
          const sideTitleWidget = SideTitleWidget(
            key: widgetKey,
            axisSide: AxisSide.bottom,
            fitInside: SideTitleFitInsideData(
              enabled: true,
              axisPosition: 100,
              parentAxisSize: 100,
              distanceFromEdge: 0,
            ),
            child: Text('A Long Text'),
          );

          await tester.pumpWidget(
            const MaterialApp(
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
