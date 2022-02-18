import 'dart:ui';

import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/extensions/color_extension.dart';
import 'package:fl_chart/src/extensions/edge_insets_extension.dart';
import 'package:fl_chart/src/extensions/fl_titles_data_extension.dart';
import 'package:fl_chart/src/extensions/paint_extension.dart';
import 'package:fl_chart/src/extensions/path_extension.dart';
import 'package:fl_chart/src/utils/path_drawing/dash_path.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../chart/data_pool.dart';
import '../helper_methods.dart';

void main() {
  test('test transparentIfWidthIsZero', () {
    var path1 = Path()
      ..moveTo(0, 0)
      ..lineTo(10, 0);
    expect(
      path1.toDashedPath(null),
      path1,
    );

    final path2 =
        dashPath(path1, dashArray: CircularIntervalList<double>([10.0, 5.0]));

    expect(HelperMethods.equalsPaths(path1.toDashedPath([10, 5]), path2), true);
  });
}
