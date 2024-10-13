import 'package:open_media_server_app/models/inventory/inventory_item.dart';
import 'package:open_media_server_app/models/metadata/metadata_model.dart';

class GridItemModel {
  final InventoryItem? inventoryItem;
  final MetadataModel? metadataModel;
  String? posterUrl;
  List<String>? childIds;

  GridItemModel({
    required this.inventoryItem,
    required this.metadataModel,
  });
}
