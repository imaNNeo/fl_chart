import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:flutter/material.dart';

class GaugeChartSample4 extends StatefulWidget {
  const GaugeChartSample4({super.key});

  @override
  State<StatefulWidget> createState() => GaugeChartSample4State();
}

class GaugeChartSample4State extends State {
  double _value = 0.7;
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          SizedBox(
            width: 250,
            height: 250,
            child: GaugeChart(
              GaugeChartData(
                value: _value,
                valueColor: GaugeColor(
                  colors: [
                    AppColors.contentColorGreen,
                    AppColors.contentColorBlue,
                    AppColors.contentColorRed
                  ],
                  limits: [0.5, 0.8],
                ),
                backgroundColor: AppColors.contentColorPurple
                    .withValues(alpha: _isSelected ? 0.2 : 1),
                strokeWidth: 30,
                startDegreeOffset: -225,
                sweepAngle: 270,
                direction: GaugeDirection.clockwise,
                strokeCap: StrokeCap.round,
                ticks: const GaugeTicks(
                  count: 11,
                  color: AppColors.contentColorCyan,
                  radius: 5,
                  position: GaugeTickPosition.inner,
                  margin: 5,
                ),
                touchData: GaugeTouchData(
                  enabled: true,
                  touchCallback: (_, response) => setState(() {
                    _isSelected = response?.touchedSpot != null;
                  }),
                ),
              ),
            ),
          ),
          Slider(value: _value, onChanged: (v) => setState(() => _value = v)),
        ],
      ),
    );
  }
}
