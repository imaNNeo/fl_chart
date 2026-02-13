import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:flutter/material.dart';

class GaugeChartSample3 extends StatefulWidget {
  const GaugeChartSample3({super.key});

  @override
  State<StatefulWidget> createState() => GaugeChartSample3State();
}

class GaugeChartSample3State extends State {
  double _value = 0.6;

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
                backgroundColor:
                    AppColors.contentColorPurple.withValues(alpha: 0.2),
                strokeWidth: 30,
                startAngle: -225,
                endAngle: 45,
                strokeCap: StrokeCap.round,
                ticks: const GaugeTicks(
                  count: 11,
                  color: AppColors.contentColorCyan,
                  radius: 5,
                  position: GaugeTickPosition.inner,
                  margin: 5,
                  showChangingColorTicks: false,
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
