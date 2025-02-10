import 'package:open_media_server_app/helpers/duration_extension_methods.dart';
import 'package:open_media_server_app/models/file_info/media_stream.dart';

class VideoStream extends MediaStream {
  double avgFrameRate;
  int bitsPerRawSample;
  (int width, int height) displayAspectRatio;
  (int width, int height) sampleAspectRatio;
  String? profile;
  int width;
  int height;
  double frameRate;
  String? pixelFormat;
  int rotation;
  double averageFrameRate;

  VideoStream({
    required int index,
    required String? codecName,
    required String? codecLongName,
    required String? codecTagString,
    required String? codecTag,
    required int bitRate,
    required Duration startTime,
    required Duration duration,
    String? language,
    Map<String, bool>? disposition,
    Map<String, String>? tags,
    int? bitDepth,
    required this.avgFrameRate,
    required this.bitsPerRawSample,
    required this.displayAspectRatio,
    required this.sampleAspectRatio,
    required this.profile,
    required this.width,
    required this.height,
    required this.frameRate,
    required this.pixelFormat,
    required this.rotation,
    required this.averageFrameRate,
  }) : super(
          index: index,
          codecName: codecName,
          codecLongName: codecLongName,
          codecTagString: codecTagString,
          codecTag: codecTag,
          bitRate: bitRate,
          startTime: startTime,
          duration: duration,
          language: language,
          disposition: disposition,
          tags: tags,
          bitDepth: bitDepth,
        );

        factory VideoStream.fromJson(Map<String, dynamic> json) {
    return VideoStream(
      index: json['index'] as int,
      codecName: json['codecName'] as String,
      codecLongName: json['codecLongName'] as String,
      codecTagString: json['codecTagString'] as String,
      codecTag: json['codecTag'] as String,
      bitRate: json['bitRate'] as int,
      startTime: (json['startTime'] as String).tryParseDuration() ?? const Duration(),
      duration: (json['duration'] as String).tryParseDuration() ?? const Duration(),
      language: json['language'] as String?,
      disposition: (json['disposition'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, value as bool)),
      tags: (json['tags'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, value as String)),
      bitDepth: json['bitDepth'] as int?,
      avgFrameRate: (json['avgFrameRate'] is String && json['avgFrameRate'].toLowerCase() == "nan") ? double.nan : (json['avgFrameRate'] as num).toDouble(),
      bitsPerRawSample: json['bitsPerRawSample'] as int,
      displayAspectRatio: (
        (json['displayAspectRatio']['Width'] as int?) ?? 0,
        (json['displayAspectRatio']['Height'] as int?)?? 0
      ),
      sampleAspectRatio: (
        (json['sampleAspectRatio']['Width'] as int?) ?? 0,
        (json['sampleAspectRatio']['Height'] as int?) ?? 0
      ),
      profile: json['profile'] as String?,
      width: json['width'] as int,
      height: json['height'] as int,
      frameRate: (json['frameRate'] is String && json['frameRate'].toLowerCase() == "nan") ? double.nan : (json['frameRate'] as num).toDouble(),
      pixelFormat: json['pixelFormat'] as String?,
      rotation: json['rotation'] as int,
      averageFrameRate: (json['averageFrameRate'] is String && json['averageFrameRate'].toLowerCase() == "nan") ? double.nan : (json['averageFrameRate'] as num).toDouble(),
    );
  }
}
