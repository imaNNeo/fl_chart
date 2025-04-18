import 'dart:ui';

import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';

mixin AxisChartCoordinateMapper<D extends AxisChartData>
    on BaseChartPainter<D> {
  /// With this function we can convert our [FlSpot] x
  /// to the view base axis x .
  /// the view 0, 0 is on the top/left, but the spots is bottom/left
  double getPixelX(double spotX) {
    final viewSize = canvasWrapper.size;
    final holder = paintHolder;
    final usableSize = holder.getChartUsableSize(viewSize);

    final pixelXUnadjusted = _getPixelX(spotX, holder.data, usableSize);

    // Adjust the position relative to the canvas if chartVirtualRect
    // is provided
    final adjustment = holder.chartVirtualRect?.left ?? 0;
    return pixelXUnadjusted + adjustment;
  }

  double _getPixelX(double spotX, D data, Size usableSize) {
    final deltaX = data.maxX - data.minX;
    if (deltaX == 0.0) {
      return 0;
    }
    return ((spotX - data.minX) / deltaX) * usableSize.width;
  }

  /// With this function we can convert our [FlSpot] y
  /// to the view base axis y.
  double getPixelY(double spotY) {
    final viewSize = canvasWrapper.size;
    final holder = paintHolder;
    final usableSize = holder.getChartUsableSize(viewSize);

    final pixelYUnadjusted = _getPixelY(spotY, holder.data, usableSize);

    // Adjust the position relative to the canvas if chartVirtualRect
    // is provided
    final adjustment = holder.chartVirtualRect?.top ?? 0;
    return pixelYUnadjusted + adjustment;
  }

  double _getPixelY(double spotY, D data, Size usableSize) {
    final deltaY = data.maxY - data.minY;
    if (deltaY == 0.0) {
      return usableSize.height;
    }
    return usableSize.height -
        (((spotY - data.minY) / deltaY) * usableSize.height);
  }
}
