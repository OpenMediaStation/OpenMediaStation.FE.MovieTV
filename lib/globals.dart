import 'package:flutter/material.dart';
import 'package:open_media_server_app/services/inventory_service.dart';
import 'package:open_media_server_app/views/detail_views/movie/movie_detail.dart';
import 'package:open_media_server_app/views/detail_views/show/show_detail.dart';
import 'package:open_media_server_app/views/settings.dart';
import 'package:open_media_station_base/views/gallery.dart';

class Globals {
  static String Title = "Open Media Station";
  static String PictureNotFoundUrl =
      "https://static.vecteezy.com/system/resources/previews/005/337/799/original/icon-image-not-found-free-vector.jpg";
  static Gallery gallery = Gallery(
      gridItemAspectRatio: 0.6,
      getInventoryItems: InventoryService.getInventoryItems,
      appTitle: Globals.Title,
      settings: const Settings(),
      additionalWidgets: const [],
      getGridItemModel: InventoryService.getInventoryItem,
      onGridItemTap: (context, inventoryItem, gridItem) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            if (inventoryItem.category == "Movie") {
              return MovieDetailView(
                itemModel: gridItem,
              );
            }
            if (inventoryItem.category == "Show") {
              return ShowDetailView(
                itemModel: gridItem,
              );
            }

            throw ArgumentError("Server models not correct");
          }),
        );
      },
      pictureNotFoundUrl: Globals.PictureNotFoundUrl,
      setFilter:
          (setOrUnsetFilter, context, disabledCategories, filterChanged) {
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
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: !disabledCategories.contains("Movie"),
                                onChanged: (value) {
                                  setOrUnsetFilter("Movie");
                                  filterChanged.value =
                                      !filterChanged.value; // Notify rebuild
                                },
                              ),
                              const Text("Movies"),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: !disabledCategories.contains("Show"),
                                onChanged: (value) {
                                  setOrUnsetFilter("Show");
                                  filterChanged.value =
                                      !filterChanged.value; // Notify rebuild
                                },
                              ),
                              const Text("Shows"),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ));
          },
        );
      });
}
