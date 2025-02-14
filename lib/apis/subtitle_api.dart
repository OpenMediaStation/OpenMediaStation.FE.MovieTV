import 'package:media_kit/media_kit.dart';
import 'package:open_media_server_app/apis/base_api.dart';
import 'package:open_media_server_app/helpers/preferences.dart';
import 'package:open_media_server_app/helpers/http_wrapper.dart'as http;
import 'package:open_media_server_app/models/inventory/inventory_item_addon.dart';

class SubtitleApi {
  Future<SubtitleTrack> getSubtitle(
      InventoryItemAddon addon, String category, String inventoryItemId) async {
    String apiUrl =
        "${Preferences.prefs?.getString("BaseUrl")}/api/addon/download?";

    var headers = await BaseApi.getRefreshedHeaders();

    var response = await http.get(
        Uri.parse(
            "${apiUrl}inventoryItemId=$inventoryItemId&category=$category&addonId=${addon.id}"),
        headers: headers);

    if (response.statusCode == 200) {
      var body = response.body;
      var track = SubtitleTrack.data(body, language: addon.subtitle?.language, title: "OMSRemoteSubtitle");
      return track;
    } else {
      throw Exception('Failed to load subtitle');
    }
  }
}
