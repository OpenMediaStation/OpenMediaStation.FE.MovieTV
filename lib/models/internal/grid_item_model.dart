import 'package:open_media_server_app/models/inventory/inventory_item.dart';
import 'package:open_media_server_app/models/metadata/metadata_model.dart';

class GridItemModel {
  final InventoryItem? inventoryItem;
  final MetadataModel? metadataModel;
  String? posterUrl;
  String? backdropUrl;
  List<String>? childIds;
  int listPosition = 0;
  bool fake = false;
  
  GridItemModel({
    required this.inventoryItem,
    required this.metadataModel,
  });
}
