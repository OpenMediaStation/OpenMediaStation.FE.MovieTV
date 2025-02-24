import 'package:open_media_server_app/helpers/duration_extension_methods.dart';

class MediaStream {
  int index;
  String? codecName;
  String? codecLongName;
  String? codecTagString;
  String? codecTag;
  int bitRate;
  Duration startTime;
  Duration duration;
  String? language;
  Map<String, bool>? disposition;
  Map<String, String>? tags;
  int? bitDepth;

  MediaStream({
    required this.index,
    required this.codecName,
    required this.codecLongName,
    required this.codecTagString,
    required this.codecTag,
    required this.bitRate,
    required this.startTime,
    required this.duration,
    this.language,
    this.disposition,
    this.tags,
    this.bitDepth,
  });

  factory MediaStream.fromJson(Map<String, dynamic> json) {
    return MediaStream(
      index: json['index'] as int,
      codecName: json['codecName'] as String,
      codecLongName: json['codecLongName'] as String,
      codecTagString: json['codecTagString'] as String?,
      codecTag: json['codecTag'] as String?,
      bitRate: json['bitRate'] as int,
      startTime: (json['startTime'] as String).tryParseDuration() ?? const Duration(),
      duration: (json['duration'] as String).tryParseDuration() ?? const Duration(),
      language: json['language'] as String?,
      disposition: (json['disposition'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, value as bool)),
      tags: (json['tags'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, value as String)),
      bitDepth: json['bitDepth'] as int?,
    );
  }
}
