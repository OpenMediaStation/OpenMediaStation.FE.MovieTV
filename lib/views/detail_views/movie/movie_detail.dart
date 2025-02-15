import 'package:flutter/material.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/services/inventory_service.dart';
import 'package:open_media_server_app/views/detail_views/movie/movie_detail_content.dart';
import 'package:open_media_server_app/widgets/favorite_button.dart';

class MovieDetailView extends StatelessWidget {
  const MovieDetailView({
    super.key,
    required this.itemModel,
  });

  final GridItemModel itemModel;

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (!itemModel.fake) {
      body = MovieDetailContent(itemModel: itemModel);
    } else {
      body = FutureBuilder<GridItemModel>(
        future: itemModel.inventoryItem?.category == "Movie"
            ? InventoryService.getMovie(itemModel.inventoryItem!)
            : InventoryService.getShow(itemModel.inventoryItem!),
        builder: (context, snapshot) {
          GridItemModel gridItem;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Grid item could not be loaded'));
          } else {
            gridItem = snapshot.data!;
          }

          return MovieDetailContent(itemModel: gridItem);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        actions: [
          FavoriteButton(itemModel: itemModel),
        ],
      ),
      body: body,
    );
  }
}
