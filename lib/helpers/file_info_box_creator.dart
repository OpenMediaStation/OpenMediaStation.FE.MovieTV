import 'package:open_media_server_app/helpers/duration_extension_methods.dart';
import 'package:open_media_server_app/models/file_info/file_info.dart';
import 'package:open_media_server_app/widgets/file_info_box.dart';

extension FileInfoBoxCreator on FileInfo{
  List<FileInfoBox> createBoxes(){
    List<FileInfoBox> boxes = [];

    var mediaData = this.mediaData;
    
    var duration = mediaData.duration ?? mediaData.format.duration;
    if(duration != null)
      {boxes.add(FileInfoBox(duration.toformattedString()));}
    boxes.add(FileInfoBox("format: ${mediaData.format.formatLongName}"));
    boxes.addAll(mediaData.format.tags?.entries.map((t) => FileInfoBox("${t.key}:${t.value}")) ?? []);

    return boxes;
  }
}