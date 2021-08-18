import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

/// Parent class for several kind of touch/pointer events (like tap, panMode, longPressStart, ...)
abstract class FlTouchEvent {
  /// Represents the position of happened touch/pointer event
  ///
  /// Some events such as [FlPanCancelEvent] and [FlTapCancelEvent]
  /// doesn't have any position (their details come from flutter engine).
  /// That's why this field is nullable
  Offset? get localPosition => null;
}

/// It is something like [GestureDragDownCallback] which contains [DragDownDetails]
class FlPanDownEvent extends FlTouchEvent {
  /// Contains information of happened touch gesture
  final DragDownDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  FlPanDownEvent(this.details);
}

/// It is something like [GestureDragStartCallback] which contains [DragStartDetails]
class FlPanStartEvent extends FlTouchEvent {
  /// Contains information of happened touch gesture
  final DragStartDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  /// Creates
  FlPanStartEvent(this.details);
}

/// It is something like [GestureDragUpdateCallback] which contains [DragUpdateDetails]
class FlPanUpdateEvent extends FlTouchEvent {
  /// Contains information of happened touch gesture
  final DragUpdateDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  FlPanUpdateEvent(this.details);
}

/// It is something like [GestureDragCancelCallback]
class FlPanCancelEvent extends FlTouchEvent {}

/// It is something like [GestureDragEndCallback] which contains [DragEndDetails]
class FlPanEndEvent extends FlTouchEvent {
  /// Contains information of happened touch gesture
  final DragEndDetails details;

  FlPanEndEvent(this.details);
}

/// It is something like [GestureTapDownCallback] which contains [TapDownDetails]
class FlTapDownEvent extends FlTouchEvent {
  /// Contains information of happened touch gesture
  final TapDownDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  FlTapDownEvent(this.details);
}

/// It is something like [GestureTapCancelCallback]
class FlTapCancelEvent extends FlTouchEvent {}

/// It is something like [GestureTapUpCallback] which contains [TapUpDetails]
class FlTapUpEvent extends FlTouchEvent {
  /// Contains information of happened touch gesture
  final TapUpDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  FlTapUpEvent(this.details);
}

/// It is something like [GestureLongPressStartCallback] which contains [LongPressStartDetails]
class FlLongPressStart extends FlTouchEvent {
  /// Contains information of happened touch gesture
  final LongPressStartDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  FlLongPressStart(this.details);
}

/// It is something like [GestureLongPressMoveUpdateCallback] which contains [LongPressMoveUpdateDetails]
class FlLongPressMoveUpdate extends FlTouchEvent {
  /// Contains information of happened touch gesture
  final LongPressMoveUpdateDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  FlLongPressMoveUpdate(this.details);
}

/// It is something like [GestureLongPressEndCallback] which contains [LongPressEndDetails]
class FlLongPressEnd extends FlTouchEvent {
  /// Contains information of happened touch gesture
  final LongPressEndDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  FlLongPressEnd(this.details);
}

/// It is something like [PointerEnterEventListener] which contains [PointerEnterEvent]
class FlPointerEnterEvent extends FlTouchEvent {
  /// Contains information of happened pointer event
  final PointerEnterEvent event;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => event.localPosition;

  FlPointerEnterEvent(this.event);
}

/// It is something like [PointerHoverEventListener] which contains [PointerHoverEvent]
class FlPointerHoverEvent extends FlTouchEvent {
  /// Contains information of happened pointer event
  final PointerHoverEvent event;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => event.localPosition;

  FlPointerHoverEvent(this.event);
}

/// It is something like [PointerExitEventListener] which contains [PointerExitEvent]
class FlPointerExitEvent extends FlTouchEvent {
  /// Contains information of happened pointer event
  final PointerExitEvent event;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => event.localPosition;

  FlPointerExitEvent(this.event);
}
