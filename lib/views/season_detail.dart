import 'package:flutter/material.dart';
import 'package:open_media_server_app/apis/inventory_api.dart';
import 'package:open_media_server_app/apis/metadata_api.dart';
import 'package:open_media_server_app/globals.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/models/metadata/metadata_model.dart';
import 'package:open_media_server_app/views/episode_detail.dart';

class SeasonDetailView extends StatelessWidget {
  const SeasonDetailView({
    super.key,
    required this.itemModel,
  });

  final GridItemModel itemModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(Globals.Title),
      ),
      body: FutureBuilder<List<GridItemModel>>(
        future: getChildren(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<GridItemModel> items = snapshot.data!;

          List<Widget> episodeButtons = [];

          for (var element in items) {
            episodeButtons.add(
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EpisodeDetailView(itemModel: element),
                      ),
                    );
                  },
                  icon: const Icon(Icons.tv),
                  label: Text("${element.metadataModel?.title}"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemModel.inventoryItem?.title ?? "Title unknown",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: episodeButtons,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<GridItemModel>> getChildren() async {
    InventoryApi inventoryApi = InventoryApi();
    MetadataApi metadataApi = MetadataApi();

    List<GridItemModel> gridItems = [];

    if (itemModel.childIds == null) {
      return [];
    }

    for (var element in itemModel.childIds!) {
      var episode = await inventoryApi.getEpisode(element);

      MetadataModel? metadata;

      if (episode.metadataId != null) {
        metadata =
            await metadataApi.getMetadata(episode.metadataId!, "Episode");
      }

      var gridItem =
          GridItemModel(inventoryItem: episode, metadataModel: metadata);
      gridItem.posterUrl = metadata?.episode?.poster;

      gridItems.add(gridItem);
    }

    return gridItems;
  }
}
