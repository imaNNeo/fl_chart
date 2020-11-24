import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_chart_data.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_chart_painter.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';

//ToDo(payam) : extend this widget from [ImplicitlyAnimatedWidget]
class RadarChart extends StatefulWidget {
  final RadarChartData data;

  const RadarChart(this.data, {Key key}) : super(key: key);

  @override
  _RadarChartState createState() => _RadarChartState();
}


//ToDo(payam) : handle animation
//ToDo(payam) : handle touch
class _RadarChartState extends State<RadarChart> {
  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [PieChartData] to the new one.
  RadarChartDataTween _radarChartDataTween;

  /// this is used to map the touch events to [PieTouchResponse]
  TouchHandler _touchHandler;

  /// this is used to retrieve the chart size to handle the touches
  final GlobalKey _chartKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      key: _chartKey,
      size: getDefaultSize(context),
      painter: RadarChartPainter(
        widget.data,
        //ToDo(payam) : update it for animations
        widget.data,
        textScale: MediaQuery.of(context).textScaleFactor,
      ),
    );
  }
}
