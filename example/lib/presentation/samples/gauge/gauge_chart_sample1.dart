import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


class GaugeChartSample1 extends StatefulWidget {
  const GaugeChartSample1({super.key});

  @override
  State<StatefulWidget> createState() => GaugeChartSample1State();
}

class GaugeChartSample1State extends State {
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
                valueColor: VariableGaugeColor(
                  colors: [AppColors.contentColorYellow, AppColors.contentColorBlue, AppColors.contentColorRed],
                  limits: [0.35, 0.5],
                ),
                backgroundColor: AppColors.contentColorPurple.withOpacity(_isSelected ? 0.2 : 1),
                strokeWidth: 30,
                startAngle: 45,
                endAngle: -225,
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
                  touchCallback: (_, value) => setState(() {
                    _isSelected = value?.spot != null;
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