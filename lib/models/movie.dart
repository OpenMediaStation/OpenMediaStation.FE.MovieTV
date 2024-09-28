import 'package:open_media_server_app/models/metadata.dart';

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
