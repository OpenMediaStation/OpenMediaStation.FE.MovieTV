import 'package:flutter/material.dart';
import 'package:open_media_server_app/globals/globals.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/widgets/custom_image.dart';
import 'package:open_media_server_app/widgets/favorite_button.dart';
import 'package:open_media_server_app/widgets/play_button.dart';

class MovieDetailView extends StatelessWidget {
  const MovieDetailView({
    super.key,
    required this.itemModel,
  });

  final GridItemModel itemModel;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<String?> selectedVersionID = ValueNotifier<String?>(
        itemModel.inventoryItem?.versions?.firstOrNull?.id);

    bool smallScreen = (MediaQuery.of(context).size.width < 434);

    var versionDropdown = ((itemModel.inventoryItem?.versions?.length ?? 0) > 1)
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: DropdownMenu(
              inputDecorationTheme: Theme.of(context).inputDecorationTheme,
              // textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
              enableSearch: false,
              dropdownMenuEntries: itemModel.inventoryItem?.versions
                      ?.map((v) => DropdownMenuEntry(
                          value: v.id,
                          label: v.name ??
                              itemModel.inventoryItem!.versions!
                                  .indexOf(v)
                                  .toString()))
                      .toList() ??
                  List.empty(),
              initialSelection: itemModel.inventoryItem?.versions?.first.id,
              onSelected: (newVID) =>
                  selectedVersionID.value = newVID as String,
            ),
          )
        : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        actions: [
          FavoriteButton(itemModel: itemModel),
        ],
      ),
      body: SingleChildScrollView(
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
                ).createShader(
                    Rect.fromLTRB(220, 220, rect.width, rect.height));
              },
              blendMode: BlendMode.dstIn,
              child: CustomImage(
                imageUrl: itemModel.backdropUrl ?? Globals.PictureNotFoundUrl,
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          itemModel.inventoryItem?.title ?? "Title unknown",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (!smallScreen && versionDropdown != null)
                        Padding(padding: const EdgeInsets.only(left: 16),child: versionDropdown)
                    ],
                  ),
                  if(smallScreen && versionDropdown != null)
                    versionDropdown,
                  const SizedBox(
                    height: 16,
                  ),
                  ValueListenableBuilder(
                      valueListenable: selectedVersionID,
                      builder: (context, versionID, __) {
                        return PlayButton(
                            itemModel: itemModel, versionID: versionID);
                      }),
                  const SizedBox(height: 8),
                  Text(
                    itemModel.metadataModel?.movie?.plot ?? "",
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
