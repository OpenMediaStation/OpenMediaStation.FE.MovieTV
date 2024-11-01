import 'dart:convert';
import 'package:open_media_server_app/apis/base_api.dart';
import 'package:http/http.dart' as http;
import 'package:open_media_server_app/helpers/preferences.dart';
import 'package:open_media_server_app/models/auth/auth_info.dart';

class AuthInfoApi {
  Future<AuthInfo> getAuthInfo() async {
    String apiUrl = "${Preferences.prefs?.getString("BaseUrl")}/auth/info";

    var headers = BaseApi.getHeaders();

    var response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      return AuthInfo.fromJson(decoded);
    } else {
      throw Exception('Failed to load auth info');
    }
  }
}
