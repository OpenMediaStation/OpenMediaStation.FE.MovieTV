import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:open_media_server_app/controls/material_tv.dart';
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

  @override
  void initState() {
    super.initState();
    player.open(
      Media(
        widget.url,
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

    var bottomButtonBar = [
      const MaterialPositionIndicator(),
      const Spacer(),
      MaterialCustomButton(
        onPressed: () async {
          await player.setSubtitleTrack(
              SubtitleTrack.auto()); // TODO choose right subtitles
        },
        icon: const Icon(Icons.subtitles),
      ),
      const MaterialFullscreenButton(),
    ];

    var mobileThemeData = MaterialVideoControlsThemeData(
      volumeGesture: true,
      brightnessGesture: true,
      seekGesture: true,
      seekOnDoubleTap: true,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
      topButtonBar: topButtonBar,
      bottomButtonBar: bottomButtonBar,
      visibleOnMount: true,
    );

    var tvThemeData = MaterialTvVideoControlsThemeData(
      topButtonBar: topButtonBar,
      bottomButtonBar: bottomButtonBar,
      visibleOnMount: true,
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

    var desktopThemeData = MaterialDesktopVideoControlsThemeData(
      topButtonBar: topButtonBar,
      bottomButtonBar: bottomButtonBar,
      visibleOnMount: true,
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
