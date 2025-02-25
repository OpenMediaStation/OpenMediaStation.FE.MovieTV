import 'dart:convert';
import 'package:open_media_server_app/apis/base_api.dart';
import 'package:open_media_server_app/helpers/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:open_media_server_app/models/progress/progress.dart';

class ProgressApi {
  Future<Progress?> getProgress(
      String? category, String? inventoryItemId) async {
    String apiUrl = "${Preferences.prefs?.getString("BaseUrl")}/api/progress?";
    var headers = await BaseApi.getRefreshedHeaders();

    var response = await http.get(
      Uri.parse("${apiUrl}category=$category&parentId=$inventoryItemId"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      dynamic jsonResponse = json.decode(response.body);
      var progress = Progress.fromJson(jsonResponse);

      return progress;
    } else {
      return null;
    }
  }

  static Future<List<Progress>?> getProgresses(
      String? category, List<String?> inventoryItemIds) async {
    String apiUrl =
        "${Preferences.prefs?.getString("BaseUrl")}/api/progress/batch?";
    var headers = await BaseApi.getRefreshedHeaders();

    Uri uri = Uri.parse(apiUrl).replace(
      queryParameters: {
        "ids": inventoryItemIds,
        "category": category,
      },
    );

    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);

      var result = jsonResponse
          .map((progressJson) => Progress.fromJson(progressJson))
          .toList();

      return result;
    } else {
      return null;
    }
  }

  Future<List<Progress>> listProgresses(String category) async {
    String apiUrl =
        "${Preferences.prefs?.getString("BaseUrl")}/api/progress/list?category=$category";
    var headers = await BaseApi.getRefreshedHeaders();

    var response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Progress.fromJson(data)).toList();
    } else {
      return [];
    }
  }

  Future<bool> updateProgress(Progress progress) async {
    String apiUrl = "${Preferences.prefs?.getString("BaseUrl")}/api/progress";
    var headers = await BaseApi.getRefreshedHeaders();
    headers["Content-Type"] = "application/json";

    var jsonContent = json.encode(progress.toJson());

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonContent,
    );

    return response.statusCode == 200;
  }
}
