import 'package:open_media_server_app/models/file_info/file_info.dart';
import 'package:open_media_server_app/models/inventory/inventory_item.dart';
import 'package:open_media_server_app/models/metadata/metadata_model.dart';
import 'package:open_media_server_app/models/progress/progress.dart';

class GridItemModel {
  final InventoryItem? inventoryItem;
  final MetadataModel? metadataModel;
  Progress? progress;
  FileInfo? fileInfo;
  bool? isFavorite;
  String? posterUrl;
  String? backdropUrl;
  List<String>? childIds;
  int listPosition = 0;
  bool fake = false;
  
  GridItemModel({
    required this.inventoryItem,
    required this.metadataModel,
    required this.isFavorite,
    required this.progress,
    this.fileInfo,
  });
}
