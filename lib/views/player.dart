import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_tv/material_tv.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:open_media_server_app/apis/base_api.dart';
import 'package:open_media_server_app/apis/progress_api.dart';
import 'package:open_media_server_app/globals/platform_globals.dart';
import 'package:open_media_server_app/models/internal/grid_item_model.dart';
import 'package:open_media_server_app/models/progress/progress.dart';
import 'package:open_media_server_app/widgets/audio_button.dart';
import 'package:open_media_server_app/widgets/subtitle_button.dart';

class PlayerView extends StatefulWidget {
  const PlayerView({
    super.key,
    required this.url,
    required this.gridItem,
  });

  final String url;
  final GridItemModel gridItem;

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
        httpHeaders: BaseApi.getHeaders(),
      ),
    );

    player.seek(
      Duration(seconds: widget.gridItem.progress?.progressSeconds ?? 0),
    );

    player.setSubtitleTrack(SubtitleTrack.no());

    int? lastUpdatedSecond;

    player.stream.position.listen((duration) async {
      var seconds = duration.inSeconds;

      if (seconds % 10 == 0 && lastUpdatedSecond != seconds && seconds != 0) {
        lastUpdatedSecond = seconds;

        ProgressApi progressApi = ProgressApi();
        widget.gridItem.progress ??= Progress(
          id: null,
          category: widget.gridItem.inventoryItem?.category,
          parentId: widget.gridItem.inventoryItem?.id,
          progressSeconds: seconds,
          progressPercentage: null,
          completions: null,
        );

        widget.gridItem.progress!.progressSeconds = seconds;

        await progressApi.updateProgress(widget.gridItem.progress!);
        widget.gridItem.progress = await progressApi.getProgress(
          widget.gridItem.inventoryItem?.category,
          widget.gridItem.inventoryItem?.id,
        );
      }
    });
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
      SubtitleButton(
        player: player,
        gridItemModel: widget.gridItem,
      ),
      AudioButton(player: player),
    ];

    if (!PlatformGlobals.isTv) {
      bottomButtonBar.add(
        const MaterialFullscreenButton(),
      );
      bottomButtonBar.insert(
          0,
          const MaterialTvVolumeButton(
            volumeHighIcon: Icon(Icons.volume_up),
            volumeLowIcon: Icon(Icons.volume_down),
            volumeMuteIcon: Icon(Icons.volume_mute),
          ));
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

    if (PlatformGlobals.isMobile) {
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
    } else if (PlatformGlobals.isTv) {
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
      var videoSize = controller.rect.value?.size;
      return MaterialDesktopVideoControlsTheme(
        normal: desktopThemeData,
        fullscreen: desktopThemeData,
        child: Scaffold(
          body: Video(
            fit: BoxFit.fitHeight,
            //width: videoWidth != null ? (videoWidth / 2) : null,
            aspectRatio: videoSize != null ? videoSize.aspectRatio * 2 : null,
            //width: MediaQuery.of(context).size.width /2,
            alignment: Alignment.centerLeft,
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
