import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class AppUtils {
  static String getFormattedCurrency(
    BuildContext context,
    double value, {
    bool noDecimals = true,
  }) {
    final germanFormat = NumberFormat.currency(
      symbol: '€',
      decimalDigits: noDecimals && value % 1 == 0 ? 0 : 2,
    );
    return germanFormat.format(value);
  }
}
