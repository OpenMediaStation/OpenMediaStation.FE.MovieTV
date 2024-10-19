class MetadataSeasonModel {
  final String? poster;
  final String? airDate;
  final int? episodeCount;
  final String? overview;

  MetadataSeasonModel({
    required this.poster,
    required this.airDate,
    required this.episodeCount,
    required this.overview,
  });

  factory MetadataSeasonModel.fromJson(Map<String, dynamic> json) {
    var overview = json['overview'] as String?;
    if (overview == "") {
      overview = null;
    }

    return MetadataSeasonModel(
      poster: json['poster'] as String?,
      airDate: json['airDate'] as String?,
      episodeCount: json['episodeCount'] as int?,
      overview: overview,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poster': poster,
      'airDate': airDate,
      'episodeCount': episodeCount,
      'overview': overview,
    };
  }
}
