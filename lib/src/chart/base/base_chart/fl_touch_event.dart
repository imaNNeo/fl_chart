// coverage:ignore-file
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

/// Parent class for several kind of touch/pointer events (like tap, panMode, longPressStart, ...)
abstract class FlTouchEvent {
  const FlTouchEvent();

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

  String get eventType => 'UnknownEvent';
}

/// When a pointer has contacted the screen and might begin to move
///
/// The [details] object provides the position of the touch.
/// Inspired from [GestureDragDownCallback]
class FlPanDownEvent extends FlTouchEvent {
  const FlPanDownEvent(this.details);

  /// Contains information of happened touch gesture
  final DragDownDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  @override
  String get eventType => 'FlPanDownEvent';
}

/// When a pointer has contacted the screen and has begun to move.
///
/// The [details] object provides the position of the touch when it first
/// touched the surface.
/// Inspired from [GestureDragStartCallback].
class FlPanStartEvent extends FlTouchEvent {
  /// Creates
  const FlPanStartEvent(this.details);

  /// Contains information of happened touch gesture
  final DragStartDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  @override
  String get eventType => 'FlPanStartEvent';
}

/// When a pointer that is in contact with the screen and moving
/// has moved again.
///
/// The [details] object provides the position of the touch and the distance it
/// has traveled since the last update.
/// Inspired from [GestureDragUpdateCallback]
class FlPanUpdateEvent extends FlTouchEvent {
  const FlPanUpdateEvent(this.details);

  /// Contains information of happened touch gesture
  final DragUpdateDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  @override
  String get eventType => 'FlPanUpdateEvent';
}

/// When the pointer that previously triggered a [FlPanStartEvent] did not complete.
/// Inspired from [GestureDragCancelCallback]
class FlPanCancelEvent extends FlTouchEvent {
  const FlPanCancelEvent();

  @override
  String get eventType => 'FlPanCancelEvent';
}

/// When a pointer that was previously in contact with the screen
/// and moving is no longer in contact with the screen.
///
/// The velocity at which the pointer was moving when it stopped contacting
/// the screen is available in the [details].
/// Inspired from [GestureDragEndCallback]
class FlPanEndEvent extends FlTouchEvent {
  const FlPanEndEvent(this.details);

  /// Contains information of happened touch gesture
  final DragEndDetails details;

  @override
  String get eventType => 'FlPanEndEvent';
}

/// When a pointer that might cause a tap has contacted the
/// screen.
///
/// The position at which the pointer contacted the screen is available in the
/// [details].
/// Inspired from [GestureTapDownCallback]
class FlTapDownEvent extends FlTouchEvent {
  const FlTapDownEvent(this.details);

  /// Contains information of happened touch gesture
  final TapDownDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  @override
  String get eventType => 'FlTapDownEvent';
}

/// When the pointer that previously triggered a [FlTapDownEvent] will not end up causing a tap.
/// Inspired from [GestureTapCancelCallback]
class FlTapCancelEvent extends FlTouchEvent {
  const FlTapCancelEvent();

  @override
  String get eventType => 'FlTapCancelEvent';
}

/// When a pointer that will trigger a tap has stopped contacting
/// the screen.
///
/// The position at which the pointer stopped contacting the screen is available
/// in the [details].
/// Inspired from [GestureTapUpCallback]
class FlTapUpEvent extends FlTouchEvent {
  const FlTapUpEvent(this.details);

  /// Contains information of happened touch gesture
  final TapUpDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  @override
  String get eventType => 'FlTapUpEvent';
}

/// Called When a pointer has remained in contact with the screen at the
/// same location for a long period of time.
///
/// Details are available in the [details].
///
/// Inspired from [GestureLongPressStartCallback]
class FlLongPressStart extends FlTouchEvent {
  const FlLongPressStart(this.details);

  /// Contains information of happened touch gesture
  final LongPressStartDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  @override
  String get eventType => 'FlLongPressStart';
}

/// When a pointer is moving after being held in contact at the same
/// location for a long period of time. Reports the new position and its offset
/// from the original down position.
///
/// Details are available in the [details]
///
/// Inspired from [GestureLongPressMoveUpdateCallback]
class FlLongPressMoveUpdate extends FlTouchEvent {
  const FlLongPressMoveUpdate(this.details);

  /// Contains information of happened touch gesture
  final LongPressMoveUpdateDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  @override
  String get eventType => 'FlLongPressMoveUpdate';
}

/// When a pointer stops contacting the screen after a long press
/// gesture was detected. Also reports the position where the pointer stopped
/// contacting the screen.
///
/// Details are available in the [details]
///
/// Inspired from [GestureLongPressEndCallback]
class FlLongPressEnd extends FlTouchEvent {
  const FlLongPressEnd(this.details);

  /// Contains information of happened touch gesture
  final LongPressEndDetails details;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => details.localPosition;

  @override
  String get eventType => 'FlLongPressEnd';
}

/// The pointer has moved with respect to the device while the pointer is or is
/// not in contact with the device, and it has entered our chart.
///
/// Details are available in the [event]
///
/// Inspired from [PointerEnterEventListener]
class FlPointerEnterEvent extends FlTouchEvent {
  const FlPointerEnterEvent(this.event);

  /// Contains information of happened pointer event
  final PointerEnterEvent event;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => event.localPosition;

  @override
  String get eventType => 'FlPointerEnterEvent';
}

/// The pointer has moved with respect to the device while the pointer is not
/// in contact with the device.
///
/// Details are available in the [event]
///
/// Inspired from [PointerHoverEventListener]
class FlPointerHoverEvent extends FlTouchEvent {
  const FlPointerHoverEvent(this.event);

  /// Contains information of happened pointer event
  final PointerHoverEvent event;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => event.localPosition;

  @override
  String get eventType => 'FlPointerHoverEvent';
}

/// The pointer has moved with respect to the device while the pointer is or is
/// not in contact with the device, and exited our chart.
///
/// Inspired from [PointerExitEventListener] which contains [PointerExitEvent]
class FlPointerExitEvent extends FlTouchEvent {
  const FlPointerExitEvent(this.event);

  /// Contains information of happened pointer event
  final PointerExitEvent event;

  /// Represents the position of happened touch/pointer event
  @override
  Offset get localPosition => event.localPosition;

  @override
  String get eventType => 'FlPointerExitEvent';
}
