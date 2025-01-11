import 'dart:async';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:open_media_server_app/apis/subtitle_api.dart';
import 'package:open_media_server_app/helpers/wrapper.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';

class SubtitleButton extends StatefulWidget {
  final Player player;
  final GridItemModel gridItemModel;

  const SubtitleButton({
    Key? key,
    required this.player,
    required this.gridItemModel,
  }) : super(key: key);

  @override
  State<SubtitleButton> createState() => _SubtitleButtonState();
}

class _SubtitleButtonState extends State<SubtitleButton> {
  late Track track = widget.player.state.track;
  late Tracks tracks = widget.player.state.tracks;

  List<StreamSubscription> subscriptions = [];

  // GlobalKey for the button to track its position
  final GlobalKey _buttonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    track = widget.player.state.track;
    tracks = widget.player.state.tracks;

    subscriptions.addAll(
      [
        widget.player.stream.track.listen((track) {
          setState(() {
            this.track = track;
          });
        }),
        widget.player.stream.tracks.listen((tracks) {
          setState(() {
            this.tracks = tracks;
          });
        }),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final s in subscriptions) {
      s.cancel();
    }
  }

  // Function to show the subtitle menu
  void pressed(BuildContext context) async {
    var subTracks = tracks.subtitle;
    subTracks.removeWhere((i) => i.id == "auto");

    SubtitleApi subtitleApi = SubtitleApi();
    var inventoryItem = widget.gridItemModel.inventoryItem;

    if (inventoryItem?.addons != null && subTracks.where((i) => i.title == "OMSRemoteSubtitle").isEmpty) {
      for (var addon in inventoryItem!.addons!) {
        var track = await subtitleApi.getSubtitle(
          addon,
          inventoryItem.category,
          inventoryItem.id,
        );

        subTracks.add(track);
      }
    }

    var items = subTracks.map((SubtitleTrack track) {
      return PopupMenuItem<SubtitleTrack>(
        value: track,
        onTap: () async {
          await widget.player.setSubtitleTrack(track);
        },
        child: OptionEntryItemWrapper(
          builder: (p0, p1) {
            return Text(
              track.language ?? track.title ?? track.id,
              style: TextStyle(
                decoration: p1 ? TextDecoration.underline : TextDecoration.none,
              ),
            );
          },
        ),
      );
    }).toList();

    // Get the button's position using the GlobalKey
    final RenderBox buttonRenderBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset buttonPosition = buttonRenderBox.localToGlobal(Offset.zero);

    // Show the menu at the button's location
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        buttonPosition.dx,
        buttonPosition.dy +
            buttonRenderBox.size.height, // Position it below the button
        0,
        0,
      ),
      items: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: _buttonKey,
      icon: const Icon(
        Icons.subtitles,
        color: Colors.white,
      ),
      onPressed: () => pressed(context),
    );
  }
}
