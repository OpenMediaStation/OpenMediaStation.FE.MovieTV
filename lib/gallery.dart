import 'package:flutter/material.dart';
import 'package:open_media_server_app/globals.dart';
import 'package:open_media_server_app/movie_item.dart';
import 'package:open_media_server_app/player.dart';
import 'package:open_media_server_app/services/movie_service.dart';
import 'models/movie.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late Future<List<Movie>> futureMovies;

  @override
  void initState() {
    super.initState();

    MovieService movieService = MovieService();

    futureMovies = movieService.listMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<Movie>>(
        future: futureMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No movies found.'));
          }

          List<Movie> movies = snapshot.data!;

          return GridView.builder(
            itemCount: movies.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.7, // Adjust for desired aspect ratio
            ),
            itemBuilder: (context, index) {
              return InkWell(
                child: MovieItem(item: movies[index]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerView(url: "${Globals.BaseUrl}/stream/${movies[index].category}/${movies[index].id}" ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
