import 'package:equatable/equatable.dart';

class AxisChartBounds extends Equatable {
  const AxisChartBounds({
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
  });

  final double minX;
  final double maxX;
  final double minY;
  final double maxY;

  double get width => maxX - minX;
  double get height => maxY - minY;

  @override
  List<Object?> get props => [minX, maxX, minY, maxY];

  AxisChartBounds copyWith({
    double? minX,
    double? maxX,
    double? minY,
    double? maxY,
  }) {
    return AxisChartBounds(
      minX: minX ?? this.minX,
      maxX: maxX ?? this.maxX,
      minY: minY ?? this.minY,
      maxY: maxY ?? this.maxY,
    );
  }
}
