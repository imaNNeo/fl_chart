import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/extensions/side_titles_extension.dart';
import 'package:flutter/widgets.dart';

extension FlTitlesDataExtension on FlTitlesData {
  EdgeInsets get allSidesPadding {
    return EdgeInsets.only(
      left: show ? leftTitles.totalReservedWidth : 0.0,
      top: show ? topTitles.totalReservedHeight : 0.0,
      right: show ? rightTitles.totalReservedWidth : 0.0,
      bottom: show ? bottomTitles.totalReservedHeight : 0.0,
    );
  }
}
