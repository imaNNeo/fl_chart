// Generates the API docs from the dartdoc comments:
// - the API tables of the markdown docs (repo_files/documentations/*.md),
// - the API data of the website (website/src/data/api.json),
// - the property specs of the playground (playground/lib/generated/).
//
// Usage (from the repo root):
//   dart run tool/api_docs/generate.dart          # update the docs
//   dart run tool/api_docs/generate.dart --check  # fail if they're stale
// ignore_for_file: avoid_print

import 'dart:io';

import 'package:path/path.dart' as p;

import 'src/api_extractor.dart';
import 'src/api_model.dart';
import 'src/json_writer.dart';
import 'src/markdown_tables.dart';
import 'src/registry_writer.dart';

Future<void> main(List<String> args) async {
  final check = args.contains('--check');
  final root = p.normalize(
    p.join(p.dirname(Platform.script.toFilePath()), '..', '..'),
  );
  final docsDir = Directory(p.join(root, 'repo_files', 'documentations'));
  final files = {
    for (final file in docsDir.listSync().whereType<File>())
      if (file.path.endsWith('.md'))
        p.basename(file.path): file.readAsStringSync(),
  };

  final anchors = headingAnchors(files);
  final extractor = await ApiExtractor.create(root);
  final types = <String, ApiType>{};
  final pages = <String, String>{};
  for (final MapEntry(key: fileName, value: markdown) in files.entries) {
    for (final marker in markersIn(markdown)) {
      final type = await extractor.extract(
        marker.typeName,
        marker.mode,
        isDocumented: anchors.containsKey,
      );
      if (type == null) continue;
      types[type.name] = type;
      pages[type.name] = fileName;
    }
  }
  if (extractor.errors.isNotEmpty) {
    extractor.errors.forEach(print);
    print('\n${extractor.errors.length} problem(s) found in the dartdoc.');
    exit(1);
  }

  final outputs = {
    for (final MapEntry(key: fileName, value: markdown) in files.entries)
      p.join(docsDir.path, fileName):
          replaceTables(markdown, fileName, types, anchors),
    p.join(root, 'website', 'src', 'data', 'api.json'):
        apiJson(types.values, pages, anchors),
    p.join(root, 'playground', 'lib', 'generated', 'api_registry.g.dart'):
        registryDart(types.values),
  };
  final stale = <String>[];
  for (final MapEntry(key: path, value: content) in outputs.entries) {
    final file = File(path);
    if (file.existsSync() && file.readAsStringSync() == content) continue;
    stale.add(p.relative(path, from: root));
    if (!check) {
      file
        ..createSync(recursive: true)
        ..writeAsStringSync(content);
    }
  }

  if (stale.isEmpty) {
    print('API docs are up to date.');
  } else if (check) {
    print('API docs are stale: ${stale.join(', ')}');
    print('Run `make docs` and commit the result.');
    exit(1);
  } else {
    print('Updated: ${stale.join(', ')}');
  }
}
