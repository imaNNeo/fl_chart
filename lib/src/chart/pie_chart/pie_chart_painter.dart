import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'pie_chart_data.dart';

/// Paints [PieChartData] in the canvas, it can be used in a [CustomPainter]
class PieChartPainter extends BaseChartPainter<PieChartData> {
  late Paint _sectionPaint, _sectionsSpaceClearPaint, _centerSpacePaint;

  /// Paints [data] into canvas, it is the animating [PieChartData],
  /// [targetData] is the animation's target and remains the same
  /// during animation, then we should use it  when we need to show
  /// tooltips or something like that, because [data] is changing constantly.
  ///
  /// [textScale] used for scaling texts inside the chart,
  /// parent can use [MediaQuery.textScaleFactor] to respect
  /// the system's font size.
  PieChartPainter() : super() {
    _sectionPaint = Paint()..style = PaintingStyle.stroke;

    _sectionsSpaceClearPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0x000000000)
      ..blendMode = BlendMode.srcOut;

    _centerSpacePaint = Paint()..style = PaintingStyle.fill;
  }

  /// Paints [PieChartData] into the provided canvas.
  @override
  void paint(Canvas canvas, Size size, PaintHolder<PieChartData> holder) {
    super.paint(canvas, size, holder);
    final data = holder.data;
    if (data.sections.isEmpty) {
      return;
    }

    final canvasWrapper = CanvasWrapper(canvas, size);

    final sectionsAngle = _calculateSectionsAngle(data.sections, data.sumValue);

    _drawCenterSpace(canvasWrapper, holder);
    _drawSections(canvasWrapper, sectionsAngle, holder);
    _drawTexts(canvasWrapper, holder);
  }

  List<double> _calculateSectionsAngle(List<PieChartSectionData> sections, double sumValue) {
    return sections.map((section) {
      return 360 * (section.value / sumValue);
    }).toList();
  }

  void _drawCenterSpace(CanvasWrapper canvasWrapper, PaintHolder<PieChartData> holder) {
    final data = holder.data;
    final viewSize = canvasWrapper.size;
    final centerX = viewSize.width / 2;
    final centerY = viewSize.height / 2;

    _centerSpacePaint.color = data.centerSpaceColor;
    canvasWrapper.drawCircle(Offset(centerX, centerY), data.centerSpaceRadius, _centerSpacePaint);
  }

  void _drawSections(
    CanvasWrapper canvasWrapper,
    List<double> sectionsAngle,
    PaintHolder<PieChartData> holder,
  ) {
    final data = holder.data;
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
        radius: _calculateCenterRadius(viewSize, holder) + (section.radius / 2),
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
      _removeSectionsSpace(canvasWrapper, holder);
    }
  }

  /// firstly the sections draw close to eachOther without any space,
  /// then here we clear a line with given [PieChartData.width]
  void _removeSectionsSpace(CanvasWrapper canvasWrapper, PaintHolder<PieChartData> holder) {
    final data = holder.data;
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
                (_calculateCenterRadius(viewSize, holder) - extraLineSize),
            math.sin(radians(startAngle)) *
                (_calculateCenterRadius(viewSize, holder) - extraLineSize),
          );

      final sectionsStartTo = center +
          Offset(
            math.cos(radians(startAngle)) *
                (_calculateCenterRadius(viewSize, holder) + maxSectionRadius + extraLineSize),
            math.sin(radians(startAngle)) *
                (_calculateCenterRadius(viewSize, holder) + maxSectionRadius + extraLineSize),
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
  void _drawTexts(CanvasWrapper canvasWrapper, PaintHolder<PieChartData> holder) {
    final data = holder.data;
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
                (_calculateCenterRadius(viewSize, holder) + (section.radius * percentageOffset)),
            math.sin(radians(sectionCenterAngle)) *
                (_calculateCenterRadius(viewSize, holder) + (section.radius * percentageOffset)),
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
            textScaleFactor: holder.textScale);

        tp.layout();
        canvasWrapper.drawText(tp, sectionCenterOffsetTitle - Offset(tp.width / 2, tp.height / 2));
      }

      tempAngle += sweepAngle;
    }
  }

  double _calculateCenterRadius(Size viewSize, PaintHolder<PieChartData> holder) {
    final data = holder.data;
    if (!data.centerSpaceRadius.isInfinite) {
      return data.centerSpaceRadius;
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

  /// Makes a [PieTouchedSection] based on the provided [touchInput]
  ///
  /// Processes [PointerEvent.localPosition] and checks
  /// the elements of the chart that are near the offset,
  /// then makes a [PieTouchedSection] from the elements that has been touched.
  PieTouchedSection? handleTouch(
    PointerEvent touchInput,
    Size size,
    PaintHolder<PieChartData> holder,
  ) {
    final data = holder.data;
    final sectionsAngle = _calculateSectionsAngle(data.sections, data.sumValue);
    return _getTouchedSection(size, touchInput, sectionsAngle, holder);
  }

  /// find touched section by the value of [touchInputNotifier]
  PieTouchedSection? _getTouchedSection(
    Size viewSize,
    PointerEvent touchInput,
    List<double> sectionsAngle,
    PaintHolder<PieChartData> holder,
  ) {
    final data = holder.data;
    final center = Offset(viewSize.width / 2, viewSize.height / 2);

    final touchedPoint2 = touchInput.localPosition - center;

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
      final centerRadius = _calculateCenterRadius(viewSize, holder);
      final sectionRadius = centerRadius + section.radius;
      final isInRadius = touchR > centerRadius && touchR <= sectionRadius;

      if (isInDegree && isInRadius) {
        foundSectionData = section;
        foundSectionDataPosition = i;
        break;
      }

      tempAngle += sectionAngle;
    }

    return PieTouchedSection(foundSectionData, foundSectionDataPosition, touchAngle, touchR);
  }

  /// Exposes offset for laying out the badge widgets upon the chart.
  Map<int, Offset> getBadgeOffsets(Size viewSize, PaintHolder<PieChartData> holder) {
    final data = holder.data;
    final center = viewSize.center(Offset.zero);
    final badgeWidgetsOffsets = <int, Offset>{};

    var tempAngle = data.startDegreeOffset;

    final sectionsAngle = _calculateSectionsAngle(data.sections, data.sumValue);
    for (var i = 0; i < data.sections.length; i++) {
      final section = data.sections[i];
      final startAngle = tempAngle;
      final sweepAngle = sectionsAngle[i];
      final sectionCenterAngle = startAngle + (sweepAngle / 2);

      Offset sectionCenter(double percentageOffset) =>
          center +
          Offset(
            math.cos(radians(sectionCenterAngle)) *
                (_calculateCenterRadius(viewSize, holder) + (section.radius * percentageOffset)),
            math.sin(radians(sectionCenterAngle)) *
                (_calculateCenterRadius(viewSize, holder) + (section.radius * percentageOffset)),
          );

      final sectionCenterOffsetBadgeWidget = sectionCenter(section.badgePositionPercentageOffset);

      badgeWidgetsOffsets[i] = sectionCenterOffsetBadgeWidget;

      tempAngle += sweepAngle;
    }

    return badgeWidgetsOffsets;
  }
}
