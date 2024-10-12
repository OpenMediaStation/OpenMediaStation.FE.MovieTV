import 'package:flutter/material.dart';
import 'package:open_media_server_app/apis/inventory_api.dart';
import 'package:open_media_server_app/apis/metadata_api.dart';
import 'package:open_media_server_app/globals.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/models/metadata/metadata_model.dart';
import 'package:open_media_server_app/movie_item.dart';
import 'package:open_media_server_app/player.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late Future<List<GridItemModel>> futureItems;

  @override
  void initState() {
    super.initState();
    futureItems = getGridItems();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<GridItemModel>>(
        future: futureItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No movies found.'));
          }

          List<GridItemModel> items = snapshot.data!;

          return GridView.builder(
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
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
                    MaterialPageRoute(
                      builder: (context) => PlayerView(
                          url:
                              "${Globals.BaseUrl}/stream/${items[index].inventoryItem?.category}/${items[index].inventoryItem?.id}"),
                    ),
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

    var items = await inventoryApi.listItems("Movie");

    List<GridItemModel> gridItems = [];

    for (var element in items) {
      var movie = await inventoryApi.getMovie(element.id);

      MetadataModel? metadata;

      if (movie.metadataId != null) {
        metadata = await metadataApi.getMetadata(movie.metadataId!, "Movie");
      }

      var gridItem =
          GridItemModel(inventoryItem: movie, metadataModel: metadata);

      gridItems.add(gridItem);
    }

    return gridItems;
  }
}
