import 'package:flutter/material.dart';

import 'api.dart';
import 'dart_code.dart';
import 'hints.dart';
import 'theme.dart';

/// The control of a property, chosen from its type.
class PropertyEditor extends StatelessWidget {
  const PropertyEditor({
    required this.spec,
    required this.hint,
    required this.value,
    required this.onChanged,
    required this.onReset,
    super.key,
  });

  final PropertySpec spec;
  final PropertyHint? hint;

  /// The current value, a [Preset] if it was picked from [PropertyHint.presets].
  final Object? value;

  final ValueChanged<Object?> onChanged;

  /// Goes back to the value of the demo.
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final presets = hint?.presets;
    if (presets != null) {
      return _PresetEditor(
        presets: presets,
        value: value,
        defaultLabel: spec.defaultCode ?? 'default',
        onChanged: onChanged,
        onReset: onReset,
      );
    }
    // A missing minX/maxX/... is stored as NaN.
    final current = value is double && (value! as double).isNaN ? null : value;
    final isNullable = spec.isNullable && (hint?.nullable ?? true);
    return switch (spec.kind) {
      PropertyKind.boolean => Row(
        children: [
          Switch(value: current == true, onChanged: onChanged),
          const SizedBox(width: 12),
          _CodeText('$current'),
        ],
      ),
      PropertyKind.integer || PropertyKind.decimal => _NumberEditor(
        spec: spec,
        hint: hint,
        isNullable: isNullable,
        value: current as num?,
        onChanged: onChanged,
      ),
      PropertyKind.text => _TextEditor(
        value: current as String? ?? '',
        onChanged: onChanged,
      ),
      PropertyKind.color => _ColorEditor(
        value: current as Color?,
        isNullable: isNullable,
        onChanged: onChanged,
      ),
      PropertyKind.enumeration => _EnumEditor(
        spec: spec,
        isNullable: isNullable,
        value: current as Enum?,
        onChanged: onChanged,
      ),
      PropertyKind.nested => _Note(
        '${spec.name} is a ${spec.nestedType}, try its own properties in '
        'the docs.',
      ),
      PropertyKind.other => _Note(
        'There is no control for a ${spec.type} yet.',
      ),
    };
  }
}

class _NumberEditor extends StatelessWidget {
  const _NumberEditor({
    required this.spec,
    required this.hint,
    required this.isNullable,
    required this.value,
    required this.onChanged,
  });

  final PropertySpec spec;
  final PropertyHint? hint;
  final bool isNullable;
  final num? value;
  final ValueChanged<Object?> onChanged;

  bool get _isInteger => spec.kind == PropertyKind.integer;

  @override
  Widget build(BuildContext context) {
    final min = hint?.min;
    final max = hint?.max;
    if (min == null || max == null) {
      return _TextEditor(
        value: value == null ? '' : '$value',
        keyboardType: TextInputType.number,
        onChanged: (text) {
          final parsed = _isInteger
              ? int.tryParse(text)
              : double.tryParse(text);
          if (parsed != null || isNullable) onChanged(parsed);
        },
      );
    }
    return Row(
      children: [
        Expanded(
          child: Slider(
            value: (value ?? (min + max) / 2).toDouble().clamp(min, max),
            min: min,
            max: max,
            divisions: _isInteger ? (max - min).round() : null,
            onChanged: value == null
                ? null
                : (v) => onChanged(_isInteger ? v.round() : v),
          ),
        ),
        SizedBox(
          width: 52,
          child: _CodeText(dartCode(value, isDouble: !_isInteger)),
        ),
        if (isNullable)
          FilterChip(
            label: const Text('null'),
            selected: value == null,
            onSelected: (isNull) {
              final middle = (min + max) / 2;
              onChanged(isNull ? null : (_isInteger ? middle.round() : middle));
            },
          ),
      ],
    );
  }
}

class _TextEditor extends StatefulWidget {
  const _TextEditor({
    required this.value,
    required this.onChanged,
    this.keyboardType,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;

  @override
  State<_TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<_TextEditor> {
  late final _controller = TextEditingController(text: widget.value);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: _controller,
    keyboardType: widget.keyboardType,
    minLines: 1,
    maxLines: widget.keyboardType == null ? 3 : 1,
    style: const TextStyle(fontFamily: monoFontFamily, fontSize: 14),
    decoration: const InputDecoration(
      isDense: true,
      border: OutlineInputBorder(),
    ),
    onChanged: widget.onChanged,
  );
}

class _ColorEditor extends StatelessWidget {
  const _ColorEditor({
    required this.value,
    required this.isNullable,
    required this.onChanged,
  });

  final Color? value;
  final bool isNullable;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final color in namedColors.keys)
        _Swatch(
          color: color,
          tooltip: namedColors[color]!,
          isSelected: value?.toARGB32() == color.toARGB32(),
          onTap: () => onChanged(color),
        ),
      if (isNullable)
        _Swatch(
          tooltip: 'null',
          isSelected: value == null,
          onTap: () => onChanged(null),
        ),
    ],
  );
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.tooltip,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  final Color? color;
  final String tooltip;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : AppColors.border,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: color == null
            ? const Icon(Icons.block, size: 16, color: AppColors.muted)
            : null,
      ),
    ),
  );
}

class _EnumEditor extends StatelessWidget {
  const _EnumEditor({
    required this.spec,
    required this.isNullable,
    required this.value,
    required this.onChanged,
  });

  final PropertySpec spec;
  final bool isNullable;
  final Enum? value;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) => DropdownButton<Enum?>(
    value: value,
    isExpanded: true,
    style: _codeStyle,
    items: [
      if (isNullable) const DropdownMenuItem(value: null, child: Text('null')),
      for (final item in spec.values!)
        DropdownMenuItem(value: item, child: Text('$item')),
    ],
    onChanged: onChanged,
  );
}

class _PresetEditor extends StatelessWidget {
  const _PresetEditor({
    required this.presets,
    required this.value,
    required this.defaultLabel,
    required this.onChanged,
    required this.onReset,
  });

  final List<Preset> presets;
  final Object? value;
  final String defaultLabel;
  final ValueChanged<Object?> onChanged;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) => DropdownButton<Preset?>(
    value: value is Preset ? value! as Preset : null,
    isExpanded: true,
    style: _codeStyle,
    items: [
      DropdownMenuItem(
        child: Text(defaultLabel, overflow: TextOverflow.ellipsis),
      ),
      for (final preset in presets)
        DropdownMenuItem(
          value: preset,
          child: Text(preset.code, overflow: TextOverflow.ellipsis),
        ),
    ],
    onChanged: (preset) => preset == null ? onReset() : onChanged(preset),
  );
}

class _Note extends StatelessWidget {
  const _Note(this.text);

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: const TextStyle(color: AppColors.muted));
}

class _CodeText extends StatelessWidget {
  const _CodeText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(text, style: _codeStyle);
}

const _codeStyle = TextStyle(
  fontFamily: monoFontFamily,
  fontSize: 13,
  color: Colors.white,
);
