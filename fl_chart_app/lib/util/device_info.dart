import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_platform/universal_platform.dart';

enum FormFactorType { Monitor, SmallPhone, LargePhone, Tablet }

// Copied from https://github.com/gskinnerTeam/flutter-folio/blob/master/lib/_utils/device_info.dart
class DeviceOS {
  // Syntax sugar, proxy the UniversalPlatform methods so our views can reference a single class
  static bool isIOS = UniversalPlatform.isIOS;
  static bool isAndroid = UniversalPlatform.isAndroid;
  static bool isMacOS = UniversalPlatform.isMacOS;
  static bool isLinux = UniversalPlatform.isLinux;
  static bool isWindows = UniversalPlatform.isWindows;

  // Higher level device class abstractions (more syntax sugar for the views)
  static bool isWeb = kIsWeb;
  static bool get isDesktop => isWindows || isMacOS || isLinux;
  static bool get isMobile => isAndroid || isIOS;
  static bool get isDesktopOrWeb => isDesktop || isWeb;
  static bool get isMobileOrWeb => isMobile || isWeb;
}

class DeviceScreen {
  // Get the device form factor as best we can.
  // Otherwise we will use the screen size to determine which class we fall into.
  static FormFactorType get(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    if (shortestSide <= 300) return FormFactorType.SmallPhone;
    if (shortestSide <= 600) return FormFactorType.LargePhone;
    if (shortestSide <= 900) return FormFactorType.Tablet;
    return FormFactorType.Monitor;
  }

  // Shortcuts for various mobile device types
  static bool isPhone(BuildContext context) => isSmallPhone(context) || isLargePhone(context);
  static bool isTablet(BuildContext context) => get(context) == FormFactorType.Tablet;
  static bool isMonitor(BuildContext context) => get(context) == FormFactorType.Monitor;
  static bool isSmallPhone(BuildContext context) => get(context) == FormFactorType.SmallPhone;
  static bool isLargePhone(BuildContext context) => get(context) == FormFactorType.LargePhone;
}
