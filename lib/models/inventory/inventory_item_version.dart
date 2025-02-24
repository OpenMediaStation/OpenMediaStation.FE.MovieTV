class InventoryItemVersion {
  final String id;
  final String path;
  final String? fileInfoId;
  final String? name;

  InventoryItemVersion({
    required this.id,
    required this.path,
    this.fileInfoId,
    this.name
  });

  factory InventoryItemVersion.fromJson(Map<String, dynamic> json) {
    return InventoryItemVersion(
      id: json['id'] as String,
      path: json['path'] as String,
      fileInfoId: json['fileInfoId'] as String?,
      name: json['name'] as String?
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
