import 'package:flutter/material.dart';
import 'package:open_media_server_app/globals/globals.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/widgets/custom_image.dart';

class GridItem extends StatelessWidget {
  final GridItemModel item;

  const GridItem({Key? key, required this.item, required this.desiredItemWidth}) : super(key: key);

  final double desiredItemWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CustomImage(
              imageUrl: item.posterUrl ?? Globals.PictureNotFoundUrl,
              fit: BoxFit.cover,
              width: desiredItemWidth + 150,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          item.inventoryItem?.title ?? "Unknown title",
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}