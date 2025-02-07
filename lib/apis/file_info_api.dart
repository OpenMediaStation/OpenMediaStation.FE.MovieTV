import 'dart:convert';

import 'package:open_media_server_app/apis/base_api.dart';
import 'package:http/http.dart' as http;
import 'package:open_media_server_app/helpers/preferences.dart';
import 'package:open_media_server_app/models/file_info/file_info.dart';

class FileInfoApi {
  Future<FileInfo?> getFileInfo(String category, String versionID) async {
    if (category == "" || versionID == "") {
      return null;
    }
    String apiUrl = "${Preferences.prefs?.getString("BaseUrl")}/api/fileInfo?";

    var headers = await BaseApi.getRefreshedHeaders();

    var response = await http.get(
        Uri.parse("${apiUrl}category=$category&id=$versionID"),
        headers: headers);

    if (response.statusCode == 200 && response.body != "") {
      dynamic jsonResponse = json.decode(response.body);
      return FileInfo.fromJson(jsonResponse);
    } else {
      return null;
    }
  }
}
