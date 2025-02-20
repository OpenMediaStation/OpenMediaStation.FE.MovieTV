import 'package:flutter/material.dart';
import 'package:open_media_server_app/apis/favorites_api.dart';
import 'package:open_media_server_app/apis/file_info_api.dart';
import 'package:open_media_server_app/apis/inventory_api.dart';
import 'package:open_media_server_app/apis/metadata_api.dart';
import 'package:open_media_server_app/apis/progress_api.dart';
import 'package:open_media_server_app/globals/globals.dart';
import 'package:open_media_server_app/models/file_info/file_info.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/models/metadata/metadata_model.dart';
import 'package:open_media_server_app/models/progress/progress.dart';
import 'package:open_media_server_app/widgets/custom_image.dart';
import 'package:open_media_server_app/widgets/favorite_button.dart';
import 'package:open_media_server_app/widgets/season_item.dart';
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
        actions: [
          FavoriteButton(itemModel: itemModel),
        ],
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
          items.sort((a, b) => a.listPosition.compareTo(b.listPosition));

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
                        alignment: Alignment.topCenter,
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

                return SeasonItem(itemModel: element);
              }
            },
          );
        },
      ),
    );
  }

  Future<List<GridItemModel>> getChildren() async {
    InventoryApi inventoryApi = InventoryApi();

    if (itemModel.childIds == null) {
      return [];
    }

    // Fetch episodes first
    var episodes = await inventoryApi.getEpisodes(itemModel.childIds!);

    List<String> metadataIds = [];
    List<String> episodeIds = [];
    List<String> fileInfoIds = [];

    for (var episode in episodes) {
      if (episode.metadataId != null) {
        metadataIds.add(episode.metadataId!);
      }
      if (episode.versions?.firstOrNull?.fileInfoId != null) {
        fileInfoIds.add(episode.versions!.firstOrNull!.fileInfoId!);
      }
      episodeIds.add(episode.id);
    }

    // Run the following API calls in parallel
    var results = await Future.wait([
      MetadataApi.getMetadatas(metadataIds, "Episode"),
      FavoritesApi.isFavoritedBatch(itemModel.childIds!, "Episode"),
      ProgressApi.getProgresses("Episode", episodeIds),
      FileInfoApi.getFileInfos("Episode", fileInfoIds),
    ]);

    var metadatas = results[0] as List<MetadataModel>?;
    var favorites = results[1] as Map<String, bool>?;
    var progresses = results[2] as List<Progress>?;
    var fileInfos = results[3] as List<FileInfo>?;

    List<GridItemModel> gridItems = [];
    for (var episode in episodes) {
      var metadata =
          metadatas?.where((i) => i.id == episode.metadataId).firstOrNull;

      var gridItem = GridItemModel(
        inventoryItem: episode,
        metadataModel: metadata,
        isFavorite: favorites?[episode.id.toString()] ?? false,
        progress:
            progresses?.where((i) => i.parentId == episode.id).firstOrNull,
        fileInfo: fileInfos
            ?.where((i) => i.id == episode.versions?.firstOrNull?.fileInfoId)
            .firstOrNull,
      );

      gridItem.backdropUrl = metadata?.episode?.backdrop;
      gridItem.listPosition = episode.episodeNr ?? 0;
      gridItems.add(gridItem);
    }

    return gridItems;
  }
}
