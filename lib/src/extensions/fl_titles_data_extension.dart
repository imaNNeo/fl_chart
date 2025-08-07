import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/extensions/side_titles_extension.dart';
import 'package:flutter/widgets.dart';

extension FlTitlesDataExtension on FlTitlesData {
  EdgeInsets get allSidesPadding => EdgeInsets.only(
        left: _getPadding(
          leftTitles.sideTitleAlignment,
          leftTitles.totalReservedSize,
        ),
        top: _getPadding(
          topTitles.sideTitleAlignment,
          topTitles.totalReservedSize,
        ),
        right: _getPadding(
          rightTitles.sideTitleAlignment,
          rightTitles.totalReservedSize,
        ),
        bottom: _getPadding(
          bottomTitles.sideTitleAlignment,
          bottomTitles.totalReservedSize,
        ),
      );

  double _getPadding(SideTitleAlignment alignment, double reservedSize) {
    if (!show || alignment == SideTitleAlignment.inside) {
      return 0;
    } else if (alignment == SideTitleAlignment.border) {
      return reservedSize / 2;
    } else {
      return reservedSize;
    }
  }
}
