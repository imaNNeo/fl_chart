import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:flutter/material.dart';

/// Multi-ring ("Apple Watch"-style) gauge. Three concentric progress
/// rings, each tracking its own value against the same 0..1 scale.
/// Sections are listed innermost-first; the slider drives the
/// innermost ring, the outer two are fixed.
class GaugeChartSample2 extends StatefulWidget {
  const GaugeChartSample2({super.key});

  @override
  State<GaugeChartSample2> createState() => _GaugeChartSample2State();
}

class _GaugeChartSample2State extends State<GaugeChartSample2> {
  int _touchedRingIndex = -1;

  static const _items = <(double, Color)>[
    (20, AppColors.contentColorPink),
    (40, AppColors.contentColorRed),
    (55, AppColors.contentColorOrange),
    (70, AppColors.contentColorGreen),
    (95, AppColors.contentColorBlue),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: SizedBox(
        width: 250,
        height: 250,
        child: Stack(
          children: [
            GaugeChart(
              GaugeChartData(
                minValue: 0,
                maxValue: 100,
                startDegreeOffset: -225,
                sweepAngle: 270,
                defaultRingWidth: 20,
                ringsSpace: 4,
                rings: _items.asMap().entries.map((e) {
                  final index = e.key;
                  final value = e.value.$1;
                  Color color = e.value.$2;
                  if (_touchedRingIndex != -1) {
                    color = index == _touchedRingIndex
                        ? color.withValues(alpha: 1)
                        : color.withValues(alpha: 0.3);
                  }
                  return GaugeProgressRing(
                    value: value,
                    color: color,
                    backgroundColor: AppColors.contentColorWhite12,
                    strokeCap: StrokeCap.round,
                  );
                }).toList(),
                touchData: GaugeTouchData(
                  enabled: true,
                  touchCallback: _onTouchCallback,
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.75),
              child: _TouchedRingAnimatedText(
                value: _touchedRingIndex != -1
                    ? _items[_touchedRingIndex].$1.toInt()
                    : 0,
                color: _touchedRingIndex != -1
                    ? _items[_touchedRingIndex].$2
                    : AppColors.contentColorWhite12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTouchCallback(FlTouchEvent event, GaugeTouchResponse? response) {
    setState(() {
      final touchedRing = response?.touchedRing;
      if (event.isInterestedForInteractions && touchedRing != null) {
        _touchedRingIndex = touchedRing.touchedRingIndex;
      } else {
        _touchedRingIndex = -1;
      }
    });
  }
}

class _TouchedRingAnimatedText extends ImplicitlyAnimatedWidget {
  final int value;
  final Color color;

  const _TouchedRingAnimatedText({
    required this.value,
    required this.color,
    super.duration = const Duration(milliseconds: 250),
  });

  @override
  ImplicitlyAnimatedWidgetState<_TouchedRingAnimatedText> createState() =>
      _TouchedRingAnimatedTextState();
}

class _TouchedRingAnimatedTextState
    extends AnimatedWidgetBaseState<_TouchedRingAnimatedText> {
  IntTween? _valueTween;
  ColorTween? _colorTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _valueTween = visitor(
      _valueTween,
      widget.value,
      (dynamic value) => IntTween(begin: value as int),
    ) as IntTween;
    _colorTween = visitor(
      _colorTween,
      widget.color,
      (dynamic value) => ColorTween(begin: value as Color),
    ) as ColorTween;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _valueTween!.evaluate(animation).toInt().toString(),
      style: TextStyle(
        fontSize: 32,
        color: _colorTween!.evaluate(animation),
      ),
    );
  }
}

