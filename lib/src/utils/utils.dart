import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';

class Utils {
  factory Utils() {
    return _singleton;
  }

  Utils._internal();
  static Utils _singleton = Utils._internal();

  @visibleForTesting
  static void changeInstance(Utils val) => _singleton = val;

  static const double _degrees2Radians = math.pi / 180.0;

  /// Converts degrees to radians
  double radians(double degrees) => degrees * _degrees2Radians;

  static const double _radians2Degrees = 180.0 / math.pi;

  /// Converts radians to degrees
  double degrees(double radians) => radians * _radians2Degrees;

  /// Returns a default size based on the screen size
  /// that is a 70% scaled square based on the screen.
  Size getDefaultSize(Size screenSize) {
    Size resultSize;
    if (screenSize.width < screenSize.height) {
      resultSize = Size(screenSize.width, screenSize.width);
    } else if (screenSize.height < screenSize.width) {
      resultSize = Size(screenSize.height, screenSize.height);
    } else {
      resultSize = Size(screenSize.width, screenSize.height);
    }
    return resultSize * 0.7;
  }

  /// Forward the view base on its degree
  double translateRotatedPosition(double size, double degree) {
    return (size / 4) * math.sin(radians(degree.abs()));
  }

  Offset calculateRotationOffset(Size size, double degree) {
    final rotatedHeight = (size.width * math.sin(radians(degree))).abs() +
        (size.height * cos(radians(degree))).abs();
    final rotatedWidth = (size.width * cos(radians(degree))).abs() +
        (size.height * sin(radians(degree))).abs();
    return Offset(
      (size.width - rotatedWidth) / 2,
      (size.height - rotatedHeight) / 2,
    );
  }

  /// Decreases [borderRadius] to <= width / 2
  BorderRadius? normalizeBorderRadius(
    BorderRadius? borderRadius,
    double width,
  ) {
    if (borderRadius == null) {
      return null;
    }

    Radius topLeft;
    if (borderRadius.topLeft.x > width / 2 ||
        borderRadius.topLeft.y > width / 2) {
      topLeft = Radius.circular(width / 2);
    } else {
      topLeft = borderRadius.topLeft;
    }

    Radius topRight;
    if (borderRadius.topRight.x > width / 2 ||
        borderRadius.topRight.y > width / 2) {
      topRight = Radius.circular(width / 2);
    } else {
      topRight = borderRadius.topRight;
    }

    Radius bottomLeft;
    if (borderRadius.bottomLeft.x > width / 2 ||
        borderRadius.bottomLeft.y > width / 2) {
      bottomLeft = Radius.circular(width / 2);
    } else {
      bottomLeft = borderRadius.bottomLeft;
    }

    Radius bottomRight;
    if (borderRadius.bottomRight.x > width / 2 ||
        borderRadius.bottomRight.y > width / 2) {
      bottomRight = Radius.circular(width / 2);
    } else {
      bottomRight = borderRadius.bottomRight;
    }

    return BorderRadius.only(
      topLeft: topLeft,
      topRight: topRight,
      bottomLeft: bottomLeft,
      bottomRight: bottomRight,
    );
  }

  /// Default value for BorderSide where borderSide value is not exists
  static const BorderSide defaultBorderSide = BorderSide(width: 0);

  /// Decreases [borderSide] to <= width / 2
  BorderSide normalizeBorderSide(BorderSide? borderSide, double width) {
    if (borderSide == null) {
      return defaultBorderSide;
    }

    double borderWidth;
    if (borderSide.width > width / 2) {
      borderWidth = width / 2.toDouble();
    } else {
      borderWidth = borderSide.width;
    }

    return borderSide.copyWith(width: borderWidth);
  }

  /// Returns an efficient interval for showing axis titles, or grid lines or ...
  ///
  /// If there isn't any provided interval, we use this function to calculate an interval to apply,
  /// using [axisViewSize] / [pixelPerInterval], we calculate the allowedCount lines in the axis,
  /// then using  [diffInAxis] / allowedCount, we can find out how much interval we need,
  /// then we round that number by finding nearest number in this pattern:
  /// 1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 5000, 10000,...
  double getEfficientInterval(
    double axisViewSize,
    double diffInAxis, {
    double pixelPerInterval = 40,
  }) {
    final allowedCount = math.max(axisViewSize ~/ pixelPerInterval, 1);
    if (diffInAxis == 0) {
      return 1;
    }
    final accurateInterval =
        diffInAxis == 0 ? axisViewSize : diffInAxis / allowedCount;
    if (allowedCount <= 2) {
      return accurateInterval;
    }
    return roundInterval(accurateInterval);
  }

  @visibleForTesting
  double roundInterval(double input) {
    if (input < 1) {
      return _roundIntervalBelowOne(input);
    }
    return _roundIntervalAboveOne(input);
  }

  double _roundIntervalBelowOne(double input) {
    assert(input < 1.0);

    if (input < 0.000001) {
      return input;
    }

    final inputString = input.toString();
    var precisionCount = inputString.length - 2;

    var zeroCount = 0;
    for (var i = 2; i <= inputString.length; i++) {
      if (inputString[i] != '0') {
        break;
      }
      zeroCount++;
    }

    final afterZerosNumberLength = precisionCount - zeroCount;
    if (afterZerosNumberLength > 2) {
      final numbersToRemove = afterZerosNumberLength - 2;
      precisionCount -= numbersToRemove;
    }

    final pow10onPrecision = pow(10, precisionCount);
    input *= pow10onPrecision;
    return _roundIntervalAboveOne(input) / pow10onPrecision;
  }

  double _roundIntervalAboveOne(double input) {
    assert(input >= 1.0);
    final decimalCount = input.toInt().toString().length - 1;
    input /= pow(10, decimalCount);

    final scaled = input >= 10 ? input.round() / 10 : input;

    if (scaled >= 7.6) {
      return 10 * pow(10, decimalCount).toInt().toDouble();
    } else if (scaled >= 2.6) {
      return 5 * pow(10, decimalCount).toInt().toDouble();
    } else if (scaled >= 1.6) {
      return 2 * pow(10, decimalCount).toInt().toDouble();
    } else {
      return 1 * pow(10, decimalCount).toInt().toDouble();
    }
  }

  /// billion number
  /// in short scale (https://en.wikipedia.org/wiki/Billion)
  static const double billion = 1000000000;

  /// million number
  static const double million = 1000000;

  /// kilo (thousands) number
  static const double kilo = 1000;

  /// Returns count of fraction digits of a value
  int getFractionDigits(double value) {
    if (value >= 1) {
      return 1;
    } else if (value >= 0.1) {
      return 2;
    } else if (value >= 0.01) {
      return 3;
    } else if (value >= 0.001) {
      return 4;
    } else if (value >= 0.0001) {
      return 5;
    } else if (value >= 0.00001) {
      return 6;
    } else if (value >= 0.000001) {
      return 7;
    } else if (value >= 0.0000001) {
      return 8;
    } else if (value >= 0.00000001) {
      return 9;
    } else if (value >= 0.000000001) {
      return 10;
    }
    return 1;
  }

  /// Formats and add symbols (K, M, B) at the end of number.
  ///
  /// if number is larger than [billion], it returns a short number like 13.3B,
  /// if number is larger than [million], it returns a short number line 43M,
  /// if number is larger than [kilo], it returns a short number like 4K,
  /// otherwise it returns number itself.
  /// also it removes .0, at the end of number for simplicity.
  String formatNumber(double axisMin, double axisMax, double axisValue) {
    final isNegative = axisValue < 0;

    if (isNegative) {
      axisValue = axisValue.abs();
    }

    String resultNumber;
    String symbol;
    if (axisValue >= billion) {
      resultNumber = (axisValue / billion).toStringAsFixed(1);
      symbol = 'B';
    } else if (axisValue >= million) {
      resultNumber = (axisValue / million).toStringAsFixed(1);
      symbol = 'M';
    } else if (axisValue >= kilo) {
      resultNumber = (axisValue / kilo).toStringAsFixed(1);
      symbol = 'K';
    } else {
      final diff = (axisMin - axisMax).abs();
      resultNumber = axisValue.toStringAsFixed(
        getFractionDigits(diff),
      );
      symbol = '';
    }

    if (resultNumber.endsWith('.0')) {
      resultNumber = resultNumber.substring(0, resultNumber.length - 2);
    }

    if (isNegative) {
      resultNumber = '-$resultNumber';
    }

    if (resultNumber == '-0') {
      resultNumber = '0';
    }

    return resultNumber + symbol;
  }

  /// Returns a TextStyle based on provided [context], if [providedStyle] provided we try to merge it.
  TextStyle getThemeAwareTextStyle(
    BuildContext context,
    TextStyle? providedStyle,
  ) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    var effectiveTextStyle = providedStyle;
    if (providedStyle == null || providedStyle.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(providedStyle);
    }
    if (MediaQuery.boldTextOf(context)) {
      effectiveTextStyle = effectiveTextStyle!
          .merge(const TextStyle(fontWeight: FontWeight.bold));
    }
    return effectiveTextStyle!;
  }

  /// Finds the best initial interval value
  ///
  /// If there is a zero point in the axis, we a value that passes through it.
  /// For example if we have -3 to +3, with interval 2. if we start from -3, we get something like this: -3, -1, +1, +3
  /// But the most important point is zero in most cases. with this logic we get this: -2, 0, 2
  double getBestInitialIntervalValue(
    double min,
    double max,
    double interval, {
    double baseline = 0.0,
  }) {
    final diff = baseline - min;
    final mod = diff % interval;
    if ((max - min).abs() <= mod) {
      return min;
    }
    if (mod == 0) {
      return min;
    }
    return min + mod;
  }

  /// Converts radius number to sigma for drawing shadows
  double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }
}
