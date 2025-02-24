import 'package:open_media_server_app/models/file_info/audio_stream.dart';
import 'package:open_media_server_app/models/file_info/media_format.dart';
import 'package:open_media_server_app/helpers/duration_extension_methods.dart';
import 'package:open_media_server_app/models/file_info/media_stream.dart';
import 'package:open_media_server_app/models/file_info/video_stream.dart';

class MediaData {
  MediaData(
      {required this.primaryVideoStream,
      required this.videoStreams,
      required this.primaryAudioStream,
      required this.audioStreams,
      required this.subtitleStreams,
      required this.duration,
      required this.format});

  final Duration? duration;
  final MediaFormat format;
  final VideoStream primaryVideoStream;
  final List<VideoStream> videoStreams;
  final AudioStream primaryAudioStream;
  final List<AudioStream> audioStreams;
  final List<MediaStream> subtitleStreams;

  factory MediaData.fromJson(Map<String, dynamic> json) {
    return MediaData(
        duration: (json['duration'] as String).tryParseDuration(),
        format: MediaFormat.fromJson(json['format']),
        primaryVideoStream: VideoStream.fromJson(json['primaryVideoStream']),
        videoStreams: (json['videoStreams'] as Iterable).map((vStr) => VideoStream.fromJson(vStr)).toList(),
        primaryAudioStream: AudioStream.fromJson(json['primaryAudioStream']),
        audioStreams: (json['audioStreams'] as Iterable).map((aStr) => AudioStream.fromJson(aStr)).toList(),
        subtitleStreams: (json['subtitleStreams'] as Iterable).map((subTitleStr) => MediaStream.fromJson(subTitleStr)).toList()
        );
  }
}
