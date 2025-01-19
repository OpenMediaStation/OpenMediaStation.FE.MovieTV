import 'package:flutter/material.dart';
import 'package:open_media_server_app/globals/globals.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/widgets/custom_image.dart';
import 'package:open_media_server_app/widgets/favorite_button.dart';
import 'package:open_media_server_app/widgets/play_button.dart';

class EpisodeDetailView extends StatelessWidget {
  const EpisodeDetailView({
    super.key,
    required this.itemModel,
  });

  final GridItemModel itemModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        actions: [
          FavoriteButton(itemModel: itemModel),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black, // Softer black
                    Colors.transparent,
                  ],
                ).createShader(
                    Rect.fromLTRB(220, 220, rect.width, rect.height));
              },
              blendMode: BlendMode.dstIn,
              child: CustomImage(
                imageUrl: itemModel.backdropUrl ?? Globals.PictureNotFoundUrl,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    itemModel.metadataModel?.title ??
                        itemModel.inventoryItem?.title ??
                        "Title unknown",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  PlayButton(
                    itemModel: itemModel,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    itemModel.metadataModel?.episode?.plot ?? "",
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
