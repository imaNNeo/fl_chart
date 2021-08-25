import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/pages/widgets/color_indicator.dart';
import 'package:fl_chart_app/resources/app_resources.dart';
import 'package:fl_chart_app/widgets/app_number_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

Future<double> showDoubleDialog(
  BuildContext context,
  String name,
  double value, {
  ValueChanged<double>? onHotChange,
}) async {
  final newData = await showDialog<double>(
    context: context,
    builder: (BuildContext context) {
      return _DoubleEditorDialog(
        data: value,
        name: name,
        onHotChange: onHotChange,
      );
    },
  );

  if (newData == null) {
    return value;
  }

  return newData;
}

class _DoubleEditorDialog extends StatefulWidget {
  final String name;
  final double data;
  final ValueChanged<double>? onHotChange;

  const _DoubleEditorDialog({
    Key? key,
    required this.name,
    required this.data,
    this.onHotChange,
  }) : super(key: key);

  @override
  _DoubleEditorDialogState createState() => _DoubleEditorDialogState();
}

class _DoubleEditorDialogState extends State<_DoubleEditorDialog> {

  late double _showingValue;
  late FocusNode _focusNode;
  late TextEditingController _controller;

  @override
  void initState() {
    _showingValue = widget.data;
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if(_focusNode.hasFocus) {
        _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.defaultRadius)),
      child: Container(
        width: 200,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppDoubleNumberField(
                label: widget.name,
                initialData: _showingValue,
                onSubmit: _submitValue,
                onValueChanged: (newValue) {
                  _showingValue = newValue;
                  if (widget.onHotChange != null) {
                    widget.onHotChange!(newValue);
                  }
                },
                focusNode: _focusNode,
                controller: _controller,
              ),
              SizedBox(
                height: 16,
              ),
              TextButton(
                onPressed: () {
                  _submitValue(_showingValue);
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitValue(double newValue) {
    Navigator.of(context).pop(newValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

Future<ScatterSpot?> showScatterSpotDialog(
  BuildContext context,
  ScatterSpot spot, {
  ValueChanged<ScatterSpot>? onHotChange,
}) => showDialog<ScatterSpot>(
  context: context,
  builder: (BuildContext context) {
    return _ScatterSpotEditorDialog(
      data: spot,
      onHotChange: onHotChange,
    );
  },
);

class _ScatterSpotEditorDialog extends StatefulWidget {
  final ScatterSpot data;
  final ValueChanged<ScatterSpot>? onHotChange;

  const _ScatterSpotEditorDialog({
    Key? key,
    required this.data,
    this.onHotChange,
  }) : super(key: key);

  @override
  _ScatterSpotEditorDialogState createState() => _ScatterSpotEditorDialogState();
}

class _ScatterSpotEditorDialogState extends State<_ScatterSpotEditorDialog> {

  late ScatterSpot _showingSpot;

  late TextEditingController _xController, _yController, _radiusController;
  late FocusNode _xFocusNode, _yFocusNode, _radiusFocusNode;

  @override
  void initState() {
    _showingSpot = widget.data;
    _xController = TextEditingController();
    _yController = TextEditingController();
    _radiusController = TextEditingController();

    _xFocusNode = FocusNode();
    _xFocusNode.addListener(() {
      if (_xFocusNode.hasFocus) {
        _xController.selection = TextSelection(baseOffset: 0, extentOffset: _xController.text.length);
      }
    });

    _yFocusNode = FocusNode();
    _yFocusNode.addListener(() {
      if (_yFocusNode.hasFocus) {
        _yController.selection = TextSelection(baseOffset: 0, extentOffset: _yController.text.length);
      }
    });

    _radiusFocusNode = FocusNode();
    _radiusFocusNode.addListener(() {
      if (_radiusFocusNode.hasFocus) {
        _radiusController.selection = TextSelection(baseOffset: 0, extentOffset: _radiusController.text.length);
      }
    });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        width: 200,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('ScatterSpot'),
              SizedBox(height: 14),
              AppDoubleNumberField(
                label: 'x',
                initialData: _showingSpot.x,
                onValueChanged: (double number) {
                  if (widget.onHotChange != null) {
                    _showingSpot = _showingSpot.copyWith(x: number);
                    widget.onHotChange!(_showingSpot);
                  }
                },
                onSubmit: (value) => _onSubmit(),
                controller: _xController,
                focusNode: _xFocusNode,
              ),
              SizedBox(height: 8),
              AppDoubleNumberField(
                label: 'y',
                initialData: _showingSpot.y,
                onValueChanged: (double number) {
                  if (widget.onHotChange != null) {
                    _showingSpot = _showingSpot.copyWith(y: number);
                    widget.onHotChange!(_showingSpot);
                  }
                },
                onSubmit: (value) => _onSubmit(),
                controller: _yController,
                focusNode: _yFocusNode,
              ),
              SizedBox(height: 8),
              AppDoubleNumberField(
                label: 'radius',
                initialData: _showingSpot.radius,
                onValueChanged: (double number) {
                  if (widget.onHotChange != null) {
                    _showingSpot = _showingSpot.copyWith(radius: number);
                    widget.onHotChange!(_showingSpot);
                  }
                },
                onSubmit: (value) => _onSubmit(),
                controller: _radiusController,
                focusNode: _radiusFocusNode,
              ),
              SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('color: '),
                  SizedBox(
                    width: 8,
                  ),
                  ColorIndicator(
                    color: _showingSpot.color,
                    onChanged: (newColor) {
                      setState(() {
                        _showingSpot = _showingSpot.copyWith(color: newColor);
                        if (widget.onHotChange != null) {
                          widget.onHotChange!(_showingSpot);
                        }
                      });
                    },
                  )
                ],
              ),
              TextButton(
                onPressed: _onSubmit,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    Navigator.of(context).pop(_showingSpot);
  }
}

Future<Color> showColorPickerDialog(BuildContext context, {Color defaultColor = Colors.black}) async {
  final color = await showDialog<Color>(
    context: context,
    builder: (context) {
      return _ColorPickerDialog(defaultColor: defaultColor);
    },
  );

  if (color == null) {
    throw StateError('Result color must not be null');
  }

  return color;
}

class _ColorPickerDialog extends StatefulWidget {
  final Color defaultColor;

  const _ColorPickerDialog({Key? key, required this.defaultColor}) : super(key: key);

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color _showingColor;

  @override
  void initState() {
    super.initState();
    _showingColor = widget.defaultColor;
  }

  // ValueChanged<Color> callback
  void _changeColor(Color color) {
    setState(() => _showingColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: MaterialColorPicker(onColorChange: _changeColor, selectedColor: _showingColor),
        // Use Material color picker:
        //
        // child: MaterialPicker(
        //   pickerColor: pickerColor,
        //   onColorChanged: changeColor,
        //   showLabel: true, // only on portrait mode
        // ),
        //
        // Use Block color picker:
        //
        // child: BlockPicker(
        //   pickerColor: currentColor,
        //   onColorChanged: changeColor,
        // ),
        //
        // child: MultipleChoiceBlockPicker(
        //   pickerColors: currentColors,
        //   onColorsChanged: changeColors,
        // ),
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('Got it'),
          onPressed: () {
            Navigator.of(context).pop(_showingColor);
          },
        ),
      ],
    );
  }
}

class ContextMenuOption {
  final String title;
  final VoidCallback onClick;

  ContextMenuOption(this.title, this.onClick);
}

void showContextMenu(BuildContext context, Offset position, List<ContextMenuOption> options) async {
  final overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
  final index = await showMenu<int>(
    context: context,
    items: options.asMap().entries.map((entry) {
      return PopupMenuItem(child: Text(entry.value.title), value: entry.key);
    }).toList(),
    position: RelativeRect.fromSize(
      position & Size(48.0, 48.0),
      overlay.size,
    ),
  );
  if (index != null) {
    options[index].onClick();
  }
}