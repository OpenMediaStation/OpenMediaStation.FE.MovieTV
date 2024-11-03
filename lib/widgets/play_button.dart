import 'package:flutter/material.dart';
import 'package:open_media_server_app/apis/base_api.dart';
import 'package:open_media_server_app/helpers/preferences.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/views/player.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({super.key, required this.itemModel});

  final GridItemModel itemModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: ElevatedButton.icon(
          onPressed: () async {
            await BaseApi.getRefreshedHeaders();

            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlayerView(
                    url:
                        "${Preferences.prefs?.getString("BaseUrl")}/stream/${itemModel.inventoryItem?.category}/${itemModel.inventoryItem?.id}"),
              ),
            );
          },
          icon: const Icon(Icons.play_arrow),
          label: const Text("Play"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
      ),
    );
  }
}
