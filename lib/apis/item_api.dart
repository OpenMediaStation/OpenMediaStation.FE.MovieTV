import 'dart:convert';
import 'package:open_media_server_app/globals.dart';
import 'package:open_media_server_app/models/item.dart';
import 'package:http/http.dart' as http;

class ItemApi {
  final String apiUrl = "${Globals.BaseUrl}/api/items?";

  Future<List<Item>> listItems(String category) async {
    var response = await http.get(Uri.parse("${apiUrl}category=$category"));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => Item.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
