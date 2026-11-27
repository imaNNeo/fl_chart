import 'package:fl_chart/src/chart/base/axis_chart/side_titles/localize_axis_number.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  test('translates number symbols without rounding again', () {
    final symbols = NumberFormat.decimalPattern('de').symbols;
    expect(localizeAxisNumber('-0.000000001', symbols), '-0,000000001');
    expect(localizeAxisNumber('1000000B', symbols), '1000000B');
    expect(
      localizeAxisNumber('1000000.000000001B', symbols),
      '1000000,000000001B',
    );
    final persian = NumberFormat.decimalPattern('fa').symbols;
    expect(localizeAxisNumber('1.5K', persian), '۱٫۵K');
  });
}
