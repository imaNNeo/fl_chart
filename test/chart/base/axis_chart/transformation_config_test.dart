import 'package:fl_chart/src/chart/base/axis_chart/scale_axis.dart';
import 'package:fl_chart/src/chart/base/axis_chart/transformation_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlTransformationConfig', () {
    test('throws assertion error when minScale is less than 1', () {
      expect(
        () => FlTransformationConfig(minScale: 0.99),
        throwsAssertionError,
      );
    });

    test('throws assertion error when maxScale is less than minScale', () {
      expect(
        () => FlTransformationConfig(minScale: 1.1, maxScale: 1),
        throwsAssertionError,
      );
    });

    test('has correct default values', () {
      const config = FlTransformationConfig();

      expect(config.minScale, 1);
      expect(config.maxScale, 2.5);
      expect(config.trackpadScrollCausesScale, false);
      expect(config.scaleAxis, FlScaleAxis.none);
      expect(config.transformationController, isNull);
    });
  });
}
