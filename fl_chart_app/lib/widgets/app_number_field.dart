import 'package:fl_chart_app/resources/app_texts.dart';
import 'package:fl_chart_app/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class AppDoubleNumberField extends StatefulWidget {
  final String label;
  final double? initialData;
  final ValueChanged<double>? onSubmit;
  final ValueChanged<double>? onValueChanged;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  const AppDoubleNumberField({
    Key? key,
    this.label = 'value',
    this.initialData,
    this.onSubmit,
    this.onValueChanged,
    this.focusNode,
    this.controller,
  }) : super(key: key);

  @override
  _AppDoubleNumberFieldState createState() => _AppDoubleNumberFieldState();
}

class _AppDoubleNumberFieldState extends State<AppDoubleNumberField> {
  late TextEditingController _controller;
  String? error;

  @override
  void initState() {
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
    }
    _controller.text = (widget.initialData ?? 0.0).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      controller: _controller,
      error: error,
      onFieldSubmitted: widget.onSubmit == null ? null : (text) {
        try {
          final value = double.parse(text);
          widget.onSubmit!(value);
          setState(() {
            error = null;
          });
        } catch (e) {
          setState(() {
            error = AppTexts.textToNumberParseError;
          });
        }
      },
      onTextChange: widget.onValueChanged == null ? null : (text) {
        try {
          final value = double.parse(text);
          widget.onValueChanged!(value);
          setState(() {
            error = null;
          });
        } catch (e) {
          setState(() {
            error = AppTexts.textToNumberParseError;
          });
        }
      },
      focusNode: widget.focusNode,
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      // We created this _controller
      _controller.dispose();
    }
    super.dispose();
  }
}
