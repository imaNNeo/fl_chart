import 'dart:convert';
import 'dart:io';

import 'package:integration_test/integration_test_driver.dart';


/// Saves the frame timings of integration_test/frame_timing_test.dart to
/// results/<label>.device.json, in the format tool/compare.dart reads.
/// The label comes from the BENCH_LABEL environment variable.
Future<void> main() => integrationDriver(
      responseDataCallback: (data) async {
        final label = Platform.environment['BENCH_LABEL'] ?? 'local';
        final json = {
          'label': label,
          'kind': 'device',
          'date': DateTime.now().toUtc().toIso8601String(),
          'scenarios': data ?? {},
        };
        final file = File('results/$label.device.json')
          ..createSync(recursive: true);
        file.writeAsStringSync(
          '${const JsonEncoder.withIndent('  ').convert(json)}\n',
        );
        stdout.writeln('Saved to ${file.path}');
      },
    );
