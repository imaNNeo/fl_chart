import 'package:fl_chart/src/extensions/text_align_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test getFinalHorizontalAlignment extension.', () {
    const textAlignLeft = TextAlign.left;
    const textAlignRight = TextAlign.right;

    expect(
      textAlignLeft.getFinalHorizontalAlignment(TextDirection.rtl),
      HorizontalAlignment.left,
    );
    expect(
      textAlignLeft.getFinalHorizontalAlignment(TextDirection.ltr),
      HorizontalAlignment.left,
    );

    expect(
      textAlignRight.getFinalHorizontalAlignment(TextDirection.rtl),
      HorizontalAlignment.right,
    );
    expect(
      textAlignRight.getFinalHorizontalAlignment(TextDirection.ltr),
      HorizontalAlignment.right,
    );

    const textAlignStart = TextAlign.start;
    expect(
      textAlignStart.getFinalHorizontalAlignment(TextDirection.ltr),
      HorizontalAlignment.left,
    );
    expect(
      textAlignStart.getFinalHorizontalAlignment(TextDirection.rtl),
      HorizontalAlignment.right,
    );

    const textAlignEnd = TextAlign.end;
    expect(
      textAlignEnd.getFinalHorizontalAlignment(TextDirection.rtl),
      HorizontalAlignment.left,
    );
    expect(
      textAlignEnd.getFinalHorizontalAlignment(TextDirection.ltr),
      HorizontalAlignment.right,
    );

    const textAlignCenter = TextAlign.center;
    expect(
      textAlignCenter.getFinalHorizontalAlignment(TextDirection.rtl),
      HorizontalAlignment.center,
    );
    expect(
      textAlignCenter.getFinalHorizontalAlignment(TextDirection.ltr),
      HorizontalAlignment.center,
    );
  });
}
