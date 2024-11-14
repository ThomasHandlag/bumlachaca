import 'package:usicat/audio/data/service/service.dart';

abstract class APIState {}

class AudioInitial extends APIState {}

class AudioLoading extends APIState {}

class AudioLoaded extends APIState {
  final List<Song> audioFiles;

  AudioLoaded(this.audioFiles);
}

class AudioError extends APIState {
  final String message;

  AudioError(this.message);
}

abstract class PlaybackState {}

class AudioPlaybackState extends PlaybackState {
  Song song;
  int position;
  int duration;

  AudioPlaybackState(this.song, this.position, this.duration);
}
