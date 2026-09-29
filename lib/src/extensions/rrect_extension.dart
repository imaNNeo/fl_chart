import 'package:cupertino_ui/cupertino_ui.dart';

/// Defines extensions on the [RRect]
extension RRectExtension on RRect {
  /// Return [Rect] from [RRect]
  Rect getRect() => Rect.fromLTRB(
        left,
        top,
        right,
        bottom,
      );
}
