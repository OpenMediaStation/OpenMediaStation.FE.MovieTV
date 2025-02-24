class Progress {
  String? id;
  String? category;
  String? parentId;
  double? progressPercentage; 
  int? progressSeconds;
  int? completions;

  Progress({
    required this.id,
    required this.category,
    required this.parentId,
    required this.progressSeconds,
    required this.progressPercentage,
    required this.completions,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      id: json['id'] as String?,
      category: json['category'] as String?,
      parentId: json['parentId'] as String?,
      progressPercentage: json['progressPercentage'] != null
          ? (json['progressPercentage'] is String && json['progressPercentage'].toLowerCase() == "nan") ? double.nan : (json['progressPercentage'] as num).toDouble()
          : null, 
      progressSeconds: json['progressSeconds'] as int?,
      completions: json['completions'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'parentId': parentId,
      'progressPercentage': progressPercentage,
      'progressSeconds': progressSeconds,
      'completions': completions,
    };
  }
}
