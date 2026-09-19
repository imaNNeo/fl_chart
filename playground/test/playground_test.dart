// ignore_for_file: avoid_print

import 'package:fl_chart_playground/generated/api_registry.g.dart';
import 'package:fl_chart_playground/src/api.dart';
import 'package:fl_chart_playground/src/dart_code.dart';
import 'package:fl_chart_playground/src/hints.dart';
import 'package:fl_chart_playground/src/hosts.dart';
import 'package:fl_chart_playground/src/playground_page.dart';
import 'package:fl_chart_playground/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('hints and hosts match the documented classes', () {
    for (final key in hints.keys) {
      final [className, property] = key.split('.');
      expect(
        apiRegistry[className]?.property(property),
        isNotNull,
        reason: 'The hint of $key is for a property that is not documented',
      );
    }
    for (final className in hosts.keys) {
      expect(apiRegistry[className], isNotNull, reason: '$className host');
    }
  });

  testWidgets('every value of every control renders', (tester) async {
    for (final MapEntry(key: className, value: host) in hosts.entries) {
      final spec = apiRegistry[className]!;
      for (final property in spec.properties) {
        final hint = hints['$className.${property.name}'];
        for (final value in _sampleValues(property, hint)) {
          final values = {
            for (final MapEntry(:key, :value) in {
              ...?hint?.requires,
              property.name: value,
            }.entries)
              key: value is Preset ? value.value : value,
          };
          final instance = spec.copy!(host.instance(), values);
          await tester.pumpWidget(_app(host.build(instance)));
          // The chart animates from the previous value.
          await tester.pump(const Duration(milliseconds: 75));
          await tester.pumpAndSettle();
          expect(
            tester.takeException(),
            isNull,
            reason: '$className.${property.name} = ${dartCode(value)}',
          );
        }
      }
    }
  });

  testWidgets('the page of every property renders', (tester) async {
    for (final MapEntry(key: className, value: spec) in apiRegistry.entries) {
      for (final property in [null, ...spec.properties]) {
        await tester.pumpWidget(
          _app(
            PlaygroundPage(target: PlaygroundTarget(className, property?.name)),
          ),
        );
        expect(tester.takeException(), isNull, reason: '$className.$property');
      }
    }
  });

  test('prints the properties without a control', () {
    final missing = [
      for (final MapEntry(key: className, value: spec) in apiRegistry.entries)
        if (!hosts.containsKey(className))
          '$className (no host)'
        else
          for (final property in spec.properties)
            if (_sampleValues(
              property,
              hints['$className.${property.name}'],
            ).isEmpty)
              '$className.${property.name} (${property.type})',
    ];
    print('${missing.length} properties without a control:');
    missing.forEach(print);
  });

  test('parses the target from the URL', () {
    expect(
      PlaygroundTarget.fromUri(Uri.parse('/LineChartBarData/isCurved')),
      const PlaygroundTarget('LineChartBarData', 'isCurved'),
    );
    expect(
      PlaygroundTarget.fromUri(Uri.parse('/')),
      const PlaygroundTarget(null),
    );
  });

  test('writes the code of the changed properties', () {
    expect(
      constructorCode(apiRegistry['LineChartBarData']!, {
        'isCurved': true,
        'curveSmoothness': 0.5,
        'color': Colors.amber,
      }),
      'LineChartBarData(\n'
      '  color: Colors.amber,\n'
      '  isCurved: true,\n'
      '  curveSmoothness: 0.5,\n'
      ')',
    );
    expect(
      constructorCode(apiRegistry['LineTooltipItem']!, {'text': 'Hi'}),
      "LineTooltipItem(\n  'Hi',\n)",
    );
    // An integral double is an int on the web.
    expect(
      constructorCode(apiRegistry['LineChartBarData']!, {'barWidth': 3}),
      'LineChartBarData(\n  barWidth: 3.0,\n)',
    );
  });
}

/// The values the control of [property] can give.
List<Object?> _sampleValues(PropertySpec property, PropertyHint? hint) {
  final presets = hint?.presets;
  if (presets != null) return presets;
  final min = hint?.min;
  final max = hint?.max;
  final values = switch (property.kind) {
    PropertyKind.boolean => [true, false],
    PropertyKind.integer when min != null && max != null => [
      min.round(),
      max.round(),
    ],
    PropertyKind.decimal when min != null && max != null => [
      min,
      (min + max) / 2,
      max,
    ],
    PropertyKind.text => ['', 'Hello\nWorld'],
    PropertyKind.color => [Colors.red, Colors.white],
    PropertyKind.enumeration => property.values!,
    _ => <Object?>[],
  };
  return [...values, if (values.isNotEmpty && property.isNullable) null];
}

Widget _app(Widget child) => MaterialApp(
  theme: playgroundTheme,
  home: Scaffold(
    body: Center(child: SizedBox(width: 400, height: 600, child: child)),
  ),
);
