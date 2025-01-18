import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:open_media_server_app/apis/base_api.dart';
import 'package:open_media_server_app/apis/inventory_api.dart';
import 'package:open_media_server_app/apis/metadata_api.dart';
import 'package:open_media_server_app/globals/globals.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/models/metadata/metadata_model.dart';
import 'package:open_media_server_app/views/detail_views/episode_detail.dart';
import 'package:open_media_server_app/widgets/custom_image.dart';
import 'package:open_media_server_app/widgets/title.dart';

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

          return ListView.builder(
            itemCount: items.length + 1, // +1 for the season info header
            itemBuilder: (context, index) {
              if (index == 0) {
                // First item is the header (season title and description)
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        imageUrl:
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
                          TitleElement(text: itemModel.inventoryItem?.title),
                          Text(
                            itemModel.metadataModel?.season?.overview ??
                                "No description",
                            maxLines: 3,
                            softWrap: true,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                // Episode list items
                var element = items[index - 1]; // Adjust index for episode

                String imageUrl = Globals.PictureNotFoundUrl;

                if (element.backdropUrl != null) {
                  imageUrl = "${element.backdropUrl}?width=300";
                }

                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: Material(
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
                                  image: CachedNetworkImageProvider(
                                    imageUrl,
                                    headers: BaseApi.getHeaders(),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        element.metadataModel?.title != null
                                            ? "${element.listPosition}. ${element.metadataModel?.title}"
                                            : "${element.listPosition}. No title",
                                        softWrap: true,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        element.metadataModel?.episode?.plot ??
                                            "No description",
                                        softWrap: true,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
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
      gridItem.backdropUrl = metadata?.episode?.backdrop;

      gridItem.listPosition = episode.episodeNr ?? 0;

      gridItems.add(gridItem);
    }

    return gridItems;
  }
}
