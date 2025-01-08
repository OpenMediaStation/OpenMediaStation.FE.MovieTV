import 'dart:convert';
import 'package:open_media_server_app/auth/login_manager.dart';
import 'package:open_media_server_app/globals/auth_globals.dart';
import 'package:open_media_server_app/helpers/preferences.dart';

class BaseApi {
  static Map<String, String> getHeaders() {
    var map = {
      "Authorization": "Bearer ${Preferences.prefs?.getString("AccessToken")}"
    };

    return map;
  }

  static Future<Map<String, String>> getRefreshedHeaders() async {
    var token = Preferences.prefs?.getString("AccessToken");

    if (AuthGlobals.authInfo != null && token != null) {
      if (isJwtAboutToExpire(token)) {
        LoginManager loginManager = LoginManager(AuthGlobals.authInfo!);
        token = await loginManager.refreshAsync(AuthGlobals.authInfo!);
      }
    }

    return {"Authorization": "Bearer $token"};
  }

  static bool isJwtAboutToExpire(String token, {int bufferInSeconds = 120}) {
    try {
      // Decode the JWT to get its payload
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception("Invalid token format");
      }

      // Base64 decode the payload part of the token
      final payload = json
          .decode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));

      // Check if the `exp` field exists in the payload
      if (!payload.containsKey('exp')) {
        throw Exception("Token does not contain expiration date");
      }

      // `exp` is the expiration time in seconds since epoch
      final exp = payload['exp'] as int;

      // Get the current time in seconds since epoch
      final currentTimeInSeconds =
          DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Check if the token is about to expire within the buffer period
      return exp - currentTimeInSeconds <= bufferInSeconds;
    } catch (e) {
      print("Error decoding token: $e");
      return true; // Assuming it's expired if there's an error
    }
  }
}
