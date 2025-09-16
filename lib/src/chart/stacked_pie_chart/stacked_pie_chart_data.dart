import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/material.dart';

/// [StackedPieChart] needs this class to render itself.
///
/// It holds data needed to draw a pie chart,
/// including pie sections, colors, ...
class StackedPieChartData extends BaseChartData with EquatableMixin {
  /// [StackedPieChart] draws some [sections] consisting of segments
  /// [StackedPieChartSectionData.segments] in a circle,
  /// and applies free space with radius [centerSpaceRadius],
  /// and color [centerSpaceColor] in the center of the circle,
  /// if you don't want it, set [centerSpaceRadius] to zero.
  ///
  /// It draws [sections] from zero degree (right side of the circle) clockwise,
  /// you can change the starting point, by changing [startDegreeOffset] (in degrees).
  ///
  /// You can define a gap between [sections] by setting [sectionsSpace].
  ///
  /// You can modify [pieTouchData] to customize touch behaviors and responses.
  StackedPieChartData({
    List<StackedPieChartSectionData>? sections,
    double? centerSpaceRadius,
    Color? centerSpaceColor,
    double? sectionsSpace,
    double? startDegreeOffset,
    StackedPieTouchData? pieTouchData,
    FlBorderData? borderData,
    bool? titleSunbeamLayout,
  })  : sections = sections ?? const [],
        centerSpaceRadius = centerSpaceRadius ?? double.infinity,
        centerSpaceColor = centerSpaceColor ?? Colors.transparent,
        sectionsSpace = sectionsSpace ?? 2,
        startDegreeOffset = startDegreeOffset ?? 0,
        pieTouchData = pieTouchData ?? StackedPieTouchData(),
        titleSunbeamLayout = titleSunbeamLayout ?? false,
        super(
          borderData: borderData ?? FlBorderData(show: false),
        );

  /// Defines showing sections of the [PieChart].
  final List<StackedPieChartSectionData> sections;

  /// Radius of free space in center of the circle.
  final double centerSpaceRadius;

  /// Color of free space in center of the circle.
  final Color centerSpaceColor;

  /// Defines gap between sections.
  ///
  /// Does not work on html-renderer,
  /// https://github.com/imaNNeo/fl_chart/issues/955
  final double sectionsSpace;

  /// [PieChart] draws [sections] from zero degree (right side of the circle) clockwise.
  final double startDegreeOffset;

  /// Handles touch behaviors and responses.
  final StackedPieTouchData pieTouchData;

  /// Whether to rotate the titles on each section of the chart
  final bool titleSunbeamLayout;

  double get sumWeights =>
      sections.fold(0, (value, section) => value + section.weight);

  StackedPieChartData copyWith({
    List<StackedPieChartSectionData>? sections,
    double? centerSpaceRadius,
    Color? centerSpaceColor,
    double? sectionsSpace,
    double? startDegreeOffset,
    StackedPieTouchData? pieTouchData,
    bool? titleSunbeamLayout,
  }) {
    return StackedPieChartData(
      sections: sections ?? this.sections,
      centerSpaceRadius: centerSpaceRadius ?? this.centerSpaceRadius,
      centerSpaceColor: centerSpaceColor ?? this.centerSpaceColor,
      sectionsSpace: sectionsSpace ?? this.sectionsSpace,
      startDegreeOffset: startDegreeOffset ?? this.startDegreeOffset,
      pieTouchData: pieTouchData ?? this.pieTouchData,
      titleSunbeamLayout: titleSunbeamLayout ?? this.titleSunbeamLayout,
    );
  }

  @override
  StackedPieChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is StackedPieChartData && b is StackedPieChartData) {
      return StackedPieChartData(
        borderData: FlBorderData.lerp(a.borderData, b.borderData, t),
        centerSpaceColor: Color.lerp(a.centerSpaceColor, b.centerSpaceColor, t),
        centerSpaceRadius: lerpDoubleAllowInfinity(
          a.centerSpaceRadius,
          b.centerSpaceRadius,
          t,
        ),
        pieTouchData: b.pieTouchData,
        sectionsSpace: lerpDouble(a.sectionsSpace, b.sectionsSpace, t),
        startDegreeOffset:
            lerpDouble(a.startDegreeOffset, b.startDegreeOffset, t),
        sections: lerpStackedPieChartSectionDataList(a.sections, b.sections, t),
        titleSunbeamLayout: b.titleSunbeamLayout,
      );
    } else {
      throw Exception('Illegal State');
    }
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        sections,
        centerSpaceRadius,
        centerSpaceColor,
        sectionsSpace,
        startDegreeOffset,
        pieTouchData,
        borderData,
        titleSunbeamLayout,
      ];
}

class StackedPieChartSectionData with EquatableMixin {
  StackedPieChartSectionData({
    double? weight,
    List<StackedPieChartSegmentData>? segments,
    double? radius,
    bool? showTitle,
    String? title,
    this.titleStyle,
    BorderSide? borderSide,
    this.badgeWidget,
    double? titlePositionPercentageOffset,
    double? badgePositionPercentageOffset,
    double? segmentsSpace,
  })  : weight = weight ?? 10,
        segments = segments ?? const [],
        radius = radius ?? 40,
        showTitle = showTitle ?? true,
        title = title ?? '',
        borderSide = borderSide ?? const BorderSide(width: 0),
        segmentsSpace = segmentsSpace ?? 2,
        titlePositionPercentageOffset = titlePositionPercentageOffset ?? 0.5,
        badgePositionPercentageOffset = badgePositionPercentageOffset ?? 0.5;

  final double weight;
  final List<StackedPieChartSegmentData> segments;
  final double radius;
  final bool showTitle;
  final TextStyle? titleStyle;
  final String title;
  final BorderSide borderSide;
  final Widget? badgeWidget;
  final double titlePositionPercentageOffset;
  final double badgePositionPercentageOffset;
  final double segmentsSpace;

  static StackedPieChartSectionData lerp(
    StackedPieChartSectionData a,
    StackedPieChartSectionData b,
    double t,
  ) =>
      StackedPieChartSectionData(
        weight: lerpDouble(a.weight, b.weight, t),
        segments: lerpStackedPieChartSegmentDataList(a.segments, b.segments, t),
        radius: lerpDouble(a.radius, b.radius, t),
        showTitle: b.showTitle,
        titleStyle: TextStyle.lerp(a.titleStyle, b.titleStyle, t),
        title: b.title,
        borderSide: BorderSide.lerp(a.borderSide, b.borderSide, t),
        badgeWidget: b.badgeWidget,
        titlePositionPercentageOffset: lerpDouble(
          a.titlePositionPercentageOffset,
          b.titlePositionPercentageOffset,
          t,
        ),
        badgePositionPercentageOffset: lerpDouble(
          a.badgePositionPercentageOffset,
          b.badgePositionPercentageOffset,
          t,
        ),
        segmentsSpace: lerpDouble(a.segmentsSpace, b.segmentsSpace, t),
      );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        weight,
        segments,
        radius,
        showTitle,
        titleStyle,
        title,
        borderSide,
        badgeWidget,
        titlePositionPercentageOffset,
        badgePositionPercentageOffset,
        segmentsSpace,
      ];

  double get totalValues =>
      segments.fold(0, (values, segment) => values + segment.value);
}

class StackedPieChartSegmentData {
  StackedPieChartSegmentData({
    double? value,
    Color? color,
    this.gradient,
  })  : value = value ?? 10,
        color = color ?? Colors.cyan;

  final double value;
  final Color color;
  final Gradient? gradient;

  StackedPieChartSegmentData copyWith({
    double? value,
    Color? color,
    Gradient? gradient,
  }) {
    return StackedPieChartSegmentData(
      value: value ?? this.value,
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
    );
  }

  static StackedPieChartSegmentData lerp(
    StackedPieChartSegmentData a,
    StackedPieChartSegmentData b,
    double t,
  ) =>
      StackedPieChartSegmentData(
        value: lerpDouble(a.value, b.value, t),
        color: Color.lerp(a.color, b.color, t),
        gradient: Gradient.lerp(a.gradient, b.gradient, t),
      );

  /// Used for equality check, see [EquatableMixin].
  List<Object?> get props => [
        value,
        color,
        gradient,
      ];
}

class StackedPieTouchData extends FlTouchData<StackedPieTouchResponse>
    with EquatableMixin {
  /// You can disable or enable the touch system using [enabled] flag,
  ///
  /// [touchCallback] notifies you about the happened touch/pointer events.
  /// It gives you a [FlTouchEvent] which is the happened event such as [FlPointerHoverEvent], [FlTapUpEvent], ...
  /// It also gives you a [StackedPieTouchResponse] which contains information
  /// about the elements that has touched.
  ///
  /// Using [mouseCursorResolver] you can change the mouse cursor
  /// based on the provided [FlTouchEvent] and [StackedPieTouchResponse]
  StackedPieTouchData({
    bool? enabled,
    BaseTouchCallback<StackedPieTouchResponse>? touchCallback,
    MouseCursorResolver<StackedPieTouchResponse>? mouseCursorResolver,
    Duration? longPressDuration,
  }) : super(
          enabled ?? true,
          touchCallback,
          mouseCursorResolver,
          longPressDuration,
        );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        enabled,
        touchCallback,
        mouseCursorResolver,
        longPressDuration,
      ];
}

class StackedPieTouchedSection with EquatableMixin {
  /// This class Contains [touchedSection], [touchedSectionIndex] that tells
  /// you touch happened on which section,
  /// [touchAngle] gives you angle of touch,
  /// and [touchRadius] gives you radius of the touch.
  StackedPieTouchedSection(
    this.touchedSection,
    this.touchedSectionIndex,
    this.touchAngle,
    this.touchRadius,
  );

  /// touch happened on this section
  final StackedPieChartSectionData? touchedSection;

  /// touch happened on this position
  final int touchedSectionIndex;

  /// touch happened with this angle on the [StackedPieChart]
  final double touchAngle;

  /// touch happened with this radius on the [StackedPieChart]
  final double touchRadius;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        touchedSection,
        touchedSectionIndex,
        touchAngle,
        touchRadius,
      ];
}

/// Holds information about touch response in the [StackedPieChart].
///
/// You can override [StackedPieTouchData.touchCallback] to handle touch events,
/// it gives you a [StackedPieTouchResponse] and you can do whatever you want.
class StackedPieTouchResponse extends BaseTouchResponse {
  /// If touch happens, [PieChart] processes it internally and passes out a [PieTouchResponse]
  StackedPieTouchResponse({
    required super.touchLocation,
    required this.touchedSection,
  });

  /// Contains information about touched section, like index, angle, radius, ...
  final StackedPieTouchedSection? touchedSection;

  /// Copies current [StackedPieTouchResponse] to a new [StackedPieTouchResponse],
  /// and replaces provided values.
  StackedPieTouchResponse copyWith({
    Offset? touchLocation,
    StackedPieTouchedSection? touchedSection,
  }) =>
      StackedPieTouchResponse(
        touchLocation: touchLocation ?? this.touchLocation,
        touchedSection: touchedSection ?? this.touchedSection,
      );
}

class StackedPieChartDataTween extends Tween<StackedPieChartData> {
  StackedPieChartDataTween(
      {required StackedPieChartData begin, required StackedPieChartData end})
      : super(begin: begin, end: end);

  /// Lerps a [PieChartData] based on [t] value, check [Tween.lerp].
  @override
  StackedPieChartData lerp(double t) => begin!.lerp(begin!, end!, t);
}
