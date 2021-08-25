import 'package:fl_chart_app/pages/widgets/color_indicator.dart';
import 'package:fl_chart_app/resources/app_resources.dart';
import 'package:flutter/material.dart';

class TextNodeWidget extends StatelessWidget {
  final String text;

  const TextNodeWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppStyles.editorPanelTextStyle,
    );
  }
}

class BoolNodeWidget extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onValueChanged;

  const BoolNodeWidget(this.title, this.value, this.onValueChanged);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: AppDimens.editorPanelBoxesSize,
          height: AppDimens.editorPanelBoxesSize,
          child: Checkbox(
            value: value,
            activeColor: AppColors.flCyan,
            checkColor: AppColors.holdersBackground,
            onChanged: (newValue) {
              if (newValue != null) {
                onValueChanged(newValue);
              }
            },
          ),
        ),
        SizedBox(width: 4),
        Text(
          title,
          style: AppStyles.editorPanelTextStyle,
        ),
      ],
    );
  }
}

class ColorNodeWidget extends StatelessWidget {
  final String title;
  final Color value;

  const ColorNodeWidget(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ColorIndicator(color: value),
        SizedBox(width: 6),
        Text(
          title,
          style: AppStyles.editorPanelTextStyle,
        ),
      ],
    );
  }
}

class IntNodeWidget extends StatelessWidget {
  final String title;
  final int value;

  const IntNodeWidget(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title.isEmpty ? '$value' : '$title: $value',
          style: AppStyles.editorPanelTextStyle,
        ),
      ],
    );
  }
}

class DoubleNodeWidget extends StatelessWidget {
  final String title;
  final double value;

  const DoubleNodeWidget(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$title: $value',
          style: AppStyles.editorPanelTextStyle,
        ),
      ],
    );
  }
}

class NullableDoubleNodeWidget extends StatelessWidget {
  final String title;
  final double? value;
  final Function(double?) onValueChanged;

  const NullableDoubleNodeWidget(
    this.title,
    this.value,
    this.onValueChanged,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$title: $value',
          style: AppStyles.editorPanelTextStyle,
        ),
      ],
    );
  }
}

class EdgeInsetsNodeWidget extends StatelessWidget {
  final String title;
  final EdgeInsets value;
  final Function(EdgeInsets) onValueChanged;

  const EdgeInsetsNodeWidget(
    this.title,
    this.value,
    this.onValueChanged,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$title: $value',
          style: AppStyles.editorPanelTextStyle,
        ),
      ],
    );
  }
}

class BorderNodeWidget extends StatelessWidget {
  final String title;
  final Border value;
  final Function(Border) onValueChanged;

  const BorderNodeWidget(
    this.title,
    this.value,
    this.onValueChanged,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppStyles.editorPanelTextStyle,
        ),
      ],
    );
  }
}
