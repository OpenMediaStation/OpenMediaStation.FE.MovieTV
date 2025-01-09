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

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AudioTrack>(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.focused)) {
              return const Color.fromARGB(83, 86, 86, 86);
            }

            return null;
          },
        ),
      ),
      icon: const Icon(
        Icons.audio_file,
        color: Colors.white,
      ),
      initialValue: AudioTrack.no(),
      onSelected: (AudioTrack newTrack) async {
        await widget.player.setAudioTrack(newTrack);
        setState(() {});
      },
      itemBuilder: (BuildContext context) {
        tracks.audio.removeWhere((i) => i.id == "auto");
        tracks.audio.removeWhere((i) => i.id == "no");

        return tracks.audio.map((AudioTrack track) {
          return PopupMenuItem<AudioTrack>(
            value: track,
            child: OptionEntryItemWrapper(
              builder: (p0, p1) {
                return Text(
                  track.title ?? track.language ?? track.id,
                  style: TextStyle(
                    decoration:
                        p1 ? TextDecoration.underline : TextDecoration.none,
                  ),
                );
              },
            ),
          );
        }).toList();
      },
    );
  }
}
