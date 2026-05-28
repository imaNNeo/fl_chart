import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/presentation/resources/app_colors.dart';
import 'package:flutter/material.dart';

/// Speedometer-style gauge combining two ring types:
/// - an inner [GaugeProgressRing] showing the current measurement
///   (350..value filled green, rest greyed out)
/// - an outer [GaugeZonesRing] painting fixed threshold bands
///   (350-600 red, 600-700 amber, 700-800 light green, 800-850 green)
///
/// Touching the gauge reports which ring was hit and, for the zones
/// ring, which specific zone the touch angle falls in.
class GaugeChartSample3 extends StatefulWidget {
  const GaugeChartSample3({super.key});

  @override
  State<StatefulWidget> createState() => GaugeChartSample3State();
}

class GaugeChartSample3State extends State<GaugeChartSample3> {
  double _value = 717;

  static const _minValue = 350.0;
  static const _maxValue = 850.0;

  static const _colorRanges = <(double to, Color color)>[
    (550, AppColors.contentColorRed),
    (700, AppColors.contentColorYellow),
    (850, AppColors.contentColorGreen),
  ];

  @override
  Widget build(BuildContext context) {
    Color barColor = _colorRanges.firstWhere((e) => _value <= e.$1).$2;

    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          SizedBox(
            width: 280,
            height: 180,
            child: GaugeChart(
              GaugeChartData(
                minValue: _minValue,
                maxValue: _maxValue,
                startDegreeOffset: 180,
                sweepAngle: 180,
                ringsSpace: 6,
                rings: [
                  // Inner ring — measurement, rounded tip looks good
                  GaugeProgressRing(
                    value: _value,
                    color: barColor,
                    backgroundColor: AppColors.contentColorWhite12,
                    width: 30,
                    strokeCap: StrokeCap.round,
                  ),
                  // Outer ring — rounded zones separated by a visible
                  // gap. zonesSpace is pixels along the arc, uniformly
                  // deducted from both ends of each zone. With round
                  // caps each cap extends width/2 beyond the arc, so
                  // effective visible gap ≈ zonesSpace - width.
                  GaugeZonesRing(
                    width: 8,
                    zonesSpace: 16,
                    zones: _colorRanges.asMap().entries.map((e) {
                      final index = e.key;
                      final to = e.value.$1;
                      final color = e.value.$2;
                      final from = index == 0 ? 350.0 : _colorRanges[index - 1].$1;
                      return GaugeZone(
                        from: from,
                        to: to,
                        color: color,
                        strokeCap: StrokeCap.round,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              _value.toStringAsFixed(0),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Slider(
            value: _value,
            min: _minValue,
            max: _maxValue,
            onChanged: (v) => setState(() => _value = v),
          ),
        ],
      ),
    );
  }
}
