import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:open_media_server_app/apis/base_api.dart';
import 'package:open_media_server_app/globals/globals.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/views/detail_views/season_detail.dart';
import 'package:open_media_server_app/widgets/view_counter.dart';

class SeasonCard extends StatelessWidget {
  const SeasonCard({super.key, required this.element});

  final GridItemModel element;

  @override
  Widget build(BuildContext context) {
    String imageUrl = Globals.PictureNotFoundUrl;

    if (element.posterUrl != null) {
      imageUrl = "${element.posterUrl!}?height=300";
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          splashColor: Colors.black26,
          child: Column(
            children: [
              Stack(
                children: [
                  Ink.image(
                    height: 300,
                    width: 300 * (9 / 14),
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      imageUrl,
                      errorListener: (p0) {},
                      headers: BaseApi.getHeaders(),
                    ),
                  ),
                  if (element.isFavorite ?? false)
                    const Positioned(
                      top: 8.0,
                      right: 8.0,
                      child: Icon(
                        AntDesign.heart_fill,
                        color: Colors.red,
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      value: (element.progress?.progressPercentage ?? 0) / 100.0,
                      minHeight: 6,
                      backgroundColor: Colors.black.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 82, 26, 114),
                      ),
                      borderRadius: const BorderRadiusDirectional.horizontal(
                        start: Radius.circular(0),
                        end: Radius.circular(8),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12.0,
                    right: 6.0,
                    child: ViewCounter(
                      completions: element.progress?.completions ?? 0,
                    ),
                  ),
                ],
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
                builder: (context) => SeasonDetailView(itemModel: element),
              ),
            );
          },
        ),
      ),
    );
  }
}
