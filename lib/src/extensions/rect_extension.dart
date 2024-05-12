import 'package:flutter/material.dart';

extension RectExtension on Rect {
  Rect applyPadding(EdgeInsets padding) {
    return Rect.fromLTRB(
      left - padding.left,
      top - padding.top,
      right + padding.right,
      bottom + padding.bottom,
    );
  }
}
