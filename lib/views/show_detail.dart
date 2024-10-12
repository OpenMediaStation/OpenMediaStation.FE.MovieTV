import 'package:flutter/material.dart';
import 'package:open_media_server_app/globals.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/views/season_detail.dart';

class ShowDetailView extends StatelessWidget {
  const ShowDetailView({
    super.key,
    required this.itemModel,
  });

  final GridItemModel itemModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(Globals.Title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster Image
              Center(
                child: Image.network(
                  itemModel.posterUrl ?? Globals.PictureNotFoundUrl,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              // Title of the Show
              Text(
                itemModel.inventoryItem?.title ?? "Title unknown",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Show Description / Plot
              Text(
                itemModel.metadataModel?.show?.plot ?? "",
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 16),

              // Button for Seasons
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to the Seasons page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SeasonDetailView(itemModel: itemModel),
                      ),
                    );
                  },
                  icon: const Icon(Icons.tv), // Icon indicating a TV series
                  label: const Text("Seasons"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
