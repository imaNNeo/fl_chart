import 'dart:ui';

extension SizeExtension on Size {
  Size rotateByQuarterTurns(int quarterTurns) {
    if (quarterTurns < 0) {
      throw ArgumentError('quarterTurns must be greater than or equal to 0.');
    }
    return switch (quarterTurns % 4) {
      0 || 2 => this,
      _ /*2 || 3*/ => Size(height, width),
    };
  }
}
