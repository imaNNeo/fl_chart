import 'dart:ui';

import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/extensions/color_extension.dart';
import 'package:fl_chart/src/extensions/edge_insets_extension.dart';
import 'package:fl_chart/src/extensions/fl_titles_data_extension.dart';
import 'package:fl_chart/src/extensions/paint_extension.dart';
import 'package:fl_chart/src/extensions/path_extension.dart';
import 'package:fl_chart/src/extensions/rrect_extension.dart';
import 'package:fl_chart/src/utils/path_drawing/dash_path.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../chart/data_pool.dart';
import '../helper_methods.dart';

void main() {
  test('test getRect', () {
    expect(
      MockData.rRect1.getRect(),
      const Rect.fromLTRB(1, 1, 1, 1),
    );
  });
}
