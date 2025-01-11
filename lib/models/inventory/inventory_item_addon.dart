import 'package:open_media_server_app/models/inventory/inventory_item_addon_subtitle.dart';

class InventoryItemAddon {
  final String id;
  final String path;
  final String category;
  final InventoryItemAddonSubtitle? subtitle;

  InventoryItemAddon({
    required this.id,
    required this.path,
    required this.category,
    this.subtitle,
  });

  factory InventoryItemAddon.fromJson(Map<String, dynamic> json) {
    return InventoryItemAddon(
      id: json['id'] as String,
      path: json['path'] as String,
      category: json['category'] as String,
      subtitle: InventoryItemAddonSubtitle.fromJson(json['subtitle']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'category': category,
      'subtitle': subtitle?.toJson()
    };
  }
}
