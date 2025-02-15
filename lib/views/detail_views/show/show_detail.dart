import 'package:flutter/material.dart';
import 'package:open_media_server_app/apis/favorites_api.dart';
import 'package:open_media_server_app/apis/inventory_api.dart';
import 'package:open_media_server_app/apis/metadata_api.dart';
import 'package:open_media_server_app/apis/progress_api.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/models/metadata/metadata_model.dart';
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
    InventoryApi inventoryApi = InventoryApi();
    MetadataApi metadataApi = MetadataApi();
    ProgressApi progressApi = ProgressApi();

    List<GridItemModel> gridItems = [];

    if (showModel.childIds == null) {
      return [];
    }

    for (var element in showModel.childIds!) {
      var season = await inventoryApi.getSeason(element);

      MetadataModel? metadata;

      if (season.metadataId != null) {
        metadata = await metadataApi.getMetadata(season.metadataId!, "Season");
      }

      FavoritesApi favoritesApi = FavoritesApi();
      var fav = await favoritesApi.isFavorited("Season", season.id);

      var progress = await progressApi.getProgress("Season", season.id);

      var gridItem = GridItemModel(
        inventoryItem: season,
        metadataModel: metadata,
        isFavorite: fav,
        progress: progress,
      );
      gridItem.childIds = season.episodeIds;
      gridItem.listPosition = season.seasonNr ?? 0;
      gridItem.posterUrl = metadata?.season?.poster;
      gridItem.backdropUrl = showModel.backdropUrl;

      gridItems.add(gridItem);
    }

    return gridItems;
  }
}
