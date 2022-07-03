import 'dart:ui';

import 'package:fl_chart/src/chart/line_chart/line_chart_data.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../chart/data_pool.dart';
import 'canvas_wrapper_test.mocks.dart';

@GenerateMocks([Canvas, FlDotPainter, Utils])
void main() {
  MockCanvas mockCanvas = MockCanvas();
  CanvasWrapper canvasWrapper = CanvasWrapper(mockCanvas, MockData.size1);

  test('test drawRRect', () {
    canvasWrapper.drawRRect(MockData.rRect1, MockData.paint1);
    verify(mockCanvas.drawRRect(MockData.rRect1, MockData.paint1)).called(1);
  });

  test('test save', () {
    canvasWrapper.save();
    verify(mockCanvas.save()).called(1);
  });

  test('test restore', () {
    canvasWrapper.restore();
    verify(mockCanvas.restore()).called(1);
  });

  test('test clipRect', () {
    canvasWrapper.clipRect(MockData.rect1);
    verify(mockCanvas.clipRect(MockData.rect1)).called(1);
  });

  test('test translate', () {
    canvasWrapper.translate(11, 232);
    verify(mockCanvas.translate(11, 232)).called(1);
  });

  test('test rotate', () {
    canvasWrapper.rotate(12);
    verify(mockCanvas.rotate(12)).called(1);
  });

  test('test drawPath', () {
    canvasWrapper.drawPath(MockData.path1, MockData.paint1);
    verify(mockCanvas.drawPath(MockData.path1, MockData.paint1)).called(1);
  });

  test('test saveLayer', () {
    canvasWrapper.saveLayer(MockData.rect1, MockData.paint1);
    verify(mockCanvas.saveLayer(MockData.rect1, MockData.paint1)).called(1);
  });

  test('test drawPicture', () {
    canvasWrapper.drawPicture(MockData.picture1());
    verify(mockCanvas.drawPicture(MockData.picture1())).called(1);
  });

  test('test clipPath', () {
    canvasWrapper.clipPath(MockData.path1);
    verify(mockCanvas.clipPath(MockData.path1)).called(1);
  });

  test('test drawRect', () {
    canvasWrapper.drawRect(MockData.rect1, MockData.paint1);
    verify(mockCanvas.drawRect(MockData.rect1, MockData.paint1)).called(1);
  });

  test('test drawLine', () {
    canvasWrapper.drawLine(MockData.offset1, MockData.offset2, MockData.paint1);
    verify(mockCanvas.drawLine(
      MockData.offset1,
      MockData.offset2,
      MockData.paint1,
    )).called(1);
  });

  test('test drawCircle', () {
    canvasWrapper.drawCircle(MockData.offset1, 12, MockData.paint1);
    verify(mockCanvas.drawCircle(MockData.offset1, 12, MockData.paint1))
        .called(1);
  });

  test('test drawArc', () {
    canvasWrapper.drawArc(MockData.rect1, 12, 22, false, MockData.paint1);
    verify(mockCanvas.drawArc(MockData.rect1, 12, 22, false, MockData.paint1))
        .called(1);
  });

  test('test drawDot', () {
    MockFlDotPainter painter = MockFlDotPainter();
    canvasWrapper.drawDot(painter, MockData.lineBarSpot1, MockData.offset1);
    verify(painter.draw(mockCanvas, MockData.lineBarSpot1, MockData.offset1))
        .called(1);
  });

  test('test drawRotated', () {
    final mockUtils = MockUtils();
    when(mockUtils.radians(any)).thenAnswer((realInvocation) => 12);
    Utils.changeInstance(mockUtils);

    var calledCallback = false;
    void callback() {
      calledCallback = true;
    }

    canvasWrapper.drawRotated(
      size: const Size(240, 240),
      rotationOffset: MockData.offset1,
      drawOffset: MockData.offset2,
      angle: 12,
      drawCallback: callback,
    );
    verify(mockCanvas.save()).called(1);
    verify(mockCanvas.translate(123, 123)).called(1);
    verify(mockCanvas.rotate(12)).called(1);
    verify(mockCanvas.translate(-122, -122)).called(1);
    expect(calledCallback, true);
    verify(mockCanvas.restore()).called(1);
  });
}
