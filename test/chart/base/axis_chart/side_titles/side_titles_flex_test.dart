import 'package:fl_chart/src/chart/base/axis_chart/side_titles/side_titles_flex.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SideTitlesFlex test', () {
    testWidgets(
      'Test vertical mode',
      (WidgetTester tester) async {
        const viewHeight = 400.0;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 40,
                  height: viewHeight,
                  child: SideTitlesFlex(
                    direction: Axis.vertical,
                    axisSideMetaData: AxisSideMetaData(
                      0,
                      10,
                      viewHeight,
                    ),
                    widgetHolders: oneToNineWidgetHolders(viewHeight),
                  ),
                ),
              ),
            ),
          ),
        );

        for (int i = 1; i <= 9; i++) {
          expect(find.text(i.toDouble().toString()), findsOneWidget);
        }
        expect(find.text('10.0'), findsNothing);
        expect(find.text('11.0'), findsNothing);
        expect(find.text('0.0'), findsNothing);
      },
    );

    testWidgets(
      'Test horizontal mode',
      (WidgetTester tester) async {
        const viewWidth = 400.0;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: viewWidth,
                  height: 40,
                  child: SideTitlesFlex(
                    direction: Axis.horizontal,
                    axisSideMetaData: AxisSideMetaData(
                      0,
                      10,
                      viewWidth,
                    ),
                    widgetHolders: List.generate(9, (index) => index.toDouble())
                        .map(
                          (value) => AxisSideTitleWidgetHolder(
                            AxisSideTitleMetaData(
                                value + 1, (value / 10) * viewWidth),
                            Text((value + 1).toString()),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        );

        for (int i = 1; i <= 9; i++) {
          expect(find.text(i.toDouble().toString()), findsOneWidget);
        }
        expect(find.text('10.0'), findsNothing);
        expect(find.text('11.0'), findsNothing);
        expect(find.text('0.0'), findsNothing);
      },
    );

    testWidgets(
      'Test update from horizontal to vertical',
      (WidgetTester tester) async {
        const valueKey = ValueKey("asdf");

        const viewSize = 400.0;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: viewSize,
                  height: 40,
                  child: SideTitlesFlex(
                    key: valueKey,
                    direction: Axis.horizontal,
                    axisSideMetaData: AxisSideMetaData(
                      0,
                      10,
                      viewSize,
                    ),
                    widgetHolders: oneToNineWidgetHolders(viewSize),
                  ),
                ),
              ),
            ),
          ),
        );

        for (int i = 1; i <= 9; i++) {
          expect(find.text(i.toDouble().toString()), findsOneWidget);
        }
        expect(find.text('10.0'), findsNothing);
        expect(find.text('11.0'), findsNothing);
        expect(find.text('0.0'), findsNothing);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 40,
                  height: viewSize,
                  child: SideTitlesFlex(
                    key: valueKey,
                    direction: Axis.vertical,
                    axisSideMetaData: AxisSideMetaData(
                      0,
                      10,
                      viewSize,
                    ),
                    widgetHolders: oneToNineWidgetHolders(viewSize),
                  ),
                ),
              ),
            ),
          ),
        );
        for (int i = 1; i <= 9; i++) {
          expect(find.text(i.toDouble().toString()), findsOneWidget);
        }
        expect(find.text('10.0'), findsNothing);
        expect(find.text('11.0'), findsNothing);
        expect(find.text('0.0'), findsNothing);
      },
    );
  });

  test('AxisSideTitlesRenderFlex horizontal', () {
    const viewSize = 400.0;
    final axisSideMetaData = AxisSideMetaData(
      0,
      10,
      viewSize,
    );
    final sideTitlesMetaData = oneToNineSideTitleMetaData(viewSize);
    final renderFlex = AxisSideTitlesRenderFlex(
      direction: Axis.horizontal,
      axisSideMetaData: axisSideMetaData,
      axisSideTitlesMetaData: sideTitlesMetaData,
    );

    DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
    renderFlex.debugFillProperties(builder);
    expect(builder.properties.length > 1, true);
    expect(
        (builder.properties.last as EnumProperty<Axis>).value, Axis.horizontal);
    expect(renderFlex.direction, Axis.horizontal);
    expect(renderFlex.axisSideMetaData, axisSideMetaData);
    expect(renderFlex.axisSideTitlesMetaData, sideTitlesMetaData);
    expect(renderFlex.debugNeedsLayout, false);
    expect(
      renderFlex.hitTestChildren(BoxHitTestResult(), position: Offset.zero),
      false,
    );
    expect(
      renderFlex
          .computeDryLayout(BoxConstraints.tight(const Size(viewSize, 40))),
      const Size(viewSize, 40),
    );
    expect(
      // ignore: invalid_use_of_protected_member
      renderFlex.computeDistanceToActualBaseline(TextBaseline.alphabetic),
      null,
    );
  });

  test('AxisSideTitlesRenderFlex vertical', () {
    const viewSize = 400.0;
    final axisSideMetaData = AxisSideMetaData(
      0,
      10,
      viewSize,
    );
    final sideTitlesMetaData = oneToNineSideTitleMetaData(viewSize);
    final renderFlex = AxisSideTitlesRenderFlex(
      direction: Axis.vertical,
      axisSideMetaData: axisSideMetaData,
      axisSideTitlesMetaData: sideTitlesMetaData,
    );
    expect(
      renderFlex
          .computeDryLayout(BoxConstraints.tight(const Size(viewSize, 40))),
      const Size(viewSize, 40),
    );
    expect(
      // ignore: invalid_use_of_protected_member
      renderFlex.computeDistanceToActualBaseline(TextBaseline.alphabetic),
      null,
    );
  });

  test('AxisSideTitleMetaData equality test', () {
    final data1 = AxisSideTitleMetaData(0, 0);
    final data1Clone = AxisSideTitleMetaData(0, 0);
    final data2 = AxisSideTitleMetaData(2, 0);
    expect(data1 == data1Clone, true);
    expect(data1 == data2, false);
  });

  test('AxisSideMetaData diff', () {
    expect(AxisSideMetaData(5, 10, 100).diff, 5);
    expect(AxisSideMetaData(5, 10, 0).diff, 5);
    expect(AxisSideMetaData(9, 10, 0).diff, 1);
  });
}

List<AxisSideTitleWidgetHolder> oneToNineWidgetHolders(double viewSize) {
  return oneToNineSideTitleMetaData(viewSize).asMap().entries.map((e) {
    final index = e.key;
    final sideTitlesMetaData = e.value;
    return AxisSideTitleWidgetHolder(
      sideTitlesMetaData,
      Text((index + 1).toDouble().toString()),
    );
  }).toList();
}

List<AxisSideTitleMetaData> oneToNineSideTitleMetaData(double viewSize) {
  return List.generate(9, (index) => index.toDouble())
      .map(
        (value) => AxisSideTitleMetaData(value + 1, (value / 10) * viewSize),
      )
      .toList();
}
