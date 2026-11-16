import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('default numeric axis labels follow app locale changes',
      (tester) async {
    final locale = ValueNotifier(const Locale('en'));
    addTearDown(locale.dispose);
    Locale? observedLocale;
    await tester.pumpWidget(
      ValueListenableBuilder<Locale>(
        valueListenable: locale,
        builder: (_, selected, __) => MaterialApp(
          locale: selected,
          supportedLocales: const [Locale('en'), Locale('de')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: Builder(
            builder: (context) {
              observedLocale = Localizations.localeOf(context);
              return Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 400,
                    height: 300,
                    child: LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: 2,
                        minY: 0,
                        maxY: 2,
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [FlSpot.zero, FlSpot(2, 2)],
                          ),
                        ],
                        titlesData: const FlTitlesData(
                          topTitles: AxisTitles(),
                          rightTitles: AxisTitles(),
                          bottomTitles: AxisTitles(),
                          leftTitles: AxisTitles(
                            sideTitles:
                                SideTitles(showTitles: true, interval: 0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(observedLocale, const Locale('en'));
    expect(find.text('0.5'), findsOneWidget);
    locale.value = const Locale('de');
    await tester.pumpAndSettle();
    expect(observedLocale, const Locale('de'));
    expect(find.text('0,5'), findsOneWidget);
    expect(find.text('0.5'), findsNothing);
  });
  testWidgets('custom title widgets retain control of their text',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
        supportedLocales: const [Locale('de')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 300,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 2,
                minY: 0,
                maxY: 2,
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  bottomTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 0.5,
                      getTitlesWidget: (value, _) => Text('custom:$value'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('custom:0.5'), findsOneWidget);
    expect(find.text('custom:0,5'), findsNothing);
  });
}
