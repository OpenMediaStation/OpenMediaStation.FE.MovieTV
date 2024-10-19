import 'package:flutter/material.dart';
import 'package:open_media_server_app/globals.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/player.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  itemModel.posterUrl ?? Globals.PictureNotFoundUrl,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                itemModel.metadataModel?.title ?? itemModel.inventoryItem?.title ?? "Title unknown",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                itemModel.metadataModel?.episode?.plot ?? "",
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerView(
                            url:
                                "${Globals.BaseUrl}/stream/${itemModel.inventoryItem?.category}/${itemModel.inventoryItem?.id}"),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Play"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
