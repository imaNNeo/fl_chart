import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Contains anything that helps LineChart works
class LineChartHelper {
  /// Calculates the [minX], [maxX], [minY], and [maxY] values of
  /// the provided [lineBarsData].
  (double minX, double maxX, double minY, double maxY) calculateMaxAxisValues(
    List<LineChartBarData> lineBarsData,
  ) {
    if (lineBarsData.isEmpty) {
      return (0, 0, 0, 0);
    }

    final LineChartBarData lineBarData;
    try {
      lineBarData = lineBarsData.firstWhere((element) => element.spots.isNotEmpty);
    } catch (_) {
      // There is no lineBarData with at least one spot
      return (0, 0, 0, 0);
    }

    final FlSpot firstValidSpot;
    try {
      firstValidSpot = lineBarData.spots.firstWhere((element) => element != FlSpot.nullSpot);
    } catch (_) {
      // There is no valid spot
      return (0, 0, 0, 0);
    }

    var minX = firstValidSpot.x;
    var maxX = firstValidSpot.x;
    var minY = firstValidSpot.y;
    var maxY = firstValidSpot.y;

    for (final barData in lineBarsData) {
      if (barData.spots.isEmpty) {
        continue;
      }

      if (barData.mostRightSpot.x > maxX) {
        maxX = barData.mostRightSpot.x;
      }

      if (barData.mostLeftSpot.x < minX) {
        minX = barData.mostLeftSpot.x;
      }

      if (barData.mostTopSpot.y > maxY) {
        maxY = barData.mostTopSpot.y;
      }

      if (barData.mostBottomSpot.y < minY) {
        minY = barData.mostBottomSpot.y;
      }
    }

    return (minX, maxX, minY, maxY);
  }

  /// Converts screen pixel coordinates to chart data coordinates.
  ///
  /// Returns null if the conversion fails or the chart data is invalid.
  /// This replicates the exact logic from AxisChartPainter.getXForPixel/getYForPixel.
  static FlSpot? screenToData(
    Offset screenPosition,
    Size chartSize,
    LineChartData chartData,
  ) {
    try {
      // Get usable chart size (this is what AxisChartPainter uses)
      final usableSize = _getChartUsableSize(chartSize, chartData);

      // Get title sizes - screenPosition is relative to widget top-left,
      // but AxisChartPainter's getXForPixel/getYForPixel expect coordinates
      // relative to the usable area (after titles)
      final leftTitleSize = chartData.titlesData.leftTitles.sideTitles.showTitles
          ? chartData.titlesData.leftTitles.sideTitles.reservedSize
          : 0.0;
      final topTitleSize = chartData.titlesData.topTitles.sideTitles.showTitles
          ? chartData.titlesData.topTitles.sideTitles.reservedSize
          : 0.0;

      // Adjust to usable area coordinate space
      final adjustedX = screenPosition.dx - leftTitleSize;
      final adjustedY = screenPosition.dy - topTitleSize;

      // Now apply AxisChartPainter logic
      final deltaX = chartData.maxX - chartData.minX;
      if (deltaX == 0.0) return null;

      final deltaY = chartData.maxY - chartData.minY;
      if (deltaY == 0.0) return null;

      final dataX = (adjustedX / usableSize.width) * deltaX + chartData.minX;
      final dataY = chartData.maxY - (adjustedY / usableSize.height) * deltaY;

      return FlSpot(
        dataX.clamp(chartData.minX, chartData.maxX),
        dataY.clamp(chartData.minY, chartData.maxY),
      );
    } catch (e) {
      return null;
    }
  }

  /// Converts chart data coordinates to screen pixel coordinates.
  /// This replicates the exact logic from AxisChartPainter.getPixelX/getPixelY.
  static Offset dataToScreen(
    FlSpot dataPoint,
    Size chartSize,
    LineChartData chartData,
  ) {
    // Get usable chart size (this is what AxisChartPainter uses)
    final usableSize = _getChartUsableSize(chartSize, chartData);

    // Get title sizes - need to add these back to convert from usable area
    // coordinate space to widget coordinate space
    final leftTitleSize = chartData.titlesData.leftTitles.sideTitles.showTitles
        ? chartData.titlesData.leftTitles.sideTitles.reservedSize
        : 0.0;
    final topTitleSize = chartData.titlesData.topTitles.sideTitles.showTitles
        ? chartData.titlesData.topTitles.sideTitles.reservedSize
        : 0.0;

    // This matches AxisChartPainter._getPixelX/_getPixelY
    final deltaX = chartData.maxX - chartData.minX;
    if (deltaX == 0.0) {
      return Offset(leftTitleSize, topTitleSize);
    }

    final deltaY = chartData.maxY - chartData.minY;
    final pixelX = ((dataPoint.x - chartData.minX) / deltaX) * usableSize.width;
    final pixelY = deltaY == 0.0
        ? usableSize.height
        : usableSize.height - (((dataPoint.y - chartData.minY) / deltaY) * usableSize.height);

    // Add title offsets to convert to widget coordinate space
    return Offset(pixelX + leftTitleSize, pixelY + topTitleSize);
  }

  /// Gets the usable size of the chart (excluding titles).
  /// This replicates the logic from BaseChartPainter.getChartUsableSize.
  static Size _getChartUsableSize(Size viewSize, LineChartData chartData) {
    final titlesData = chartData.titlesData;

    final leftTitleSize =
        titlesData.leftTitles.sideTitles.showTitles ? titlesData.leftTitles.sideTitles.reservedSize : 0.0;
    final rightTitleSize =
        titlesData.rightTitles.sideTitles.showTitles ? titlesData.rightTitles.sideTitles.reservedSize : 0.0;
    final topTitleSize =
        titlesData.topTitles.sideTitles.showTitles ? titlesData.topTitles.sideTitles.reservedSize : 0.0;
    final bottomTitleSize =
        titlesData.bottomTitles.sideTitles.showTitles ? titlesData.bottomTitles.sideTitles.reservedSize : 0.0;

    return Size(
      viewSize.width - leftTitleSize - rightTitleSize,
      viewSize.height - topTitleSize - bottomTitleSize,
    );
  }
}
