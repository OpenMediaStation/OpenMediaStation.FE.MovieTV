import 'dart:convert';
import 'package:open_media_server_app/apis/base_api.dart';
import 'package:open_media_server_app/helpers/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:open_media_server_app/models/progress/progress.dart';

class ProgressApi {
  Future<Progress?> getProgress(String category, String inventoryItemId) async {
    String apiUrl = "${Preferences.prefs?.getString("BaseUrl")}/api/progress?";
    var headers = await BaseApi.getRefreshedHeaders();

    var response = await http.get(
      Uri.parse("${apiUrl}category=$category&parentId=$inventoryItemId"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      dynamic jsonResponse = json.decode(response.body);
      return Progress.fromJson(jsonResponse);
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

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(progress.toJson()),
    );

    return response.statusCode == 200;
  }
}
