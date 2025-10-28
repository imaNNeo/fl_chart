// coverage:ignore-file
// This file is copied from Flutter's InteractiveViewer widget.
// The only change is that the child is not wrapped in a `Transform` so
// we can react to the transformation ourselves.
//
// This should be removed once the official InteractiveViewer allows to disable
// the Transform widget.

// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/gestures.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart' show Matrix4, Quad, Vector3;

typedef CustomInteractiveViewerWidgetBuilder = Widget Function(
  BuildContext context,
  Quad viewport,
);

@immutable
class CustomInteractiveViewer extends StatefulWidget {
  CustomInteractiveViewer({
    super.key,
    this.clipBehavior = Clip.hardEdge,
    this.panAxis = PanAxis.free,
    this.boundaryMargin = EdgeInsets.zero,
    this.constrained = true,
    this.maxScale = 2.5,
    this.minScale = 0.8,
    this.interactionEndFrictionCoefficient = _kDrag,
    this.onInteractionEnd,
    this.onInteractionStart,
    this.onInteractionUpdate,
    this.panEnabled = true,
    this.scaleEnabled = true,
    this.scaleFactor = kDefaultMouseScrollToScaleFactor,
    this.transformationController,
    this.alignment,
    this.trackpadScrollCausesScale = false,
    required this.child,
  })  : assert(minScale > 0),
        assert(interactionEndFrictionCoefficient > 0),
        assert(minScale.isFinite),
        assert(maxScale > 0),
        assert(!maxScale.isNaN),
        assert(maxScale >= minScale),
        assert(
          (boundaryMargin.horizontal.isInfinite &&
                  boundaryMargin.vertical.isInfinite) ||
              (boundaryMargin.top.isFinite &&
                  boundaryMargin.right.isFinite &&
                  boundaryMargin.bottom.isFinite &&
                  boundaryMargin.left.isFinite),
        ),
        builder = null;

  CustomInteractiveViewer.builder({
    super.key,
    this.clipBehavior = Clip.hardEdge,
    this.panAxis = PanAxis.free,
    this.boundaryMargin = EdgeInsets.zero,
    this.maxScale = 2.5,
    this.minScale = 0.8,
    this.interactionEndFrictionCoefficient = _kDrag,
    this.onInteractionEnd,
    this.onInteractionStart,
    this.onInteractionUpdate,
    this.panEnabled = true,
    this.scaleEnabled = true,
    this.scaleFactor = 200.0,
    this.transformationController,
    this.alignment,
    this.trackpadScrollCausesScale = false,
    required CustomInteractiveViewerWidgetBuilder this.builder,
  })  : assert(minScale > 0),
        assert(interactionEndFrictionCoefficient > 0),
        assert(minScale.isFinite),
        assert(maxScale > 0),
        assert(!maxScale.isNaN),
        assert(maxScale >= minScale),
        assert(
          (boundaryMargin.horizontal.isInfinite &&
                  boundaryMargin.vertical.isInfinite) ||
              (boundaryMargin.top.isFinite &&
                  boundaryMargin.right.isFinite &&
                  boundaryMargin.bottom.isFinite &&
                  boundaryMargin.left.isFinite),
        ),
        constrained = false,
        child = null;

  final Alignment? alignment;
  final Clip clipBehavior;

  final PanAxis panAxis;

  final EdgeInsets boundaryMargin;

  final CustomInteractiveViewerWidgetBuilder? builder;

  final Widget? child;

  final bool constrained;

  final bool panEnabled;

  final bool scaleEnabled;

  final bool trackpadScrollCausesScale;

  final double scaleFactor;

  final double maxScale;

  final double minScale;

  final double interactionEndFrictionCoefficient;

  final GestureScaleEndCallback? onInteractionEnd;

  final GestureScaleStartCallback? onInteractionStart;

  final GestureScaleUpdateCallback? onInteractionUpdate;

  final TransformationController? transformationController;

  static const double _kDrag = 0.0000135;

  /// Returns the closest point to the given point on the given line segment.
  @visibleForTesting
  static Vector3 getNearestPointOnLine(Vector3 point, Vector3 l1, Vector3 l2) {
    final lengthSquared = math.pow(l2.x - l1.x, 2.0).toDouble() +
        math.pow(l2.y - l1.y, 2.0).toDouble();

    // In this case, l1 == l2.
    if (lengthSquared == 0) {
      return l1;
    }

    // Calculate how far down the line segment the closest point is and return
    // the point.
    final l1P = point - l1;
    final l1L2 = l2 - l1;
    final fraction = clampDouble(l1P.dot(l1L2) / lengthSquared, 0, 1);
    return l1 + l1L2 * fraction;
  }

  /// Returns the axis aligned bounding box for the given Quad, which might not
  /// be axis aligned.
  static Rect axisAlignedBoundingBox(Quad quad) {
    var xMin = quad.point0.x;
    var xMax = quad.point0.x;
    var yMin = quad.point0.y;
    var yMax = quad.point0.y;
    for (final point in <Vector3>[
      quad.point1,
      quad.point2,
      quad.point3,
    ]) {
      if (point.x < xMin) {
        xMin = point.x;
      } else if (point.x > xMax) {
        xMax = point.x;
      }

      if (point.y < yMin) {
        yMin = point.y;
      } else if (point.y > yMax) {
        yMax = point.y;
      }
    }

    return Rect.fromLTRB(xMin, yMin, xMax, yMax);
  }

  /// Given a quad, return its axis aligned bounding box.
  @visibleForTesting
  static Quad getAxisAlignedBoundingBox(Quad quad) {
    final double minX = math.min(
      quad.point0.x,
      math.min(
        quad.point1.x,
        math.min(
          quad.point2.x,
          quad.point3.x,
        ),
      ),
    );
    final double minY = math.min(
      quad.point0.y,
      math.min(
        quad.point1.y,
        math.min(
          quad.point2.y,
          quad.point3.y,
        ),
      ),
    );
    final double maxX = math.max(
      quad.point0.x,
      math.max(
        quad.point1.x,
        math.max(
          quad.point2.x,
          quad.point3.x,
        ),
      ),
    );
    final double maxY = math.max(
      quad.point0.y,
      math.max(
        quad.point1.y,
        math.max(
          quad.point2.y,
          quad.point3.y,
        ),
      ),
    );
    return Quad.points(
      Vector3(minX, minY, 0),
      Vector3(maxX, minY, 0),
      Vector3(maxX, maxY, 0),
      Vector3(minX, maxY, 0),
    );
  }

  /// Returns true iff the point is inside the rectangle given by the Quad,
  /// inclusively.
  /// Algorithm from https://math.stackexchange.com/a/190373.
  @visibleForTesting
  static bool pointIsInside(Vector3 point, Quad quad) {
    final aM = point - quad.point0;
    final aB = quad.point1 - quad.point0;
    final aD = quad.point3 - quad.point0;

    final aMAB = aM.dot(aB);
    final aBAB = aB.dot(aB);
    final aMAD = aM.dot(aD);
    final aDAD = aD.dot(aD);

    return 0 <= aMAB && aMAB <= aBAB && 0 <= aMAD && aMAD <= aDAD;
  }

  /// Get the point inside (inclusively) the given Quad that is nearest to the
  /// given Vector3.
  @visibleForTesting
  static Vector3 getNearestPointInside(Vector3 point, Quad quad) {
    // If the point is inside the axis aligned bounding box, then it's ok where
    // it is.
    if (pointIsInside(point, quad)) {
      return point;
    }

    // Otherwise, return the nearest point on the quad.
    final closestPoints = <Vector3>[
      CustomInteractiveViewer.getNearestPointOnLine(
        point,
        quad.point0,
        quad.point1,
      ),
      CustomInteractiveViewer.getNearestPointOnLine(
        point,
        quad.point1,
        quad.point2,
      ),
      CustomInteractiveViewer.getNearestPointOnLine(
        point,
        quad.point2,
        quad.point3,
      ),
      CustomInteractiveViewer.getNearestPointOnLine(
        point,
        quad.point3,
        quad.point0,
      ),
    ];
    var minDistance = double.infinity;
    late Vector3 closestOverall;
    for (final closePoint in closestPoints) {
      final distance = math.sqrt(
        math.pow(point.x - closePoint.x, 2) +
            math.pow(point.y - closePoint.y, 2),
      );
      if (distance < minDistance) {
        minDistance = distance;
        closestOverall = closePoint;
      }
    }
    return closestOverall;
  }

  /// Transform the four corners of the viewport by the inverse of the given
  /// matrix. This gives the viewport after the child has been transformed by the
  /// given matrix. The viewport transforms as the inverse of the child (i.e.
  /// moving the child left is equivalent to moving the viewport right).
  static Quad transformViewport(Matrix4 matrix, Rect viewport) {
    final inverseMatrix = matrix.clone()..invert();
    return Quad.points(
      inverseMatrix.transform3(
        Vector3(
          viewport.topLeft.dx,
          viewport.topLeft.dy,
          0,
        ),
      ),
      inverseMatrix.transform3(
        Vector3(
          viewport.topRight.dx,
          viewport.topRight.dy,
          0,
        ),
      ),
      inverseMatrix.transform3(
        Vector3(
          viewport.bottomRight.dx,
          viewport.bottomRight.dy,
          0,
        ),
      ),
      inverseMatrix.transform3(
        Vector3(
          viewport.bottomLeft.dx,
          viewport.bottomLeft.dy,
          0,
        ),
      ),
    );
  }

  @override
  State<CustomInteractiveViewer> createState() =>
      _CustomInteractiveViewerState();
}

class _CustomInteractiveViewerState extends State<CustomInteractiveViewer>
    with TickerProviderStateMixin {
  TransformationController? _transformationController;

  final GlobalKey _childKey = GlobalKey();
  final GlobalKey _parentKey = GlobalKey();
  Animation<Offset>? _animation;
  Animation<double>? _scaleAnimation;
  late Offset _scaleAnimationFocalPoint;
  late AnimationController _controller;
  late AnimationController _scaleController;
  Axis? _currentAxis; // Used with panAxis.
  Offset? _referenceFocalPoint; // Point where the current gesture began.
  double? _scaleStart; // Scale value at start of scaling gesture.
  final double _currentRotation =
      0; // Rotation of _transformationController.value.
  _GestureType? _gestureType;

  // The _boundaryRect is calculated by adding the boundaryMargin to the size of
  // the child.
  Rect get _boundaryRect {
    assert(_childKey.currentContext != null);
    assert(!widget.boundaryMargin.left.isNaN);
    assert(!widget.boundaryMargin.right.isNaN);
    assert(!widget.boundaryMargin.top.isNaN);
    assert(!widget.boundaryMargin.bottom.isNaN);

    final childRenderBox =
        _childKey.currentContext!.findRenderObject()! as RenderBox;
    final childSize = childRenderBox.size;
    final boundaryRect =
        widget.boundaryMargin.inflateRect(Offset.zero & childSize);
    assert(
      !boundaryRect.isEmpty,
      "CustomInteractiveViewer's child must have nonzero dimensions.",
    );
    // Boundaries that are partially infinite are not allowed because Matrix4's
    // rotation and translation methods don't handle infinite well.
    assert(
      boundaryRect.isFinite ||
          (boundaryRect.left.isInfinite &&
              boundaryRect.top.isInfinite &&
              boundaryRect.right.isInfinite &&
              boundaryRect.bottom.isInfinite),
      'boundaryRect must either be infinite in all directions or finite in all directions.',
    );
    return boundaryRect;
  }

  // The Rect representing the child's parent.
  Rect get _viewport {
    assert(_parentKey.currentContext != null);
    final parentRenderBox =
        _parentKey.currentContext!.findRenderObject()! as RenderBox;
    return Offset.zero & parentRenderBox.size;
  }

  // Return a new matrix representing the given matrix after applying the given
  // translation.
  Matrix4 _matrixTranslate(Matrix4 matrix, Offset translation) {
    if (translation == Offset.zero) {
      return matrix.clone();
    }

    final Offset alignedTranslation;

    if (_currentAxis != null) {
      alignedTranslation = switch (widget.panAxis) {
        PanAxis.horizontal => _alignAxis(translation, Axis.horizontal),
        PanAxis.vertical => _alignAxis(translation, Axis.vertical),
        PanAxis.aligned => _alignAxis(translation, _currentAxis!),
        PanAxis.free => translation,
      };
    } else {
      alignedTranslation = translation;
    }

    final nextMatrix = matrix.clone()
      ..translateByDouble(
        alignedTranslation.dx,
        alignedTranslation.dy,
        0,
        1,
      );

    // Transform the viewport to determine where its four corners will be after
    // the child has been transformed.
    final nextViewport = CustomInteractiveViewer.transformViewport(
      nextMatrix,
      _viewport,
    );

    // If the boundaries are infinite, then no need to check if the translation
    // fits within them.
    if (_boundaryRect.isInfinite) {
      return nextMatrix;
    }

    // Expand the boundaries with rotation. This prevents the problem where a
    // mismatch in orientation between the viewport and boundaries effectively
    // limits translation. With this approach, all points that are visible with
    // no rotation are visible after rotation.
    final boundariesAabbQuad = _getAxisAlignedBoundingBoxWithRotation(
      _boundaryRect,
      _currentRotation,
    );

    // If the given translation fits completely within the boundaries, allow it.
    final offendingDistance = _exceedsBy(boundariesAabbQuad, nextViewport);
    if (offendingDistance == Offset.zero) {
      return nextMatrix;
    }

    // Desired translation goes out of bounds, so translate to the nearest
    // in-bounds point instead.
    final nextTotalTranslation = _getMatrixTranslation(nextMatrix);
    final currentScale = matrix.getMaxScaleOnAxis();
    final correctedTotalTranslation = Offset(
      nextTotalTranslation.dx - offendingDistance.dx * currentScale,
      nextTotalTranslation.dy - offendingDistance.dy * currentScale,
    );

    final correctedMatrix = matrix.clone()
      ..setTranslation(
        Vector3(
          correctedTotalTranslation.dx,
          correctedTotalTranslation.dy,
          0,
        ),
      );

    // Double check that the corrected translation fits.
    final correctedViewport = CustomInteractiveViewer.transformViewport(
      correctedMatrix,
      _viewport,
    );
    final offendingCorrectedDistance =
        _exceedsBy(boundariesAabbQuad, correctedViewport);
    if (offendingCorrectedDistance == Offset.zero) {
      return correctedMatrix;
    }

    // If the corrected translation doesn't fit in either direction, don't allow
    // any translation at all. This happens when the viewport is larger than the
    // entire boundary.
    if (offendingCorrectedDistance.dx != 0.0 &&
        offendingCorrectedDistance.dy != 0.0) {
      return matrix.clone();
    }

    // Otherwise, allow translation in only the direction that fits. This
    // happens when the viewport is larger than the boundary in one direction.
    final unidirectionalCorrectedTotalTranslation = Offset(
      offendingCorrectedDistance.dx == 0.0 ? correctedTotalTranslation.dx : 0.0,
      offendingCorrectedDistance.dy == 0.0 ? correctedTotalTranslation.dy : 0.0,
    );
    return matrix.clone()
      ..setTranslation(
        Vector3(
          unidirectionalCorrectedTotalTranslation.dx,
          unidirectionalCorrectedTotalTranslation.dy,
          0,
        ),
      );
  }

  // Return a new matrix representing the given matrix after applying the given
  // scale.
  Matrix4 _matrixScale(Matrix4 matrix, double scale) {
    if (scale == 1.0) {
      return matrix.clone();
    }
    assert(scale != 0.0);

    // Don't allow a scale that results in an overall scale beyond min/max
    // scale.
    final currentScale = _transformationController!.value.getMaxScaleOnAxis();
    final double totalScale = math.max(
      currentScale * scale,
      // Ensure that the scale cannot make the child so big that it can't fit
      // inside the boundaries (in either direction).
      math.max(
        _viewport.width / _boundaryRect.width,
        _viewport.height / _boundaryRect.height,
      ),
    );
    final clampedTotalScale = clampDouble(
      totalScale,
      widget.minScale,
      widget.maxScale,
    );
    final clampedScale = clampedTotalScale / currentScale;
    return matrix.clone()
      ..scaleByDouble(clampedScale, clampedScale, clampedScale, 1);
  }

  // Returns true iff the given _GestureType is enabled.
  bool _gestureIsSupported(_GestureType? gestureType) {
    return switch (gestureType) {
      _GestureType.scale => widget.scaleEnabled,
      _GestureType.pan || null => widget.panEnabled,
    };
  }

  // Decide which type of gesture this is by comparing the amount of scale
  // and rotation in the gesture, if any. Scale starts at 1 and rotation
  // starts at 0. Pan will have no scale and no rotation because it uses only one
  // finger.
  _GestureType _getGestureType(ScaleUpdateDetails details) {
    final scale = !widget.scaleEnabled ? 1.0 : details.scale;
    if (scale != 1) {
      return _GestureType.scale;
    } else {
      return _GestureType.pan;
    }
  }

  // Handle the start of a gesture. All of pan, scale, and rotate are handled
  // with GestureDetector's scale gesture.
  void _onScaleStart(ScaleStartDetails details) {
    widget.onInteractionStart?.call(details);

    if (_controller.isAnimating) {
      _controller
        ..stop()
        ..reset();
      _animation?.removeListener(_onAnimate);
      _animation = null;
    }
    if (_scaleController.isAnimating) {
      _scaleController
        ..stop()
        ..reset();
      _scaleAnimation?.removeListener(_onScaleAnimate);
      _scaleAnimation = null;
    }

    _gestureType = null;
    _currentAxis = null;
    _scaleStart = _transformationController!.value.getMaxScaleOnAxis();
    _referenceFocalPoint = _transformationController!.toScene(
      details.localFocalPoint,
    );
  }

  // Handle an update to an ongoing gesture. All of pan, scale, and rotate are
  // handled with GestureDetector's scale gesture.
  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scale = _transformationController!.value.getMaxScaleOnAxis();
    _scaleAnimationFocalPoint = details.localFocalPoint;
    final focalPointScene = _transformationController!.toScene(
      details.localFocalPoint,
    );

    if (_gestureType == _GestureType.pan) {
      // When a gesture first starts, it sometimes has no change in scale and
      // rotation despite being a two-finger gesture. Here the gesture is
      // allowed to be reinterpreted as its correct type after originally
      // being marked as a pan.
      _gestureType = _getGestureType(details);
    } else {
      _gestureType ??= _getGestureType(details);
    }
    if (!_gestureIsSupported(_gestureType)) {
      widget.onInteractionUpdate?.call(details);
      return;
    }

    switch (_gestureType!) {
      case _GestureType.scale:
        assert(_scaleStart != null);
        // details.scale gives us the amount to change the scale as of the
        // start of this gesture, so calculate the amount to scale as of the
        // previous call to _onScaleUpdate.
        final desiredScale = _scaleStart! * details.scale;
        final scaleChange = desiredScale / scale;
        _transformationController!.value = _matrixScale(
          _transformationController!.value,
          scaleChange,
        );

        // While scaling, translate such that the user's two fingers stay on
        // the same places in the scene. That means that the focal point of
        // the scale should be on the same place in the scene before and after
        // the scale.
        final focalPointSceneScaled = _transformationController!.toScene(
          details.localFocalPoint,
        );
        _transformationController!.value = _matrixTranslate(
          _transformationController!.value,
          focalPointSceneScaled - _referenceFocalPoint!,
        );

        // details.localFocalPoint should now be at the same location as the
        // original _referenceFocalPoint point. If it's not, that's because
        // the translate came in contact with a boundary. In that case, update
        // _referenceFocalPoint so subsequent updates happen in relation to
        // the new effective focal point.
        final focalPointSceneCheck = _transformationController!.toScene(
          details.localFocalPoint,
        );
        if (_round(_referenceFocalPoint!) != _round(focalPointSceneCheck)) {
          _referenceFocalPoint = focalPointSceneCheck;
        }

      case _GestureType.pan:
        assert(_referenceFocalPoint != null);
        // details may have a change in scale here when scaleEnabled is false.
        // In an effort to keep the behavior similar whether or not scaleEnabled
        // is true, these gestures are thrown away.
        if (details.scale != 1.0) {
          widget.onInteractionUpdate?.call(details);
          return;
        }
        _currentAxis ??= _getPanAxis(_referenceFocalPoint!, focalPointScene);
        // Translate so that the same point in the scene is underneath the
        // focal point before and after the movement.
        final translationChange = focalPointScene - _referenceFocalPoint!;
        _transformationController!.value = _matrixTranslate(
          _transformationController!.value,
          translationChange,
        );
        _referenceFocalPoint = _transformationController!.toScene(
          details.localFocalPoint,
        );
    }
    widget.onInteractionUpdate?.call(details);
  }

  // Handle the end of a gesture of _GestureType. All of pan, scale, and rotate
  // are handled with GestureDetector's scale gesture.
  void _onScaleEnd(ScaleEndDetails details) {
    widget.onInteractionEnd?.call(details);
    _scaleStart = null;
    _referenceFocalPoint = null;

    _animation?.removeListener(_onAnimate);
    _scaleAnimation?.removeListener(_onScaleAnimate);
    _controller.reset();
    _scaleController.reset();

    if (!_gestureIsSupported(_gestureType)) {
      _currentAxis = null;
      return;
    }

    switch (_gestureType) {
      case _GestureType.pan:
        if (details.velocity.pixelsPerSecond.distance < kMinFlingVelocity) {
          _currentAxis = null;
          return;
        }
        final translationVector =
            _transformationController!.value.getTranslation();
        final translation = Offset(translationVector.x, translationVector.y);
        final frictionSimulationX = FrictionSimulation(
          widget.interactionEndFrictionCoefficient,
          translation.dx,
          details.velocity.pixelsPerSecond.dx,
        );
        final frictionSimulationY = FrictionSimulation(
          widget.interactionEndFrictionCoefficient,
          translation.dy,
          details.velocity.pixelsPerSecond.dy,
        );
        final tFinal = _getFinalTime(
          details.velocity.pixelsPerSecond.distance,
          widget.interactionEndFrictionCoefficient,
        );
        _animation = Tween<Offset>(
          begin: translation,
          end: Offset(frictionSimulationX.finalX, frictionSimulationY.finalX),
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.decelerate,
          ),
        );
        _controller.duration = Duration(milliseconds: (tFinal * 1000).round());
        _animation!.addListener(_onAnimate);
        unawaited(_controller.forward());
      case _GestureType.scale:
        if (details.scaleVelocity.abs() < 0.1) {
          _currentAxis = null;
          return;
        }
        final scale = _transformationController!.value.getMaxScaleOnAxis();
        final frictionSimulation = FrictionSimulation(
          widget.interactionEndFrictionCoefficient * widget.scaleFactor,
          scale,
          details.scaleVelocity / 10,
        );
        final tFinal = _getFinalTime(
          details.scaleVelocity.abs(),
          widget.interactionEndFrictionCoefficient,
          effectivelyMotionless: 0.1,
        );
        _scaleAnimation =
            Tween<double>(begin: scale, end: frictionSimulation.x(tFinal))
                .animate(
          CurvedAnimation(
            parent: _scaleController,
            curve: Curves.decelerate,
          ),
        );
        _scaleController.duration =
            Duration(milliseconds: (tFinal * 1000).round());
        _scaleAnimation!.addListener(_onScaleAnimate);
        unawaited(_scaleController.forward());
      case null:
        break;
    }
  }

  // Handle mouse wheel and web trackpad scroll events.
  void _receivedPointerSignal(PointerSignalEvent event) {
    final double scaleChange;
    if (event is PointerScrollEvent) {
      if (event.kind == PointerDeviceKind.trackpad &&
          !widget.trackpadScrollCausesScale) {
        // Trackpad scroll, so treat it as a pan.
        widget.onInteractionStart?.call(
          ScaleStartDetails(
            focalPoint: event.position,
            localFocalPoint: event.localPosition,
          ),
        );

        final localDelta = PointerEvent.transformDeltaViaPositions(
          untransformedEndPosition: event.position + event.scrollDelta,
          untransformedDelta: event.scrollDelta,
          transform: event.transform,
        );

        if (!_gestureIsSupported(_GestureType.pan)) {
          widget.onInteractionUpdate?.call(
            ScaleUpdateDetails(
              focalPoint: event.position - event.scrollDelta,
              localFocalPoint: event.localPosition - event.scrollDelta,
              focalPointDelta: -localDelta,
            ),
          );
          widget.onInteractionEnd?.call(ScaleEndDetails());
          return;
        }

        final focalPointScene = _transformationController!.toScene(
          event.localPosition,
        );

        final newFocalPointScene = _transformationController!.toScene(
          event.localPosition - localDelta,
        );

        _transformationController!.value = _matrixTranslate(
          _transformationController!.value,
          newFocalPointScene - focalPointScene,
        );

        widget.onInteractionUpdate?.call(
          ScaleUpdateDetails(
            focalPoint: event.position - event.scrollDelta,
            localFocalPoint: event.localPosition - localDelta,
            focalPointDelta: -localDelta,
          ),
        );
        widget.onInteractionEnd?.call(ScaleEndDetails());
        return;
      }
      // Ignore left and right mouse wheel scroll.
      if (event.scrollDelta.dy == 0.0) {
        return;
      }
      scaleChange = math.exp(-event.scrollDelta.dy / widget.scaleFactor);
    } else if (event is PointerScaleEvent) {
      scaleChange = event.scale;
    } else {
      return;
    }
    widget.onInteractionStart?.call(
      ScaleStartDetails(
        focalPoint: event.position,
        localFocalPoint: event.localPosition,
      ),
    );

    if (!_gestureIsSupported(_GestureType.scale)) {
      widget.onInteractionUpdate?.call(
        ScaleUpdateDetails(
          focalPoint: event.position,
          localFocalPoint: event.localPosition,
          scale: scaleChange,
        ),
      );
      widget.onInteractionEnd?.call(ScaleEndDetails());
      return;
    }

    final focalPointScene = _transformationController!.toScene(
      event.localPosition,
    );

    _transformationController!.value = _matrixScale(
      _transformationController!.value,
      scaleChange,
    );

    // After scaling, translate such that the event's position is at the
    // same scene point before and after the scale.
    final focalPointSceneScaled = _transformationController!.toScene(
      event.localPosition,
    );
    _transformationController!.value = _matrixTranslate(
      _transformationController!.value,
      focalPointSceneScaled - focalPointScene,
    );

    widget.onInteractionUpdate?.call(
      ScaleUpdateDetails(
        focalPoint: event.position,
        localFocalPoint: event.localPosition,
        scale: scaleChange,
      ),
    );
    widget.onInteractionEnd?.call(ScaleEndDetails());
  }

  // Handle inertia drag animation.
  void _onAnimate() {
    if (!_controller.isAnimating) {
      _currentAxis = null;
      _animation?.removeListener(_onAnimate);
      _animation = null;
      _controller.reset();
      return;
    }
    // Translate such that the resulting translation is _animation.value.
    final translationVector = _transformationController!.value.getTranslation();
    final translation = Offset(translationVector.x, translationVector.y);
    final translationScene = _transformationController!.toScene(
      translation,
    );
    final animationScene = _transformationController!.toScene(
      _animation!.value,
    );
    final translationChangeScene = animationScene - translationScene;
    _transformationController!.value = _matrixTranslate(
      _transformationController!.value,
      translationChangeScene,
    );
  }

  // Handle inertia scale animation.
  void _onScaleAnimate() {
    if (!_scaleController.isAnimating) {
      _currentAxis = null;
      _scaleAnimation?.removeListener(_onScaleAnimate);
      _scaleAnimation = null;
      _scaleController.reset();
      return;
    }
    final desiredScale = _scaleAnimation!.value;
    final scaleChange =
        desiredScale / _transformationController!.value.getMaxScaleOnAxis();
    final referenceFocalPoint = _transformationController!.toScene(
      _scaleAnimationFocalPoint,
    );
    _transformationController!.value = _matrixScale(
      _transformationController!.value,
      scaleChange,
    );

    // While scaling, translate such that the user's two fingers stay on
    // the same places in the scene. That means that the focal point of
    // the scale should be on the same place in the scene before and after
    // the scale.
    final focalPointSceneScaled = _transformationController!.toScene(
      _scaleAnimationFocalPoint,
    );
    _transformationController!.value = _matrixTranslate(
      _transformationController!.value,
      focalPointSceneScaled - referenceFocalPoint,
    );
  }

  void _onTransformationControllerChange() {
    // A change to the TransformationController's value is a change to the
    // state.
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _transformationController =
        widget.transformationController ?? TransformationController();
    _transformationController!.addListener(_onTransformationControllerChange);
    _controller = AnimationController(
      vsync: this,
    );
    _scaleController = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(CustomInteractiveViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle all cases of needing to dispose and initialize
    // transformationControllers.
    if (oldWidget.transformationController == null) {
      if (widget.transformationController != null) {
        _transformationController!
            .removeListener(_onTransformationControllerChange);
        _transformationController!.dispose();
        _transformationController = widget.transformationController;
        _transformationController!
            .addListener(_onTransformationControllerChange);
      }
    } else {
      if (widget.transformationController == null) {
        _transformationController!
            .removeListener(_onTransformationControllerChange);
        _transformationController = TransformationController();
        _transformationController!
            .addListener(_onTransformationControllerChange);
      } else if (widget.transformationController !=
          oldWidget.transformationController) {
        _transformationController!
            .removeListener(_onTransformationControllerChange);
        _transformationController = widget.transformationController;
        _transformationController!
            .addListener(_onTransformationControllerChange);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scaleController.dispose();
    _transformationController!
        .removeListener(_onTransformationControllerChange);
    if (widget.transformationController == null) {
      _transformationController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (widget.child != null) {
      child = _CustomInteractiveViewerBuilt(
        childKey: _childKey,
        clipBehavior: widget.clipBehavior,
        constrained: widget.constrained,
        matrix: _transformationController!.value,
        alignment: widget.alignment,
        child: widget.child!,
      );
    } else {
      // When using CustomInteractiveViewer.builder, then constrained is false and the
      // viewport is the size of the constraints.
      assert(widget.builder != null);
      assert(!widget.constrained);
      child = LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final matrix = _transformationController!.value;
          return _CustomInteractiveViewerBuilt(
            childKey: _childKey,
            clipBehavior: widget.clipBehavior,
            constrained: widget.constrained,
            alignment: widget.alignment,
            matrix: matrix,
            child: widget.builder!(
              context,
              CustomInteractiveViewer.transformViewport(
                matrix,
                Offset.zero & constraints.biggest,
              ),
            ),
          );
        },
      );
    }

    return Listener(
      key: _parentKey,
      onPointerSignal: _receivedPointerSignal,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque, // Necessary when panning off screen.
        onScaleEnd: _onScaleEnd,
        onScaleStart: _onScaleStart,
        onScaleUpdate: _onScaleUpdate,
        trackpadScrollCausesScale: widget.trackpadScrollCausesScale,
        trackpadScrollToScaleFactor: Offset(0, -1 / widget.scaleFactor),
        child: child,
      ),
    );
  }
}

// This widget allows us to easily swap in and out the LayoutBuilder in
// CustomInteractiveViewer's depending on if it's using a builder or a child.
class _CustomInteractiveViewerBuilt extends StatelessWidget {
  const _CustomInteractiveViewerBuilt({
    required this.child,
    required this.childKey,
    required this.clipBehavior,
    required this.constrained,
    required this.matrix,
    required this.alignment,
  });

  final Widget child;
  final GlobalKey childKey;
  final Clip clipBehavior;
  final bool constrained;
  final Matrix4 matrix;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    Widget child = KeyedSubtree(
      key: childKey,
      child: this.child,
    );

    if (!constrained) {
      child = OverflowBox(
        alignment: Alignment.topLeft,
        minWidth: 0,
        minHeight: 0,
        maxWidth: double.infinity,
        maxHeight: double.infinity,
        child: child,
      );
    }

    return ClipRect(
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}

// A classification of relevant user gestures. Each contiguous user gesture is
// represented by exactly one _GestureType.
enum _GestureType {
  pan,
  scale,
}

// Given a velocity and drag, calculate the time at which motion will come to
// a stop, within the margin of effectivelyMotionless.
double _getFinalTime(
  double velocity,
  double drag, {
  double effectivelyMotionless = 10,
}) {
  return math.log(effectivelyMotionless / velocity) / math.log(drag / 100);
}

// Return the translation from the given Matrix4 as an Offset.
Offset _getMatrixTranslation(Matrix4 matrix) {
  final nextTranslation = matrix.getTranslation();
  return Offset(nextTranslation.x, nextTranslation.y);
}

// Find the axis aligned bounding box for the rect rotated about its center by
// the given amount.
Quad _getAxisAlignedBoundingBoxWithRotation(Rect rect, double rotation) {
  final rotationMatrix = Matrix4.identity()
    ..translateByDouble(rect.size.width / 2, rect.size.height / 2, 0, 1)
    ..rotateZ(rotation)
    ..translateByDouble(-rect.size.width / 2, -rect.size.height / 2, 0, 1);
  final boundariesRotated = Quad.points(
    rotationMatrix.transform3(Vector3(rect.left, rect.top, 0)),
    rotationMatrix.transform3(Vector3(rect.right, rect.top, 0)),
    rotationMatrix.transform3(Vector3(rect.right, rect.bottom, 0)),
    rotationMatrix.transform3(Vector3(rect.left, rect.bottom, 0)),
  );
  return CustomInteractiveViewer.getAxisAlignedBoundingBox(boundariesRotated);
}

// Return the amount that viewport lies outside of boundary. If the viewport
// is completely contained within the boundary (inclusively), then returns
// Offset.zero.
Offset _exceedsBy(Quad boundary, Quad viewport) {
  final viewportPoints = <Vector3>[
    viewport.point0,
    viewport.point1,
    viewport.point2,
    viewport.point3,
  ];
  var largestExcess = Offset.zero;
  for (final point in viewportPoints) {
    final pointInside =
        CustomInteractiveViewer.getNearestPointInside(point, boundary);
    final excess = Offset(
      pointInside.x - point.x,
      pointInside.y - point.y,
    );
    if (excess.dx.abs() > largestExcess.dx.abs()) {
      largestExcess = Offset(excess.dx, largestExcess.dy);
    }
    if (excess.dy.abs() > largestExcess.dy.abs()) {
      largestExcess = Offset(largestExcess.dx, excess.dy);
    }
  }

  return _round(largestExcess);
}

// Round the output values. This works around a precision problem where
// values that should have been zero were given as within 10^-10 of zero.
Offset _round(Offset offset) {
  return Offset(
    double.parse(offset.dx.toStringAsFixed(9)),
    double.parse(offset.dy.toStringAsFixed(9)),
  );
}

// Align the given offset to the given axis by allowing movement only in the
// axis direction.
Offset _alignAxis(Offset offset, Axis axis) {
  return switch (axis) {
    Axis.horizontal => Offset(offset.dx, 0),
    Axis.vertical => Offset(0, offset.dy),
  };
}

// Given two points, return the axis where the distance between the points is
// greatest. If they are equal, return null.
Axis? _getPanAxis(Offset point1, Offset point2) {
  if (point1 == point2) {
    return null;
  }
  final x = point2.dx - point1.dx;
  final y = point2.dy - point1.dy;
  return x.abs() > y.abs() ? Axis.horizontal : Axis.vertical;
}
