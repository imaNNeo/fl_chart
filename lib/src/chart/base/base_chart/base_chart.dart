import 'dart:async';

import 'package:fl_chart/fl_chart.dart';

import 'base_chart_painter.dart';
import 'touch_input.dart';

/// BaseChart is a base class for our charts,
/// each chart should extends this class and implement the [painter] method.
/// and the Painter should extends from [BaseChartPainter].
/// the painter content will be painted on the [FlChart] class.
/// you can find concrete examples here :
/// [LineChart], [BarChart], [PieChart]
abstract class BaseChart {
  /// [touchInputNotifier] the FlChart sends the touch events through this notifier,
  /// in form of a [FlTouchInput] that is a parent class for some touch behaviors.
  /// [touchResponseSink] the painter will responds the touch events through this [StreamSink],
  /// the owner should implement a StreamController and listen to that stream,
  /// and pass the sink here to get the response in form of [BaseTouchResponse],
  /// that is the base class for our charts touched details
  BaseChartPainter painter(
      {FlTouchInputNotifier touchInputNotifier, StreamSink<BaseTouchResponse> touchResponseSink});

  /// get the data of the concrete chart
  BaseChartData getData();
}
