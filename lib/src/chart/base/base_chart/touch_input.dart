import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// An abstract class for touch inputs.
///
/// Each touch gesture should be contained an offset,
/// that determines the touch location in the screen.
abstract class FlTouchInput {
  /// Determines the touch location in the screen.
  Offset getOffset();
}

/// Abstract class for long touches input
abstract class FlTouchLongInput extends FlTouchInput {}

/// Represents a [GestureDetector.onLongPressStart] event.
class FlLongPressStart extends FlTouchLongInput with EquatableMixin {
  /// It is a localized touch position inside our widget,
  /// it represents [LongPressStartDetails.localPosition].
  final Offset localPosition;

  /// [localPosition] is a localized position inside our widget,
  /// it represents [LongPressStartDetails.localPosition].
  FlLongPressStart(this.localPosition);

  /// Returns local offset of the touch in the screen,
  /// it represents [LongPressStartDetails.localPosition].
  @override
  Offset getOffset() {
    return localPosition;
  }

  @override
  List<Object> get props => [
        localPosition,
      ];
}

/// Represents a [GestureDetector.onLongPressMoveUpdate] event.
class FlLongPressMoveUpdate extends FlTouchLongInput with EquatableMixin {
  /// It is a localized touch position inside our widget,
  /// it represents [LongPressMoveUpdateDetails.localPosition].
  final Offset localPosition;

  /// [localPosition] is a localized position inside our widget,
  /// it represents [LongPressMoveUpdateDetails.localPosition].
  FlLongPressMoveUpdate(this.localPosition);

  /// Returns local offset of the touch in the screen,
  /// it represents [LongPressMoveUpdateDetails.localPosition].
  @override
  Offset getOffset() {
    return localPosition;
  }

  @override
  List<Object> get props => [
        localPosition,
      ];
}

/// Represents a [GestureDetector.onLongPressEnd] event.
class FlLongPressEnd extends FlTouchLongInput with EquatableMixin {
  /// It is a localized touch position inside our widget,
  /// it represents [LongPressEndDetails.localPosition].
  final Offset localPosition;

  /// [localPosition] is a localized position inside our widget,
  /// it represents [LongPressEndDetails.localPosition].
  FlLongPressEnd(this.localPosition);

  /// Returns local offset of the touch in the screen,
  /// it represents [LongPressEndDetails.localPosition].
  @override
  Offset getOffset() {
    return localPosition;
  }

  @override
  List<Object> get props => [
        localPosition,
      ];
}

/// Abstract class for normal touches input
abstract class FlTouchNormalInput extends FlTouchInput {}

/// Represents a [GestureDetector.onPanDown] event.
class FlPanStart extends FlTouchNormalInput with EquatableMixin {
  /// It is a localized touch position inside our widget,
  /// it represents [DragDownDetails.localPosition].
  final Offset localPosition;

  /// [localPosition] is a localized position inside our widget,
  /// it represents [DragDownDetails.localPosition].
  FlPanStart(this.localPosition);

  /// Returns local offset of the touch in the screen,
  /// it represents [DragDownDetails.localPosition].
  @override
  Offset getOffset() {
    return localPosition;
  }

  @override
  List<Object> get props => [
        localPosition,
      ];
}

/// Represents a [GestureDetector.onPanUpdate] event.
class FlPanMoveUpdate extends FlTouchNormalInput with EquatableMixin {
  /// It is a localized touch position inside our widget,
  /// it represents [DragUpdateDetails.localPosition].
  final Offset localPosition;

  /// [localPosition] is a localized position inside our widget,
  /// it represents [DragUpdateDetails.localPosition].
  FlPanMoveUpdate(this.localPosition);

  /// Returns local offset of the touch in the screen,
  /// it represents [DragUpdateDetails.localPosition].
  @override
  Offset getOffset() {
    return localPosition;
  }

  @override
  List<Object> get props => [
        localPosition,
      ];
}

/// Represents a [GestureDetector.onPanEnd] event.
class FlPanEnd extends FlTouchNormalInput with EquatableMixin {
  /// It is a localized touch position inside our widget.
  final Offset localPosition;

  /// Represents [DragEndDetails.velocity].
  final Velocity velocity;

  /// [localPosition] is a localized touch position inside our widget,
  /// [velocity] represents [DragEndDetails.velocity].
  FlPanEnd(
    this.localPosition,
    this.velocity,
  );

  /// Returns local offset of the touch in the screen.
  @override
  Offset getOffset() {
    return localPosition;
  }

  @override
  List<Object> get props => [
        localPosition,
        velocity,
      ];
}
