import 'package:fl_chart/src/chart/base/base_chart/initial_animation_configuration.dart';
import 'package:flutter/material.dart';

@optionalTypeArgs
mixin InitialAnimationMixin<T, D extends ImplicitlyAnimatedWidget>
    on AnimatedWidgetBaseState<D> {
  InitialAnimationConfiguration get initialAnimationConfiguration;
  Tween<dynamic>? get tween;

  T? _targetValue;

  @override
  void initState() {
    super.initState();
    _handleInitialAnimation();
  }

  void _handleInitialAnimation() {
    if (!initialAnimationConfiguration.enabled) {
      return;
    }

    if (tween == null || _targetValue == null) {
      return;
    }
    tween!
      ..begin = tween!.evaluate(animation)
      ..end = _targetValue;

    controller
      ..value = 0.0
      ..forward();
    didUpdateTweens();
  }

  T constructInitialData(T data) {
    if (!initialAnimationConfiguration.enabled) {
      return data;
    }
    _targetValue = data;

    return getAppearanceAnimationData(data);
  }

  T getAppearanceAnimationData(T data);

  double getAppearanceValue(double minY, double maxY) {
    final initialValue = initialAnimationConfiguration.initialValue;
    if (initialValue != null) {
      return initialValue;
    }

    return (minY <= 0 && maxY >= 0) ? 0.0 : minY;
  }
}
