import 'dart:async';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:open_media_server_app/helpers/wrapper.dart';

class AudioButton extends StatefulWidget {
  final Player player;

  const AudioButton({
    Key? key,
    required this.player,
  }) : super(key: key);

  @override
  State<AudioButton> createState() => _AudioButtonState();
}

class _AudioButtonState extends State<AudioButton> {
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
  void pressed(BuildContext context) {
    tracks.audio.removeWhere((i) => i.id == "auto");
    tracks.audio.removeWhere((i) => i.id == "no");

    var items = tracks.audio.map((AudioTrack track) {
      return PopupMenuItem<AudioTrack>(
        value: track,
        onTap: () async {
          await widget.player.setAudioTrack(track);
        },
        child: OptionEntryItemWrapper(
          builder: (p0, p1) {
            return Text(
              track.title ?? track.language ?? track.id,
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
        Icons.audio_file,
        color: Colors.white,
      ),
      onPressed: () => pressed(context),
    );
  }
}
