import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/extensions/side_titles_extension.dart';
import 'package:flutter/widgets.dart';

extension FlTitlesDataExtension on FlTitlesData {
  EdgeInsets get allSidesPadding => EdgeInsets.only(
        left: show && !leftTitles.overlayOnChart
            ? leftTitles.totalReservedSize
            : 0.0,
        top: show && !topTitles.overlayOnChart
            ? topTitles.totalReservedSize
            : 0.0,
        right: show && !rightTitles.overlayOnChart
            ? rightTitles.totalReservedSize
            : 0.0,
        bottom: show && !bottomTitles.overlayOnChart
            ? bottomTitles.totalReservedSize
            : 0.0,
      );
}
