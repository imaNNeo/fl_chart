import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/presentation/resources/app_colors.dart';
import 'package:flutter/material.dart';

class GaugeChartSample4 extends StatefulWidget {
  const GaugeChartSample4({super.key});

  @override
  State<GaugeChartSample4> createState() => _GaugeChartSample4State();
}

class _GaugeChartSample4State extends State<GaugeChartSample4> {

  double _value = 0.35;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 28,
        right: 28,
        top: 80,
        bottom: 28,
      ),
      child: Column(
        children: [
          SizedBox(
            width: 280,
            height: 280,
            child: GaugeChart(
              GaugeChartData(
                startDegreeOffset: -200,
                sweepAngle: 220,
                ringsSpace: 6,
                rings: [
                  GaugeZonesRing(
                    width: 100,
                    zonesSpace: 4,
                    zones: [
                      GaugeZone(
                        from: 0,
                        to: 0.25,
                        color: AppColors.contentColorRed,
                      ),
                      GaugeZone(
                        from: 0.25,
                        to: 0.50,
                        color: AppColors.contentColorOrange,
                      ),
                      GaugeZone(
                        from: 0.50,
                        to: 0.75,
                        color: AppColors.contentColorYellow,
                      ),
                      GaugeZone(
                        from: 0.75,
                        to: 1.0,
                        color: AppColors.contentColorGreen,
                      ),
                    ],
                  ),
                ],
                ticks: GaugeTicks(
                  count: 11,
                  offset: 8,
                  painter: const GaugeTickLinePainter(
                    length: 10,
                    thickness: 2,
                    color: AppColors.contentColorWhite,
                  ),
                  labelBuilder: (v) => (v * 100).toStringAsFixed(0),
                  labelStyle: const TextStyle(
                    fontSize: 12,
                    color: AppColors.contentColorWhite,
                    fontWeight: FontWeight.w600,
                  ),
                  labelOffset: 4,
                ),
                pointers: [
                  // Needle extending from center toward the current value.
                  GaugePointer(
                    value: _value,
                    painter: GaugePointerNeedlePainter(
                      length: 80,
                      width: 10,
                      tailLength: 24,
                      color: AppColors.contentColorWhite,
                    ),
                  ),
                  // Pivot cap sitting at the gauge center, on top of the
                  // needle's base — just a second pointer with a small
                  // circle painter (anchorRadius: 0).
                  GaugePointer(
                    value: 0.65,
                    painter: GaugePointerCirclePainter(
                      radius: 8,
                      color: AppColors.contentColorBlack,
                      strokeWidth: 2,
                      strokeColor: AppColors.contentColorWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Slider(
            value: _value,
            onChanged: (v) => setState(() => _value = v),
          )
        ],
      ),
    );
  }
}
