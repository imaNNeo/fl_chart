import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/scatter_chart/scatter_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../data_pool.dart';
import 'scatter_chart_painter_test.mocks.dart';

@GenerateMocks([Canvas, CanvasWrapper, BuildContext, Utils])
void main() {
  group('paint()', () {
    test('test 1', () {
      final utilsMainInstance = Utils();
      const viewSize = Size(400, 400);
      final data = ScatterChartData(
        scatterSpots: [
          ScatterSpot(0, 1),
          ScatterSpot(1, 3),
          ScatterSpot(3, 4),
        ],
      );

      final scatterPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(
        data,
        data,
        TextScaler.noScaling,
      );

      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getThemeAwareTextStyle(any, any))
          .thenAnswer((realInvocation) => textStyle1);
      when(mockUtils.calculateRotationOffset(any, any))
          .thenAnswer((realInvocation) => Offset.zero);
      when(mockUtils.convertRadiusToSigma(any))
          .thenAnswer((realInvocation) => 4.0);
      when(mockUtils.getEfficientInterval(any, any))
          .thenAnswer((realInvocation) => 1.0);
      when(mockUtils.getBestInitialIntervalValue(any, any, any))
          .thenAnswer((realInvocation) => 1.0);
      when(mockUtils.normalizeBorderRadius(any, any))
          .thenAnswer((realInvocation) => BorderRadius.zero);
      when(mockUtils.normalizeBorderSide(any, any)).thenAnswer(
        (realInvocation) => const BorderSide(color: MockData.color0),
      );

      final mockBuildContext = MockBuildContext();
      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      scatterPainter.paint(
        mockBuildContext,
        mockCanvasWrapper,
        holder,
      );

      verify(mockCanvasWrapper.drawDot(any, any, any)).called(3);
      Utils.changeInstance(utilsMainInstance);
    });
  });

  group('drawSpots()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);

      final dotPainter1 = FlDotCirclePainter(radius: 18);
      final dotPainter3 = FlDotCirclePainter(radius: 4);
      final dotPainter4 = FlDotCirclePainter(radius: 6);

      final spot1 = ScatterSpot(1, 1, dotPainter: dotPainter1);
      final spot2 = ScatterSpot(3, 9, show: false);
      final spot3 = ScatterSpot(8, 2, dotPainter: dotPainter3);
      final spot4 = ScatterSpot(7, 5, dotPainter: dotPainter4);
      final data = ScatterChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        scatterSpots: [spot1, spot2, spot3, spot4],
        titlesData: const FlTitlesData(show: false),
        clipData: const FlClipData.all(),
      );

      final scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(
        data,
        data,
        TextScaler.noScaling,
      );

      final mockBuildContext = MockBuildContext();
      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenReturn(viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      scatterChartPainter.drawSpots(
        mockBuildContext,
        mockCanvasWrapper,
        holder,
      );

      verify(
        mockCanvasWrapper.drawDot(
          dotPainter1,
          spot1,
          const Offset(10, 90),
        ),
      ).called(1);
      verify(
        mockCanvasWrapper.drawDot(
          dotPainter3,
          spot3,
          const Offset(80, 80),
        ),
      ).called(1);
      verify(
        mockCanvasWrapper.drawDot(
          dotPainter4,
          spot4,
          const Offset(70, 50),
        ),
      ).called(1);

      verifyNever(mockCanvasWrapper.drawText(any, any));
      verify(mockCanvasWrapper.clipRect(any)).called(1);
    });

    test('test 2', () {
      const viewSize = Size(100, 100);

      final data = ScatterChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        scatterSpots: [
          ScatterSpot(1, 1, show: false),
          ScatterSpot(3, 9, show: false),
          ScatterSpot(8, 2, show: false),
          ScatterSpot(7, 5, show: false),
        ],
        titlesData: const FlTitlesData(show: false),
        clipData: const FlClipData.none(),
      );

      final scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(
        data,
        data,
        TextScaler.noScaling,
      );

      final mockBuildContext = MockBuildContext();
      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenReturn(viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      scatterChartPainter.drawSpots(
        mockBuildContext,
        mockCanvasWrapper,
        holder,
      );

      verifyNever(mockCanvasWrapper.drawCircle(any, any, any));
      verifyNever(mockCanvasWrapper.clipRect(any));

      verifyNever(mockCanvasWrapper.drawText(any, any));
    });

    test('test 3', () {
      const viewSize = Size(100, 100);

      final data = ScatterChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        scatterSpots: [
          ScatterSpot(1, 1, dotPainter: FlDotCirclePainter(radius: 18)),
          ScatterSpot(2, 2, dotPainter: FlDotCirclePainter(radius: 8)),
          ScatterSpot(3, 9, show: false),
          ScatterSpot(8, 8, dotPainter: FlDotCirclePainter(radius: 4)),
          ScatterSpot(7, 5, dotPainter: FlDotCirclePainter(radius: 20)),
          ScatterSpot(4, 6, dotPainter: FlDotCirclePainter(radius: 24)),
        ],
        titlesData: const FlTitlesData(show: false),
        clipData: const FlClipData.all(),
        scatterLabelSettings: ScatterLabelSettings(
          showLabel: true,
          getLabelTextStyleFunction: (int index, ScatterSpot spot) =>
              const TextStyle(fontSize: 12),
          getLabelFunction: (int index, ScatterSpot spot) {
            if (index == 5) {
              return '';
            }
            return 'Label : $index';
          },
        ),
      );

      final scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(
        data,
        data,
        TextScaler.noScaling,
      );

      final mockBuildContext = MockBuildContext();
      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenReturn(viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(const TextStyle(color: Color(0x00ffffff)));
      when(mockUtils.calculateRotationOffset(any, any)).thenReturn(Offset.zero);

      scatterChartPainter.drawSpots(
        mockBuildContext,
        mockCanvasWrapper,
        holder,
      );

      verify(
        mockCanvasWrapper.drawDot(
          any,
          data.scatterSpots[0],
          const Offset(10, 90),
        ),
      ).called(1);
      verify(
        mockCanvasWrapper.drawDot(
          any,
          data.scatterSpots[1],
          const Offset(20, 80),
        ),
      ).called(1);
      verify(
        mockCanvasWrapper.drawDot(
          any,
          data.scatterSpots[3],
          const Offset(80, 20),
        ),
      ).called(1);
      verify(
        mockCanvasWrapper.drawDot(
          any,
          data.scatterSpots[4],
          const Offset(70, 50),
        ),
      ).called(1);
      verify(
        mockCanvasWrapper.drawDot(
          any,
          data.scatterSpots[5],
          const Offset(40, 40),
        ),
      ).called(1);

      verify(mockCanvasWrapper.drawText(any, any)).called(4);

      verify(mockCanvasWrapper.clipRect(any)).called(1);
    });
  });

  group('drawTooltips()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);

      final data = ScatterChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        scatterSpots: [
          ScatterSpot(1, 1, dotPainter: FlDotCirclePainter(radius: 18)),
          ScatterSpot(3, 9, show: false),
          ScatterSpot(8, 2, dotPainter: FlDotCirclePainter(radius: 4)),
          ScatterSpot(7, 5, dotPainter: FlDotCirclePainter(radius: 6)),
        ],
        showingTooltipIndicators: [0, 2, 3],
        titlesData: const FlTitlesData(show: false),
      );

      final scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(
        data,
        data,
        TextScaler.noScaling,
      );
      final mockCanvasWrapper = MockCanvasWrapper();
      final mockBuildContext = MockBuildContext();
      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(const TextStyle(color: Color(0x00ffffff)));
      when(mockUtils.calculateRotationOffset(any, any)).thenReturn(Offset.zero);
      when(mockCanvasWrapper.size).thenReturn(viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      scatterChartPainter.drawTouchTooltips(
        mockBuildContext,
        mockCanvasWrapper,
        holder,
      );

      verify(
        mockCanvasWrapper.drawRotated(
          size: anyNamed('size'),
          rotationOffset: anyNamed('rotationOffset'),
          drawOffset: anyNamed('drawOffset'),
          angle: anyNamed('angle'),
          drawCallback: anyNamed('drawCallback'),
        ),
      ).called(3);
    });

    test('test 2', () {
      const viewSize = Size(100, 100);

      final data = ScatterChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        scatterSpots: [
          ScatterSpot(1, 1, dotPainter: FlDotCirclePainter(radius: 18)),
          ScatterSpot(3, 9, show: false),
          ScatterSpot(8, 2, dotPainter: FlDotCirclePainter(radius: 4)),
          ScatterSpot(7, 5, dotPainter: FlDotCirclePainter(radius: 6)),
        ],
        showingTooltipIndicators: [0, 2, 3],
        scatterTouchData: ScatterTouchData(
          touchTooltipData: ScatterTouchTooltipData(
            getTooltipItems: (spot) => null,
          ),
        ),
        titlesData: const FlTitlesData(show: false),
      );

      final scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(
        data,
        data,
        TextScaler.noScaling,
      );
      final mockCanvasWrapper = MockCanvasWrapper();
      final mockBuildContext = MockBuildContext();
      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(const TextStyle(color: Color(0x00ffffff)));
      when(mockUtils.calculateRotationOffset(any, any)).thenReturn(Offset.zero);
      when(mockCanvasWrapper.size).thenReturn(viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      scatterChartPainter.drawTouchTooltips(
        mockBuildContext,
        mockCanvasWrapper,
        holder,
      );

      verifyNever(
        mockCanvasWrapper.drawRotated(
          size: null,
          angle: null,
          drawCallback: () {},
        ),
      );
      verifyNever(mockCanvasWrapper.drawRect(any, any));
    });
  });

  group('drawTouchTooltip()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);

      final spot1 = ScatterSpot(1, 1);
      final data = ScatterChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        scatterSpots: [
          spot1,
          scatterSpot2,
          scatterSpot3,
          scatterSpot4,
        ],
        showingTooltipIndicators: [0, 2, 3],
        titlesData: const FlTitlesData(show: false),
        scatterTouchData: ScatterTouchData(
          touchTooltipData: ScatterTouchTooltipData(
            rotateAngle: 18,
            tooltipBgColor: const Color(0xFF00FF00),
            tooltipRoundedRadius: 85,
            tooltipPadding: const EdgeInsets.all(12),
            getTooltipItems: (_) {
              return ScatterTooltipItem(
                'faketext',
                textStyle: textStyle1,
                textAlign: TextAlign.left,
                textDirection: TextDirection.rtl,
                children: [
                  textSpan2,
                  textSpan1,
                ],
              );
            },
          ),
        ),
      );

      final scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(
        data,
        data,
        TextScaler.noScaling,
      );
      final mockCanvasWrapper = MockCanvasWrapper();
      final mockBuildContext = MockBuildContext();
      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getThemeAwareTextStyle(any, any)).thenReturn(textStyle2);
      when(mockUtils.calculateRotationOffset(any, any)).thenReturn(Offset.zero);
      when(mockCanvasWrapper.size).thenReturn(viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      scatterChartPainter.drawTouchTooltip(
        mockBuildContext,
        mockCanvasWrapper,
        (data.touchData as ScatterTouchData).touchTooltipData,
        spot1,
        holder,
      );

      final verificationResult = verify(
        mockCanvasWrapper.drawRotated(
          size: anyNamed('size'),
          drawOffset: anyNamed('drawOffset'),
          angle: 18,
          drawCallback: captureAnyNamed('drawCallback'),
        ),
      );

      final passedDrawCallback =
          verificationResult.captured.first as DrawCallback;
      passedDrawCallback();

      verificationResult.called(1);

      final captured2 = verifyInOrder([
        mockCanvasWrapper.drawRRect(captureAny, captureAny),
        mockCanvasWrapper.drawText(captureAny, any),
      ]).captured;

      final rRect = captured2[0][0] as RRect;
      final bgPaint = captured2[0][1] as Paint;
      final textPainter = captured2[1][0] as TextPainter;

      expect(rRect.blRadiusX, 85);
      expect(rRect.tlRadiusY, 85);

      expect(bgPaint.color, const Color(0xFF00FF00));
      expect(
        textPainter.text,
        const TextSpan(
          style: textStyle2,
          text: 'faketext',
          children: [
            textSpan2,
            textSpan1,
          ],
        ),
      );
    });

    test('test 2', () {
      const viewSize = Size(100, 100);

      final spot1 = ScatterSpot(1, 1);
      final data = ScatterChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        scatterSpots: [
          spot1,
          scatterSpot2,
          scatterSpot3,
          scatterSpot4,
        ],
        showingTooltipIndicators: [0, 2, 3],
        titlesData: const FlTitlesData(show: false),
        scatterTouchData: ScatterTouchData(
          touchTooltipData: ScatterTouchTooltipData(
            rotateAngle: 18,
            tooltipBgColor: const Color(0xFFFFFF00),
            tooltipRoundedRadius: 22,
            fitInsideHorizontally: false,
            fitInsideVertically: true,
            tooltipPadding: const EdgeInsets.all(12),
            tooltipHorizontalAlignment: FLHorizontalAlignment.left,
            getTooltipItems: (_) {
              return ScatterTooltipItem(
                'faketext',
                textStyle: textStyle2,
                textAlign: TextAlign.right,
                textDirection: TextDirection.ltr,
                children: [
                  textSpan1,
                  textSpan2,
                ],
              );
            },
          ),
        ),
      );

      final scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(
        data,
        data,
        TextScaler.noScaling,
      );
      final mockCanvasWrapper = MockCanvasWrapper();
      final mockBuildContext = MockBuildContext();
      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getThemeAwareTextStyle(any, any)).thenReturn(textStyle1);
      when(mockUtils.calculateRotationOffset(any, any)).thenReturn(Offset.zero);
      when(mockCanvasWrapper.size).thenReturn(viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      scatterChartPainter.drawTouchTooltip(
        mockBuildContext,
        mockCanvasWrapper,
        (data.touchData as ScatterTouchData).touchTooltipData,
        spot1,
        holder,
      );

      final verificationResult = verify(
        mockCanvasWrapper.drawRotated(
          size: anyNamed('size'),
          drawOffset: anyNamed('drawOffset'),
          angle: 18,
          drawCallback: captureAnyNamed('drawCallback'),
        ),
      );

      final passedDrawCallback =
          verificationResult.captured.first as DrawCallback;
      passedDrawCallback();

      verificationResult.called(1);

      final captured2 = verifyInOrder([
        mockCanvasWrapper.drawRRect(captureAny, captureAny),
        mockCanvasWrapper.drawText(captureAny, any),
      ]).captured;

      final rRect = captured2[0][0] as RRect;
      final bgPaint = captured2[0][1] as Paint;
      final textPainter = captured2[1][0] as TextPainter;

      expect(rRect.blRadiusX, 22);
      expect(rRect.tlRadiusY, 22);

      expect(rRect.left, -134);

      expect(bgPaint.color, const Color(0xFFFFFF00));
      expect(
        textPainter.text,
        const TextSpan(
          style: textStyle1,
          text: 'faketext',
          children: [
            textSpan1,
            textSpan2,
          ],
        ),
      );
    });

    test('test 3', () {
      const viewSize = Size(100, 100);

      final spot1 = ScatterSpot(1, 1);
      final data = ScatterChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        scatterSpots: [
          spot1,
          scatterSpot2,
          scatterSpot3,
          scatterSpot4,
        ],
        showingTooltipIndicators: [0, 2, 3],
        titlesData: const FlTitlesData(show: false),
        scatterTouchData: ScatterTouchData(
          touchTooltipData: ScatterTouchTooltipData(
            rotateAngle: 18,
            tooltipBgColor: const Color(0xFFFFFF00),
            tooltipRoundedRadius: 22,
            fitInsideHorizontally: false,
            fitInsideVertically: true,
            tooltipPadding: const EdgeInsets.all(12),
            tooltipHorizontalAlignment: FLHorizontalAlignment.right,
            getTooltipItems: (_) {
              return ScatterTooltipItem(
                'faketext',
                textStyle: textStyle2,
                textAlign: TextAlign.right,
                textDirection: TextDirection.ltr,
                children: [
                  textSpan1,
                  textSpan2,
                ],
              );
            },
          ),
        ),
      );

      final scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(
        data,
        data,
        TextScaler.noScaling,
      );
      final mockCanvasWrapper = MockCanvasWrapper();
      final mockBuildContext = MockBuildContext();
      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getThemeAwareTextStyle(any, any)).thenReturn(textStyle1);
      when(mockUtils.calculateRotationOffset(any, any)).thenReturn(Offset.zero);
      when(mockCanvasWrapper.size).thenReturn(viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      scatterChartPainter.drawTouchTooltip(
        mockBuildContext,
        mockCanvasWrapper,
        (data.touchData as ScatterTouchData).touchTooltipData,
        spot1,
        holder,
      );

      final verificationResult = verify(
        mockCanvasWrapper.drawRotated(
          size: anyNamed('size'),
          drawOffset: anyNamed('drawOffset'),
          angle: 18,
          drawCallback: captureAnyNamed('drawCallback'),
        ),
      );

      final passedDrawCallback =
          verificationResult.captured.first as DrawCallback;
      passedDrawCallback();

      verificationResult.called(1);

      final captured2 = verifyInOrder([
        mockCanvasWrapper.drawRRect(captureAny, captureAny),
        mockCanvasWrapper.drawText(captureAny, any),
      ]).captured;

      final rRect = captured2[0][0] as RRect;
      final bgPaint = captured2[0][1] as Paint;
      final textPainter = captured2[1][0] as TextPainter;

      expect(rRect.blRadiusX, 22);
      expect(rRect.tlRadiusY, 22);

      expect(rRect.left, 10);

      expect(bgPaint.color, const Color(0xFFFFFF00));
      expect(
        textPainter.text,
        const TextSpan(
          style: textStyle1,
          text: 'faketext',
          children: [
            textSpan1,
            textSpan2,
          ],
        ),
      );
    });
  });

  group('handleTouch()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);
      final spots = [
        ScatterSpot(1, 1),
        ScatterSpot(2, 4),
        ScatterSpot(5, 2, dotPainter: FlDotCirclePainter(radius: 0.5)),
        ScatterSpot(8, 7),
      ];

      final data = ScatterChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        titlesData: const FlTitlesData(show: false),
        scatterSpots: spots,
      );

      final scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(
        data,
        data,
        TextScaler.noScaling,
      );
      final touchedSpot = scatterChartPainter.handleTouch(
        const Offset(10, 90),
        viewSize,
        holder,
      );
      expect(touchedSpot!.spot, spots[0]);

      final touchedSpot2 = scatterChartPainter.handleTouch(
        const Offset(50, 80),
        viewSize,
        holder,
      );
      expect(touchedSpot2!.spot, spots[2]);

      final touchedSpot3 = scatterChartPainter.handleTouch(
        const Offset(50.49, 80),
        viewSize,
        holder,
      );
      expect(touchedSpot3!.spot, spots[2]);

      final touchedSpot4 = scatterChartPainter.handleTouch(
        const Offset(50.5, 80),
        viewSize,
        holder,
      );
      expect(touchedSpot4, null);

      final radius = spots[2].size.width / 2;
      final touchedSpot5 = scatterChartPainter.handleTouch(
        Offset(
          50 + (math.cos(math.pi / 4) * radius) - 0.01,
          80 + (math.sin(math.pi / 4) * radius) - 0.01,
        ),
        viewSize,
        holder,
      );
      expect(touchedSpot5!.spot, spots[2]);

      final touchedSpot6 = scatterChartPainter.handleTouch(
        Offset(
          50 + (math.cos(math.pi / 4) * radius),
          80 + (math.sin(math.pi / 4) * radius),
        ),
        viewSize,
        holder,
      );
      expect(touchedSpot6, null);
    });

    test('test 2', () {
      const viewSize = Size(100, 100);
      final spots = [
        ScatterSpot(1, 1),
        ScatterSpot(2, 4),
        ScatterSpot(5, 2, dotPainter: FlDotCirclePainter(radius: 0.5)),
        ScatterSpot(8, 7),
      ];

      final data = ScatterChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(
            axisNameSize: 4,
            axisNameWidget: Text('ss1'),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 10,
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 10,
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 6,
            ),
          ),
          bottomTitles: AxisTitles(
            axisNameSize: 4,
            axisNameWidget: Text('ss2'),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 6,
            ),
          ),
        ),
        scatterSpots: spots,
      );

      final scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(
        data,
        data,
        TextScaler.noScaling,
      );
      final touchedSpot = scatterChartPainter.handleTouch(
        const Offset(10, 90),
        viewSize,
        holder,
      );
      expect(touchedSpot!.spot, spots[0]);

      final touchedSpot2 = scatterChartPainter.handleTouch(
        const Offset(50, 80),
        viewSize,
        holder,
      );
      expect(touchedSpot2!.spot, spots[2]);

      final touchedSpot3 = scatterChartPainter.handleTouch(
        const Offset(50.49, 80),
        viewSize,
        holder,
      );
      expect(touchedSpot3!.spot, spots[2]);

      final touchedSpot4 = scatterChartPainter.handleTouch(
        const Offset(50.5, 80),
        viewSize,
        holder,
      );
      expect(touchedSpot4, null);

      final radius = spots[2].size.width / 2;
      final touchedSpot5 = scatterChartPainter.handleTouch(
        Offset(
          50 + (math.cos(math.pi / 4) * radius) - 0.01,
          80 + (math.sin(math.pi / 4) * radius) - 0.01,
        ),
        viewSize,
        holder,
      );
      expect(touchedSpot5!.spot, spots[2]);

      final touchedSpot6 = scatterChartPainter.handleTouch(
        Offset(
          50 + (math.cos(math.pi / 4) * radius),
          80 + (math.sin(math.pi / 4) * radius),
        ),
        viewSize,
        holder,
      );
      expect(touchedSpot6, null);
    });
  });
}
