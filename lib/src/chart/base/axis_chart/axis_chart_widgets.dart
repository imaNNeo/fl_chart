import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';

/// Wraps a [child] widget and applies some default behaviours
///
/// Recommended to be used in [SideTitles.getTitlesWidget]
/// You need to pass [axisSide] value that provided by [TitleMeta]
/// It forces the widget to be close to the chart.
/// It also applies a [space] to the chart.
/// You can also fill [angle] in radians if you need to rotate your widget.
class SideTitleWidget extends StatelessWidget {
  final AxisSide axisSide;
  final double space;
  final Widget child;
  final double angle;

  const SideTitleWidget({
    Key? key,
    required this.child,
    required this.axisSide,
    this.space = 8.0,
    this.angle = 0.0,
  }) : super(key: key);

  Alignment _getAlignment() {
    switch (axisSide) {
      case AxisSide.left:
        return Alignment.centerRight;
      case AxisSide.top:
        return Alignment.bottomCenter;
      case AxisSide.right:
        return Alignment.centerLeft;
      case AxisSide.bottom:
        return Alignment.topCenter;
      default:
        throw StateError("Invalid side");
    }
  }

  EdgeInsets _getMargin() {
    switch (axisSide) {
      case AxisSide.left:
        return EdgeInsets.only(right: space);
      case AxisSide.top:
        return EdgeInsets.only(bottom: space);
      case AxisSide.right:
        return EdgeInsets.only(left: space);
      case AxisSide.bottom:
        return EdgeInsets.only(top: space);
      default:
        throw StateError("Invalid side");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        margin: _getMargin(),
        alignment: _getAlignment(),
        child: child,
      ),
    );
  }
}
