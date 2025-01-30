import 'dart:io';

import 'package:alphabet_scrollbar/alphabet_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_media_server_app/apis/favorites_api.dart';
import 'package:open_media_server_app/apis/inventory_api.dart';
import 'package:open_media_server_app/apis/metadata_api.dart';
import 'package:open_media_server_app/apis/progress_api.dart';
import 'package:open_media_server_app/globals/globals.dart';
import 'package:open_media_server_app/globals/platform_globals.dart';
import 'package:open_media_server_app/helpers/preferences.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/models/inventory/inventory_item.dart';
import 'package:open_media_server_app/models/metadata/metadata_model.dart';
import 'package:open_media_server_app/widgets/grid_item.dart';
import 'package:open_media_server_app/views/detail_views/movie_detail.dart';
import 'package:open_media_server_app/views/detail_views/show_detail.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  var searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _descending = false;
  bool displayMovies = true;
  bool displayShows = true;
  GlobalKey fstItemGlobalKey = GlobalKey();
  double? gridItemHeight;
  ValueNotifier<bool> filterChanged = ValueNotifier<bool>(false);

  void _getItemSize() {
    if (fstItemGlobalKey.currentContext != null) {
      final RenderBox renderbox =
          fstItemGlobalKey.currentContext?.findRenderObject() as RenderBox;
      gridItemHeight ??= renderbox.size.height;
    }
  }

  @override
  Widget build(BuildContext context) {
    var futureItems = getInventoryItems();

    double screenWidth = MediaQuery.of(context).size.width;
    double desiredItemWidth = 150;
    if (screenWidth > 1000) {
      desiredItemWidth = 300;
    }
    int crossAxisCount = (screenWidth / desiredItemWidth).floor();
    double gridItemAspectRatio = 0.6;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Image(
                image: AssetImage('assets/AppImage/myapp.png'),
                height: 60,
              ),
            ),
            Text(Globals.Title),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          PlatformGlobals.isKiosk
              ? IconButton(
                  onPressed: () => exit(0), icon: const Icon(Icons.close))
              : const Text(''),
          IconButton(
              onPressed: () => setState(() {
                    _descending = !_descending;
                  }),
              icon: const Icon(Icons.sort_by_alpha)),
          IconButton(
              onPressed: () => {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          insetPadding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.topRight,
                          child: SizedBox(
                            height: 50,
                            width: 20,
                            child: ValueListenableBuilder(
                                valueListenable: filterChanged,
                                builder: (context, _, __) {
                                  filterChanged.value = false;
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Checkbox(
                                              value: displayMovies,
                                              onChanged: (value) =>
                                                  setState(() {
                                                    displayMovies =
                                                        !displayMovies;
                                                    filterChanged.value = true;
                                                  })),
                                          const Text("Movies")
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Checkbox(
                                              value: displayShows,
                                              onChanged: (value) =>
                                                  setState(() {
                                                    displayShows =
                                                        !displayShows;
                                                    filterChanged.value = true;
                                                  })),
                                          const Text("Shows")
                                        ],
                                      )
                                    ],
                                  );
                                }),
                          ),
                        );
                      },
                    )
                  },
              icon: const Icon(Icons.filter_alt))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              PreferredSize(
                  preferredSize: const Size(0, 20),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 8.0, left: 8.0, bottom: 15),
                    child: TextField(
                      controller: searchController,
                      expands: false,
                      decoration:
                          const InputDecoration(icon: Icon(Icons.search)),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  )),
              FutureBuilder<List<InventoryItem>>(
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
                    List<InventoryItem> filteredItems = items
                        .where((item) =>
                            (searchController.text == '' ||
                                (item.title?.toLowerCase().contains(
                                        searchController.text.toLowerCase()) ??
                                    false)) &&
                            ((item.category == "Movie" && displayMovies) ||
                                (item.category == "Show" && displayShows)))
                        .toList();

                    if (_descending) {
                      filteredItems.sort((a, b) =>
                          b.title
                              ?.toLowerCase()
                              .compareTo(a.title?.toLowerCase() ?? '') ??
                          0);
                    }

                    return Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: GridView.builder(
                              controller: _scrollController,
                              itemCount: filteredItems.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                                childAspectRatio:
                                    gridItemAspectRatio, // Adjust for desired aspect ratio
                              ),
                              itemBuilder: (context, index) {
                                return FutureBuilder<GridItemModel>(
                                  future:
                                      filteredItems[index].category == "Movie"
                                          ? getMovie(filteredItems[index])
                                          : getShow(filteredItems[index]),
                                  builder: (context, snapshot) {
                                    GridItemModel gridItem;

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      gridItem = GridItemModel(
                                        inventoryItem: filteredItems[index],
                                        metadataModel: null,
                                        isFavorite: null,
                                        progress: null,
                                      );

                                      gridItem.fake = true;
                                      gridItem.posterUrl =
                                          "${Preferences.prefs?.getString("BaseUrl")}/images/${filteredItems[index].category}/${filteredItems[index].metadataId}/poster";
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (!snapshot.hasData) {
                                      return const Center(
                                          child: Text(
                                              'Grid item could not be loaded'));
                                    } else {
                                      gridItem = snapshot.data!;
                                    }

                                    Key? inkwellKey;
                                    if ((fstItemGlobalKey.currentContext ==
                                        null)) {
                                      inkwellKey = fstItemGlobalKey;
                                    } else if (gridItemHeight == null) {
                                      _getItemSize();
                                    }

                                    return InkWell(
                                      key: inkwellKey,
                                      child: GridItem(
                                        item: gridItem,
                                        desiredItemWidth: desiredItemWidth,
                                      ),
                                      onTap: () {
                                        if (!gridItem.fake) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                              if (filteredItems[index]
                                                      .category ==
                                                  "Movie") {
                                                return MovieDetailView(
                                                  itemModel: gridItem,
                                                );
                                              }
                                              if (filteredItems[index]
                                                      .category ==
                                                  "Show") {
                                                return ShowDetailView(
                                                  itemModel: gridItem,
                                                );
                                              }

                                              throw ArgumentError(
                                                  "Server models not correct");
                                            }),
                                          );
                                        }
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            child: AlphabetScrollbar(
                              letterCollection: filteredItems
                                  .map((item) =>
                                      item.title
                                          ?.toUpperCase()
                                          .characters
                                          .first ??
                                      "")
                                  .where((c) => c != "")
                                  .toSet()
                                  .toList(),
                              onLetterChange: (letter) {
                                // await
                                HapticFeedback.mediumImpact();
                                _scrollController.animateTo(
                                  ((gridItemHeight ??
                                              (desiredItemWidth /
                                                  gridItemAspectRatio)) +
                                          8) *
                                      (filteredItems.indexWhere((item) =>
                                              item.title
                                                  ?.toUpperCase()
                                                  .startsWith(letter) ??
                                              false) ~/
                                          crossAxisCount),
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.fastOutSlowIn,
                                );
                              },
                              factor: 15,
                              selectedLetterAdditionalSpace: 10,
                              reverse: _descending,
                            ),
                          )
                        ],
                      ),
                    );
                  })
            ],
          )),
    );
  }

  Future<List<InventoryItem>> getInventoryItems() async {
    InventoryApi inventoryApi = InventoryApi();

    var items = await inventoryApi.listItems("Movie");
    var shows = await inventoryApi.listItems("Show");

    items.addAll(shows);
    items.sort((a, b) => a.title?.compareTo(b.title ?? '') ?? 0);
    return items;
  }

  Future<GridItemModel> getMovie(InventoryItem element) async {
    InventoryApi inventoryApi = InventoryApi();
    MetadataApi metadataApi = MetadataApi();
    FavoritesApi favoritesApi = FavoritesApi();
    ProgressApi progressApi = ProgressApi();

    var movie = await inventoryApi.getMovie(element.id);

    MetadataModel? metadata;

    if (movie.metadataId != null) {
      metadata = await metadataApi.getMetadata(movie.metadataId!, "Movie");
    }

    var fav = await favoritesApi.isFavorited("Movie", movie.id);

    var progress = await progressApi.getProgress("Movie", movie.id);

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

  Future<GridItemModel> getShow(InventoryItem element) async {
    InventoryApi inventoryApi = InventoryApi();
    MetadataApi metadataApi = MetadataApi();
    FavoritesApi favoritesApi = FavoritesApi();
    ProgressApi progressApi = ProgressApi();

    var show = await inventoryApi.getShow(element.id);

    MetadataModel? metadata;

    if (show.metadataId != null) {
      metadata = await metadataApi.getMetadata(show.metadataId!, "Show");
    }

    var fav = await favoritesApi.isFavorited("Show", show.id);

    var progress = await progressApi.getProgress("Show", show.id);

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
