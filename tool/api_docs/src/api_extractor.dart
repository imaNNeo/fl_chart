import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:path/path.dart' as p;

import 'api_model.dart';

/// Reads the public API of `package:fl_chart` (types, defaults and dartdoc)
/// using the analyzer, so the dartdoc stays the single source of truth.
class ApiExtractor {
  ApiExtractor._(this._session, this._library, this._templates);

  static Future<ApiExtractor> create(String packageRoot) async {
    final libDir = p.join(packageRoot, 'lib');
    final collection = AnalysisContextCollection(includedPaths: [libDir]);
    final session = collection.contextFor(libDir).currentSession;
    final result =
        await session.getLibraryByUri('package:fl_chart/fl_chart.dart');
    if (result is! LibraryElementResult) {
      throw StateError('Could not resolve package:fl_chart: $result');
    }
    return ApiExtractor._(session, result.element, _readTemplates(libDir));
  }

  final AnalysisSession _session;
  final LibraryElement _library;

  /// `{@template name}` bodies, used to expand `{@macro name}`.
  final Map<String, String> _templates;

  final _units = <String, CompilationUnit>{};

  /// Problems found while extracting; the caller fails if it's not empty.
  final errors = <String>[];

  /// Extracts [name], or returns null (and records an error) if [name] is not
  /// a class or enum exported by `package:fl_chart`.
  ///
  /// [isDocumented] tells whether a type has its own section in the docs, so
  /// its fields are not repeated in the tables of its subclasses.
  Future<ApiType?> extract(
    String name,
    TableMode? mode, {
    required bool Function(String typeName) isDocumented,
  }) async {
    final element = _library.exportNamespace.get2(name);
    if (element is EnumElement) {
      return ApiType(
        name: name,
        mode: TableMode.enumValues,
        members: [
          for (final constant in element.constants)
            ApiMember(
              name: constant.name!,
              doc: _doc(name, constant.name!, constant),
            ),
        ],
      );
    }
    if (element is! ClassElement) {
      errors.add('$name: not a class or enum exported by package:fl_chart');
      return null;
    }
    return switch (mode ?? TableMode.constructor) {
      TableMode.fields => _fieldsType(element, isDocumented),
      _ => _constructorType(element),
    };
  }

  Future<ApiType?> _constructorType(ClassElement cls) async {
    final name = cls.name!;
    final ctor = cls.unnamedConstructor;
    if (ctor == null) {
      errors.add('$name: has no unnamed constructor, use the `fields` mode');
      return null;
    }
    final members = <ApiMember>[];
    for (final param in ctor.formalParameters) {
      final paramName = param.name!;
      final field = _findField(cls, paramName);
      members.add(
        ApiMember(
          name: paramName,
          type: param.type.getDisplayString(),
          defaultValue: await _defaultValue(param, ctor),
          isRequired: param.isRequired,
          deprecationMessage: _deprecation(param) ?? _deprecation(field),
          doc: _doc(name, paramName, field ?? param),
        ),
      );
    }
    return ApiType(name: name, mode: TableMode.constructor, members: members);
  }

  ApiType _fieldsType(
    ClassElement cls,
    bool Function(String typeName) isDocumented,
  ) {
    // Superclasses first, like the fields read top-down in the docs, up to
    // the first one that has its own section.
    final chain = <InterfaceElement>[];
    String? inheritsFrom;
    for (InterfaceElement? c = cls; c != null && _isFlChart(c);) {
      if (c != cls && isDocumented(c.name!)) {
        inheritsFrom = c.name;
        break;
      }
      chain.insert(0, c);
      c = c.supertype?.element;
    }
    return ApiType(
      name: cls.name!,
      mode: TableMode.fields,
      inheritsFrom: inheritsFrom,
      members: [
        for (final c in chain)
          for (final field in c.fields)
            if (field.isOriginDeclaration && field.isPublic && !field.isStatic)
              ApiMember(
                name: field.name!,
                type: field.type.getDisplayString(),
                deprecationMessage: _deprecation(field),
                doc: _doc(cls.name!, field.name!, _findField(cls, field.name!)),
              ),
      ],
    );
  }

  bool _isFlChart(Element element) =>
      element.library?.uri.pathSegments.firstOrNull == 'fl_chart';

  /// The field (or getter) called [name] in [cls] or its supertypes that has
  /// a dartdoc (so `minX` of a `LineChartData` is documented by
  /// `AxisChartData.minX`).
  Element? _findField(InterfaceElement cls, String name) {
    Element? found;
    for (final type in [cls, ...cls.allSupertypes.map((t) => t.element)]) {
      for (final element in [type.getField(name), type.getGetter(name)]) {
        if (element == null) continue;
        found ??= element;
        if ((element.documentationComment ?? '').trim().isNotEmpty) {
          return element;
        }
      }
    }
    return found;
  }

  String? _deprecation(Element? element) {
    if (element == null || !element.metadata.hasDeprecated) return null;
    for (final annotation in element.metadata.annotations) {
      if (!annotation.isDeprecated) continue;
      final value = annotation.computeConstantValue();
      return value?.getField('message')?.toStringValue() ?? '';
    }
    return '';
  }

  /// Resolves what the user gets when they omit [param]:
  /// - its declared default (`this.barWidth = 2.0`),
  /// - the default of the super constructor parameter (`super.gridData`),
  /// - `field = param ?? value` in the initializer list,
  /// - or a getter like `get radius => _radius ?? value`.
  /// Returns null when the default depends on other parameters.
  Future<String?> _defaultValue(
    FormalParameterElement param,
    ConstructorElement ctor,
  ) async {
    if (param.isRequired) return null;
    final code = param.defaultValueCode;
    if (code != null) {
      // `stepDirectionMiddle` reads as `LineChartStepData.stepDirectionMiddle`.
      final isStatic = ctor.enclosingElement.getField(code)?.isStatic ?? false;
      return isStatic ? '${ctor.enclosingElement.name}.$code' : code;
    }
    if (param is SuperFormalParameterElement) {
      final superParam = param.superConstructorParameter;
      final superCtor = superParam?.enclosingElement;
      if (superParam != null && superCtor is ConstructorElement) {
        return _defaultValue(superParam, superCtor);
      }
    }
    final node = await _declarationNode(ctor);
    final initializers = node is ConstructorDeclaration
        ? node.initializers
        : const <ConstructorInitializer>[];
    for (final initializer in initializers) {
      if (initializer is! ConstructorFieldInitializer) continue;
      final expression = initializer.expression;
      if (expression is! BinaryExpression ||
          expression.operator.lexeme != '??' ||
          expression.leftOperand.toSource() != param.name) {
        continue;
      }
      final fallback = expression.rightOperand.toSource();
      final dependsOnOtherParams = ctor.formalParameters.any(
        (other) => RegExp('\\b${other.name}\\b').hasMatch(fallback),
      );
      return dependsOnOtherParams ? null : fallback;
    }
    final getter = ctor.enclosingElement.getGetter(param.name!);
    final getterNode = getter == null ? null : await _declarationNode(getter);
    if (getterNode is MethodDeclaration) {
      final body = getterNode.body;
      final expression =
          body is ExpressionFunctionBody ? body.expression : null;
      if (expression is BinaryExpression &&
          expression.operator.lexeme == '??') {
        return expression.rightOperand.toSource();
      }
    }
    return param.type.nullabilitySuffix == NullabilitySuffix.question
        ? 'null'
        : null;
  }

  /// The AST node that declares [element] (only for declarations in lib/).
  Future<Declaration?> _declarationNode(Element element) async {
    final path = element.library?.firstFragment.source.fullName;
    if (path == null) return null;
    var unit = _units[path];
    if (unit == null) {
      final result = await _session.getResolvedUnit(path);
      if (result is! ResolvedUnitResult) return null;
      unit = _units[path] = result.unit;
    }
    final finder = _DeclarationFinder(element.firstFragment.offset);
    unit.accept(finder);
    return finder.found;
  }

  DocText _doc(String owner, String member, Element? element) {
    final raw = element?.documentationComment;
    final markdown = raw == null ? '' : _cleanComment(raw);
    if (markdown.isEmpty) {
      errors.add('$owner.$member: missing dartdoc');
      return DocText('', const {});
    }
    final references = <String, Element>{};
    for (final ref in referencesIn(markdown)) {
      final resolved = _resolve(ref, element!);
      if (resolved == null) {
        errors.add('$owner.$member: unresolved dartdoc reference [$ref]');
      } else {
        references[ref] = resolved;
      }
    }
    return DocText(markdown, references);
  }

  /// Strips `///`, expands `{@macro}` and drops `{@template}` tags.
  String _cleanComment(String raw) {
    final text = _stripCommentMarkers(raw);
    return text
        .replaceAllMapped(RegExp(r'\{@macro\s+([\w.]+)\}'), (m) {
          final template = _templates[m[1]];
          if (template == null) errors.add('unknown {@macro ${m[1]}}');
          return template ?? '';
        })
        .replaceAll(RegExp(r'\{@template\s+[\w.]+\}|\{@endtemplate\}'), '')
        .trim();
  }

  /// Resolves `[Foo]`, `[foo]` or `[Foo.bar]` the way dartdoc does: first as
  /// a member of the enclosing type, then from the library scope.
  Element? _resolve(String ref, Element context) {
    final parts = ref.split('.');
    final enclosingType = context.thisOrAncestorOfType<InterfaceElement>();
    var current =
        enclosingType == null ? null : _member(enclosingType, parts.first);
    current ??= context.library?.firstFragment.scope.lookup(parts.first).getter;
    for (final part in parts.skip(1)) {
      if (current is! InterfaceElement) return null;
      current = _member(current, part) ?? current.getNamedConstructor(part);
    }
    return current;
  }

  Element? _member(InterfaceElement type, String name) {
    final member = type.getField(name) ??
        type.getGetter(name) ??
        type.getMethod(name) ??
        type.thisType.lookUpGetter(name, type.library) ??
        type.thisType.lookUpMethod(name, type.library);
    // Fields are reached through their (synthetic) getters when inherited.
    return member is GetterElement ? member.variable : member;
  }
}

/// The `[references]` of a cleaned dartdoc text, skipping code and links.
Iterable<String> referencesIn(String markdown) sync* {
  for (final segment in splitCode(markdown)) {
    if (segment.isCode) continue;
    for (final match in referencePattern.allMatches(segment.text)) {
      yield match[1]!;
    }
  }
}

/// `[Foo]` or `[Foo.bar]`, but not a markdown link like `[text](url)`.
final referencePattern =
    RegExp(r'\[([A-Za-z_$][\w$]*(?:\.[\w$]+)*)\](?![(\[:])');

class TextSegment {
  TextSegment(this.text, {required this.isCode, this.isBlock = false});

  final String text;
  final bool isCode;

  /// True for a fenced code block (vs an inline code span).
  final bool isBlock;
}

/// Splits [markdown] into plain text, inline code spans and fenced blocks.
List<TextSegment> splitCode(String markdown) {
  final segments = <TextSegment>[];
  final pattern = RegExp(r'```[\s\S]*?```|`[^`\n]*`');
  var start = 0;
  for (final match in pattern.allMatches(markdown)) {
    segments
      ..add(TextSegment(markdown.substring(start, match.start), isCode: false))
      ..add(
        TextSegment(
          match[0]!,
          isCode: true,
          isBlock: match[0]!.startsWith('```'),
        ),
      );
    start = match.end;
  }
  segments.add(TextSegment(markdown.substring(start), isCode: false));
  return segments;
}

String _stripCommentMarkers(String raw) => raw.split('\n').map((line) {
      final trimmed = line.trimLeft();
      if (trimmed.startsWith('///')) {
        final rest = trimmed.substring(3);
        return rest.startsWith(' ') ? rest.substring(1) : rest;
      }
      return trimmed
          .replaceFirst(RegExp(r'^/\*\*'), '')
          .replaceFirst(RegExp(r'\*/$'), '')
          .replaceFirst(RegExp(r'^\* ?'), '');
    }).join('\n');

Map<String, String> _readTemplates(String libDir) {
  final templates = <String, String>{};
  final pattern = RegExp(r'\{@template\s+([\w.]+)\}([\s\S]*?)\{@endtemplate\}');
  final files = Directory(libDir)
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'));
  for (final file in files) {
    final comments = file
        .readAsLinesSync()
        .map((line) => line.trimLeft())
        .where((line) => line.startsWith('///'))
        .join('\n');
    for (final match in pattern.allMatches(_stripCommentMarkers(comments))) {
      templates[match[1]!] = match[2]!.trim();
    }
  }
  return templates;
}

class _DeclarationFinder extends GeneralizingAstVisitor<void> {
  _DeclarationFinder(this.offset);

  final int offset;
  Declaration? found;

  @override
  void visitDeclaration(Declaration node) {
    if (node.declaredFragment?.offset == offset) found = node;
    super.visitDeclaration(node);
  }
}
