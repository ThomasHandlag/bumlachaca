import 'package:usicat/audio/data/service/service.dart';

abstract class APIEvent {}

class AudioAPIEvent extends APIEvent {}

abstract class PlaybackEvent {}

class OnNewSong extends PlaybackEvent {
  final Song song;

  OnNewSong(this.song);
}

class OnPositionChange extends PlaybackEvent {
  final int position;

  OnPositionChange(this.position);
}

class OnStateChange extends PlaybackEvent {
  final bool isPlaying;

  OnStateChange(this.isPlaying);
}

class OnDurationChange extends PlaybackEvent {
  final int duration;

  OnDurationChange(this.duration);
}
