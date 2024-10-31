import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:open_media_server_app/apis/base_api.dart';
import 'package:open_media_server_app/player_controls/material_tv.dart';
import 'package:open_media_server_app/helpers/wrapper.dart';
import 'package:open_media_server_app/globals.dart';

class PlayerView extends StatefulWidget {
  const PlayerView({super.key, required this.url});

  final String url;

  @override
  State<PlayerView> createState() => _PlayerState();
}

class _PlayerState extends State<PlayerView> {
  late final player = Player();
  late final controller = VideoController(player);

  SubtitleTrack? selectedSubtitle;

  @override
  void initState() {
    super.initState();
    player.open(
      Media(
        widget.url,
        httpHeaders: BaseApi.getHeaders(),
      ),
    );

    player.setSubtitleTrack(SubtitleTrack.no());
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var topButtonBar = [
      MaterialCustomButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
      ),
    ];

    List<SubtitleTrack> subtitles = player.state.tracks.subtitle;
    List<AudioTrack> audios = player.state.tracks.audio;

    var bottomButtonBar = [
      const MaterialPositionIndicator(),
      const Spacer(),
      subtitles.isNotEmpty
          ? PopupMenuButton<SubtitleTrack>(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.focused)) {
                      return const Color.fromARGB(83, 86, 86, 86);
                    }
                  },
                ),
              ),
              icon: const Icon(
                Icons.subtitles,
                color: Colors.white,
              ),
              initialValue: selectedSubtitle,
              onSelected: (SubtitleTrack newTrack) async {
                setState(() {
                  selectedSubtitle = newTrack;
                });
                await player.setSubtitleTrack(newTrack);
              },
              itemBuilder: (BuildContext context) {
                return subtitles.map((SubtitleTrack track) {
                  return PopupMenuItem<SubtitleTrack>(
                    value: track,
                    child: OptionEntryItemWrapper(
                      builder: (p0, p1) {
                        return Text(
                          track.title ?? track.id,
                          style: TextStyle(
                            decoration: p1
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
                        );
                      },
                    ),
                  );
                }).toList();
              },
            )
          : const SizedBox(), // Return an empty widget if no subtitles
      audios.isNotEmpty
          ? PopupMenuButton<AudioTrack>(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.focused)) {
                      return const Color.fromARGB(83, 86, 86, 86);
                    }
                  },
                ),
              ),
              icon: const Icon(
                Icons.audio_file,
                color: Colors.white,
              ),
              onSelected: (AudioTrack newTrack) async {
                await player.setAudioTrack(newTrack);
              },
              itemBuilder: (BuildContext context) {
                return audios.map((AudioTrack track) {
                  return PopupMenuItem<AudioTrack>(
                    value: track,
                    child: OptionEntryItemWrapper(
                      builder: (p0, p1) {
                        return Text(
                          track.title ?? track.id,
                          style: TextStyle(
                            decoration: p1
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
                        );
                      },
                    ),
                  );
                }).toList();
              },
            )
          : const SizedBox(),
    ];

    if (!Globals.isTv) {
      bottomButtonBar.add(
        const MaterialFullscreenButton(),
      );
    }

    var seekBarColor = const Color.fromARGB(255, 82, 26, 114);

    var mobileThemeData = MaterialVideoControlsThemeData(
      volumeGesture: true,
      brightnessGesture: true,
      seekGesture: true,
      seekOnDoubleTap: true,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
      topButtonBar: topButtonBar,
      bottomButtonBar: bottomButtonBar,
      visibleOnMount: true,
      seekBarThumbColor: seekBarColor,
      seekBarPositionColor: seekBarColor,
    );

    var tvThemeData = MaterialTvVideoControlsThemeData(
      topButtonBar: topButtonBar,
      bottomButtonBar: bottomButtonBar,
      visibleOnMount: true,
      seekBarThumbColor: seekBarColor,
      seekBarPositionColor: seekBarColor,
      primaryButtonBar: [
        const MaterialTvPlayOrPauseButton(
          iconSize: 124,
        ),
      ],
    );

    var desktopThemeData = MaterialDesktopVideoControlsThemeData(
      topButtonBar: topButtonBar,
      bottomButtonBar: bottomButtonBar,
      visibleOnMount: true,
      seekBarThumbColor: seekBarColor,
      seekBarPositionColor: seekBarColor,
      keyboardShortcuts: {
        const SingleActivator(LogicalKeyboardKey.mediaPlay): () =>
            controller.player.play(),
        const SingleActivator(LogicalKeyboardKey.mediaPause): () =>
            controller.player.pause(),
        const SingleActivator(LogicalKeyboardKey.mediaPlayPause): () =>
            controller.player.playOrPause(),
        const SingleActivator(LogicalKeyboardKey.mediaTrackNext): () =>
            controller.player.next(),
        const SingleActivator(LogicalKeyboardKey.mediaTrackPrevious): () =>
            controller.player.previous(),
        const SingleActivator(LogicalKeyboardKey.space): () =>
            controller.player.playOrPause(),
        const SingleActivator(LogicalKeyboardKey.keyJ): () {
          final rate =
              controller.player.state.position - const Duration(seconds: 10);
          controller.player.seek(rate);
        },
        const SingleActivator(LogicalKeyboardKey.keyI): () {
          final rate =
              controller.player.state.position + const Duration(seconds: 10);
          controller.player.seek(rate);
        },
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () {
          final rate =
              controller.player.state.position - const Duration(seconds: 2);
          controller.player.seek(rate);
        },
        const SingleActivator(LogicalKeyboardKey.arrowRight): () {
          final rate =
              controller.player.state.position + const Duration(seconds: 2);
          controller.player.seek(rate);
        },
        const SingleActivator(LogicalKeyboardKey.arrowUp): () {
          final volume = controller.player.state.volume + 5.0;
          controller.player.setVolume(volume.clamp(0.0, 100.0));
        },
        const SingleActivator(LogicalKeyboardKey.arrowDown): () {
          final volume = controller.player.state.volume - 5.0;
          controller.player.setVolume(volume.clamp(0.0, 100.0));
        },
        const SingleActivator(LogicalKeyboardKey.keyF): () =>
            toggleFullscreen(context),
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            exitFullscreen(context),
      },
    );

    if (Globals.isMobile) {
      return MaterialVideoControlsTheme(
        normal: mobileThemeData,
        fullscreen: mobileThemeData,
        child: Scaffold(
          body: Video(
            controller: controller,
            controls: (state) {
              return MaterialVideoControls(state);
            },
          ),
        ),
      );
    } else if (Globals.isTv) {
      return MaterialTvVideoControlsTheme(
        normal: tvThemeData,
        fullscreen: tvThemeData,
        child: Scaffold(
          body: Video(
            controller: controller,
            controls: (state) {
              return MaterialTvVideoControls(state);
            },
          ),
        ),
      );
    } else {
      return MaterialDesktopVideoControlsTheme(
        normal: desktopThemeData,
        fullscreen: desktopThemeData,
        child: Scaffold(
          body: Video(
            controller: controller,
            controls: (state) {
              return MaterialDesktopVideoControls(state);
            },
          ),
        ),
      );
    }
  }
}
