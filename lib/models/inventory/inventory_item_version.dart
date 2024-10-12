class InventoryItemVersion {
  final String id;
  final String path;
  final String? fileInfoId;

  InventoryItemVersion({
    required this.id,
    required this.path,
    this.fileInfoId,
  });

  factory InventoryItemVersion.fromJson(Map<String, dynamic> json) {
    return InventoryItemVersion(
      id: json['id'] as String,
      path: json['path'] as String,
      fileInfoId: json['fileInfoId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'fileInfoId': fileInfoId,
    };
  }
}
