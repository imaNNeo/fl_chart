import 'package:equatable/equatable.dart';

/// It holds configuration for initial animation
class InitialAnimationConfiguration with EquatableMixin {
  const InitialAnimationConfiguration({
    this.enabled = true,
    this.initialValue,
  });

  /// Determines if the initial animation is enabled.
  final bool enabled;

  /// Initial value of the animation. If null then max(0, minY) is used.
  final double? initialValue;

  @override
  List<Object?> get props => [enabled, initialValue];
}
