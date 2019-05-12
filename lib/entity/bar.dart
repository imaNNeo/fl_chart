import 'dart:ui';

import 'package:flutter_smooth_chart/entity/spot.dart';

class Bar {
  final List<Spot> spots;
  final Color barColor;
  final Color dotColor;
  final bool showDots;

  Bar({this.spots, this.barColor, this.dotColor, this.showDots});
}