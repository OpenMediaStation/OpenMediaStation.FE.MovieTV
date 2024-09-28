import 'dart:convert';
import 'package:open_media_server_app/globals.dart';
import 'package:http/http.dart' as http;
import 'package:open_media_server_app/models/movie.dart';

class MovieApi {
  final String apiUrl = "${Globals.BaseUrl}/api/movie?";

  Future<Movie> getMovie(String id) async {
      var response = await http.get(Uri.parse("${apiUrl}id=$id"));

      if (response.statusCode == 200) {
        dynamic jsonResponse = json.decode(response.body);
        return Movie.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load movies');
      }
  }
}
