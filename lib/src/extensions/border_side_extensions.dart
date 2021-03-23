

import 'package:flutter/widgets.dart';

/// Defines extensions on the [BorderSide]
extension BorderSideExtensions on BorderSide {
  /// returns false if we don't need to draw anything
  bool isVisible() => width != 0.0 && color.opacity != 0.0;
}
