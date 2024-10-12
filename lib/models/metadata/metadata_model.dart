import 'package:open_media_server_app/models/metadata/metadata_book_model.dart';
import 'package:open_media_server_app/models/metadata/metadata_episode_model.dart';
import 'package:open_media_server_app/models/metadata/metadata_movie_model.dart';
import 'package:open_media_server_app/models/metadata/metadata_show_model.dart';

class MetadataModel {
  final String id;
  final String parentId;

  final String? title;
  final String? category;

  final MetadataMovieModel? movie;
  final MetadataShowModel? show;
  final MetadataEpisodeModel? episode;
  final MetadataBookModel? book;

  MetadataModel({
    required this.id,
    required this.parentId,
    this.title,
    this.category,
    this.movie,
    this.show,
    this.episode,
    this.book,
  });

  // Factory method to create a MetadataModel from JSON
  factory MetadataModel.fromJson(Map<String, dynamic> json) {
    return MetadataModel(
      id: json['id'] as String,
      parentId: json['parentId'] as String,
      title: json['title'] as String?,
      category: json['category'] as String?,
      movie: json['movie'] != null
          ? MetadataMovieModel.fromJson(json['movie'] as Map<String, dynamic>)
          : null,
      show: json['show'] != null
          ? MetadataShowModel.fromJson(json['show'] as Map<String, dynamic>)
          : null,
      episode: json['episode'] != null
          ? MetadataEpisodeModel.fromJson(json['episode'] as Map<String, dynamic>)
          : null,
      book: json['book'] != null
          ? MetadataBookModel.fromJson(json['book'] as Map<String, dynamic>)
          : null,
    );
  }

  // Method to convert a MetadataModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parentId': parentId,
      'title': title,
      'category': category,
      'movie': movie?.toJson(),
      'show': show?.toJson(),
      'episode': episode?.toJson(),
      'book': book?.toJson(),
    };
  }
}
