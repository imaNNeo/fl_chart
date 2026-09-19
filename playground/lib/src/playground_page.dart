import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../generated/api_registry.g.dart';
import 'api.dart';
import 'dart_code.dart';
import 'hints.dart';
import 'hosts.dart';
import 'property_editor.dart';
import 'theme.dart';

/// The class and property to show, from the URL: `#/LineChartBarData/isCurved`.
@immutable
class PlaygroundTarget {
  const PlaygroundTarget(this.className, [this.property]);

  factory PlaygroundTarget.fromUri(Uri uri) {
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    return PlaygroundTarget(
      segments.elementAtOrNull(0),
      segments.elementAtOrNull(1),
    );
  }

  final String? className;
  final String? property;

  @override
  bool operator ==(Object other) =>
      other is PlaygroundTarget &&
      other.className == className &&
      other.property == property;

  @override
  int get hashCode => Object.hash(className, property);
}

/// Shows a live chart of a documented class, with a control to change one of
/// its properties, and the code of the result.
class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({required this.target, super.key});

  final PlaygroundTarget target;

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  ClassSpec? _spec;
  Host? _host;
  PropertySpec? _property;
  PropertyHint? _hint;

  /// The demo instance of the class, before any change.
  Object? _instance;

  /// The properties changed from [_instance], values can be [Preset]s.
  var _values = <String, Object?>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(PlaygroundPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.target != widget.target) _load();
  }

  void _load() {
    final className = widget.target.className;
    _spec = apiRegistry[className];
    _host = hosts[className];
    _property = _spec?.property(widget.target.property ?? '');
    _hint = hints['$className.${_property?.name}'];
    _instance = _host?.instance();
    _values = {...?_hint?.requires};
  }

  @override
  Widget build(BuildContext context) {
    final spec = _spec;
    final host = _host;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: spec == null || host == null
                ? const _Message('Pick a property in the docs to try it here.')
                : _content(spec, host),
          ),
        ),
      ),
    );
  }

  Widget _content(ClassSpec spec, Host host) {
    final property = _property;
    final chart = _buildChart(spec, host);
    final note = _hint?.note ?? host.note;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          spec.name,
          style: const TextStyle(color: AppColors.muted, fontSize: 13),
        ),
        const SizedBox(height: 2),
        if (property == null)
          const Text('Pick a property in the docs to try it here.')
        else ...[
          Text(
            property.name,
            style: const TextStyle(
              fontFamily: monoFontFamily,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          Text(
            [
              property.type,
              if (property.isRequired) 'required',
              if (property.defaultCode != null)
                'default ${property.defaultCode}',
            ].join('  ·  '),
            style: const TextStyle(
              fontFamily: monoFontFamily,
              fontSize: 12,
              color: AppColors.muted,
            ),
          ),
        ],
        const SizedBox(height: 16),
        _Card(
          padding: const EdgeInsets.fromLTRB(4, 28, 20, 8),
          child: SizedBox(height: 220, child: chart),
        ),
        if (note != null) ...[
          const SizedBox(height: 8),
          Text(note, style: const TextStyle(color: AppColors.muted)),
        ],
        if (property != null) ...[
          const SizedBox(height: 16),
          _Card(
            child: PropertyEditor(
              key: ValueKey(widget.target),
              spec: property,
              hint: _hint,
              value: _value(spec, property),
              onChanged: (value) =>
                  setState(() => _values = {..._values, property.name: value}),
              onReset: () => setState(() {
                _values = {..._values}..remove(property.name);
              }),
            ),
          ),
          const SizedBox(height: 16),
          _CodeCard(code: _code(spec, property)),
        ],
      ],
    );
  }

  Object? _value(ClassSpec spec, PropertySpec property) =>
      _values.containsKey(property.name)
      ? _values[property.name]
      : spec.read?.call(_instance!, property.name);

  Widget _buildChart(ClassSpec spec, Host host) {
    try {
      final values = {
        for (final MapEntry(:key, :value) in _values.entries)
          key: value is Preset ? value.value : value,
      };
      final instance = spec.copy?.call(_instance!, values) ?? _instance!;
      return host.build(instance);
    } on Object catch (error) {
      return _Message('This value is not valid:\n$error');
    }
  }

  String _code(ClassSpec spec, PropertySpec property) => constructorCode(
    spec,
    {..._values, property.name: _value(spec, property)},
    fallbackCodes: {property.name: property.defaultCode ?? '...'},
  );
}

class _CodeCard extends StatelessWidget {
  const _CodeCard({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 12, 44, 12),
        decoration: BoxDecoration(
          color: AppColors.codeBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: SelectableText(
          code,
          style: const TextStyle(
            fontFamily: monoFontFamily,
            fontSize: 13,
            height: 1.5,
            color: Colors.white,
          ),
        ),
      ),
      Positioned(
        top: 4,
        right: 4,
        child: IconButton(
          tooltip: 'Copy',
          icon: const Icon(Icons.copy, size: 16, color: AppColors.muted),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: code));
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Copied')));
          },
        ),
      ),
    ],
  );
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding = const EdgeInsets.all(12)});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    child: child,
  );
}

class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppColors.muted),
      ),
    ),
  );
}
