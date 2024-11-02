import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_media_server_app/helpers/preferences.dart';
import 'package:open_media_server_app/models/auth/auth_info.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DeviceCode {
  Future<Map<String, dynamic>> getDeviceCode(
      String clientId, String scope, String deviceCodeUrl) async {
    final response = await http.post(
      Uri.parse(deviceCodeUrl), // Replace with your provider's URL
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'client_id': clientId, 'scope': scope},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get device code');
    }
  }

  Future<String?> authenticateUser(AuthInfo authInfo, String scope,
      String deviceCodeUrl, BuildContext context) async {
    try {
      final deviceCodeResponse =
          await getDeviceCode(authInfo.clientId, scope, deviceCodeUrl);
      final userCode = deviceCodeResponse['user_code'];
      final verificationUri = deviceCodeResponse['verification_uri'];

      String fullVerificationUrl = "$verificationUri?code=$userCode";

      print('Please go to $fullVerificationUrl');

      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login with your phone'),
            content: SizedBox(
              height: 200,
              width: 200,
              child: QrImageView(
                eyeStyle: const QrEyeStyle(
                  color: Colors.white,
                  eyeShape: QrEyeShape.square,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  color: Colors.white,
                  dataModuleShape: QrDataModuleShape.square,
                ),
                data: fullVerificationUrl,
                version: QrVersions.auto,
                // size: 200.0,
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Done'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      final code = deviceCodeResponse['device_code'];
      final interval = deviceCodeResponse['interval'];
      var token = await pollForToken(
        code,
        interval,
        authInfo.clientId,
        authInfo.tokenUrl,
        scope,
      );

      return token;
    } catch (e) {
      print('Error: $e');
    }

    return null;
  }

  Future<String?> pollForToken(
      String deviceCode, int interval, String clientId, String tokenUrl, String scope) async {
    while (true) {
      await Future.delayed(Duration(seconds: interval));

      final response = await http.post(
        Uri.parse(tokenUrl), // Replace with your provider's token URL
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'client_id': clientId,
          'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
          'device_code': deviceCode,
          'scope': scope
        },
      );

      if (response.statusCode == 200) {
        final tokenResponse = json.decode(response.body);
        print('Access token: ${tokenResponse['access_token']}');

        Preferences.prefs?.setString("RefreshToken", tokenResponse['refresh_token']);
        print('Refresh token: ${tokenResponse['refresh_token']}');

        return tokenResponse['access_token'];
      } else {
        final errorResponse = json.decode(response.body);
        if (errorResponse['error'] == 'authorization_pending') {
          print('Authorization pending...');
          continue;
        } else if (errorResponse['error'] == 'authorization_declined') {
          print('Authorization declined by user');
          break;
        } else if (errorResponse['error'] == 'expired_token') {
          print('Device code expired');
          break;
        } else {
          print('Unknown error: ${errorResponse['error']}');
          break;
        }
      }
    }

    return null;
  }
}
