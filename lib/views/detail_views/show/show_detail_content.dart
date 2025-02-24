import 'package:flutter/material.dart';
import 'package:open_media_server_app/globals/globals.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/widgets/custom_image.dart';
import 'package:open_media_server_app/widgets/season_card.dart';
import 'package:open_media_server_app/widgets/title.dart';

class ShowDetailContent extends StatelessWidget {
  const ShowDetailContent({
    super.key,
    required this.showModel,
    required this.children,
  });

  final GridItemModel showModel;
  final List<GridItemModel> children;

  @override
  Widget build(BuildContext context) {
    List<Widget> seasons = [];

    children.sort((a, b) => a.listPosition.compareTo(b.listPosition));

    for (var element in children) {
      seasons.add(
        SeasonCard(element: element),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black, // Softer black
                  Colors.transparent,
                ],
              ).createShader(Rect.fromLTRB(220, 220, rect.width, rect.height));
            },
            blendMode: BlendMode.dstIn,
            child: CustomImage(
              imageUrl: showModel.backdropUrl ?? Globals.PictureNotFoundUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                TitleElement(text: showModel.inventoryItem?.title),
                const SizedBox(height: 8),

                // Show Description / Plot
                Text(
                  showModel.metadataModel?.show?.plot ?? "",
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: seasons,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
