
import 'dart:ffi';

import 'package:open_media_server_app/helpers/duration_extension_methods.dart';

class MediaFormat {
  MediaFormat(
      {required this.duration,
      required this.formatName,
      required this.formatLongName,
      required this.streamCount,
      required this.probeScore,
      required this.bitRate,
      required this.tags});

  final Duration? duration;
  final String formatName;
  final String formatLongName;
  final int streamCount;
  final double probeScore;
  final double bitRate;
  final Map<String, String>? tags;

  factory MediaFormat.fromJson(Map<String, dynamic> json) {
    var probeScoreFromJson = json['probeScore'];
    var bitRateFromJson = json['bitRate'];
    return MediaFormat(
        duration: (json['duration'] as String).tryParseDuration(),
        formatName: json['formatName'],
        formatLongName: json['formatLongName'],
        streamCount: json['streamCount'],
        probeScore: probeScoreFromJson is double ? probeScoreFromJson : (probeScoreFromJson as int).toDouble(),
        bitRate: bitRateFromJson is double ? bitRateFromJson : (bitRateFromJson as int).toDouble(),
        tags: (json['tags'] as Map<String, dynamic>).map((key,value) => MapEntry(key, value.toString())));
  }
}
