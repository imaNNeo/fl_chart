// coverage:ignore-file
import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/extensions/border_extension.dart';
import 'package:flutter/material.dart';

import 'base_chart_painter.dart';

/// This class holds all data needed for [BaseChartPainter].
///
/// In this phase we draw the border,
/// and handle touches in an abstract way.
abstract class BaseChartData with EquatableMixin {
  /// Holds data to drawing border around the chart.
  FlBorderData borderData;

  /// Holds data needed to touch behavior and responses.
  FlTouchData touchData;

  /// It draws 4 borders around your chart, you can customize it using [borderData],
  /// [touchData] defines the touch behavior and responses.
  BaseChartData({
    FlBorderData? borderData,
    required FlTouchData touchData,
  })  : borderData = borderData ?? FlBorderData(),
        touchData = touchData;

  BaseChartData lerp(BaseChartData a, BaseChartData b, double t);

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        borderData,
        touchData,
      ];
}

/// Holds data to drawing border around the chart.
class FlBorderData with EquatableMixin {
  final bool show;
  Border border;

  /// [show] Determines showing or hiding border around the chart.
  /// [border] Determines the visual look of 4 borders, see [Border].
  FlBorderData({
    bool? show,
    Border? border,
  })  : show = show ?? true,
        border = border ??
            Border.all(
              color: Colors.black,
              width: 1.0,
              style: BorderStyle.solid,
            );

  /// returns false if all borders have 0 width or 0 opacity
  bool isVisible() => show && border.isVisible();

  /// Lerps a [FlBorderData] based on [t] value, check [Tween.lerp].
  static FlBorderData lerp(FlBorderData a, FlBorderData b, double t) {
    return FlBorderData(
      show: b.show,
      border: Border.lerp(a.border, b.border, t),
    );
  }

  /// Copies current [FlBorderData] to a new [FlBorderData],
  /// and replaces provided values.
  FlBorderData copyWith({
    bool? show,
    Border? border,
  }) {
    return FlBorderData(
      show: show ?? this.show,
      border: border ?? this.border,
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        show,
        border,
      ];
}

/// Holds data to handle touch events, and touch responses in abstract way.
///
/// There is a touch flow, explained [here](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/handle_touches.md)
/// in a simple way, each chart's renderer captures the touch events, and passes the pointerEvent
/// to the painter, and gets touched spot, and wraps it into a concrete [BaseTouchResponse].
abstract class FlTouchData<R extends BaseTouchResponse> with EquatableMixin {
  /// You can disable or enable the touch system using [enabled] flag,
  final bool enabled;

  /// [touchCallback] notifies you about the happened touch/pointer events.
  /// It gives you a [FlTouchEvent] which is the happened event such as [FlPointerHoverEvent], [FlTapUpEvent], ...
  /// It also gives you a [BaseTouchResponse] which is the chart specific type and contains information
  /// about the elements that has touched.
  final BaseTouchCallback<R>? touchCallback;

  /// Using [mouseCursorResolver] you can change the mouse cursor
  /// based on the provided [FlTouchEvent] and [BaseTouchResponse]
  final MouseCursorResolver<R>? mouseCursorResolver;

  /// You can disable or enable the touch system using [enabled] flag,
  FlTouchData(
    bool enabled,
    BaseTouchCallback<R>? touchCallback,
    MouseCursorResolver<R>? mouseCursorResolver,
  )   : enabled = enabled,
        touchCallback = touchCallback,
        mouseCursorResolver = mouseCursorResolver;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        enabled,
        touchCallback,
        mouseCursorResolver,
      ];
}

/// Holds data to clipping chart around its borders.
class FlClipData with EquatableMixin {
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  /// Creates data that clips specified sides
  FlClipData({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });

  /// Creates data that clips all sides
  FlClipData.all() : this(top: true, bottom: true, left: true, right: true);

  /// Creates data that clips only top and bottom side
  FlClipData.vertical()
      : this(top: true, bottom: true, left: false, right: false);

  /// Creates data that clips only left and right side
  FlClipData.horizontal()
      : this(top: false, bottom: false, left: true, right: true);

  /// Creates data that doesn't clip any side
  FlClipData.none()
      : this(top: false, bottom: false, left: false, right: false);

  /// Checks whether any of the sides should be clipped
  bool get any => top || bottom || left || right;

  /// Copies current [FlBorderData] to a new [FlBorderData],
  /// and replaces provided values.
  FlClipData copyWith({
    bool? top,
    bool? bottom,
    bool? left,
    bool? right,
  }) {
    return FlClipData(
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
      right: right ?? this.right,
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [top, bottom, left, right];
}

/// Chart's touch callback.
typedef BaseTouchCallback<R extends BaseTouchResponse> = void Function(
    FlTouchEvent, R?);

/// It gives you the happened [FlTouchEvent] and existed [R] data at the event's location,
/// then you should provide a [MouseCursor] to change the cursor at the event's location.
/// For example you can pass the [SystemMouseCursors.click] to change the mouse cursor to click.
typedef MouseCursorResolver<R extends BaseTouchResponse> = MouseCursor Function(
    FlTouchEvent, R?);

/// This class holds the touch response details of charts.
abstract class BaseTouchResponse {
  BaseTouchResponse();
}
