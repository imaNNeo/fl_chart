import 'package:flutter/widgets.dart';

extension EdgeInsetsExtension on EdgeInsets {
  EdgeInsets get onlyTopBottom => EdgeInsets.only(
        top: top,
        bottom: bottom,
      );

  EdgeInsets get onlyLeftRight => EdgeInsets.only(
        left: left,
        right: right,
      );
}
