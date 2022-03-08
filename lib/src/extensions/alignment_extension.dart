import 'package:flutter/material.dart';

enum HorizontalAlignment { left, center, right }

extension TextAlignExtension on TextAlign {
  HorizontalAlignment getFinalHorizontalAlignment(TextDirection? direction) {
    if (((this == TextAlign.left) ||
        (this == TextAlign.start && direction == TextDirection.ltr) ||
        (this == TextAlign.end && direction == TextDirection.rtl))) {
      return HorizontalAlignment.left;
    } else if ((this == TextAlign.right) ||
        (this == TextAlign.end && direction == TextDirection.ltr) ||
        (this == TextAlign.start && direction == TextDirection.rtl)) {
      return HorizontalAlignment.right;
    } else {
      return HorizontalAlignment.center;
    }
  }
}
