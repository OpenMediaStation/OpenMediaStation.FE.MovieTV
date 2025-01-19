import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:open_media_server_app/apis/favorites_api.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    super.key,
    required this.itemModel,
  });

  final GridItemModel itemModel;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    FavoritesApi favoritesApi = FavoritesApi();

    return IconButton(
      onPressed: () async {
        if (widget.itemModel.inventoryItem == null) {
          return;
        }

        bool success = false;

        if (widget.itemModel.isFavorite ?? false) {
          success = await favoritesApi.unfavorite(
            widget.itemModel.inventoryItem!.category,
            widget.itemModel.inventoryItem!.id,
          );
        } else {
          success = await favoritesApi.favorite(
            widget.itemModel.inventoryItem!.category,
            widget.itemModel.inventoryItem!.id,
          );
        }

        if (success == true) {
          setState(() {
            widget.itemModel.isFavorite =
                !(widget.itemModel.isFavorite ?? false);
          });
        }
      },
      icon: Icon(
        widget.itemModel.isFavorite ?? false
            ? AntDesign.heart_fill
            : AntDesign.heart_outline,
        color: widget.itemModel.isFavorite ?? false ? Colors.red : null,
      ),
    );
  }
}
