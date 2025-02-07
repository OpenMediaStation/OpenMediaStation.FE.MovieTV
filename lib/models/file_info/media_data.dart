import 'package:open_media_server_app/models/file_info/media_format.dart';
import 'package:open_media_server_app/helpers/duration_extension_methods.dart';

class MediaData {
  MediaData({required this.duration, required this.format});

  final Duration? duration;
  final MediaFormat format;

  factory MediaData.fromJson(Map<String, dynamic> json) {
    return MediaData(
        duration: (json['duration'] as String).tryParseDuration(),
        format: MediaFormat.fromJson(json['format']));
  }
}
