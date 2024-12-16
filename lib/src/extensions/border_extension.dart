import 'package:flutter/widgets.dart';

extension BorderExtension on Border {
  bool isVisible() {
    if (left.width == 0 &&
        top.width == 0 &&
        right.width == 0 &&
        bottom.width == 0) {
      return false;
    }

    if (left.color.a == 0.0 &&
        top.color.a == 0.0 &&
        right.color.a == 0.0 &&
        bottom.color.a == 0.0) {
      return false;
    }
    return true;
  }
}
