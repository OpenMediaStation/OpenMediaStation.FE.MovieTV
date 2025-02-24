import 'package:open_media_server_app/models/file_info/media_data.dart';

class FileInfo {
  FileInfo({
    required this.id,
    required this.parentId,
    required this.parentCategory,
    required this.mediaData,
  });

  final String id;
  final String parentId;
  final String parentCategory;
  final MediaData mediaData;

  factory FileInfo.fromJson(Map<String, dynamic> json) {
    return FileInfo(
        id: json['id'] as String,
        parentId: json['parentId'] as String,
        parentCategory: json['parentCategory'],
        mediaData: MediaData.fromJson(json['mediaData']));
  }
}
