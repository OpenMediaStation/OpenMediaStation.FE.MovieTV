import 'package:flutter/material.dart';
import 'package:open_media_server_app/apis/inventory_api.dart';
import 'package:open_media_server_app/apis/metadata_api.dart';
import 'package:open_media_server_app/globals/globals.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/models/metadata/metadata_model.dart';
import 'package:open_media_server_app/widgets/gallery_item.dart';
import 'package:open_media_server_app/views/detail_views/movie_detail.dart';
import 'package:open_media_server_app/views/player.dart';
import 'package:open_media_server_app/views/detail_views/show_detail.dart';

class Gallery extends StatelessWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var futureItems = getGridItems();

    double screenWidth = MediaQuery.of(context).size.width;
    double desiredItemWidth = 150;
    if (screenWidth > 1000) {
      desiredItemWidth = 300;
    }
    int crossAxisCount = (screenWidth / desiredItemWidth).floor();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<GridItemModel>>(
        future: futureItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No movies found.'));
          }

          List<GridItemModel> items = snapshot.data!;

          return GridView.builder(
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.7, // Adjust for desired aspect ratio
            ),
            itemBuilder: (context, index) {
              return InkWell(
                child: GridItem(item: items[index]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      if (items[index].inventoryItem!.category == "Movie") {
                        return MovieDetailView(
                          itemModel: items[index],
                        );
                      }
                      if (items[index].inventoryItem!.category == "Show") {
                        return ShowDetailView(
                          itemModel: items[index],
                        );
                      }

                      throw ArgumentError("Server models not correct");
                    }),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<GridItemModel>> getGridItems() async {
    InventoryApi inventoryApi = InventoryApi();
    MetadataApi metadataApi = MetadataApi();

    var movies = await inventoryApi.listItems("Movie");
    var shows = await inventoryApi.listItems("Show");

    List<GridItemModel> gridItems = [];

    for (var element in movies) {
      var movie = await inventoryApi.getMovie(element.id);

      MetadataModel? metadata;

      if (movie.metadataId != null) {
        metadata = await metadataApi.getMetadata(movie.metadataId!, "Movie");
      }

      var gridItem =
          GridItemModel(inventoryItem: movie, metadataModel: metadata);

      gridItem.posterUrl = metadata?.movie?.poster;
      gridItem.backdropUrl = metadata?.movie?.backdrop;

      gridItems.add(gridItem);
    }

    for (var element in shows) {
      var show = await inventoryApi.getShow(element.id);

      MetadataModel? metadata;

      if (show.metadataId != null) {
        metadata = await metadataApi.getMetadata(show.metadataId!, "Show");
      }

      var gridItem =
          GridItemModel(inventoryItem: show, metadataModel: metadata);

      gridItem.posterUrl = metadata?.show?.poster;
      gridItem.backdropUrl = metadata?.show?.backdrop;
      gridItem.childIds = show.seasonIds;

      gridItems.add(gridItem);
    }

    return gridItems;
  }
}
