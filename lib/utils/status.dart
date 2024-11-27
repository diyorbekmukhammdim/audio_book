enum Status{loading,success,fail}


enum ButtonState {
  paused,
  playing,
  loading,
}

class ProgressBarState {
  const ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum RepeatState {
  off,
  repeatSong,
  repeatPlaylist,
}