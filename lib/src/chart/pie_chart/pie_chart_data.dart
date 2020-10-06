import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../base/base_chart/base_chart_data.dart';
import 'pie_chart.dart';

/// [PieChart] needs this class to render itself.
///
/// It holds data needed to draw a pie chart,
/// including pie sections, colors, ...
class PieChartData extends BaseChartData with EquatableMixin {
  /// Defines showing sections of the [PieChart].
  final List<PieChartSectionData> sections;

  /// Radius of free space in center of the circle.
  final double centerSpaceRadius;

  /// Color of free space in center of the circle.
  final Color centerSpaceColor;

  /// Defines gap between sections.
  final double sectionsSpace;

  /// [PieChart] draws [sections] from zero degree (right side of the circle) clockwise.
  final double startDegreeOffset;

  /// Handles touch behaviors and responses.
  final PieTouchData pieTouchData;

  /// We hold this value to determine weight of each [PieChartSectionData.value].
  double get sumValue =>
      sections.map((data) => data.value).reduce((first, second) => first + second);

  /// [PieChart] draws some [sections] in a circle,
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
  PieChartData({
    List<PieChartSectionData> sections,
    double centerSpaceRadius,
    Color centerSpaceColor,
    double sectionsSpace,
    double startDegreeOffset,
    PieTouchData pieTouchData,
    FlBorderData borderData,
  })  : sections = sections ?? const [],
        centerSpaceRadius = centerSpaceRadius ?? double.infinity,
        centerSpaceColor = centerSpaceColor ?? Colors.transparent,

        /// we've disabled `groupSpace` on web, because some BlendModes are [not working](https://github.com/flutter/flutter/issues/56071) yet
        sectionsSpace = kIsWeb ? 0 : sectionsSpace ?? 2,
        startDegreeOffset = startDegreeOffset ?? 0,
        pieTouchData = pieTouchData ?? PieTouchData(),
        super(borderData: borderData, touchData: pieTouchData ?? PieTouchData());

  /// Copies current [PieChartData] to a new [PieChartData],
  /// and replaces provided values.
  PieChartData copyWith({
    List<PieChartSectionData> sections,
    double centerSpaceRadius,
    Color centerSpaceColor,
    double sectionsSpace,
    double startDegreeOffset,
    PieTouchData pieTouchData,
    FlBorderData borderData,
  }) {
    return PieChartData(
      sections: sections ?? this.sections,
      centerSpaceRadius: centerSpaceRadius ?? this.centerSpaceRadius,
      centerSpaceColor: centerSpaceColor ?? this.centerSpaceColor,
      sectionsSpace: sectionsSpace ?? this.sectionsSpace,
      startDegreeOffset: startDegreeOffset ?? this.startDegreeOffset,
      pieTouchData: pieTouchData ?? this.pieTouchData,
      borderData: borderData ?? this.borderData,
    );
  }

  /// Lerps a [BaseChartData] based on [t] value, check [Tween.lerp].
  @override
  BaseChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is PieChartData && b is PieChartData && t != null) {
      return PieChartData(
        borderData: FlBorderData.lerp(a.borderData, b.borderData, t),
        centerSpaceColor: Color.lerp(a.centerSpaceColor, b.centerSpaceColor, t),
        centerSpaceRadius: lerpDouble(a.centerSpaceRadius, b.centerSpaceRadius, t),
        pieTouchData: b.pieTouchData,
        sectionsSpace: lerpDouble(a.sectionsSpace, b.sectionsSpace, t),
        startDegreeOffset: lerpDouble(a.startDegreeOffset, b.startDegreeOffset, t),
        sections: lerpPieChartSectionDataList(a.sections, b.sections, t),
      );
    } else {
      throw Exception('Illegal State');
    }
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object> get props => [
        sections,
        centerSpaceRadius,
        centerSpaceColor,
        pieTouchData,
        sectionsSpace,
        startDegreeOffset,
        borderData,
      ];
}

/// Holds data related to drawing each [PieChart] section.
class PieChartSectionData with EquatableMixin {
  /// It determines how much space it should occupy around the circle.
  ///
  /// This is depends on sum of all sections, each section should
  /// occupy ([value] / sumValues) * 360 degrees.
  final double value;

  /// Defines the color of section.
  final Color color;

  /// Defines the radius of section.
  final double radius;

  /// Defines show or hide the title of section.
  final bool showTitle;

  /// Defines style of showing title of section.
  final TextStyle titleStyle;

  /// Defines text of showing title at the middle of section.
  final String title;

  /// Defines a widget that represents the section.
  ///
  /// This can be anything from a text, an image, an animation, and even a combination of widgets.
  /// Use AnimatedWidgets to animate this widget.
  final Widget badgeWidget;

  /// Defines position of showing title in the section.
  ///
  /// It should be between 0.0 to 1.0,
  /// 0.0 means near the center,
  /// 1.0 means near the outside of the [PieChart].
  final double titlePositionPercentageOffset;

  /// Defines position of badge widget in the section.
  ///
  /// It should be between 0.0 to 1.0,
  /// 0.0 means near the center,
  /// 1.0 means near the outside of the [PieChart].
  final double badgePositionPercentageOffset;

  /// [PieChart] draws section from right side of the circle (0 degrees),
  /// each section have a [value] that determines how much it should occupy,
  /// this is depends on sum of all sections, each section should
  /// occupy ([value] / sumValues) * 360 degrees.
  ///
  /// It draws this section with filled [color], and [radius].
  ///
  /// If [showTitle] is true, it draws a title at the middle of section,
  /// you can set the text using [title], and set the style using [titleStyle],
  /// by default it draws texts at the middle of section, but you can change the
  /// [titlePositionPercentageOffset] to have your desire design,
  /// it should be between 0.0 to 1.0,
  /// 0.0 means near the center,
  /// 1.0 means near the outside of the [PieChart].
  ///
  /// If [badgeWidget] is not null, it draws a widget at the middle of section,
  /// by default it draws the widget at the middle of section, but you can change the
  /// [badgePositionPercentageOffset] to have your desire design,
  /// the value works the same way as [titlePositionPercentageOffset].
  PieChartSectionData({
    double value,
    Color color,
    double radius,
    bool showTitle,
    TextStyle titleStyle,
    String title,
    Widget badgeWidget,
    double titlePositionPercentageOffset,
    double badgePositionPercentageOffset,
  })  : value = value ?? 10,
        color = color ?? Colors.red,
        radius = radius ?? 40,
        showTitle = showTitle ?? true,
        titleStyle = titleStyle ??
            const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        title = title ?? value.toString(),
        badgeWidget = badgeWidget,
        titlePositionPercentageOffset = titlePositionPercentageOffset ?? 0.5,
        badgePositionPercentageOffset = badgePositionPercentageOffset ?? 0.5;

  /// Copies current [PieChartSectionData] to a new [PieChartSectionData],
  /// and replaces provided values.
  PieChartSectionData copyWith({
    double value,
    Color color,
    double radius,
    bool showTitle,
    TextStyle titleStyle,
    String title,
    Widget badgeWidget,
    double titlePositionPercentageOffset,
    double badgePositionPercentageOffset,
  }) {
    return PieChartSectionData(
      value: value ?? this.value,
      color: color ?? this.color,
      radius: radius ?? this.radius,
      showTitle: showTitle ?? this.showTitle,
      titleStyle: titleStyle ?? this.titleStyle,
      title: title ?? this.title,
      badgeWidget: badgeWidget ?? this.badgeWidget,
      titlePositionPercentageOffset:
          titlePositionPercentageOffset ?? this.titlePositionPercentageOffset,
      badgePositionPercentageOffset:
          badgePositionPercentageOffset ?? this.badgePositionPercentageOffset,
    );
  }

  /// Lerps a [PieChartSectionData] based on [t] value, check [Tween.lerp].
  static PieChartSectionData lerp(PieChartSectionData a, PieChartSectionData b, double t) {
    return PieChartSectionData(
      value: lerpDouble(a.value, b.value, t),
      color: Color.lerp(a.color, b.color, t),
      radius: lerpDouble(a.radius, b.radius, t),
      showTitle: b.showTitle,
      titleStyle: TextStyle.lerp(a.titleStyle, b.titleStyle, t),
      title: b.title,
      badgeWidget: b.badgeWidget,
      titlePositionPercentageOffset:
          lerpDouble(a.titlePositionPercentageOffset, b.titlePositionPercentageOffset, t),
      badgePositionPercentageOffset:
          lerpDouble(a.badgePositionPercentageOffset, b.badgePositionPercentageOffset, t),
    );
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object> get props => [
        value,
        color,
        radius,
        showTitle,
        titleStyle,
        title,
        badgeWidget,
        titlePositionPercentageOffset,
        badgePositionPercentageOffset,
      ];
}

/// Holds data to handle touch events, and touch responses in the [PieChart].
///
/// There is a touch flow, explained [here](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/handle_touches.md)
/// in a simple way, each chart captures the touch events, and passes a concrete
/// instance of [FlTouchInput] to the painter, and gets a generated [PieTouchResponse].
class PieTouchData extends FlTouchData with EquatableMixin {
  /// you can implement it to receive touches callback
  final Function(PieTouchResponse) touchCallback;

  /// You can disable or enable the touch system using [enabled] flag,
  ///
  /// You can listen to touch events using [touchCallback],
  /// It gives you a [PieTouchResponse] that contains some
  /// useful information about happened touch.
  PieTouchData({
    bool enabled,
    Function(PieTouchResponse) touchCallback,
  })  : touchCallback = touchCallback,
        super(enabled ?? true);

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object> get props => [
        enabled,
      ];
}

/// Holds information about touch response in the [PieChart].
///
/// You can override [PieTouchData.touchCallback] to handle touch events,
/// it gives you a [PieTouchResponse] and you can do whatever you want.
class PieTouchResponse extends BaseTouchResponse with EquatableMixin {
  /// touch happened on this section
  final PieChartSectionData touchedSection;

  /// touch happened on this position
  final int touchedSectionIndex;

  /// touch happened with this angle on the [PieChart]
  final double touchAngle;

  /// touch happened with this radius on the [PieChart]
  final double touchRadius;

  /// If touch happens, [PieChart] processes it internally and passes out a [PieTouchResponse]
  /// that contains [touchedSection], [touchedSectionIndex] that tells
  /// you touch happened on which section,
  /// [touchAngle] gives you angle of touch,
  /// and [touchRadius] gives you radius of the touch.
  /// [touchInput] is the type of happened touch.
  PieTouchResponse(
    PieChartSectionData touchedSection,
    int touchedSectionIndex,
    double touchAngle,
    double touchRadius,
    FlTouchInput touchInput,
  )   : touchedSection = touchedSection,
        touchedSectionIndex = touchedSectionIndex,
        touchAngle = touchAngle,
        touchRadius = touchRadius,
        super(touchInput);

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object> get props => [
        touchedSection,
        touchedSectionIndex,
        touchAngle,
        touchRadius,
        touchInput,
      ];
}

/// It lerps a [PieChartData] to another [PieChartData] (handles animation for updating values)
class PieChartDataTween extends Tween<PieChartData> {
  PieChartDataTween({PieChartData begin, PieChartData end}) : super(begin: begin, end: end);

  /// Lerps a [PieChartData] based on [t] value, check [Tween.lerp].
  @override
  PieChartData lerp(double t) => begin.lerp(begin, end, t);
}
