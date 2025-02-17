import 'package:better_player/better_player.dart';
import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:invidious/database.dart';
import 'package:invidious/globals.dart';
import 'package:invidious/player/states/video_player.dart';
import 'package:invidious/settings/models/db/settings.dart';
import 'package:logging/logging.dart';

import '../../settings/states/settings.dart';

part 'tv_player_settings.g.dart';

const List<String> tvAvailablePlaybackSpeeds = ['0.5x', '0.75x', '1x', '1.25x', '1.5x', '1.75x', '2x', '2.25x', '2.5x', '2.75x', '3x'];
final Logger log = Logger('TvSettingsController');

enum Tabs {
  video,
  audio,
  captions,
  playbackSpeed;
}

class TvPlayerSettingsCubit extends Cubit<TvPlayerSettingsState> {
  final VideoPlayerCubit player;
  final SettingsCubit settings;

  TvPlayerSettingsCubit(super.initialState, this.player, this.settings);

  List<String> get videoTrackNames => settings.state.useDash || (player.state.video?.liveNow ?? false)
      ? player.state.videoController?.betterPlayerAsmsTracks.map((e) => '${e.height}p').toSet().toList() ?? []
      : player.state.videoController?.betterPlayerDataSource?.resolutions?.keys.toList() ?? [];

  List<String> get audioTrackNames => settings.state.useDash ? player.state.videoController?.betterPlayerAsmsAudioTracks?.map((e) => '${e.label}').toList() ?? [] : [];

  List<String> get availableCaptions => player.state.videoController?.betterPlayerSubtitlesSourceList.map((e) => '${e.name}').toList() ?? [];

  BetterPlayerController? get videoController => player.state.videoController;

  videoButtonFocusChange(bool focus) {
    if (focus) {
      var state = this.state.copyWith();
      state.selected = Tabs.video;
      emit(state);
    }
  }

  audioButtonFocusChange(bool focus) {
    if (focus) {
      var state = this.state.copyWith();
      state.selected = Tabs.audio;
      emit(state);
    }
  }

  captionsButtonFocusChange(bool focus) {
    if (focus) {
      var state = this.state.copyWith();
      state.selected = Tabs.captions;
      emit(state);
    }
  }

  playbackSpeedButtonFocusChange(bool focus) {
    if (focus) {
      var state = this.state.copyWith();
      state.selected = Tabs.playbackSpeed;
      emit(state);
    }
  }

  changeVideoTrack(String selected) {
    log.fine('Video quality selected $selected');

    if (settings.state.useDash) {
      BetterPlayerAsmsTrack? track = videoController?.betterPlayerAsmsTracks.firstWhere((element) => '${element.height}p' == selected);

      if (track != null) {
        log.fine('Changing video track to $selected');
        videoController?.setTrack(track);
      }
    } else {
      String? url = videoController?.betterPlayerDataSource?.resolutions?[selected];
      if (url != null) {
        videoController?.setResolution(url);
      }
    }
  }

  changeChangeAudioTrack(String selected) {
    log.fine('Audio quality selected $selected');
    BetterPlayerAsmsAudioTrack? track = videoController?.betterPlayerAsmsAudioTracks?.firstWhere((e) => '${e.label}' == selected);

    if (track != null) {
      log.fine('Changing audio track to $selected');
      videoController?.setAudioTrack(track);
    }
  }

  changeSubtitles(String selected) {
    log.fine('Subtitles selected $selected');
    BetterPlayerSubtitlesSource? track = videoController?.betterPlayerSubtitlesSourceList.firstWhere((e) => '${e.name}' == selected);

    settings.setLastSubtitle(selected);

    if (track != null) {
      log.fine('Changing subtitles to $selected');
      videoController?.setupSubtitleSource(track);
    }
  }

  changePlaybackSpeed(String selected) {
    String speed = selected.replaceAll('x', '');
    videoController?.setSpeed(double.parse(speed));
  }
}

@CopyWith(constructor: "_")
class TvPlayerSettingsState {
  Tabs selected = Tabs.video;

  TvPlayerSettingsState();

  TvPlayerSettingsState._(this.selected);
}
