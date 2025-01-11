import 'package:open_media_server_app/models/inventory/inventory_item_addon.dart';
import 'package:open_media_server_app/models/inventory/inventory_item_version.dart';

class InventoryItem {
  final String id;
  final String? title;
  final String category;
  final String? metadataId;
  final String? folderPath;
  final List<InventoryItemVersion>? versions;
  final List<InventoryItemAddon>? addons;

  InventoryItem({
    required this.id,
    required this.title,
    required this.category,
    required this.metadataId,
    required this.folderPath,
    required this.versions,
    required this.addons,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] as String,
      title: json['title'] as String?,
      category: json['category'] as String,
      metadataId: json['metadataId'] as String?,
      folderPath: json['folderPath'] as String?,
      versions: (json['versions'] as List<dynamic>?)
          ?.map((version) =>
              InventoryItemVersion.fromJson(version as Map<String, dynamic>))
          .toList(),
      addons: (json['addons'] as List<dynamic>?)
          ?.map((addon) =>
              InventoryItemAddon.fromJson(addon as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'metadataId': metadataId,
      'folderPath': folderPath,
      'versions': versions,
      'addons': addons,
    };
  }
}
