import 'package:flutter/widgets.dart';

extension EdgeInsetsExtension on EdgeInsets {
  EdgeInsets get onlyTopBottom => EdgeInsets.only(
        left: 0,
        top: top,
        right: 0,
        bottom: bottom,
      );

  EdgeInsets get onlyLeftRight => EdgeInsets.only(
        left: left,
        top: 0,
        right: right,
        bottom: 0,
      );
}
