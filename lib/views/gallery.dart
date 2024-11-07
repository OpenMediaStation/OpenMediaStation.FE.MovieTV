import 'package:flutter/material.dart';
import 'package:open_media_server_app/apis/inventory_api.dart';
import 'package:open_media_server_app/apis/metadata_api.dart';
import 'package:open_media_server_app/helpers/preferences.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/models/inventory/inventory_item.dart';
import 'package:open_media_server_app/models/metadata/metadata_model.dart';
import 'package:open_media_server_app/widgets/grid_item.dart';
import 'package:open_media_server_app/views/detail_views/movie_detail.dart';
import 'package:open_media_server_app/views/detail_views/show_detail.dart';

class Gallery extends StatelessWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var futureItems = getInventoryItems();

    double screenWidth = MediaQuery.of(context).size.width;
    double desiredItemWidth = 150;
    if (screenWidth > 1000) {
      desiredItemWidth = 300;
    }
    int crossAxisCount = (screenWidth / desiredItemWidth).floor();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<InventoryItem>>(
        future: futureItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No movies found.'));
          }

          List<InventoryItem> items = snapshot.data!;

          return GridView.builder(
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.7, // Adjust for desired aspect ratio
            ),
            itemBuilder: (context, index) {
              return FutureBuilder<GridItemModel>(
                future: items[index].category == "Movie"
                    ? getMovie(items[index])
                    : getShow(items[index]),
                builder: (context, snapshot) {
                  GridItemModel gridItem;

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    gridItem = GridItemModel(
                      inventoryItem: items[index],
                      metadataModel: null,
                    );

                    gridItem.fake = true;
                    gridItem.posterUrl =
                        "${Preferences.prefs?.getString("BaseUrl")}/images/${items[index].category}/${items[index].metadataId}/poster";
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(
                        child: Text('Grid item could not be loaded'));
                  } else {
                    gridItem = snapshot.data!;
                  }

                  return InkWell(
                    child: GridItem(
                      item: gridItem,
                      desiredItemWidth: desiredItemWidth,
                    ),
                    onTap: () {
                      if (!gridItem.fake) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            if (items[index].category == "Movie") {
                              return MovieDetailView(
                                itemModel: gridItem,
                              );
                            }
                            if (items[index].category == "Show") {
                              return ShowDetailView(
                                itemModel: gridItem,
                              );
                            }

                            throw ArgumentError("Server models not correct");
                          }),
                        );
                      }
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<InventoryItem>> getInventoryItems() async {
    InventoryApi inventoryApi = InventoryApi();

    var items = await inventoryApi.listItems("Movie");
    var shows = await inventoryApi.listItems("Show");

    items.addAll(shows);

    return items;
  }

  Future<GridItemModel> getMovie(InventoryItem element) async {
    InventoryApi inventoryApi = InventoryApi();
    MetadataApi metadataApi = MetadataApi();

    var movie = await inventoryApi.getMovie(element.id);

    MetadataModel? metadata;

    if (movie.metadataId != null) {
      metadata = await metadataApi.getMetadata(movie.metadataId!, "Movie");
    }

    var gridItem = GridItemModel(inventoryItem: movie, metadataModel: metadata);

    gridItem.posterUrl = metadata?.movie?.poster;
    gridItem.backdropUrl = metadata?.movie?.backdrop;
    return gridItem;
  }

  Future<GridItemModel> getShow(InventoryItem element) async {
    InventoryApi inventoryApi = InventoryApi();
    MetadataApi metadataApi = MetadataApi();

    var show = await inventoryApi.getShow(element.id);

    MetadataModel? metadata;

    if (show.metadataId != null) {
      metadata = await metadataApi.getMetadata(show.metadataId!, "Show");
    }

    var gridItem = GridItemModel(inventoryItem: show, metadataModel: metadata);

    gridItem.posterUrl = metadata?.show?.poster;
    gridItem.backdropUrl = metadata?.show?.backdrop;
    gridItem.childIds = show.seasonIds;
    return gridItem;
  }
}
