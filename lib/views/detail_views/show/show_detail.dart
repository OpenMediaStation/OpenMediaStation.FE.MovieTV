import 'package:flutter/material.dart';
import 'package:open_media_server_app/apis/favorites_api.dart';
import 'package:open_media_server_app/apis/inventory_api.dart';
import 'package:open_media_server_app/apis/metadata_api.dart';
import 'package:open_media_server_app/apis/progress_api.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/models/metadata/metadata_model.dart';
import 'package:open_media_server_app/models/progress/progress.dart';
import 'package:open_media_server_app/services/inventory_service.dart';
import 'package:open_media_server_app/views/detail_views/show/show_detail_content.dart';
import 'package:open_media_server_app/widgets/favorite_button.dart';

class ShowDetailView extends StatelessWidget {
  const ShowDetailView({
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
      body: FutureBuilder<(List<GridItemModel>, GridItemModel)>(
        future: getItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var (children, show) = snapshot.data!;

          return ShowDetailContent(showModel: show, children: children);
        },
      ),
    );
  }

  Future<(List<GridItemModel>, GridItemModel)> getItems() async {
    GridItemModel show;

    if (itemModel.fake) {
      show = await InventoryService.getShow(itemModel.inventoryItem!);
    } else {
      show = itemModel;
    }

    var children = await getChildren(show);

    return (children, show);
  }

  Future<List<GridItemModel>> getChildren(GridItemModel showModel) async {
    List<GridItemModel> gridItems = [];

    if (showModel.childIds == null) {
      return [];
    }

    var seasons = await InventoryApi.getSeasons(showModel.childIds ?? []);

    List<String> metadataIds = [];
    List<String> seasonIds = [];

    for (var season in seasons) {
      if (season.metadataId != null) {
        metadataIds.add(season.metadataId!);
      }
      seasonIds.add(season.id);
    }

    // Run the following API calls in parallel
    var results = await Future.wait([
      MetadataApi.getMetadatas(metadataIds, "Season"),
      FavoritesApi.isFavoritedBatch(showModel.childIds ?? [], "Season"),
      ProgressApi.getProgresses("Season", seasonIds),
    ]);

    var metadatas = results[0] as List<MetadataModel>?;
    var favorites = results[1] as Map<String, bool>?;
    var progresses = results[2] as List<Progress>?;

    for (var season in seasons) {
      var metadata =
          metadatas?.where((i) => i.id == season.metadataId).firstOrNull;

      var gridItem = GridItemModel(
        inventoryItem: season,
        metadataModel: metadata,
        isFavorite: favorites?[season.id.toString()] ?? false,
        progress: progresses?.where((i) => i.parentId == season.id).firstOrNull,
      );

      gridItem.backdropUrl = metadata?.episode?.backdrop;
      gridItem.listPosition = season.seasonNr ?? 0;
      gridItem.childIds = season.episodeIds;
      gridItem.posterUrl = metadata?.season?.poster;
      gridItem.backdropUrl = showModel.backdropUrl;

      gridItems.add(gridItem);
    }

    return gridItems;
  }
}
