import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:open_media_server_app/apis/base_api.dart';
import 'package:open_media_server_app/globals/globals.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/views/detail_views/episode_detail.dart';

class SeasonItem extends StatelessWidget {
  const SeasonItem({super.key, required this.itemModel});

  final GridItemModel itemModel;

  @override
  Widget build(BuildContext context) {
    String imageUrl = Globals.PictureNotFoundUrl;

    if (itemModel.backdropUrl != null) {
      imageUrl = "${itemModel.backdropUrl}?width=300";
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          splashColor: Colors.black26,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EpisodeDetailView(itemModel: itemModel),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        Ink.image(
                          height: 125 * (9 / 14),
                          width: 125,
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            imageUrl,
                            headers: BaseApi.getHeaders(),
                          ),
                        ),
                                                Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: LinearProgressIndicator(
                            value: (itemModel.progress?.progressPercentage ?? 0) /
                                100.0,
                            minHeight: 4,
                            backgroundColor: Colors.black.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 82, 26, 114),
                            ),
                            borderRadius:
                                const BorderRadiusDirectional.horizontal(
                              start: Radius.circular(0),
                              end: Radius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            itemModel.metadataModel?.title != null
                                ? "${itemModel.listPosition}. ${itemModel.metadataModel?.title}"
                                : "${itemModel.listPosition}. No title",
                            softWrap: true,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            itemModel.metadataModel?.episode?.plot ??
                                "No description",
                            softWrap: true,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
