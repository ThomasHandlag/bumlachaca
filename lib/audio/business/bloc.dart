import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usicat/audio/business/event.dart';
import 'package:usicat/audio/business/state.dart';
import 'package:usicat/audio/data/repository/audio_repository.dart';

class AudioBloc extends Bloc<APIEvent, APIState> {
  final AudioRepository audioRepository;

  AudioBloc(this.audioRepository) : super(AudioInitial()) {
    on<AudioAPIEvent>((event, emit) async {
      emit(AudioLoading());
      try {
        final audioFiles = await audioRepository.getAudioFiles();
        emit(AudioLoaded(audioFiles));
      } catch (e) {
        emit(AudioError("Failed to fetch audio files"));
      }
    });
  }
}

class PlaybackBloc extends Bloc<PlaybackEvent, PlaybackState> {
  PlaybackBloc(super.initialState) {
    on<OnNewSong>((event, emit) {
      emit(AudioPlaybackState(event.song, 0, 0));
    });
  }
}
