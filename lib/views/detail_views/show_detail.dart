import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:open_media_server_app/apis/base_api.dart';
import 'package:open_media_server_app/apis/favorites_api.dart';
import 'package:open_media_server_app/apis/inventory_api.dart';
import 'package:open_media_server_app/apis/metadata_api.dart';
import 'package:open_media_server_app/globals/globals.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/models/metadata/metadata_model.dart';
import 'package:open_media_server_app/views/detail_views/season_detail.dart';
import 'package:open_media_server_app/widgets/custom_image.dart';
import 'package:open_media_server_app/widgets/favorite_button.dart';
import 'package:open_media_server_app/widgets/title.dart';

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

          List<Widget> seasons = [];

          for (var element in items) {
            String imageUrl = Globals.PictureNotFoundUrl;

            if (element.posterUrl != null) {
              imageUrl = "${element.posterUrl!}?height=300";
            }

            seasons.add(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    splashColor: Colors.black26,
                    child: Column(
                      children: [
                        Ink.image(
                          height: 300,
                          width: 300 * (9 / 14),
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            imageUrl,
                            errorListener: (p0) {
                              print("fuck");
                            },
                            headers: BaseApi.getHeaders(),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          "${element.inventoryItem?.title}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SeasonDetailView(itemModel: element),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
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
                      const SizedBox(height: 16),

                      TitleElement(text: itemModel.inventoryItem?.title),
                      const SizedBox(height: 8),

                      // Show Description / Plot
                      Text(
                        itemModel.metadataModel?.show?.plot ?? "",
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: seasons,
                          ),
                        ),
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
      var season = await inventoryApi.getSeason(element);

      MetadataModel? metadata;

      if (season.metadataId != null) {
        metadata = await metadataApi.getMetadata(season.metadataId!, "Season");
      }

      FavoritesApi favoritesApi = FavoritesApi();
      var fav = await favoritesApi.isFavorited("Season", season.id);

      var gridItem = GridItemModel(
        inventoryItem: season,
        metadataModel: metadata,
        isFavorite: fav,
      );
      gridItem.childIds = season.episodeIds;
      gridItem.listPosition = season.seasonNr ?? 0;
      gridItem.posterUrl = metadata?.season?.poster;
      gridItem.backdropUrl = itemModel.backdropUrl;

      gridItems.add(gridItem);
    }

    return gridItems;
  }
}
