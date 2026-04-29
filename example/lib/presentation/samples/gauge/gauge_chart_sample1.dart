import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:flutter/material.dart';

class GaugeChartSample1 extends StatefulWidget {
  const GaugeChartSample1({super.key});

  @override
  State<StatefulWidget> createState() => GaugeChartSample1State();
}

class GaugeChartSample1State extends State<GaugeChartSample1> {
  double _value = 0.5;

  // Continuous min/max thresholds — deliberately off the 11-tick grid
  // (0.0, 0.1, ..., 1.0) to show GaugeMarker carries an arbitrary
  // value, not a discrete tick index.
  static const _minValue = 0.23;
  static const _maxValue = 0.77;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          SizedBox(
            width: 250,
            height: 250,
            child: Stack(
              children: [
                GaugeChart(
                  GaugeChartData.progress(
                    value: _value,
                    color: AppColors.contentColorPurple,
                    width: 30,
                    backgroundColor:
                    AppColors.contentColorPurple.withValues(alpha: 0.2),
                    startDegreeOffset: -200,
                    sweepAngle: 220,
                    touchData: GaugeTouchData(enabled: true),
                    ticks: GaugeTicks(
                      position: GaugeTickPosition.center,
                      count: 11,
                      offset: 0,
                      painter: GaugeTickCirclePainter(
                        color: AppColors.contentColorWhite,
                        radius: 5,
                      ),
                      checkToShowTick: GaugeTicks.hideEndpoints,
                    ),
                    markers: const [
                      GaugeMarker(
                        value: _minValue,
                        position: GaugeTickPosition.center,
                        painter: GaugeMarkerLinePainter(
                          length: 40,
                          thickness: 4,
                          color: Colors.green,
                          label: 'Min',
                          labelStyle: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          labelSide: GaugeMarkerLabelSide.inward,
                        ),
                      ),
                      GaugeMarker(
                        value: _maxValue,
                        position: GaugeTickPosition.center,
                        painter: GaugeMarkerLinePainter(
                          length: 40,
                          thickness: 4,
                          color: Colors.red,
                          label: 'Max',
                          labelStyle: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          labelSide: GaugeMarkerLabelSide.inward,
                        ),
                      ),
                    ],
                    pointers: [
                      // Needle extending from center toward the current value.
                      GaugePointer(
                        value: _value,
                        painter: GaugePointerNeedlePainter(
                          length: 88,
                          width: 20,
                          tailLength: 40,
                          color: AppColors.contentColorWhite,
                        ),
                      ),
                      // Pivot cap sitting at the gauge center, on top of the
                      // needle's base — just a second pointer with a small
                      // circle painter (anchorRadius: 0).
                      GaugePointer(
                        value: 0.3,
                        painter: GaugePointerCirclePainter(
                          radius: 24,
                          color: AppColors.contentColorBlack,
                          strokeWidth: 2,
                          strokeColor: AppColors.contentColorWhite,
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Text(
                    "${(_value * 100).toInt()}",
                    style: TextStyle(
                      color: AppColors.contentColorWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
          Slider(value: _value, onChanged: (v) => setState(() => _value = v)),
        ],
      ),
    );
  }
}
