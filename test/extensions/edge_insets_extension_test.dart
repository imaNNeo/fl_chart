import 'package:fl_chart/src/extensions/edge_insets_extension.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test onlyTopBottom', () {
    const input = EdgeInsets.symmetric(horizontal: 10, vertical: 20);

    expect(
      input.onlyTopBottom,
      const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
    );

    expect(
      input.onlyLeftRight,
      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
    );
  });
}
