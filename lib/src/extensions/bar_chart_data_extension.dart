import 'package:fl_chart/src/chart/bar_chart/bar_chart_data.dart';

extension BarChartDataExtension on BarChartData {
  List<double> calculateGroupsX(double viewWidth) {
    assert(barGroups.isNotEmpty);
    final groupsX = List<double>.filled(barGroups.length, 0);

    var sumWidth =
        barGroups.map((group) => group.width).reduce((a, b) => a + b);
    final spaceAvailable = viewWidth - sumWidth;

    void spaceEvenly() {
      final eachSpace = spaceAvailable / (barGroups.length + 1);
      var tempX = 0.0;
      barGroups.asMap().forEach((i, group) {
        tempX += eachSpace;
        tempX += group.width / 2;
        groupsX[i] = tempX;
        tempX += group.width / 2;
      });
    }

    switch (alignment) {
      case BarChartAlignment.start:
        var tempX = 0.0;
        for (var i = 0; i < barGroups.length; i++) {
          final group = barGroups[i];
          groupsX[i] = tempX + group.width / 2;

          final groupSpace = i == barGroups.length - 1 ? 0 : groupsSpace;
          tempX += group.width + groupSpace;
        }
        if (tempX > viewWidth) {
          spaceEvenly();
        }

      case BarChartAlignment.end:
        sumWidth += groupsSpace * (barGroups.length - 1);
        final horizontalMargin = viewWidth - sumWidth;

        var tempX = 0.0;
        for (var i = 0; i < barGroups.length; i++) {
          final group = barGroups[i];
          groupsX[i] = horizontalMargin + tempX + group.width / 2;

          final groupSpace = i == barGroups.length - 1 ? 0 : groupsSpace;
          tempX += group.width + groupSpace;
        }
        if (tempX > viewWidth) {
          spaceEvenly();
        }

      case BarChartAlignment.center:
        sumWidth += groupsSpace * (barGroups.length - 1);
        final horizontalMargin = (viewWidth - sumWidth) / 2;

        var tempX = 0.0;
        for (var i = 0; i < barGroups.length; i++) {
          final group = barGroups[i];
          groupsX[i] = horizontalMargin + tempX + group.width / 2;

          final groupSpace = i == barGroups.length - 1 ? 0 : groupsSpace;
          tempX += group.width + groupSpace;
        }
        if (tempX > viewWidth) {
          spaceEvenly();
        }

      case BarChartAlignment.spaceBetween:
        final eachSpace = spaceAvailable / (barGroups.length - 1);

        var tempX = 0.0;
        barGroups.asMap().forEach((index, group) {
          tempX += group.width / 2;
          if (index != 0) {
            tempX += eachSpace;
          }
          groupsX[index] = tempX;
          tempX += group.width / 2;
        });

      case BarChartAlignment.spaceAround:
        final eachSpace = spaceAvailable / (barGroups.length * 2);

        var tempX = 0.0;
        barGroups.asMap().forEach((i, group) {
          tempX += eachSpace;
          tempX += group.width / 2;
          groupsX[i] = tempX;
          tempX += group.width / 2;
          tempX += eachSpace;
        });

      case BarChartAlignment.spaceEvenly:
        spaceEvenly();
    }

    return groupsX;
  }
}
