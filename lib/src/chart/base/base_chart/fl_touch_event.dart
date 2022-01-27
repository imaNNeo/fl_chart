// coverage:ignore-file
import 'package:flutter/foundation.dart';
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

  /// excludes exit or up events to show interactions on charts
  bool get isInterestedForInteractions {
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isWindows = defaultTargetPlatform == TargetPlatform.windows;

    final isDesktopOrWeb = kIsWeb || isLinux || isMacOS || isWindows;

    /// In desktop when mouse hovers into a chart element using [FlPointerHoverEvent], we show the interaction
    /// and when tap happens at the same position, interaction will be dismissed because of [FlTapUpEvent].
    /// That's why we exclude it on desktop or web
    if (isDesktopOrWeb && this is FlTapUpEvent) {
      return true;
    }

    return this is! FlPanEndEvent &&
        this is! FlPanCancelEvent &&
        this is! FlPointerExitEvent &&
        this is! FlLongPressEnd &&
        this is! FlTapUpEvent &&
        this is! FlTapCancelEvent;
  }
}

/// When a pointer has contacted the screen and might begin to move
///
/// The [details] object provides the position of the touch.
/// Inspired from [GestureDragDownCallback]
class FlPanDownEvent extends FlTouchEvent {
  /// Contains information of happened touch gesture
  final DragDownDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  FlPanDownEvent(this.details);
}

/// When a pointer has contacted the screen and has begun to move.
///
/// The [details] object provides the position of the touch when it first
/// touched the surface.
/// Inspired from [GestureDragStartCallback].
class FlPanStartEvent extends FlTouchEvent {
  /// Contains information of happened touch gesture
  final DragStartDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  /// Creates
  FlPanStartEvent(this.details);
}

/// When a pointer that is in contact with the screen and moving
/// has moved again.
///
/// The [details] object provides the position of the touch and the distance it
/// has traveled since the last update.
/// Inspired from [GestureDragUpdateCallback]
class FlPanUpdateEvent extends FlTouchEvent {
  /// Contains information of happened touch gesture
  final DragUpdateDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  FlPanUpdateEvent(this.details);
}

/// When the pointer that previously triggered a [FlPanStartEvent] did not complete.
/// Inspired from [GestureDragCancelCallback]
class FlPanCancelEvent extends FlTouchEvent {}

/// When a pointer that was previously in contact with the screen
/// and moving is no longer in contact with the screen.
///
/// The velocity at which the pointer was moving when it stopped contacting
/// the screen is available in the [details].
/// Inspired from [GestureDragEndCallback]
class FlPanEndEvent extends FlTouchEvent {
  /// Contains information of happened touch gesture
  final DragEndDetails details;

  FlPanEndEvent(this.details);
}

/// When a pointer that might cause a tap has contacted the
/// screen.
///
/// The position at which the pointer contacted the screen is available in the
/// [details].
/// Inspired from [GestureTapDownCallback]
class FlTapDownEvent extends FlTouchEvent {
  /// Contains information of happened touch gesture
  final TapDownDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  FlTapDownEvent(this.details);
}

/// When the pointer that previously triggered a [FlTapDownEvent] will not end up causing a tap.
/// Inspired from [GestureTapCancelCallback]
class FlTapCancelEvent extends FlTouchEvent {}

/// When a pointer that will trigger a tap has stopped contacting
/// the screen.
///
/// The position at which the pointer stopped contacting the screen is available
/// in the [details].
/// Inspired from [GestureTapUpCallback]
class FlTapUpEvent extends FlTouchEvent {
  /// Contains information of happened touch gesture
  final TapUpDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  FlTapUpEvent(this.details);
}

/// Called When a pointer has remained in contact with the screen at the
/// same location for a long period of time.
///
/// Details are available in the [details].
///
/// Inspired from [GestureLongPressStartCallback]
class FlLongPressStart extends FlTouchEvent {
  /// Contains information of happened touch gesture
  final LongPressStartDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  FlLongPressStart(this.details);
}

/// When a pointer is moving after being held in contact at the same
/// location for a long period of time. Reports the new position and its offset
/// from the original down position.
///
/// Details are available in the [details]
///
/// Inspired from [GestureLongPressMoveUpdateCallback]
class FlLongPressMoveUpdate extends FlTouchEvent {
  /// Contains information of happened touch gesture
  final LongPressMoveUpdateDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  FlLongPressMoveUpdate(this.details);
}

/// When a pointer stops contacting the screen after a long press
/// gesture was detected. Also reports the position where the pointer stopped
/// contacting the screen.
///
/// Details are available in the [details]
///
/// Inspired from [GestureLongPressEndCallback]
class FlLongPressEnd extends FlTouchEvent {
  /// Contains information of happened touch gesture
  final LongPressEndDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  FlLongPressEnd(this.details);
}

/// The pointer has moved with respect to the device while the pointer is or is
/// not in contact with the device, and it has entered our chart.
///
/// Details are available in the [event]
///
/// Inspired from [PointerEnterEventListener]
class FlPointerEnterEvent extends FlTouchEvent {
  /// Contains information of happened pointer event
  final PointerEnterEvent event;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => event.localPosition;

  FlPointerEnterEvent(this.event);
}

/// The pointer has moved with respect to the device while the pointer is not
/// in contact with the device.
///
/// Details are available in the [event]
///
/// Inspired from [PointerHoverEventListener]
class FlPointerHoverEvent extends FlTouchEvent {
  /// Contains information of happened pointer event
  final PointerHoverEvent event;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => event.localPosition;

  FlPointerHoverEvent(this.event);
}

/// The pointer has moved with respect to the device while the pointer is or is
/// not in contact with the device, and exited our chart.
///
/// Inspired from [PointerExitEventListener] which contains [PointerExitEvent]
class FlPointerExitEvent extends FlTouchEvent {
  /// Contains information of happened pointer event
  final PointerExitEvent event;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => event.localPosition;

  FlPointerExitEvent(this.event);
}
