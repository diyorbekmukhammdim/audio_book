import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/di.dart';
import '../../domain/models/book_model.dart';
import '../../domain/repository/books/books_repository.dart';
import '../../utils/status.dart';

part 'player_event.dart';

part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc() : super(PlayerState()) {
    final repository = getIt<BooksRepository>();
    final audioHandler = getIt<AudioHandler>();
    on<LoadAudiosEvent>((event, emit) async {
      await audioHandler.skipToQueueItem(event.index);
      final mediaItem = audioHandler.mediaItem.value;
      final playlist = audioHandler.queue.value;
      if (playlist.length < 2 || mediaItem == null) {
        emit(state.copyWith(isFirstAudio: true, isLastAudio: true));
      } else {
        emit(state.copyWith(
            isFirstAudio: playlist.first == mediaItem,
            isLastAudio: playlist.last == mediaItem));
      }
      audioHandler.playbackState.listen((playbackState) {
        print('STreem: $playbackState');
        add(UpdatePositionEvent(
            position: ProgressBarState(
          current: state.progressBarState.current,
          buffered: playbackState.bufferedPosition,
          total: state.progressBarState.total,
        )));
        var isPlaying = playbackState.playing;
        final processingState = playbackState.processingState;
        if (playbackState.processingState == AudioProcessingState.loading ||
            playbackState.processingState == AudioProcessingState.buffering) {
          add(UpdatePlayButtonEvent(buttonState: ButtonState.loading));
        } else if (!playbackState.playing) {
          add(UpdatePlayButtonEvent(buttonState: ButtonState.paused));
        } else if (playbackState.processingState !=
            AudioProcessingState.completed) {
          add(UpdatePlayButtonEvent(buttonState: ButtonState.playing));
        } else {
          audioHandler.seek(Duration.zero);
          audioHandler.pause();
        }
      });
      AudioService.position.listen((position) {
        add(UpdatePositionEvent(
            position: ProgressBarState(
          current: position,
          buffered: state.progressBarState.buffered,
          total: state.progressBarState.total,
        )));
      });
      audioHandler.mediaItem.listen((mediaItem) {
        add(UpdatePositionEvent(
            position: ProgressBarState(
          current: state.progressBarState.current,
          buffered: state.progressBarState.buffered,
          total: mediaItem?.duration ?? Duration.zero,
        )));

        if (audioHandler.queue.value.length < 2 ||
            audioHandler.mediaItem.value == null) {
          add(UpdateSkipButtonEvent(
              audioTitle: audioHandler.mediaItem.value?.title ?? '',
              isFirst: true,
              isLast: true));
        } else {
          add(UpdateSkipButtonEvent(
              audioTitle: audioHandler.mediaItem.value?.title ?? '',
              isFirst: audioHandler.queue.value.first ==
                  audioHandler.mediaItem.value,
              isLast: audioHandler.queue.value.last ==
                  audioHandler.mediaItem.value));
        }
      });
    });

    on<UpdatePlayButtonEvent>((event, emit) async {
      print(event.buttonState);
      emit(state.copyWith(playButtonState: event.buttonState));
    });
    on<PlayEvent>((event, emit) async {
      audioHandler.play();
    });

    on<PauseEvent>((event, emit) async {
      audioHandler.pause();
    });

    on<DisposeEvent>((event, emit) async {
      audioHandler.customAction('dispose');
    });

    on<StopEvent>((event, emit) async {
      audioHandler.stop();
    });

    on<NextEvent>((event, emit) async {
      audioHandler.skipToNext();
    });

    on<PrevEvent>((event, emit) async {
      audioHandler.skipToPrevious();
    });

    on<UpdatePositionEvent>((event, emit) {
      emit(state.copyWith(progressBarState: event.position));
    });
    on<UpdateSeekPositionEvent>((event, emit) {
      audioHandler.seek(event.position);
    });

    on<RepeatEvent>((event, emit) {
      final next = (state.repeatState.index + 1) % RepeatState.values.length;
      emit(state.copyWith(repeatState: RepeatState.values[next]));
      final repeatMode = state.repeatState;
      switch (repeatMode) {
        case RepeatState.off:
          audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
          break;
        case RepeatState.repeatSong:
          audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
          break;
        case RepeatState.repeatPlaylist:
          audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
          break;
      }
    });

    on<ShuffleEvent>((event, emit) {
      final enable = !state.isShuffle;
      emit(state.copyWith(isShuffle: enable));
      if (enable) {
        audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
      } else {
        audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
      }
    });

    on<AddToQueEvent>((event, emit) async {
      while (audioHandler.queue.value.isNotEmpty) {
        audioHandler.queue.value.removeLast();
      }
      final mediaItems = state.chapters!
          .map((song) => MediaItem(
                id: song.id ?? '',
                title: song.audioName ?? '',
                extras: {'url': song.audioUrl},
              ))
          .toList();
      await audioHandler.addQueueItems(mediaItems);
      add(LoadAudiosEvent(index: event.index));
      //emit(state.copyWith(status: Status.success));
    });

    on<GetAllChaptersEvent>((event, emit) async {
      emit(state.copyWith(status: Status.loading));
      try {
        final chapters =
            await repository.getSingleBookData(bookName: event.bookName);
        //add(AddToQueEvent(mediaItems: mediaItems));
        emit(state.copyWith(status: Status.success, chapters: chapters));
      } catch (e) {
        emit(state.copyWith(status: Status.fail, errorMessage: e.toString()));
      }
    });
  }
}
