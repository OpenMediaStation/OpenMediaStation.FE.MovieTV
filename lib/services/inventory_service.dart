import 'package:open_media_server_app/apis/favorites_api.dart';
import 'package:open_media_server_app/apis/inventory_api.dart';
import 'package:open_media_server_app/apis/metadata_api.dart';
import 'package:open_media_server_app/apis/progress_api.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/models/inventory/inventory_item.dart';
import 'package:open_media_server_app/models/metadata/metadata_model.dart';
import 'package:open_media_server_app/models/progress/progress.dart';

class InventoryService {
  static Future<List<InventoryItem>> getInventoryItems() async {
    InventoryApi inventoryApi = InventoryApi();

    var items = await inventoryApi.listItems("Movie");
    var shows = await inventoryApi.listItems("Show");

    items.addAll(shows);
    items.sort((a, b) => a.title?.compareTo(b.title ?? '') ?? 0);
    return items;
  }

  static Future<GridItemModel> getMovie(InventoryItem element) async {
    InventoryApi inventoryApi = InventoryApi();
    MetadataApi metadataApi = MetadataApi();
    FavoritesApi favoritesApi = FavoritesApi();
    ProgressApi progressApi = ProgressApi();

    var movie = await inventoryApi.getMovie(element.id);

    Future<MetadataModel?> metadataFuture = movie.metadataId != null
        ? metadataApi.getMetadata(movie.metadataId!, "Movie")
        : Future.value(null);

    Future<bool?> favFuture = favoritesApi.isFavorited("Movie", movie.id);
    Future<Progress?> progressFuture =
        progressApi.getProgress("Movie", movie.id);

    var results = await Future.wait([metadataFuture, favFuture, progressFuture]);

    var metadata = results[0] as MetadataModel?;
    var fav = results[1] as bool?;
    var progress = results[2] as Progress?;

    var gridItem = GridItemModel(
      inventoryItem: movie,
      metadataModel: metadata,
      isFavorite: fav,
      progress: progress,
    );

    gridItem.posterUrl = metadata?.movie?.poster;
    gridItem.backdropUrl = metadata?.movie?.backdrop;
    return gridItem;
  }

  static Future<GridItemModel> getShow(InventoryItem element) async {
    InventoryApi inventoryApi = InventoryApi();
    MetadataApi metadataApi = MetadataApi();
    FavoritesApi favoritesApi = FavoritesApi();
    ProgressApi progressApi = ProgressApi();

    var show = await inventoryApi.getShow(element.id);

    Future<MetadataModel?> metadataFuture = show.metadataId != null
        ? metadataApi.getMetadata(show.metadataId!, "Show")
        : Future.value(null);
    Future<bool?> favFuture = favoritesApi.isFavorited("Show", show.id);
    Future<Progress?> progressFuture = progressApi.getProgress("Show", show.id);

    var results =
        await Future.wait([metadataFuture, favFuture, progressFuture]);

    var metadata = results[0] as MetadataModel?;
    var fav = results[1] as bool?;
    var progress = results[2] as Progress?;

    var gridItem = GridItemModel(
      inventoryItem: show,
      metadataModel: metadata,
      isFavorite: fav,
      progress: progress,
    );

    gridItem.posterUrl = metadata?.show?.poster;
    gridItem.backdropUrl = metadata?.show?.backdrop;
    gridItem.childIds = show.seasonIds;
    return gridItem;
  }
}
