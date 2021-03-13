import 'dart:ui';

/// Abstract class for our painters
///
/// This class contains [paint] method, that takes a [canvas], and [size] for drawing the content.
abstract class ChartPainter {
  void paint(Canvas canvas, Size size);
}
