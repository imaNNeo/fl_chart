// Generates the API tables of the markdown docs from the dartdoc comments.
//
// Usage (from the repo root):
//   dart run tool/api_docs/generate.dart          # update the docs
//   dart run tool/api_docs/generate.dart --check  # fail if they're stale
// ignore_for_file: avoid_print

import 'dart:io';

import 'package:path/path.dart' as p;

import 'src/api_extractor.dart';
import 'src/api_model.dart';
import 'src/markdown_tables.dart';

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
  for (final markdown in files.values) {
    for (final marker in markersIn(markdown)) {
      final type = await extractor.extract(
        marker.typeName,
        marker.mode,
        isDocumented: anchors.containsKey,
      );
      if (type != null) types[type.name] = type;
    }
  }
  if (extractor.errors.isNotEmpty) {
    extractor.errors.forEach(print);
    print('\n${extractor.errors.length} problem(s) found in the dartdoc.');
    exit(1);
  }

  final stale = <String>[];
  for (final MapEntry(key: fileName, value: markdown) in files.entries) {
    final updated = replaceTables(markdown, fileName, types, anchors);
    if (updated == markdown) continue;
    stale.add(fileName);
    if (!check) {
      File(p.join(docsDir.path, fileName)).writeAsStringSync(updated);
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
