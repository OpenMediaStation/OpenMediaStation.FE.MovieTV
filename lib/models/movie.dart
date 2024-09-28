class Rating {
  final String source;
  final String value;

  Rating({
    required this.source,
    required this.value,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      source: json['source'] as String,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'value': value,
    };
  }
}

class Metadata {
  final String title;
  final String year;
  final String rated;
  final String released;
  final String runtime;
  final String genre;
  final String director;
  final String writer;
  final String actors;
  final String plot;
  final String language;
  final String country;
  final String awards;
  final String poster;
  final List<Rating> ratings;
  final String metascore;
  final String imdbRating;
  final String imdbVotes;
  final String imdbID;
  final String type;
  final String dvd;
  final String boxOffice;
  final String production;
  final String website;
  final String response;

  Metadata({
    required this.title,
    required this.year,
    required this.rated,
    required this.released,
    required this.runtime,
    required this.genre,
    required this.director,
    required this.writer,
    required this.actors,
    required this.plot,
    required this.language,
    required this.country,
    required this.awards,
    required this.poster,
    required this.ratings,
    required this.metascore,
    required this.imdbRating,
    required this.imdbVotes,
    required this.imdbID,
    required this.type,
    required this.dvd,
    required this.boxOffice,
    required this.production,
    required this.website,
    required this.response,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    var ratingsList = json['ratings'] as List;
    List<Rating> ratings = ratingsList.map((ratingJson) => Rating.fromJson(ratingJson)).toList();

    return Metadata(
      title: json['title'] as String,
      year: json['year'] as String,
      rated: json['rated'] as String,
      released: json['released'] as String,
      runtime: json['runtime'] as String,
      genre: json['genre'] as String,
      director: json['director'] as String,
      writer: json['writer'] as String,
      actors: json['actors'] as String,
      plot: json['plot'] as String,
      language: json['language'] as String,
      country: json['country'] as String,
      awards: json['awards'] as String,
      poster: json['poster'] as String,
      ratings: ratings,
      metascore: json['metascore'] as String,
      imdbRating: json['imdbRating'] as String,
      imdbVotes: json['imdbVotes'] as String,
      imdbID: json['imdbID'] as String,
      type: json['type'] as String,
      dvd: json['dvd'] as String,
      boxOffice: json['boxOffice'] as String,
      production: json['production'] as String,
      website: json['website'] as String,
      response: json['response'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
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
      'ratings': ratings.map((rating) => rating.toJson()).toList(),
      'metascore': metascore,
      'imdbRating': imdbRating,
      'imdbVotes': imdbVotes,
      'imdbID': imdbID,
      'type': type,
      'dvd': dvd,
      'boxOffice': boxOffice,
      'production': production,
      'website': website,
      'response': response,
    };
  }
}

class Movie {
  final String category;
  final Metadata metadata;
  final String id;
  final String title;
  final String path;

  Movie({
    required this.category,
    required this.metadata,
    required this.id,
    required this.title,
    required this.path,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      category: json['category'] as String,
      metadata: Metadata.fromJson(json['metadata']),
      id: json['id'] as String,
      title: json['title'] as String,
      path: json['path'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'metadata': metadata.toJson(),
      'id': id,
      'title': title,
      'path': path,
    };
  }
}
