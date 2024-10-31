// import 'package:fedodo_general/globals/preferences.dart';
// import 'package:fedodo_general/widgets/auth/oauth_handler/custom_web_base_dummy.dart'
//     if (dart.library.html) '../oauth_handler/custom_web_base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/interfaces.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:open_media_server_app/auth/device_code.dart';
import 'package:open_media_server_app/globals.dart';
import 'package:open_media_server_app/helpers/Preferences.dart';
import 'package:random_string/random_string.dart';

class LoginManager {
  late OAuth2Client client;

  BaseWebAuth? baseWebAuth;

  LoginManager() {
    if (Globals.isTv) {
      // Do nothing
    } else if (!Globals.isWeb) {
      client = OAuth2Client(
        authorizeUrl: Globals.AuthorizeUrl,
        tokenUrl: Globals.TokenUrl,
        redirectUri: "my.test.app:/oauth2redirect", // TODO
        customUriScheme: "my.test.app",
      );
    } else {
      // client = OAuth2Client(
      //   authorizeUrl:
      //       "https://auth.${Preferences.prefs!.getString("DomainName")}/oauth/authorize",
      //   tokenUrl:
      //       "https://auth.${Preferences.prefs!.getString("DomainName")}/oauth/token",
      //   redirectUri: AuthGlobals.redirectUriWeb,
      //   // refreshUrl: "https://auth.${GlobalSettings.domainName}/oauth/token",
      //   customUriScheme: Uri.parse(AuthGlobals.redirectUriWeb).authority,
      // );
    }

    // if (kIsWeb) {
    //   baseWebAuth = CustomWebBase();
    // }
  }

  Future<String?> login(String clientId, BuildContext context) async {
    if (Globals.isTv) {
      DeviceCode deviceCode = DeviceCode();
      var token = await deviceCode.authenticateUser(Globals.ClientId, "offline_access", Globals.DeviceCodeUrl, context);

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
      clientId: clientId,
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

  Future<String?> refreshAsync() async {
    String clientId = Preferences.prefs!.getString("ClientId")!;
    String clientSecret = Preferences.prefs!.getString("ClientSecret")!;

    var tknResponse = await client.refreshToken(
      Preferences.prefs!.getString("RefreshToken")!,
      clientId: clientId,
      clientSecret: Uri.encodeQueryComponent(clientSecret),
    );

    Preferences.prefs?.setString("AccessToken", tknResponse.accessToken!);
    Preferences.prefs?.setString("RefreshToken", tknResponse.refreshToken!);

    return tknResponse.accessToken;
  }
}
