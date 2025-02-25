import 'package:flutter/material.dart';
import 'package:open_media_server_app/helpers/duration_extension_methods.dart';
import 'package:open_media_server_app/models/file_info/file_info.dart';
import 'package:open_media_server_app/widgets/file_info_box.dart';

extension FileInfoBoxCreator on FileInfo {
  List<FileInfoBox> createBoxes() {
    List<FileInfoBox> boxes = [];

    var mediaData = this.mediaData;

    var duration = mediaData.duration ?? mediaData.format.duration;
    if (duration != null) {
      boxes.add(FileInfoBox(duration.toformattedString(), key: GlobalKey(),));
    }
    // if(mediaData.videoStreams.isNotEmpty){
    // for (var vStr in mediaData.videoStreams) {
    var vStr = mediaData.primaryVideoStream;
    var resolution = "${vStr.width}x${vStr.height}";
    boxes.add(FileInfoBox(vStr.width >= 3840
        ? "Ultra HD"
        : vStr.width >= 2560
            ? "WQHD"
            : vStr.width >= 1920
                ? "Full HD"
                : vStr.width >= 720
                    ? "SD"
                    : resolution, key: GlobalKey(),));
    if (vStr.codecName != null || vStr.profile != null) {
      boxes.add(FileInfoBox(vStr.codecName?.toUpperCase() ?? vStr.profile!, key: GlobalKey(),));
    }
    //   }
    // }
    // boxes.add(FileInfoBox(mediaData.primaryAudioStream.channelLayout));
    // boxes.add(FileInfoBox(mediaData.primaryAudioStream.profile));
    if (mediaData.audioStreams.isNotEmpty) {
      for (var aStr in mediaData.audioStreams) {
        boxes.add(FileInfoBox(
            "${aStr.profile ?? aStr.codecName?.toUpperCase() ?? ""} ${aStr.channelLayout}${" ${aStr.language ?? ""}"}", key: GlobalKey(),));
      }
    }

    if (mediaData.format.formatLongName != null) {
      boxes.add(FileInfoBox(mediaData.format.formatLongName!, key: GlobalKey(),));
    }
    // boxes.addAll(mediaData.format.tags?.entries.map((t) => FileInfoBox("${t.key}:${t.value}")) ?? []);

    return boxes;
  }
}
