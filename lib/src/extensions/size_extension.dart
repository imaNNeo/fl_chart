import 'dart:ui';

extension SizeExtension on Size {
  Size rotateByQuarterTurns(int quarterTurns) => switch (quarterTurns % 4) {
        0 || 2 => this,
        1 || 3 => Size(height, width),
        _ => throw ArgumentError('Invalid quarterTurns $quarterTurns'),
      };
}
