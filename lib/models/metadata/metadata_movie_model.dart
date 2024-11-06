import 'package:open_media_server_app/models/metadata/rating.dart';

class MetadataMovieModel {
  final String? year;
  final String? rated;
  final String? released;
  final String? runtime;
  final String? genre;
  final String? director;
  final String? writer;
  final String? actors;
  final String? plot;
  final String? language;
  final String? country;
  final String? awards;
  final String? poster;
  final String? logo;
  final String? backdrop;
  final List<Rating>? ratings;
  final String? metascore;
  final String? imdbRating;
  final String? imdbVotes;
  final String? imdbID;
  final String? type;
  final String? dvd;
  final String? boxOffice;
  final String? production;
  final String? website;

  MetadataMovieModel({
    this.year,
    this.rated,
    this.released,
    this.runtime,
    this.genre,
    this.director,
    this.writer,
    this.actors,
    this.plot,
    this.language,
    this.country,
    this.awards,
    this.poster,
    this.logo,
    this.backdrop,
    this.ratings,
    this.metascore,
    this.imdbRating,
    this.imdbVotes,
    this.imdbID,
    this.type,
    this.dvd,
    this.boxOffice,
    this.production,
    this.website,
  });

  factory MetadataMovieModel.fromJson(Map<String, dynamic> json) {
    var ratingsList = json['ratings'] as List?;
    List<Rating>? ratings =
        ratingsList?.map((ratingJson) => Rating.fromJson(ratingJson)).toList();

    var poster = (json['poster'] as String?);

    if (poster == "N/A") {
      poster = null;
    }

    return MetadataMovieModel(
      year: json['year'] as String?,
      rated: json['rated'] as String?,
      released: json['released'] as String?,
      runtime: json['runtime'] as String?,
      genre: json['genre'] as String?,
      director: json['director'] as String?,
      writer: json['writer'] as String?,
      actors: json['actors'] as String?,
      plot: json['plot'] as String?,
      language: json['language'] as String?,
      country: json['country'] as String?,
      awards: json['awards'] as String?,
      poster: poster,
      logo: json['logo'] as String?,
      backdrop: json['backdrop'] as String?,
      ratings: ratings,
      metascore: json['metascore'] as String?,
      imdbRating: json['imdbRating'] as String?,
      imdbVotes: json['imdbVotes'] as String?,
      imdbID: json['imdbID'] as String?,
      type: json['type'] as String?,
      dvd: json['dvd'] as String?,
      boxOffice: json['boxOffice'] as String?,
      production: json['production'] as String?,
      website: json['website'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'rated': rated,
      'released': released,
      'runtime': runtime,
      'genre': genre,
      'director': director,
      'writer': writer,
      'actors': actors,
      'plot': plot,
      'language': language,
      'country': country,
      'awards': awards,
      'poster': poster,
      'logo': logo,
      'backdrop': backdrop,
      'ratings': ratings?.map((rating) => rating.toJson()).toList(),
      'metascore': metascore,
      'imdbRating': imdbRating,
      'imdbVotes': imdbVotes,
      'imdbID': imdbID,
      'type': type,
      'dvd': dvd,
      'boxOffice': boxOffice,
      'production': production,
      'website': website,
    };
  }
}
