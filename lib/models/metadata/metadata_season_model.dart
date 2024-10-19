class MetadataSeasonModel {
  final String? poster;
  final String? airDate;
  final int? episodeCount;
  final String? overview;
  final double? popularity;

  MetadataSeasonModel({
    required this.poster,
    required this.airDate,
    required this.episodeCount,
    required this.overview,
    required this.popularity,
  });

  factory MetadataSeasonModel.fromJson(Map<String, dynamic> json) {
    return MetadataSeasonModel(
      poster: json['poster'] as String?,
      airDate: json['airDate'] as String?,
      episodeCount: json['episodeCount'] as int?,
      overview: json['overview'] as String?,
      popularity: json['popularity'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poster': poster,
      'airDate': airDate,
      'episodeCount': episodeCount,
      'overview': overview,
      'popularity': popularity,
    };
  }
}
