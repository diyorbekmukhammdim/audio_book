part of 'player_bloc.dart';


abstract class PlayerEvent {}

class LoadAudiosEvent extends PlayerEvent{
  final int index;

  LoadAudiosEvent({required this.index});
}
class PlayEvent extends PlayerEvent{}
class PauseEvent extends PlayerEvent{}
class NextEvent extends PlayerEvent{}
class PrevEvent extends PlayerEvent{}
class AddToQueEvent extends PlayerEvent{
  final int index;

  AddToQueEvent({required this.index});
}
class ShuffleEvent extends PlayerEvent{}
class RepeatEvent extends PlayerEvent{}
class SavePositionEvent extends PlayerEvent{}
class UpdatePositionEvent extends PlayerEvent{
  final ProgressBarState position;

  UpdatePositionEvent({required this.position});
}

class UpdateSeekPositionEvent extends PlayerEvent {
  final Duration position;

  UpdateSeekPositionEvent({required this.position});
}
  class GetAllChaptersEvent extends PlayerEvent{
  final String bookName;

  GetAllChaptersEvent({required this.bookName});
  }

  class UpdatePlayButtonEvent extends PlayerEvent{
  final ButtonState buttonState;

  UpdatePlayButtonEvent({required this.buttonState});
  }

class UpdateSkipButtonEvent extends PlayerEvent{
  final bool isFirst;
  final bool isLast;
  final String audioTitle;

  UpdateSkipButtonEvent({required this.audioTitle, required this.isFirst, required this.isLast});

}

class DisposeEvent extends PlayerEvent{}
class StopEvent extends PlayerEvent{}

