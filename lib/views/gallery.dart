import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_media_server_app/globals/platform_globals.dart';
import 'package:open_media_server_app/helpers/preferences.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/models/inventory/inventory_item.dart';
import 'package:open_media_server_app/services/inventory_service.dart';
import 'package:open_media_server_app/widgets/alphabet_bar.dart';
import 'package:open_media_server_app/widgets/app_bar_title.dart';
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
  bool searchBarVisible = false;
  GlobalKey fstItemGlobalKey = GlobalKey();
  double? gridItemHeight;
  ValueNotifier<bool> filterChanged = ValueNotifier<bool>(false);
  late Future<List<InventoryItem>> futureItems;

  void _getItemSize() {
    if (fstItemGlobalKey.currentContext != null) {
      final RenderBox renderbox =
          fstItemGlobalKey.currentContext?.findRenderObject() as RenderBox;
      gridItemHeight ??= renderbox.size.height;
    }
  }

  @override
  void initState() {
    futureItems = InventoryService.getInventoryItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double desiredItemWidth = 150;
    bool largeScreen = false;
    if (screenWidth > 1000) {
      desiredItemWidth = 300;
      largeScreen = true;
    }
    int crossAxisCount = (screenWidth / desiredItemWidth).floor();
    double gridItemAspectRatio = 0.6;

    var searchBar = Flexible(
      fit: FlexFit.tight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 550, minWidth: 200),
        child: Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8.0),
            child: TextField(
              controller: searchController,
              expands: false,
              decoration: const InputDecoration(
                icon: Icon(
                  Icons.search,
                  size: 15,
                  color: Colors.grey,
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            )),
      ),
    );

    List<Widget> appBarTitleSpace = [];
    if ((PlatformGlobals.isMobile || !largeScreen) && searchBarVisible) {
      appBarTitleSpace.add(searchBar);
    } else if (searchBarVisible) {
      appBarTitleSpace
          .addAll([AppBarTitle(screenWidth: screenWidth), searchBar]);
    } else {
      appBarTitleSpace.add(AppBarTitle(screenWidth: screenWidth));
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: !largeScreen,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: largeScreen
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          children: appBarTitleSpace,
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => setState(() {
                    searchBarVisible = !searchBarVisible;
                    if (!searchBarVisible) {
                      searchController.text = "";
                    }
                  }),
              icon: !searchBarVisible
                  ? const Icon(Icons.search)
                  : const Icon(Icons.search_off)),
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
              icon: const Icon(Icons.filter_alt)),
          PlatformGlobals.isKiosk
              ? IconButton(
                  onPressed: () => exit(0), icon: const Icon(Icons.close))
              : const Text(''),
          PlatformGlobals.isMobile
              ? const Text('')
              : IconButton(
                  onPressed: () => setState(() {
                        futureItems = InventoryService.getInventoryItems();
                      }),
                  icon: const Icon(Icons.refresh))
        ],
      ),
      body: Padding(
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
                List<InventoryItem> filteredItems = filterItems(items);

                return Stack(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: screenWidth - 50,
                          child: RefreshIndicator(
                            displacement: 40,
                            onRefresh: () async {
                              setState(() {
                                futureItems = InventoryService.getInventoryItems();
                              });
                            },
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
                                          ? InventoryService.getMovie(filteredItems[index])
                                          : InventoryService.getShow(filteredItems[index]),
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
                        ),
                        const Expanded(child: Text(''))
                      ],
                    ),
                    if (filteredItems.length ~/ crossAxisCount > 5)
                      AlphabetBar(
                        scrollController: _scrollController,
                        filteredItems: filteredItems,
                        descending: _descending,
                        gridItemHeight: gridItemHeight,
                        desiredItemWidth: desiredItemWidth,
                        gridItemAspectRatio: gridItemAspectRatio,
                        crossAxisCount: crossAxisCount,
                      ),
                  ],
                );
              })),
    );
  }

  List<InventoryItem> filterItems(List<InventoryItem> items) {
    var filteredList = items
        .where((item) =>
            (searchController.text == "" ||
                (item.title
                        ?.toLowerCase()
                        .contains(searchController.text.toLowerCase()) ??
                    false)) &&
            ((item.category == "Movie" && displayMovies) ||
                (item.category == "Show" && displayShows)))
        .toList();

    filteredList.sort((a, b) =>
        a.title?.toLowerCase().compareTo(b.title?.toLowerCase() ?? '') ?? 0);

    if (_descending) {
      filteredList.sort((a, b) =>
          b.title?.toLowerCase().compareTo(a.title?.toLowerCase() ?? '') ?? 0);
    }
    return filteredList;
  }
}
