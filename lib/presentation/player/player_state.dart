part of 'player_bloc.dart';

class PlayerState {
  final Status? status;
  final Duration? position;
  final Duration? total;
  final bool? isPlaying;
  final List<BookAudioModel>? chapters;
  final String? errorMessage;
  final String? currentAudioTitle;
  final ProgressBarState progressBarState;
  final RepeatState repeatState;
  final bool isFirstAudio;
  final ButtonState playButtonState;
  final bool isLastAudio;

  final bool isShuffle;

  PlayerState(
      {this.currentAudioTitle,
      this.progressBarState = const ProgressBarState(current: Duration.zero, buffered: Duration.zero, total: Duration.zero),
      this.repeatState = RepeatState.off,
      this.isFirstAudio = true,
      this.playButtonState = ButtonState.paused,
      this.isLastAudio = true,
      this.isShuffle = false,
      this.errorMessage,
      this.chapters,
      this.status,
      this.position,
      this.total,
      this.isPlaying});

  PlayerState copyWith(
          {Status? status,
          Duration? position,
          Duration? total,
          bool? isPlaying,
          List<BookAudioModel>? chapters,
          String? errorMessage,
          String? currentAudioTitle,
          ProgressBarState? progressBarState,
          RepeatState? repeatState,
          bool? isFirstAudio,
          ButtonState? playButtonState,
          bool? isLastAudio,
          bool? isShuffle}) =>
      PlayerState(
          status: status ?? this.status,
          position: position ?? this.position,
          total: total ?? this.total,
          isPlaying: isPlaying ?? this.isPlaying,
          chapters: chapters ?? this.chapters,
          errorMessage: errorMessage ?? this.errorMessage,
          currentAudioTitle: currentAudioTitle ?? this.currentAudioTitle,
          progressBarState: progressBarState ?? this.progressBarState,
          repeatState: repeatState ?? this.repeatState,
          isFirstAudio: isFirstAudio ?? this.isFirstAudio,
          playButtonState: playButtonState ?? this.playButtonState,
          isLastAudio: isLastAudio ?? this.isLastAudio,
          isShuffle: isShuffle ?? this.isShuffle);
}
