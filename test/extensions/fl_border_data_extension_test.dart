import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/extensions/fl_border_data_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test allSidesPadding', () {
    expect(
      FlBorderData(
        show: false,
        border: Border.all(
          color: Colors.red,
          width: 10,
        ),
      ).allSidesPadding,
      EdgeInsets.zero,
    );

    expect(
      FlBorderData(
          show: true,
          border: Border(
              left: const BorderSide(
                width: 1,
                color: Colors.transparent,
              ),
              top: BorderSide(
                width: 10,
                color: Colors.red.withOpacity(0.5),
              ),
              right: BorderSide.none,
              bottom: const BorderSide(
                width: 4,
                color: Colors.red,
              ))).allSidesPadding,
      const EdgeInsets.fromLTRB(1.0, 10.0, 0.0, 4.0),
    );
  });
}
