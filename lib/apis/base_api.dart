import 'package:open_media_server_app/helpers/Preferences.dart';

class BaseApi {
  static Map<String, String> getHeaders() {
    return {
      "Authorization": "Bearer ${Preferences.prefs?.getString("AccessToken")}"
    };
  }
}
