import 'dart:convert';

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

  static Future<Map<String, bool>> isFavoritedBatch(
      List<String> ids, String category) async {
    String baseUrl = Preferences.prefs?.getString("BaseUrl") ?? "";
    String apiUrl = "$baseUrl/api/favorite/batch";

    var headers = await BaseApi.getRefreshedHeaders();

    Uri uri = Uri.parse(apiUrl).replace(
      queryParameters: {
        "ids": ids, 
        "category": category,
      },
    );

    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((key, value) => MapEntry(key, value as bool));
    } else {
      throw Exception('Failed to fetch favorites: ${response.body}');
    }
  }
}
