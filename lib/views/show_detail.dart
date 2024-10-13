import 'package:flutter/material.dart';
import 'package:open_media_server_app/apis/inventory_api.dart';
import 'package:open_media_server_app/globals.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/views/season_detail.dart';

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
          items.sort((a, b) => a.listPosition!.compareTo(b.listPosition!));

          List<Widget> seasonButtons = [];

          for (var element in items) {
            seasonButtons.add(
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SeasonDetailView(itemModel: element),
                      ),
                    );
                  },
                  icon: const Icon(Icons.tv),
                  label: Text("${element.inventoryItem?.title}"),
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
                  // Poster Image
                  Center(
                    child: Image.network(
                      itemModel.posterUrl ?? Globals.PictureNotFoundUrl,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title of the Show
                  Text(
                    itemModel.inventoryItem?.title ?? "Title unknown",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Show Description / Plot
                  Text(
                    itemModel.metadataModel?.show?.plot ?? "",
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: seasonButtons,
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

    List<GridItemModel> gridItems = [];

    if (itemModel.childIds == null) {
      return [];
    }

    for (var element in itemModel.childIds!) {
      var season = await inventoryApi.getSeason(element);

      var gridItem = GridItemModel(inventoryItem: season, metadataModel: null);
      gridItem.childIds = season.episodeIds;
      gridItem.listPosition = season.seasonNr;

      gridItems.add(gridItem);
    }

    return gridItems;
  }
}