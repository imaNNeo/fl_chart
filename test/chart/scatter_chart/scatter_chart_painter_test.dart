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
  group('ScatterChart usable size', () {
    test('test 1', () {
      const viewSize = Size(728, 728);

      final ScatterChartData data = ScatterChartData(
          titlesData: FlTitlesData(
        leftTitles: SideTitles(reservedSize: 12, margin: 8, showTitles: true),
        rightTitles: SideTitles(reservedSize: 44, margin: 20, showTitles: true),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(showTitles: false),
      ));

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      expect(scatterChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(644, 728));
    });

    test('test 2', () {
      const viewSize = Size(2020, 2020);

      final ScatterChartData data = ScatterChartData(
          titlesData: FlTitlesData(
        leftTitles: SideTitles(reservedSize: 44, margin: 18, showTitles: true),
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(showTitles: false),
      ));

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      expect(scatterChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(1958, 2020));
    });

    test('test 3', () {
      const viewSize = Size(1000, 1000);

      final ScatterChartData data = ScatterChartData(
          titlesData: FlTitlesData(
        leftTitles: SideTitles(showTitles: false),
        rightTitles:
            SideTitles(reservedSize: 100, margin: 400, showTitles: true),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(showTitles: false),
      ));

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      expect(scatterChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(500, 1000));
    });

    test('test 4', () {
      const viewSize = Size(800, 1000);

      final ScatterChartData data = ScatterChartData(
          titlesData: FlTitlesData(
        leftTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(reservedSize: 10, margin: 0, showTitles: true),
        topTitles: SideTitles(reservedSize: 230, margin: 10, showTitles: true),
        bottomTitles:
            SideTitles(reservedSize: 10, margin: 312, showTitles: true),
      ));

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      expect(scatterChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(790, 438));
    });

    test('test 5', () {
      const viewSize = Size(600, 400);

      final ScatterChartData data = ScatterChartData(
          titlesData: FlTitlesData(
        leftTitles: SideTitles(reservedSize: 0, margin: 0, showTitles: true),
        rightTitles:
            SideTitles(reservedSize: 10, margin: 342134123, showTitles: false),
        topTitles: SideTitles(reservedSize: 80, margin: 0, showTitles: true),
        bottomTitles:
            SideTitles(reservedSize: 10, margin: 312, showTitles: false),
      ));

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      expect(scatterChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(600, 320));
    });
  });

  group('drawAxisTitles()', () {
    test('test 1', () {
      const viewSize = Size(728, 728);

      final ScatterChartData data =
          ScatterChartData(axisTitleData: flAxisTitleData1);

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      MockBuildContext _mockBuildContext = MockBuildContext();
      MockUtils _mockUtils = MockUtils();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      Utils.changeInstance(_mockUtils);
      when(_mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(const TextStyle(color: Color(0x00ffffff)));
      scatterChartPainter.drawAxisTitles(
        _mockBuildContext,
        _mockCanvasWrapper,
        holder,
      );
      verify(_mockCanvasWrapper.drawText(any, any)).called(4);
    });

    test('test 2', () {
      const viewSize = Size(728, 728);

      final ScatterChartData data = ScatterChartData(
          axisTitleData: flAxisTitleData1.copyWith(
              leftTitle: AxisTitle(showTitle: false)));

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      MockBuildContext _mockBuildContext = MockBuildContext();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      when(_mockBuildContext
              .dependOnInheritedWidgetOfExactType<DefaultTextStyle>())
          .thenAnswer((realInvocation) => defaultTextStyle1);
      when(_mockBuildContext.dependOnInheritedWidgetOfExactType<MediaQuery>())
          .thenAnswer((realInvocation) => null);

      scatterChartPainter.drawAxisTitles(
        _mockBuildContext,
        _mockCanvasWrapper,
        holder,
      );
      verify(_mockCanvasWrapper.drawText(any, any)).called(3);
    });
  });

  group('drawTitles()', () {
    test('test 1', () {
      const viewSize = Size(600, 400);

      final ScatterChartData data = ScatterChartData(
        minY: 0,
        maxY: 10,
        titlesData: flTitlesData1.copyWith(
          show: true,
          leftTitles: flTitlesData1.leftTitles.copyWith(
            showTitles: true,
            interval: 2,
            reservedSize: 0,
            rotateAngle: 11,
          ),
          bottomTitles: flTitlesData1.bottomTitles.copyWith(showTitles: false),
          topTitles: flTitlesData1.topTitles.copyWith(showTitles: false),
          rightTitles: flTitlesData1.rightTitles.copyWith(showTitles: false),
        ),
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      MockBuildContext _mockBuildContext = MockBuildContext();
      MockUtils _mockUtils = MockUtils();
      when(_mockCanvasWrapper.size).thenReturn(viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      Utils.changeInstance(_mockUtils);
      when(_mockUtils.calculateRotationOffset(any, any))
          .thenReturn(Offset.zero);
      when(_mockUtils.getBestInitialIntervalValue(any, any, any)).thenReturn(0);
      when(_mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(const TextStyle(color: Color(0x00ffffff)));
      scatterChartPainter.drawTitles(
        _mockBuildContext,
        _mockCanvasWrapper,
        holder,
      );
      verify(_mockCanvasWrapper.drawText(any, any, 11)).called(6);
    });

    test('test 2', () {
      const viewSize = Size(600, 400);

      final ScatterChartData data = ScatterChartData(
        minY: 0,
        maxY: 19,
        titlesData: flTitlesData1.copyWith(
          show: true,
          leftTitles: SideTitles(showTitles: true),
          bottomTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
          rightTitles: SideTitles(showTitles: false),
        ),
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      MockBuildContext _mockBuildContext = MockBuildContext();
      MockUtils _mockUtils = MockUtils();
      when(_mockCanvasWrapper.size).thenReturn(viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      Utils.changeInstance(_mockUtils);
      when(_mockUtils.getEfficientInterval(any, any)).thenReturn(5);

      when(_mockUtils.formatNumber(any)).thenReturn("1");
      when(_mockUtils.calculateRotationOffset(any, any))
          .thenReturn(Offset.zero);
      when(_mockUtils.getBestInitialIntervalValue(any, any, any)).thenReturn(0);
      when(_mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(const TextStyle(color: Color(0x00ffffff)));
      scatterChartPainter.drawTitles(
        _mockBuildContext,
        _mockCanvasWrapper,
        holder,
      );
      verify(_mockCanvasWrapper.drawText(any, any, 0.0)).called(5);
    });

    test('test 3', () {
      const viewSize = Size(600, 400);

      final ScatterChartData data = ScatterChartData(
        minY: 0,
        maxY: 20,
        titlesData: flTitlesData1.copyWith(
          show: true,
          leftTitles: SideTitles(showTitles: true),
          bottomTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
          rightTitles: SideTitles(showTitles: false),
        ),
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      MockBuildContext _mockBuildContext = MockBuildContext();
      MockUtils _mockUtils = MockUtils();
      when(_mockCanvasWrapper.size).thenReturn(viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      Utils.changeInstance(_mockUtils);
      when(_mockUtils.getEfficientInterval(any, any)).thenReturn(5);

      when(_mockUtils.formatNumber(any)).thenReturn("1");
      when(_mockUtils.calculateRotationOffset(any, any))
          .thenReturn(Offset.zero);
      when(_mockUtils.getBestInitialIntervalValue(any, any, any)).thenReturn(0);
      when(_mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(const TextStyle(color: Color(0x00ffffff)));
      scatterChartPainter.drawTitles(
        _mockBuildContext,
        _mockCanvasWrapper,
        holder,
      );
      verify(_mockCanvasWrapper.drawText(any, any, 0.0)).called(5);
    });

    test('test 4', () {
      const viewSize = Size(600, 400);

      List<double> leftTitlesCalledValues = [];
      String leftTitlesCallback(double value) {
        leftTitlesCalledValues.add(value);
        return value.toString();
      }

      List<double> bottomTitlesCalledValues = [];
      String bottomTitlesCallback(double value) {
        bottomTitlesCalledValues.add(value);
        return value.toString();
      }

      final ScatterChartData data = ScatterChartData(
        minY: 0,
        maxY: 20,
        minX: 0,
        maxX: 9,
        titlesData: flTitlesData1.copyWith(
          show: true,
          leftTitles:
              SideTitles(showTitles: true, getTitles: leftTitlesCallback),
          bottomTitles:
              SideTitles(showTitles: true, getTitles: bottomTitlesCallback),
          topTitles: SideTitles(showTitles: false),
          rightTitles: SideTitles(showTitles: false),
        ),
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      MockBuildContext _mockBuildContext = MockBuildContext();
      MockUtils _mockUtils = MockUtils();
      when(_mockCanvasWrapper.size).thenReturn(viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      Utils.changeInstance(_mockUtils);
      when(_mockUtils.getEfficientInterval(any, any)).thenReturn(5);

      when(_mockUtils.formatNumber(any)).thenReturn("1");
      when(_mockUtils.calculateRotationOffset(any, any))
          .thenReturn(Offset.zero);
      when(_mockUtils.getBestInitialIntervalValue(any, any, any)).thenReturn(0);
      when(_mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(const TextStyle(color: Color(0x00ffffff)));
      scatterChartPainter.drawTitles(
        _mockBuildContext,
        _mockCanvasWrapper,
        holder,
      );
      verify(_mockCanvasWrapper.drawText(any, any, 0.0)).called(8);
      expect(leftTitlesCalledValues.contains(0.0), true);
      expect(leftTitlesCalledValues.contains(5.0), true);
      expect(leftTitlesCalledValues.contains(10.0), true);
      expect(leftTitlesCalledValues.contains(15.0), true);
      expect(leftTitlesCalledValues.contains(20.0), true);
      expect(bottomTitlesCalledValues.contains(0.0), true);
      expect(bottomTitlesCalledValues.contains(5.0), true);
    });

    test('test 5', () {
      const viewSize = Size(600, 400);

      List<double> leftTitlesCalledValues = [];
      String rightTitlesCallback(double value) {
        leftTitlesCalledValues.add(value);
        return value.toString();
      }

      List<double> bottomTitlesCalledValues = [];
      String topTitlesCallback(double value) {
        bottomTitlesCalledValues.add(value);
        return value.toString();
      }

      final ScatterChartData data = ScatterChartData(
        minY: 0,
        maxY: 20,
        minX: 0,
        maxX: 9,
        titlesData: flTitlesData1.copyWith(
          show: true,
          leftTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(
            showTitles: true,
            getTitles: topTitlesCallback,
          ),
          rightTitles: SideTitles(
            showTitles: true,
            getTitles: rightTitlesCallback,
          ),
        ),
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      MockBuildContext _mockBuildContext = MockBuildContext();
      MockUtils _mockUtils = MockUtils();
      when(_mockCanvasWrapper.size).thenReturn(viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      Utils.changeInstance(_mockUtils);
      when(_mockUtils.getEfficientInterval(any, any)).thenReturn(5);

      when(_mockUtils.formatNumber(any)).thenReturn("1");
      when(_mockUtils.calculateRotationOffset(any, any))
          .thenReturn(Offset.zero);
      when(_mockUtils.getBestInitialIntervalValue(any, any, any)).thenReturn(0);
      when(_mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(const TextStyle(color: Color(0x00ffffff)));
      scatterChartPainter.drawTitles(
        _mockBuildContext,
        _mockCanvasWrapper,
        holder,
      );
      verify(_mockCanvasWrapper.drawText(any, any, 0.0)).called(8);
      expect(leftTitlesCalledValues.contains(0.0), true);
      expect(leftTitlesCalledValues.contains(5.0), true);
      expect(leftTitlesCalledValues.contains(10.0), true);
      expect(leftTitlesCalledValues.contains(15.0), true);
      expect(leftTitlesCalledValues.contains(20.0), true);
      expect(bottomTitlesCalledValues.contains(0.0), true);
      expect(bottomTitlesCalledValues.contains(5.0), true);
    });
  });

  group('drawSpots()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);

      final ScatterChartData data = ScatterChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        scatterSpots: [
          ScatterSpot(1, 1, radius: 18),
          ScatterSpot(3, 9, show: false),
          ScatterSpot(8, 2, radius: 4),
          ScatterSpot(7, 5, radius: 6),
        ],
        titlesData: FlTitlesData(show: false),
        clipData: FlClipData.all(),
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenReturn(viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      scatterChartPainter.drawSpots(
        _mockCanvasWrapper,
        holder,
      );

      verify(_mockCanvasWrapper.drawCircle(const Offset(10, 90), 18, any))
          .called(1);
      verify(_mockCanvasWrapper.drawCircle(const Offset(80, 80), 4, any))
          .called(1);
      verify(_mockCanvasWrapper.drawCircle(const Offset(70, 50), 6, any))
          .called(1);

      verify(_mockCanvasWrapper.clipRect(any)).called(1);
    });

    test('test 2', () {
      const viewSize = Size(100, 100);

      final ScatterChartData data = ScatterChartData(
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
        titlesData: FlTitlesData(show: false),
        clipData: FlClipData.none(),
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenReturn(viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      scatterChartPainter.drawSpots(
        _mockCanvasWrapper,
        holder,
      );

      verifyNever(_mockCanvasWrapper.drawCircle(any, any, any));
      verifyNever(_mockCanvasWrapper.clipRect(any));
    });
  });

  group('drawTooltips()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);

      final ScatterChartData data = ScatterChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        scatterSpots: [
          ScatterSpot(1, 1, radius: 18),
          ScatterSpot(3, 9, show: false),
          ScatterSpot(8, 2, radius: 4),
          ScatterSpot(7, 5, radius: 6),
        ],
        showingTooltipIndicators: [0, 2, 3],
        titlesData: FlTitlesData(show: false),
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      MockBuildContext _mockBuildContext = MockBuildContext();
      MockUtils _mockUtils = MockUtils();
      Utils.changeInstance(_mockUtils);
      when(_mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(const TextStyle(color: Color(0x00ffffff)));
      when(_mockUtils.calculateRotationOffset(any, any))
          .thenReturn(Offset.zero);
      when(_mockCanvasWrapper.size).thenReturn(viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      scatterChartPainter.drawTouchTooltips(
        _mockBuildContext,
        _mockCanvasWrapper,
        holder,
      );

      verify(_mockCanvasWrapper.drawRotated(
              size: anyNamed("size"),
              rotationOffset: anyNamed("rotationOffset"),
              drawOffset: anyNamed("drawOffset"),
              angle: anyNamed("angle"),
              drawCallback: anyNamed("drawCallback")))
          .called(3);
    });

    test('test 2', () {
      const viewSize = Size(100, 100);

      final ScatterChartData data = ScatterChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        scatterSpots: [
          ScatterSpot(1, 1, radius: 18),
          ScatterSpot(3, 9, show: false),
          ScatterSpot(8, 2, radius: 4),
          ScatterSpot(7, 5, radius: 6),
        ],
        showingTooltipIndicators: [0, 2, 3],
        scatterTouchData: ScatterTouchData(
            touchTooltipData: ScatterTouchTooltipData(
          getTooltipItems: (spot) => null,
        )),
        titlesData: FlTitlesData(show: false),
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      MockBuildContext _mockBuildContext = MockBuildContext();
      MockUtils _mockUtils = MockUtils();
      Utils.changeInstance(_mockUtils);
      when(_mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(const TextStyle(color: Color(0x00ffffff)));
      when(_mockUtils.calculateRotationOffset(any, any))
          .thenReturn(Offset.zero);
      when(_mockCanvasWrapper.size).thenReturn(viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      scatterChartPainter.drawTouchTooltips(
        _mockBuildContext,
        _mockCanvasWrapper,
        holder,
      );

      verifyNever(_mockCanvasWrapper.drawRotated());
      verifyNever(_mockCanvasWrapper.drawRect(any, any));
    });
  });

  group('drawTouchTooltip()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);

      ScatterSpot spot1 = ScatterSpot(1, 1);
      final ScatterChartData data = ScatterChartData(
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
        titlesData: FlTitlesData(show: false),
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
              }),
        ),
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      MockBuildContext _mockBuildContext = MockBuildContext();
      MockUtils _mockUtils = MockUtils();
      Utils.changeInstance(_mockUtils);
      when(_mockUtils.getThemeAwareTextStyle(any, any)).thenReturn(textStyle2);
      when(_mockUtils.calculateRotationOffset(any, any))
          .thenReturn(Offset.zero);
      when(_mockCanvasWrapper.size).thenReturn(viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      scatterChartPainter.drawTouchTooltip(
        _mockBuildContext,
        _mockCanvasWrapper,
        (data.touchData as ScatterTouchData).touchTooltipData,
        spot1,
        holder,
      );

      final verificationResult = verify(_mockCanvasWrapper.drawRotated(
          size: anyNamed("size"),
          rotationOffset: Offset.zero,
          drawOffset: anyNamed("drawOffset"),
          angle: 18,
          drawCallback: captureAnyNamed("drawCallback")));

      var passedDrawCallback = verificationResult.captured.first;
      passedDrawCallback();

      verificationResult.called(1);

      final captured2 = verifyInOrder([
        _mockCanvasWrapper.drawRRect(captureAny, captureAny),
        _mockCanvasWrapper.drawText(captureAny, any),
      ]).captured;

      final RRect rRect = captured2[0][0] as RRect;
      final Paint bgPaint = captured2[0][1] as Paint;
      final TextPainter textPainter = captured2[1][0] as TextPainter;

      expect(rRect.blRadiusX, 85);
      expect(rRect.tlRadiusY, 85);

      expect(bgPaint.color, const Color(0xFF00FF00));
      expect(
          textPainter.text,
          const TextSpan(
            style: textStyle2,
            text: "faketext",
            children: [
              textSpan2,
              textSpan1,
            ],
          ));
    });

    test('test 2', () {
      const viewSize = Size(100, 100);

      ScatterSpot spot1 = ScatterSpot(1, 1);
      final ScatterChartData data = ScatterChartData(
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
        titlesData: FlTitlesData(show: false),
        scatterTouchData: ScatterTouchData(
          touchTooltipData: ScatterTouchTooltipData(
              rotateAngle: 18,
              tooltipBgColor: const Color(0xFFFFFF00),
              tooltipRoundedRadius: 22,
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              tooltipPadding: const EdgeInsets.all(12),
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
              }),
        ),
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      MockBuildContext _mockBuildContext = MockBuildContext();
      MockUtils _mockUtils = MockUtils();
      Utils.changeInstance(_mockUtils);
      when(_mockUtils.getThemeAwareTextStyle(any, any)).thenReturn(textStyle1);
      when(_mockUtils.calculateRotationOffset(any, any))
          .thenReturn(Offset.zero);
      when(_mockCanvasWrapper.size).thenReturn(viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      scatterChartPainter.drawTouchTooltip(
        _mockBuildContext,
        _mockCanvasWrapper,
        (data.touchData as ScatterTouchData).touchTooltipData,
        spot1,
        holder,
      );

      final verificationResult = verify(_mockCanvasWrapper.drawRotated(
          size: anyNamed("size"),
          rotationOffset: Offset.zero,
          drawOffset: anyNamed("drawOffset"),
          angle: 18,
          drawCallback: captureAnyNamed("drawCallback")));

      var passedDrawCallback = verificationResult.captured.first;
      passedDrawCallback();

      verificationResult.called(1);

      final captured2 = verifyInOrder([
        _mockCanvasWrapper.drawRRect(captureAny, captureAny),
        _mockCanvasWrapper.drawText(captureAny, any),
      ]).captured;

      final RRect rRect = captured2[0][0] as RRect;
      final Paint bgPaint = captured2[0][1] as Paint;
      final TextPainter textPainter = captured2[1][0] as TextPainter;

      expect(rRect.blRadiusX, 22);
      expect(rRect.tlRadiusY, 22);

      expect(bgPaint.color, const Color(0xFFFFFF00));
      expect(
          textPainter.text,
          const TextSpan(
            style: textStyle1,
            text: "faketext",
            children: [
              textSpan1,
              textSpan2,
            ],
          ));
    });
  });

  group('getExtraNeededHorizontalSpace()', () {
    test('test 1', () {
      final ScatterChartData data = ScatterChartData(
        titlesData: FlTitlesData(show: false),
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      final result = scatterChartPainter.getExtraNeededHorizontalSpace(holder);
      expect(result, 0);
    });

    test('test 2', () {
      final ScatterChartData data = ScatterChartData(
        titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(showTitles: true, reservedSize: 10, margin: 0),
          rightTitles:
              SideTitles(showTitles: false, reservedSize: 10, margin: 0),
        ),
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      final result = scatterChartPainter.getExtraNeededHorizontalSpace(holder);
      expect(result, 10);
    });

    test('test 3', () {
      final ScatterChartData data = ScatterChartData(
        titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(showTitles: true, reservedSize: 10, margin: 2),
          rightTitles:
              SideTitles(showTitles: true, reservedSize: 10, margin: 2),
        ),
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      final result = scatterChartPainter.getExtraNeededHorizontalSpace(holder);
      expect(result, 24);
    });
  });

  group('getExtraNeededVerticalSpace()', () {
    test('test 1', () {
      final ScatterChartData data = ScatterChartData(
        titlesData: FlTitlesData(show: false),
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      final result = scatterChartPainter.getExtraNeededVerticalSpace(holder);
      expect(result, 0);
    });

    test('test 2', () {
      final ScatterChartData data = ScatterChartData(
        titlesData: FlTitlesData(
          show: true,
          topTitles: SideTitles(showTitles: true, reservedSize: 10, margin: 0),
          bottomTitles:
              SideTitles(showTitles: false, reservedSize: 10, margin: 0),
        ),
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      final result = scatterChartPainter.getExtraNeededVerticalSpace(holder);
      expect(result, 10);
    });

    test('test 3', () {
      final ScatterChartData data = ScatterChartData(
        titlesData: FlTitlesData(
          show: true,
          topTitles: SideTitles(showTitles: true, reservedSize: 10, margin: 2),
          bottomTitles:
              SideTitles(showTitles: true, reservedSize: 10, margin: 2),
        ),
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      final result = scatterChartPainter.getExtraNeededVerticalSpace(holder);
      expect(result, 24);
    });
  });

  group('getLeftOffsetDrawSize()', () {
    test('test 1', () {
      final ScatterChartData data = ScatterChartData(
        titlesData: FlTitlesData(show: false),
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      final result = scatterChartPainter.getLeftOffsetDrawSize(holder);
      expect(result, 0);
    });

    test('test 2', () {
      final ScatterChartData data = ScatterChartData(
        titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(showTitles: true, reservedSize: 10, margin: 0),
          rightTitles:
              SideTitles(showTitles: false, reservedSize: 10, margin: 0),
        ),
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      final result = scatterChartPainter.getLeftOffsetDrawSize(holder);
      expect(result, 10);
    });

    test('test 3', () {
      final ScatterChartData data = ScatterChartData(
        titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(showTitles: true, reservedSize: 10, margin: 2),
          rightTitles:
              SideTitles(showTitles: true, reservedSize: 10, margin: 2),
        ),
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      final result = scatterChartPainter.getLeftOffsetDrawSize(holder);
      expect(result, 12);
    });
  });

  group('getTopOffsetDrawSize()', () {
    test('test 1', () {
      final ScatterChartData data = ScatterChartData(
        titlesData: FlTitlesData(show: false),
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      final result = scatterChartPainter.getTopOffsetDrawSize(holder);
      expect(result, 0);
    });

    test('test 2', () {
      final ScatterChartData data = ScatterChartData(
        titlesData: FlTitlesData(
          show: true,
          topTitles: SideTitles(showTitles: true, reservedSize: 10, margin: 0),
          bottomTitles:
              SideTitles(showTitles: false, reservedSize: 10, margin: 0),
        ),
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      final result = scatterChartPainter.getTopOffsetDrawSize(holder);
      expect(result, 10);
    });

    test('test 3', () {
      final ScatterChartData data = ScatterChartData(
        titlesData: FlTitlesData(
          show: true,
          topTitles: SideTitles(showTitles: true, reservedSize: 10, margin: 2),
          bottomTitles:
              SideTitles(showTitles: true, reservedSize: 10, margin: 2),
        ),
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      final result = scatterChartPainter.getTopOffsetDrawSize(holder);
      expect(result, 12);
    });
  });

  group('handleTouch()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);
      final spots = [
        ScatterSpot(1, 1),
        ScatterSpot(2, 4),
        ScatterSpot(5, 2, radius: 0.5),
        ScatterSpot(8, 7),
      ];

      final ScatterChartData data = ScatterChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
        scatterSpots: spots,
      );

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      ScatterTouchedSpot? touchedSpot = scatterChartPainter.handleTouch(
        const Offset(10, 90),
        viewSize,
        holder,
      );
      expect(touchedSpot!.spot, spots[0]);

      ScatterTouchedSpot? touchedSpot2 = scatterChartPainter.handleTouch(
        const Offset(50, 80),
        viewSize,
        holder,
      );
      expect(touchedSpot2!.spot, spots[2]);

      ScatterTouchedSpot? touchedSpot3 = scatterChartPainter.handleTouch(
        const Offset(50.49, 80),
        viewSize,
        holder,
      );
      expect(touchedSpot3!.spot, spots[2]);

      ScatterTouchedSpot? touchedSpot4 = scatterChartPainter.handleTouch(
        const Offset(50.5, 80),
        viewSize,
        holder,
      );
      expect(touchedSpot4, null);

      final radius = spots[2].radius;
      ScatterTouchedSpot? touchedSpot5 = scatterChartPainter.handleTouch(
        Offset(
          50 + (math.cos(math.pi / 4) * radius) - 0.01,
          80 + (math.sin(math.pi / 4) * radius) - 0.01,
        ),
        viewSize,
        holder,
      );
      expect(touchedSpot5!.spot, spots[2]);

      ScatterTouchedSpot? touchedSpot6 = scatterChartPainter.handleTouch(
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
      const viewSize = Size(128, 112);
      final spots = [
        ScatterSpot(1, 1),
        ScatterSpot(2, 4),
        ScatterSpot(5, 2, radius: 0.5),
        ScatterSpot(8, 7),
      ];

      final ScatterChartData data = ScatterChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(
            showTitles: true,
            reservedSize: 8,
            margin: 2,
          ),
          rightTitles: SideTitles(
            showTitles: true,
            reservedSize: 8,
            margin: 2,
          ),
          topTitles: SideTitles(
            showTitles: true,
            reservedSize: 4,
            margin: 2,
          ),
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 4,
            margin: 2,
          ),
        ),
        axisTitleData: FlAxisTitleData(
          show: true,
          leftTitle: AxisTitle(
            showTitle: true,
            reservedSize: 2,
            margin: 2,
          ),
          topTitle: AxisTitle(
            showTitle: false,
          ),
          rightTitle: AxisTitle(
            showTitle: true,
            reservedSize: 2,
            margin: 2,
          ),
        ),
        scatterSpots: spots,
      );

      const leftExtra = 14;
      const topExtra = 6;
      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      ScatterTouchedSpot? touchedSpot = scatterChartPainter.handleTouch(
        const Offset(leftExtra + 10, topExtra + 90),
        viewSize,
        holder,
      );
      expect(touchedSpot!.spot, spots[0]);

      ScatterTouchedSpot? touchedSpot2 = scatterChartPainter.handleTouch(
        const Offset(leftExtra + 50, topExtra + 80),
        viewSize,
        holder,
      );
      expect(touchedSpot2!.spot, spots[2]);

      ScatterTouchedSpot? touchedSpot3 = scatterChartPainter.handleTouch(
        const Offset(leftExtra + 50.49, topExtra + 80),
        viewSize,
        holder,
      );
      expect(touchedSpot3!.spot, spots[2]);

      ScatterTouchedSpot? touchedSpot4 = scatterChartPainter.handleTouch(
        const Offset(leftExtra + 50.5, topExtra + 80),
        viewSize,
        holder,
      );
      expect(touchedSpot4, null);

      final radius = spots[2].radius;
      ScatterTouchedSpot? touchedSpot5 = scatterChartPainter.handleTouch(
        Offset(
          leftExtra + 50 + (math.cos(math.pi / 4) * radius) - 0.01,
          topExtra + 80 + (math.sin(math.pi / 4) * radius) - 0.01,
        ),
        viewSize,
        holder,
      );
      expect(touchedSpot5!.spot, spots[2]);

      ScatterTouchedSpot? touchedSpot6 = scatterChartPainter.handleTouch(
        Offset(
          leftExtra + 50 + (math.cos(math.pi / 4) * radius),
          topExtra + 80 + (math.sin(math.pi / 4) * radius),
        ),
        viewSize,
        holder,
      );
      expect(touchedSpot6, null);
    });
  });
}
