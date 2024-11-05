import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class PlatformGlobals {
  static bool isTv = false;
  static bool isAndroidTv = false;
  static bool isMobile = false;
  static bool isWeb = false;
  static bool isKiosk = false;

  static Future setGlobals() async {
    PlatformGlobals.isMobile = defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;

    if (defaultTargetPlatform == TargetPlatform.android) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      PlatformGlobals.isTv =
          androidInfo.systemFeatures.contains('android.software.leanback');
    }

    if (PlatformGlobals.isTv) {
      PlatformGlobals.isMobile = false;
    }

    if (PlatformGlobals.isTv &&
        defaultTargetPlatform == TargetPlatform.android) {
      PlatformGlobals.isAndroidTv = true;
    }

    if (kIsWeb) {
      PlatformGlobals.isWeb = true;
    }
  }
}
