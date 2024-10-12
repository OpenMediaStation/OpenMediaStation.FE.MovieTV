import 'package:flutter/material.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';

class SeasonDetailView extends StatelessWidget {
  final GridItemModel itemModel;

  const SeasonDetailView({Key? key, required this.itemModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Placeholder for the actual implementation of the seasons view.
    // This can be modified to display a list of seasons for the show.
    return Scaffold(
      appBar: AppBar(
        title: Text('${itemModel.inventoryItem?.title ?? 'Seasons'}'),
      ),
      body: Center(
        child: Text('Seasons will be displayed here.'),
      ),
    );
  }
}
