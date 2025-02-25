import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:open_media_server_app/globals/globals.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/widgets/custom_image.dart';
import 'package:open_media_server_app/widgets/view_counter.dart';

class GridItem extends StatelessWidget {
  final GridItemModel item;
  final double desiredItemWidth;

  const GridItem({
    Key? key,
    required this.item,
    required this.desiredItemWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Stack(
                      children: [
                        CustomImage(
                          imageUrl: item.posterUrl,
                          fit: BoxFit.cover,
                          width: desiredItemWidth + 150,
                          height: double.infinity,
                          fake: item.fake,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: LinearProgressIndicator(
                            value: (item.progress?.progressPercentage ?? 0) /
                                100.0,
                            minHeight: 6,
                            backgroundColor: Colors.black.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 82, 26, 114),
                            ),
                            borderRadius:
                                const BorderRadiusDirectional.horizontal(
                              start: Radius.circular(0),
                              end: Radius.circular(8),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12.0,
                          right: 6.0,
                          child: ViewCounter(
                            completions: item.progress?.completions ?? 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              item.inventoryItem?.title ?? "Unknown title",
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        if (item.isFavorite ?? false)
          const Positioned(
            top: 8.0,
            right: 8.0,
            child: Icon(
              AntDesign.heart_fill,
              color: Colors.red,
            ),
          ),
      ],
    );
  }
}
