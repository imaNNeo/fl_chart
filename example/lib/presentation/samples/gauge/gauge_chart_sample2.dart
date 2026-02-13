import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:flutter/material.dart';

class GaugeChartSample2 extends StatefulWidget {
  const GaugeChartSample2({super.key});

  @override
  State<StatefulWidget> createState() => GaugeChartSample2State();
}

class GaugeChartSample2State extends State {
  double _value = 0.5;

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
                valueColor:
                    GaugeColor.simple(color: AppColors.contentColorYellow),
                backgroundColor:
                    AppColors.contentColorPurple.withValues(alpha: 0.2),
                strokeWidth: 30,
                startDegreeOffset: -225,
                sweepAngle: 270,
                direction: GaugeDirection.clockwise,
                strokeCap: StrokeCap.butt,
                ticks: const GaugeTicks(
                  count: 11,
                  color: AppColors.contentColorCyan,
                  radius: 5,
                  position: GaugeTickPosition.inner,
                  margin: 5,
                ),
                touchData: GaugeTouchData(
                  enabled: true,
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
