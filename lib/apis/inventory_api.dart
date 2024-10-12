import 'dart:convert';
import 'package:open_media_server_app/globals.dart';
import 'package:open_media_server_app/models/inventory/inventory_item.dart';
import 'package:http/http.dart' as http;
import 'package:open_media_server_app/models/inventory/movie.dart';

class InventoryApi {
  Future<List<InventoryItem>> listItems(String category) async {
    String apiUrl = "${Globals.BaseUrl}/api/inventory/items?";

    var response = await http.get(Uri.parse("${apiUrl}category=$category"));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => InventoryItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<Movie> getMovie(String id) async {
    String apiUrl = "${Globals.BaseUrl}/api/inventory/movie?";

    var response = await http.get(Uri.parse("${apiUrl}id=$id"));

    if (response.statusCode == 200) {
      dynamic jsonResponse = json.decode(response.body);
      return Movie.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<Movie> getShow(String id) async {
    String apiUrl = "${Globals.BaseUrl}/api/inventory/show?";

    var response = await http.get(Uri.parse("${apiUrl}id=$id"));

    if (response.statusCode == 200) {
      dynamic jsonResponse = json.decode(response.body);
      return Movie.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load shows');
    }
  }
}
