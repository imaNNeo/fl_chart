import 'dart:ui';

import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/extensions/color_extension.dart';
import 'package:fl_chart/src/extensions/edge_insets_extension.dart';
import 'package:fl_chart/src/extensions/fl_titles_data_extension.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../chart/data_pool.dart';

void main() {
  test('test allSidesPadding', () {
    expect(
      MockData.flTitlesData1.copyWith(show: false).allSidesPadding,
      EdgeInsets.zero,
    );

    expect(
      MockData.flTitlesData1.allSidesPadding,
      const EdgeInsets.fromLTRB(27.0, 16.0, 16.0, 16.0),
    );
  });
}
