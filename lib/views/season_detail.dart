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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
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
          items.sort((a, b) => a.listPosition!.compareTo(b.listPosition!));

          List<Widget> episodeButtons = [];

          for (var element in items) {
            episodeButtons.add(
              Material(
                type: MaterialType.transparency,
                child: InkWell(
                  splashColor: Colors.black26,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EpisodeDetailView(itemModel: element),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Ink.image(
                              height: 125 * (9 / 14),
                              width: 125,
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                element.posterUrl ?? Globals.PictureNotFoundUrl,
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Text(
                              element.metadataModel?.title != null
                                  ? "${element.listPosition}. ${element.metadataModel?.title}"
                                  : "No title",
                              softWrap: true,
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                          child: Text(
                            element.metadataModel?.episode?.plot ??
                                "No description",
                            softWrap: true,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return SingleChildScrollView(
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
                  child: Image.network(
                    itemModel.backdropUrl ?? Globals.PictureNotFoundUrl,
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
              ],
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
      gridItem.backdropUrl = metadata?.episode?.poster; // TODO backend change use backdrop instead of poster here
      gridItem.posterUrl = metadata?.episode?.poster;

      gridItem.listPosition = episode.episodeNr;

      gridItems.add(gridItem);
    }

    return gridItems;
  }
}
