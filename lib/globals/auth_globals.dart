import 'package:flutter/foundation.dart';
import 'package:open_media_server_app/globals/preference_globals.dart';

class AuthGlobals {
  static String get redirectUriWeb {
    if (kDebugMode) {
      return "http://localhost:8000/redirect.html";
    } else {
      return "https://${PreferenceGlobals.BaseUrl}/redirect.html";
    }
  }

  static String? appLoginCodeRoute;

}