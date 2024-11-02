import 'package:open_media_server_app/globals/auth_globals.dart';
import 'package:open_media_server_app/auth/oauth_handler/custom_web_base_dummy.dart'
    if (dart.library.html) './oauth_handler/custom_web_base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/interfaces.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:open_media_server_app/auth/device_code.dart';
import 'package:open_media_server_app/globals/platform_globals.dart';
import 'package:open_media_server_app/helpers/preferences.dart';
import 'package:open_media_server_app/models/auth/auth_info.dart';
import 'package:random_string/random_string.dart';

class LoginManager {
  late OAuth2Client client;

  BaseWebAuth? baseWebAuth;

  LoginManager(AuthInfo authInfo) {
    if (PlatformGlobals.isTv) {
      client = OAuth2Client(
        authorizeUrl: authInfo.authorizeUrl,
        tokenUrl: authInfo.tokenUrl,
        redirectUri: "my.test.app:/oauth2redirect", // TODO
        customUriScheme: "my.test.app",
      );
    } else if (!PlatformGlobals.isWeb) {
      client = OAuth2Client(
        authorizeUrl: authInfo.authorizeUrl,
        tokenUrl: authInfo.tokenUrl,
        redirectUri: "my.test.app:/oauth2redirect", // TODO
        customUriScheme: "my.test.app",
      );
    } else if (PlatformGlobals.isWeb) {
      client = OAuth2Client(
        authorizeUrl: authInfo.authorizeUrl,
        tokenUrl: authInfo.tokenUrl,
        redirectUri: AuthGlobals.redirectUriWeb,
        // refreshUrl: "https://auth.${GlobalSettings.domainName}/oauth/token",
        customUriScheme: Uri.parse(AuthGlobals.redirectUriWeb).authority,
      );
    }

    if (kIsWeb) {
      baseWebAuth = CustomWebBase();
    }
  }

  Future<String?> login(AuthInfo authInfo, BuildContext context) async {
    if (PlatformGlobals.isTv) {
      DeviceCode deviceCode = DeviceCode();
      var token = await deviceCode.authenticateUser(
          authInfo, "offline_access", authInfo.deviceCodeUrl, context);

      Preferences.prefs?.setString("AccessToken", token!);

      return token;
    }

    var state = Preferences.prefs?.getString("OAuth_State");
    var codeVerifier = Preferences.prefs?.getString("OAuth_CodeVerifier");

    if (kIsWeb && codeVerifier == null) {
      codeVerifier = randomAlphaNumeric(80);
      Preferences.prefs?.setString("OAuth_CodeVerifier", codeVerifier);
    }

    AccessTokenResponse tknResponse = await client.getTokenWithAuthCodeFlow(
      clientId: authInfo.clientId,
      scopes: ["offline_access"],
      webAuthClient: baseWebAuth,
      state: state,
      codeVerifier: codeVerifier,
    );

    var refreshToken = tknResponse.refreshToken;
    if (refreshToken != null) {
      Preferences.prefs?.setString("RefreshToken", refreshToken);
    }

    Preferences.prefs?.setString("AccessToken", tknResponse.accessToken!);

    return tknResponse.accessToken;
  }

  Future<String?> refreshAsync(AuthInfo authInfo) async {
    var tknResponse = await client.refreshToken(
      Preferences.prefs!.getString("RefreshToken")!,
      clientId: authInfo.clientId,
    );

    Preferences.prefs?.setString("AccessToken", tknResponse.accessToken!);
    Preferences.prefs?.setString("RefreshToken", tknResponse.refreshToken!);

    return tknResponse.accessToken;
  }
}
