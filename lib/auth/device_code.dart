import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:open_media_server_app/globals.dart';

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

  Future<String?> authenticateUser(
      String clientId, String scope, String deviceCodeUrl) async {
    try {
      final deviceCodeResponse =
          await getDeviceCode(clientId, scope, deviceCodeUrl);
      final userCode = deviceCodeResponse['user_code'];
      final verificationUri = deviceCodeResponse['verification_uri'];

      print('Please go to $verificationUri?code=$userCode');

      final code = deviceCodeResponse['device_code'];
      final interval = deviceCodeResponse['interval'];
      var token = await pollForToken(
          code, interval, Globals.ClientId, Globals.TokenUrl);

      return token;
    } catch (e) {
      print('Error: $e');
    }

    return null;
  }

  Future<String?> pollForToken(
      String deviceCode, int interval, String clientId, String tokenUrl) async {
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
        },
      );

      if (response.statusCode == 200) {
        final tokenResponse = json.decode(response.body);
        print('Access token: ${tokenResponse['access_token']}');

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
