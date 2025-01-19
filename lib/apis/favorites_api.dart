import 'package:open_media_server_app/apis/base_api.dart';
import 'package:open_media_server_app/helpers/preferences.dart';
import 'package:http/http.dart' as http;

class FavoritesApi {
  Future<bool> favorite(String category, String inventoryItemId) async {
    String apiUrl = "${Preferences.prefs?.getString("BaseUrl")}/api/favorite?";

    var headers = await BaseApi.getRefreshedHeaders();

    var response = await http.post(
      Uri.parse("${apiUrl}category=$category&inventoryItemId=$inventoryItemId"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> unfavorite(String category, String inventoryItemId) async {
    String apiUrl = "${Preferences.prefs?.getString("BaseUrl")}/api/favorite?";

    var headers = await BaseApi.getRefreshedHeaders();

    var response = await http.delete(
      Uri.parse("${apiUrl}category=$category&inventoryItemId=$inventoryItemId"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool?> isFavorited(String category, String inventoryItemId) async {
    String apiUrl = "${Preferences.prefs?.getString("BaseUrl")}/api/favorite?";

    var headers = await BaseApi.getRefreshedHeaders();

    var response = await http.get(
      Uri.parse("${apiUrl}category=$category&inventoryItemId=$inventoryItemId"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      if (response.body == "true") {
        return true;
      } else if (response.body == "false") {
        return false;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
