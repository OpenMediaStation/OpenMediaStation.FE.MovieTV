import 'dart:convert';
import 'package:open_media_server_app/apis/base_api.dart';
import 'package:open_media_server_app/helpers/preferences.dart';
import 'package:open_media_server_app/models/inventory/episode.dart';
import 'package:open_media_server_app/models/inventory/inventory_item.dart';
import 'package:http/http.dart' as http;
import 'package:open_media_server_app/models/inventory/movie.dart';
import 'package:open_media_server_app/models/inventory/season.dart';
import 'package:open_media_server_app/models/inventory/show.dart';

class InventoryApi {
  Future<List<InventoryItem>> listItems(String category) async {
    String apiUrl = "${Preferences.prefs?.getString("BaseUrl")}/api/inventory/items?";

    var headers = await BaseApi.getRefreshedHeaders();

    var response = await http.get(Uri.parse("${apiUrl}category=$category"),
        headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => InventoryItem.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<Movie> getMovie(String id) async {
    String apiUrl = "${Preferences.prefs?.getString("BaseUrl")}/api/inventory/movie?";

    var headers = await BaseApi.getRefreshedHeaders();

    var response =
        await http.get(Uri.parse("${apiUrl}id=$id"), headers: headers);

    if (response.statusCode == 200) {
      dynamic jsonResponse = json.decode(response.body);
      return Movie.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<Show> getShow(String id) async {
    String apiUrl = "${Preferences.prefs?.getString("BaseUrl")}/api/inventory/show?";

    var headers = await BaseApi.getRefreshedHeaders();

    var response =
        await http.get(Uri.parse("${apiUrl}id=$id"), headers: headers);

    if (response.statusCode == 200) {
      dynamic jsonResponse = json.decode(response.body);
      return Show.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load show');
    }
  }

  Future<Season> getSeason(String id) async {
    String apiUrl = "${Preferences.prefs?.getString("BaseUrl")}/api/inventory/season?";

    var headers = await BaseApi.getRefreshedHeaders();

    var response =
        await http.get(Uri.parse("${apiUrl}id=$id"), headers: headers);

    if (response.statusCode == 200) {
      dynamic jsonResponse = json.decode(response.body);
      return Season.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load season');
    }
  }

  Future<Episode> getEpisode(String id) async {
    String apiUrl = "${Preferences.prefs?.getString("BaseUrl")}/api/inventory/episode?";

    var headers = await BaseApi.getRefreshedHeaders();

    var response =
        await http.get(Uri.parse("${apiUrl}id=$id"), headers: headers);

    if (response.statusCode == 200) {
      dynamic jsonResponse = json.decode(response.body);
      return Episode.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load episode');
    }
  }
}
