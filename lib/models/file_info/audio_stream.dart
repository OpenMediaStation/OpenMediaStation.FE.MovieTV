import 'package:open_media_server_app/helpers/duration_extension_methods.dart';
import 'package:open_media_server_app/models/file_info/media_stream.dart';

class AudioStream extends MediaStream {
  int channels;
  String channelLayout;
  int sampleRateHz;
  String? profile;

  AudioStream({
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
    required this.channels,
    required this.channelLayout,
    required this.sampleRateHz,
    required this.profile,
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

  factory AudioStream.fromJson(Map<String, dynamic> json) {
    return AudioStream(
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
      channels: json['channels'] as int,
      channelLayout: json['channelLayout'] as String,
      sampleRateHz: json['sampleRateHz'] as int,
      profile: json['profile'] as String?,
    );
  }
}
