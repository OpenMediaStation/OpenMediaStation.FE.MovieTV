import 'package:open_media_server_app/apis/item_api.dart';
import 'package:open_media_server_app/apis/movie_api.dart';
import 'package:open_media_server_app/models/movie.dart';

class MovieService {
  Future<List<Movie>> listMovies() async {
    ItemApi itemApi = ItemApi();
    MovieApi movieApi = MovieApi();

    var items = await itemApi.listItems("Movie");

    List<Movie> movies = [];

    for (var element in items) {
      movies.add(await movieApi.getMovie(element.id));
    }

    return movies;
  }
}
