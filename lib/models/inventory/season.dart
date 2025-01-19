import 'package:open_media_server_app/models/inventory/inventory_item.dart';
import 'package:open_media_server_app/models/inventory/inventory_item_addon.dart';
import 'package:open_media_server_app/models/inventory/inventory_item_version.dart';

class Season extends InventoryItem {
  final List<String>? episodeIds;
  final int? seasonNr;

  Season({
    required super.id,
    required super.title,
    required super.category,
    required super.metadataId,
    required super.folderPath,
    required super.versions,
    required super.addons,
    required this.episodeIds,
    required this.seasonNr,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['id'] as String,
      title: json['title'] as String?,
      category: json['category'] as String,
      metadataId: json['metadataId'] as String?,
      folderPath: json['folderPath'] as String?,
      seasonNr: json['seasonNr'] as int?,
      versions: (json['versions'] as List<dynamic>?)
          ?.map((version) =>
              InventoryItemVersion.fromJson(version as Map<String, dynamic>))
          .toList(),
      episodeIds: (json['episodeIds'] as List<dynamic>?)
          ?.map((version) => version.toString())
          .toList(),
      addons: (json['addons'] as List<dynamic>?)
          ?.map((addon) =>
              InventoryItemAddon.fromJson(addon as Map<String, dynamic>))
          .toList(),
    );
  }

}
