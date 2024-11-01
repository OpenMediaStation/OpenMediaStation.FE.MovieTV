import 'package:flutter/material.dart';
import 'package:open_media_server_app/globals/globals.dart';
import 'package:open_media_server_app/globals/preference_globals.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/views/player.dart';
import 'package:open_media_server_app/widgets/custom_image.dart';

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
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayerView(
                                  url:
                                      "${PreferenceGlobals.BaseUrl}/stream/${itemModel.inventoryItem?.category}/${itemModel.inventoryItem?.id}"),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text("Play"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ),
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
