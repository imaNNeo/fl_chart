import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/extensions/side_titles_extension.dart';
import 'package:flutter/widgets.dart';

extension FlTitlesDataExtension on FlTitlesData {
  EdgeInsets get allSidesPadding {
    return EdgeInsets.only(
      left: leftTitles.totalReservedSize,
      top: topTitles.totalReservedSize,
      right: rightTitles.totalReservedSize,
      bottom: bottomTitles.totalReservedSize,
    );
  }
}
