import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'pie_chart_data.dart';

/// Paints [PieChartData] in the canvas, it can be used in a [CustomPainter]
class PieChartPainter extends BaseChartPainter<PieChartData>
    with TouchHandler<PieTouchResponse>, PieChartWidgetsPositionHandler {
  late Paint _sectionPaint, _sectionsSpaceClearPaint, _centerSpacePaint;

  /// Paints [data] into canvas, it is the animating [PieChartData],
  /// [targetData] is the animation's target and remains the same
  /// during animation, then we should use it  when we need to show
  /// tooltips or something like that, because [data] is changing constantly.
  ///
  /// [touchHandler] passes a [TouchHandler] to the parent,
  /// parent will use it for touch handling flow.
  ///
  /// [textScale] used for scaling texts inside the chart,
  /// parent can use [MediaQuery.textScaleFactor] to respect
  /// the system's font size.
  PieChartPainter(PieChartData data, PieChartData targetData,
      Function(TouchHandler<PieTouchResponse>) touchHandler,
      {required Function(PieChartWidgetsPositionHandler) widgetsPositionHandler,
      double textScale = 1})
      : super(
          data,
          targetData,
          textScale: textScale,
        ) {
    touchHandler(this);
    widgetsPositionHandler(this);

    _sectionPaint = Paint()..style = PaintingStyle.stroke;

    _sectionsSpaceClearPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0x000000000)
      ..blendMode = BlendMode.srcOut;

    _centerSpacePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = data.centerSpaceColor;
  }

  /// Paints [PieChartData] into the provided canvas.
  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    if (data.sections.isEmpty) {
      return;
    }

    final canvasWrapper = CanvasWrapper(canvas, size);

    final sectionsAngle = _calculateSectionsAngle(data.sections, data.sumValue);

    _drawCenterSpace(canvasWrapper);
    _drawSections(canvasWrapper, sectionsAngle);
    _drawTexts(canvasWrapper);
  }

  List<double> _calculateSectionsAngle(List<PieChartSectionData> sections, double sumValue) {
    return sections.map((section) {
      return 360 * (section.value / sumValue);
    }).toList();
  }

  void _drawCenterSpace(CanvasWrapper canvasWrapper) {
    final viewSize = canvasWrapper.size;
    final centerX = viewSize.width / 2;
    final centerY = viewSize.height / 2;

    canvasWrapper.drawCircle(Offset(centerX, centerY), data.centerSpaceRadius, _centerSpacePaint);
  }

  void _drawSections(CanvasWrapper canvasWrapper, List<double> sectionsAngle) {
    final shouldDrawSeparators = data.sectionsSpace != 0 && data.sections.length != 1;

    final viewSize = canvasWrapper.size;

    if (shouldDrawSeparators) {
      canvasWrapper.saveLayer(Rect.fromLTWH(0, 0, viewSize.width, viewSize.height), Paint());
    }

    final center = Offset(viewSize.width / 2, viewSize.height / 2);

    var tempAngle = data.startDegreeOffset;

    for (var i = 0; i < data.sections.length; i++) {
      final section = data.sections[i];
      final sectionDegree = sectionsAngle[i];

      final rect = Rect.fromCircle(
        center: center,
        radius: _calculateCenterRadius(viewSize, data.centerSpaceRadius) + (section.radius / 2),
      );

      _sectionPaint.color = section.color;
      _sectionPaint.strokeWidth = section.radius;

      final startAngle = tempAngle;
      final sweepAngle = sectionDegree;
      canvasWrapper.drawArc(
        rect,
        radians(startAngle),
        radians(sweepAngle),
        false,
        _sectionPaint,
      );

      tempAngle += sweepAngle;
    }

    if (shouldDrawSeparators) {
      _removeSectionsSpace(canvasWrapper);
    }
  }

  /// firstly the sections draw close to eachOther without any space,
  /// then here we clear a line with given [PieChartData.width]
  void _removeSectionsSpace(CanvasWrapper canvasWrapper) {
    final viewSize = canvasWrapper.size;
    const extraLineSize = 1;
    final center = Offset(viewSize.width / 2, viewSize.height / 2);

    var tempAngle = data.startDegreeOffset;
    data.sections.asMap().forEach((index, section) {
      final previousIndex = index == 0 ? data.sections.length - 1 : index - 1;
      final previousSection = data.sections[previousIndex];

      final maxSectionRadius = math.max(section.radius, previousSection.radius);

      final startAngle = tempAngle;
      final sweepAngle = 360 * (section.value / data.sumValue);

      final sectionsStartFrom = center +
          Offset(
            math.cos(radians(startAngle)) *
                (_calculateCenterRadius(viewSize, data.centerSpaceRadius) - extraLineSize),
            math.sin(radians(startAngle)) *
                (_calculateCenterRadius(viewSize, data.centerSpaceRadius) - extraLineSize),
          );

      final sectionsStartTo = center +
          Offset(
            math.cos(radians(startAngle)) *
                (_calculateCenterRadius(viewSize, data.centerSpaceRadius) +
                    maxSectionRadius +
                    extraLineSize),
            math.sin(radians(startAngle)) *
                (_calculateCenterRadius(viewSize, data.centerSpaceRadius) +
                    maxSectionRadius +
                    extraLineSize),
          );

      _sectionsSpaceClearPaint.strokeWidth = data.sectionsSpace;
      canvasWrapper.drawLine(sectionsStartFrom, sectionsStartTo, _sectionsSpaceClearPaint);
      tempAngle += sweepAngle;
    });
    canvasWrapper.restore();
  }

  /// Calculates layout of overlaying elements, includes:
  /// - title text
  /// - badge widget positions
  void _drawTexts(CanvasWrapper canvasWrapper) {
    final viewSize = canvasWrapper.size;
    final center = Offset(viewSize.width / 2, viewSize.height / 2);

    var tempAngle = data.startDegreeOffset;

    for (var i = 0; i < data.sections.length; i++) {
      final section = data.sections[i];
      final startAngle = tempAngle;
      final sweepAngle = 360 * (section.value / data.sumValue);
      final sectionCenterAngle = startAngle + (sweepAngle / 2);

      Offset sectionCenter(double percentageOffset) =>
          center +
          Offset(
            math.cos(radians(sectionCenterAngle)) *
                (_calculateCenterRadius(viewSize, data.centerSpaceRadius) +
                    (section.radius * percentageOffset)),
            math.sin(radians(sectionCenterAngle)) *
                (_calculateCenterRadius(viewSize, data.centerSpaceRadius) +
                    (section.radius * percentageOffset)),
          );

      final sectionCenterOffsetTitle = sectionCenter(section.titlePositionPercentageOffset);

      if (section.showTitle) {
        final span = TextSpan(
          style: section.titleStyle,
          text: section.title,
        );
        final tp = TextPainter(
            text: span,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            textScaleFactor: textScale);

        tp.layout();
        canvasWrapper.drawText(tp, sectionCenterOffsetTitle - Offset(tp.width / 2, tp.height / 2));
      }

      tempAngle += sweepAngle;
    }
  }

  double _calculateCenterRadius(Size viewSize, double givenCenterRadius) {
    if (!givenCenterRadius.isInfinite) {
      return givenCenterRadius;
    }

    var maxRadius = 0.0;
    for (var i = 0; i < data.sections.length; i++) {
      final section = data.sections[i];
      if (section.radius > maxRadius) {
        maxRadius = section.radius;
      }
    }

    final minWidthHeight = math.min(viewSize.width, viewSize.height);
    final centerRadius = (minWidthHeight - (maxRadius * 2)) / 2;
    return centerRadius;
  }

  /// Makes a [PieTouchResponse] based on the provided [FlTouchInput]
  ///
  /// Processes [FlTouchInput.getOffset] and checks
  /// the elements of the chart that are near the offset,
  /// then makes a [PieTouchResponse] from the elements that has been touched.
  @override
  PieTouchResponse handleTouch(FlTouchInput touchInput, Size size) {
    final sectionsAngle = _calculateSectionsAngle(data.sections, data.sumValue);
    return _getTouchedDetails(size, touchInput, sectionsAngle);
  }

  /// find touched section by the value of [touchInputNotifier]
  PieTouchResponse _getTouchedDetails(
      Size viewSize, FlTouchInput touchInput, List<double> sectionsAngle) {
    final center = Offset(viewSize.width / 2, viewSize.height / 2);

    final touchedPoint2 = touchInput.getOffset() - center;

    final touchX = touchedPoint2.dx;
    final touchY = touchedPoint2.dy;

    final touchR = math.sqrt(math.pow(touchX, 2) + math.pow(touchY, 2));
    var touchAngle = degrees(math.atan2(touchY, touchX));
    touchAngle = touchAngle < 0 ? (180 - touchAngle.abs()) + 180 : touchAngle;

    PieChartSectionData? foundSectionData;
    var foundSectionDataPosition = -1;

    /// Find the nearest section base on the touch spot
    final relativeTouchAngle = (touchAngle - data.startDegreeOffset) % 360;
    var tempAngle = 0.0;
    for (var i = 0; i < data.sections.length; i++) {
      final section = data.sections[i];
      var sectionAngle = sectionsAngle[i];

      tempAngle %= 360;
      if (data.sections.length == 1) {
        sectionAngle = 360;
      } else {
        sectionAngle %= 360;
      }

      /// degree criteria
      final space = data.sectionsSpace / 2;
      final fromDegree = tempAngle + space;
      final toDegree = sectionAngle + tempAngle - space;
      final isInDegree = relativeTouchAngle >= fromDegree && relativeTouchAngle <= toDegree;

      /// radius criteria
      final centerRadius = _calculateCenterRadius(viewSize, data.centerSpaceRadius);
      final sectionRadius = centerRadius + section.radius;
      final isInRadius = touchR > centerRadius && touchR <= sectionRadius;

      if (isInDegree && isInRadius) {
        foundSectionData = section;
        foundSectionDataPosition = i;
        break;
      }

      tempAngle += sectionAngle;
    }

    return PieTouchResponse(
        foundSectionData, foundSectionDataPosition, touchAngle, touchR, touchInput);
  }

  /// Exposes offset for laying out the badge widgets upon the chart.
  @override
  Map<int, Offset> getBadgeOffsets(Size viewSize) {
    final center = Offset(viewSize.width / 2, viewSize.height / 2);
    final badgeWidgetsOffsets = <int, Offset>{};

    var tempAngle = data.startDegreeOffset;

    for (var i = 0; i < data.sections.length; i++) {
      final section = data.sections[i];
      final startAngle = tempAngle;
      final sweepAngle = 360 * (section.value / data.sumValue);
      final sectionCenterAngle = startAngle + (sweepAngle / 2);

      Offset sectionCenter(double percentageOffset) =>
          center +
          Offset(
            math.cos(radians(sectionCenterAngle)) *
                (_calculateCenterRadius(viewSize, data.centerSpaceRadius) +
                    (section.radius * percentageOffset)),
            math.sin(radians(sectionCenterAngle)) *
                (_calculateCenterRadius(viewSize, data.centerSpaceRadius) +
                    (section.radius * percentageOffset)),
          );

      final sectionCenterOffsetBadgeWidget = sectionCenter(section.badgePositionPercentageOffset);

      if (section.badgeWidget != null) {
        badgeWidgetsOffsets[i] = sectionCenterOffsetBadgeWidget;
      }

      tempAngle += sweepAngle;
    }

    return badgeWidgetsOffsets;
  }

  /// Determines should it redraw the chart or not.
  ///
  /// If there is a change in the [PieChartData],
  /// [PieChartPainter] should repaint itself.
  @override
  bool shouldRepaint(PieChartPainter oldDelegate) => oldDelegate.data != data;
}

/// Responsible to expose offset positions for laying out the widgets upon the chart.
mixin PieChartWidgetsPositionHandler {
  /// Exposes offset for laying out the badge widgets upon the chart.
  Map<int, Offset> getBadgeOffsets(Size size) => throw UnsupportedError('not implemented');
}
