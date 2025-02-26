import 'dart:convert';
import 'package:open_media_server_app/apis/base_api.dart';
import 'package:open_media_server_app/helpers/preferences.dart';
import 'package:open_media_server_app/models/metadata/metadata_model.dart';
import 'package:open_media_server_app/helpers/http_wrapper.dart'as http;

class MetadataApi {
  Future<MetadataModel> getMetadata(String id, String category) async {
    String apiUrl = "${Preferences.prefs?.getString("BaseUrl")}/api/metadata?";

    var headers = await BaseApi.getRefreshedHeaders();

    var response = await http
        .get(Uri.parse("${apiUrl}id=$id&category=$category"), headers: headers);

    if (response.statusCode == 200) {
      dynamic jsonResponse = json.decode(response.body);
      return MetadataModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load metadata');
    }
  }

  static Future<List<MetadataModel>> getMetadatas(
      List<String> ids, String category) async {
    String baseUrl = Preferences.prefs?.getString("BaseUrl") ?? "";
    String apiUrl = "$baseUrl/api/metadata/batch";

    var headers = await BaseApi.getRefreshedHeaders();

    Uri uri = Uri.parse(apiUrl).replace(
      queryParameters: {
        "ids": ids,
        "category": category,
      },
    );

    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((e) => MetadataModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load metadata: ${response.body}');
    }
  }
}
