import 'package:fl_chart_app/pages/editor/dialogs/editor_dialogs.dart';
import 'package:flutter/material.dart';

class ColorIndicator extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Function(Color)? onChanged;

  const ColorIndicator({
    Key? key,
    required this.color,
    this.width = 18,
    this.height = 18,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged == null ? null : () async {
        final newColor = await showColorPickerDialog(context, defaultColor: color);
        onChanged!(newColor);
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: color,
          border: color.opacity == 0 ? Border.all(color: Colors.white60, width: 0.5) : null,
        ),
      ),
    );
  }
}
