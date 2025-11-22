import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_helper.dart';
import 'package:flutter/material.dart';

/// A callback for when a drag operation starts on a spot.
///
/// Parameters:
/// - [barIndex]: The index of the bar (line) that was touched
/// - [spotIndex]: The index of the spot within that bar
/// - [spot]: The data coordinates of the touched spot (FlSpot with x and y values)
typedef DragStartCallback = void Function(
  int barIndex,
  int spotIndex,
  FlSpot spot,
);

/// A callback for when a spot is being dragged.
///
/// Parameters:
/// - [barIndex]: The index of the bar (line) being dragged
/// - [spotIndex]: The index of the spot being dragged
/// - [oldSpot]: The previous data coordinates
/// - [newSpot]: The new data coordinates after the drag movement
typedef DragUpdateCallback = void Function(
  int barIndex,
  int spotIndex,
  FlSpot oldSpot,
  FlSpot newSpot,
);

/// A callback for when a drag operation ends.
typedef DragEndCallback = void Function();

/// A callback for when a spot is tapped.
///
/// Parameters:
/// - [barIndex]: The index of the bar (line) that was tapped
/// - [spotIndex]: The index of the spot that was tapped
/// - [spot]: The data coordinates of the tapped spot
typedef SpotTapCallback = void Function(
  int barIndex,
  int spotIndex,
  FlSpot spot,
);

/// A callback to determine if a specific bar/spot can be dragged.
///
/// Return true to allow dragging, false to ignore.
/// If null, all spots are draggable.
typedef CanDragSpotCallback = bool Function(
  int barIndex,
  int spotIndex,
);

/// A callback to constrain/modify the drag position.
///
/// This allows enforcing business rules like:
/// - Keeping points in order
/// - Restricting movement to certain axes
/// - Clamping to valid ranges
///
/// Return the constrained FlSpot position.
typedef ConstrainDragCallback = FlSpot Function(
  int barIndex,
  int spotIndex,
  FlSpot oldSpot,
  FlSpot proposedSpot,
);

/// A LineChart widget that supports dragging spots by wrapping the chart
/// with a GestureDetector. This provides reliable drag behavior without
/// conflicting with the chart's tooltip system.
///
/// This widget is useful for interactive chart editing where users need to
/// drag data points to new positions, such as in profile editors,
/// curve adjusters, or data visualization tools.
///
/// Example usage:
/// ```dart
/// DraggableLineChart(
///   data: LineChartData(
///     lineBarsData: [
///       LineChartBarData(
///         spots: [FlSpot(0, 1), FlSpot(1, 3), FlSpot(2, 2)],
///       ),
///     ],
///     minX: 0,
///     maxX: 10,
///     minY: 0,
///     maxY: 10,
///   ),
///   onDragStart: (barIndex, spotIndex, spot) {
///     print('Started dragging spot $spotIndex of bar $barIndex');
///   },
///   onDragUpdate: (barIndex, spotIndex, oldSpot, newSpot) {
///     // Update your data model with newSpot coordinates
///     print('Dragged to ${newSpot.x}, ${newSpot.y}');
///   },
///   onDragEnd: () {
///     print('Drag ended');
///   },
/// )
/// ```
class DraggableLineChart extends StatefulWidget {
  const DraggableLineChart({
    super.key,
    required this.data,
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
    this.onSpotTap,
    this.canDragSpot,
    this.constrainDrag,
    this.dragTolerance = 3.5,
    this.dragThrottle = const Duration(milliseconds: 33),
  });

  /// The chart data to display. Note that [LineTouchData.enabled] will be
  /// automatically set to false to prevent conflicts with drag gestures.
  final LineChartData data;

  /// Called when a drag operation starts.
  final DragStartCallback? onDragStart;

  /// Called repeatedly as a spot is dragged. Updates are throttled according
  /// to [dragThrottle].
  final DragUpdateCallback? onDragUpdate;

  /// Called when a drag operation ends.
  final DragEndCallback? onDragEnd;

  /// Called when a spot is tapped (not dragged).
  final SpotTapCallback? onSpotTap;

  /// Callback to determine if a spot can be dragged.
  /// Return true to allow dragging, false to ignore.
  /// If null, all spots are draggable.
  final CanDragSpotCallback? canDragSpot;

  /// Callback to constrain/modify drag positions.
  /// This allows enforcing business rules like keeping points in order,
  /// restricting movement to certain axes, or clamping to valid ranges.
  /// If null, no constraints are applied.
  final ConstrainDragCallback? constrainDrag;

  /// The maximum distance (in data units) from a spot for it to be considered
  /// "hit" by a touch. Default is 3.5.
  final double dragTolerance;

  /// Minimum time between drag update callbacks. Default is 33ms (~30 FPS).
  final Duration dragThrottle;

  @override
  State<DraggableLineChart> createState() => _DraggableLineChartState();
}

class _DraggableLineChartState extends State<DraggableLineChart> {
  final GlobalKey _chartKey = GlobalKey();
  bool _isDragging = false;
  int? _draggedBarIndex;
  int? _draggedSpotIndex;
  FlSpot? _draggedSpotInitial;
  FlSpot? _lastDraggedSpot; // Track last position for accurate onPanEnd
  DateTime? _lastUpdateTime;

  @override
  Widget build(BuildContext context) {
    // Ensure touch is disabled on the LineChart itself
    final data = widget.data.copyWith(
      lineTouchData: const LineTouchData(enabled: false),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) {
        _handleTapDown(details.localPosition);
      },
      onPanDown: (details) {
        _handlePanDown(details.localPosition);
      },
      onPanStart: (details) {
        _handlePanStart(details.localPosition);
      },
      onPanUpdate: (details) {
        if (_isDragging) {
          _handlePanUpdate(details.localPosition);
        }
      },
      onPanEnd: (details) {
        if (_isDragging) {
          // Send final update with last known position to ensure accuracy
          if (_draggedBarIndex != null &&
              _draggedSpotIndex != null &&
              _draggedSpotInitial != null &&
              _lastDraggedSpot != null) {
            // Send final update (bypass throttle) with the last tracked position
            widget.onDragUpdate?.call(
              _draggedBarIndex!,
              _draggedSpotIndex!,
              _draggedSpotInitial!,
              _lastDraggedSpot!,
            );
          }

          _isDragging = false;
          _draggedBarIndex = null;
          _draggedSpotIndex = null;
          _draggedSpotInitial = null;
          _lastDraggedSpot = null;
          _lastUpdateTime = null;
          widget.onDragEnd?.call();
        }
      },
      onPanCancel: () {
        if (_isDragging) {
          _isDragging = false;
          _draggedBarIndex = null;
          _draggedSpotIndex = null;
          _draggedSpotInitial = null;
          _lastDraggedSpot = null;
          _lastUpdateTime = null;
          widget.onDragEnd?.call();
        }
      },
      child: Container(
        key: _chartKey,
        child: LineChart(data),
      ),
    );
  }

  void _handleTapDown(Offset position) {
    if (widget.onSpotTap == null) return;

    final result = _findNearestSpot(position);
    if (result != null) {
      widget.onSpotTap?.call(
        result.barIndex,
        result.spotIndex,
        result.spot,
      );
    }
  }

  void _handlePanDown(Offset position) {
    // Check if we're near a draggable spot
    final result = _findNearestSpot(position);
    if (result != null && widget.onDragStart != null) {
      _isDragging = true;
      _draggedBarIndex = result.barIndex;
      _draggedSpotIndex = result.spotIndex;
      _draggedSpotInitial = result.spot;

      // CRITICAL: Call onDragStart immediately in onPanDown to claim gesture
      // before scrolling can win the gesture arena
      widget.onDragStart?.call(
        result.barIndex,
        result.spotIndex,
        result.spot,
      );
    }
  }

  void _handlePanStart(Offset position) {
    // If we didn't already start dragging in onPanDown, try here
    if (!_isDragging && widget.onDragStart != null) {
      final result = _findNearestSpot(position);
      if (result != null) {
        _isDragging = true;
        _draggedBarIndex = result.barIndex;
        _draggedSpotIndex = result.spotIndex;
        _draggedSpotInitial = result.spot;

        widget.onDragStart?.call(
          result.barIndex,
          result.spotIndex,
          result.spot,
        );
      }
    }
  }

  void _handlePanUpdate(Offset position) {
    if (_draggedBarIndex == null || _draggedSpotIndex == null || _draggedSpotInitial == null) {
      return;
    }

    var newSpot = screenToChartCoordinates(position);
    if (newSpot == null) return;

    // Apply constraints if provided
    if (widget.constrainDrag != null) {
      newSpot = widget.constrainDrag!(
        _draggedBarIndex!,
        _draggedSpotIndex!,
        _draggedSpotInitial!,
        newSpot,
      );
    }

    // Always track the last position (even if throttled)
    _lastDraggedSpot = newSpot;

    // Throttle updates
    final now = DateTime.now();
    if (_lastUpdateTime == null || now.difference(_lastUpdateTime!) >= widget.dragThrottle) {
      _lastUpdateTime = now;

      widget.onDragUpdate?.call(
        _draggedBarIndex!,
        _draggedSpotIndex!,
        _draggedSpotInitial!,
        newSpot,
      );
    }
  }

  ({int barIndex, int spotIndex, FlSpot spot})? _findNearestSpot(
    Offset position,
  ) {
    final renderBox = _chartKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;

    final size = renderBox.size;

    int? nearestBarIndex;
    var nearestSpotIndex = 0;
    var nearestSpot = FlSpot.zero;
    var minDistance = double.infinity;

    for (var barIndex = 0; barIndex < widget.data.lineBarsData.length; barIndex++) {
      final bar = widget.data.lineBarsData[barIndex];

      for (var spotIndex = 0; spotIndex < bar.spots.length; spotIndex++) {
        // Check if this spot can be dragged
        if (widget.canDragSpot != null && !widget.canDragSpot!(barIndex, spotIndex)) {
          continue; // Skip non-draggable spots
        }

        final spot = bar.spots[spotIndex];

        // Convert spot data coordinates to screen pixel coordinates using LineChartHelper
        final spotScreen = LineChartHelper.dataToScreen(spot, size, widget.data);

        // Calculate pixel distance (Euclidean distance in screen space)
        final dx = position.dx - spotScreen.dx;
        final dy = position.dy - spotScreen.dy;
        final pixelDistance = sqrt(dx * dx + dy * dy);

        if (pixelDistance < minDistance) {
          minDistance = pixelDistance;
          nearestBarIndex = barIndex;
          nearestSpotIndex = spotIndex;
          nearestSpot = spot;
        }
      }
    }

    // dragTolerance is now in pixels (default 3.5 means 3.5 pixels)
    // Multiply by a reasonable factor for easier tapping
    final tolerancePixels = widget.dragTolerance * 10; // 35 pixels by default

    if (minDistance <= tolerancePixels && nearestBarIndex != null) {
      return (barIndex: nearestBarIndex, spotIndex: nearestSpotIndex, spot: nearestSpot);
    }

    return null;
  }

  /// Converts screen pixel coordinates to chart data coordinates.
  ///
  /// Uses LineChartHelper for pixel-perfect coordinate conversion that matches
  /// fl_chart's internal rendering logic.
  FlSpot? screenToChartCoordinates(Offset screenPosition) {
    final renderBox = _chartKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;

    final size = renderBox.size;

    // Use LineChartHelper for accurate conversion
    return LineChartHelper.screenToData(screenPosition, size, widget.data);
  }
}
