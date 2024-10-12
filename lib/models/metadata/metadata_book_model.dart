class MetadataBookModel {
  final List<String>? authors;
  final String? publisher;
  final String? publishedDate;
  final String? description;
  final int? pageCount;
  final String? language;
  final String? thumbnail;

  MetadataBookModel({
    this.authors,
    this.publisher,
    this.publishedDate,
    this.description,
    this.pageCount,
    this.language,
    this.thumbnail,
  });

  // Factory method to create MetadataBookModel from JSON
  factory MetadataBookModel.fromJson(Map<String, dynamic> json) {
    return MetadataBookModel(
      authors: (json['authors'] as List<dynamic>?)
          ?.map((author) => author as String)
          .toList(),
      publisher: json['publisher'] as String?,
      publishedDate: json['publishedDate'] as String?,
      description: json['description'] as String?,
      pageCount: json['pageCount'] as int?,
      language: json['language'] as String?,
      thumbnail: json['thumbnail'] as String?,
    );
  }

  // Method to convert MetadataBookModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'authors': authors,
      'publisher': publisher,
      'publishedDate': publishedDate,
      'description': description,
      'pageCount': pageCount,
      'language': language,
      'thumbnail': thumbnail,
    };
  }
}
