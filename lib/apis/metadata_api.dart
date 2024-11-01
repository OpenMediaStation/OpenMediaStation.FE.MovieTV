import 'dart:convert';
import 'package:open_media_server_app/apis/base_api.dart';
import 'package:open_media_server_app/helpers/preferences.dart';
import 'package:open_media_server_app/models/metadata/metadata_model.dart';
import 'package:http/http.dart' as http;

class MetadataApi {
  Future<MetadataModel> getMetadata(String id, String category) async {
    String apiUrl = "${Preferences.prefs?.getString("BaseUrl")}/api/metadata?";

    var headers = BaseApi.getHeaders();

    var response = await http
        .get(Uri.parse("${apiUrl}id=$id&category=$category"), headers: headers);

    if (response.statusCode == 200) {
      dynamic jsonResponse = json.decode(response.body);
      return MetadataModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load metadata');
    }
  }
}
