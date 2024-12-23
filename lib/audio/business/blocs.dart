import 'package:audiopc/audiopc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usicat/audio/data/repository/audio_repository.dart';
import 'package:usicat/audio/data/service/local_lib.dart';
import 'package:usicat/audio/data/service/service.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'events.dart';
part 'states.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class APIBloc extends Bloc<APIEvent, APIState> {
  final AudioRepository audioRepository;

  APIBloc(this.audioRepository) : super(const APIState()) {
    on<OnGetNewSong>(_getNewSong,
        transformer: throttleDroppable(throttleDuration));
    on<OnGetSongById>(_getSongById,
        transformer: throttleDroppable(throttleDuration));
    on<OnGetSongByKeyword>(_getSongByKeyword,
        transformer: throttleDroppable(throttleDuration));
    on<OnGetSongByGenre>(_getSongByGenre,
        transformer: throttleDroppable(throttleDuration));
    on<OnGetMostPopularSong>(_getMostPopularSong,
        transformer: throttleDroppable(throttleDuration));
    on<OnGetSongs>(_getSongs, transformer: throttleDroppable(throttleDuration));
  }

  Future<void> _getNewSong(OnGetNewSong event, Emitter<APIState> emit) async {
    try {
      final List<Song> newSong = await audioRepository.getNewSong();
      emit(state.copyWith(newSongs: newSong, status: FetChStatus.loaded));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(status: FetChStatus.error));
    }
  }

  Future<void> _getSongById(OnGetSongById event, Emitter<APIState> emit) async {
    try {
      final song = await audioRepository.getSongById(event.id);
      emit(state.copyWith(searchSongs: song, status: FetChStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: FetChStatus.error));
    }
  }

  Future<void> _getSongByKeyword(
      OnGetSongByKeyword event, Emitter<APIState> emit) async {
    try {
      final song = await audioRepository.getSongByKeyword(event.keyword);
      emit(state.copyWith(searchSongs: song, status: FetChStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: FetChStatus.error));
    }
  }

  Future<void> _getSongByGenre(
      OnGetSongByGenre event, Emitter<APIState> emit) async {
    try {
      final song = await audioRepository.getSongByGenre(event.genre);
      emit(state.copyWith(searchSongs: song, status: FetChStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: FetChStatus.error));
    }
  }

  Future<void> _getMostPopularSong(
      OnGetMostPopularSong event, Emitter<APIState> emit) async {
    try {
      final song = await audioRepository.getMostPopularSong();
      emit(state.copyWith(popularSongs: song));
    } catch (e) {
      emit(state.copyWith(status: FetChStatus.error));
    }
  }

  Future<void> _getSongs(OnGetSongs event, Emitter<APIState> emit) async {
    try {
      final song = await audioRepository.getSongs();
      emit(state.copyWith(searchSongs: song, status: FetChStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: FetChStatus.error));
    }
  }
}

class LocalLibBloc extends Bloc<APIEvent, LocalLibState> {
  final LocalAudioRepo localAudioRepo = LocalAudioRepo(DatabaseHelper());

  LocalLibBloc() : super(const LocalLibState()) {
    on<OnGetLocalSong>(_getLocalSong);
    on<OnGetPlayList>(_getPlayList);
    on<OnGetSongFromPlayList>(_getSongFromPlayList);
    on<OnAddPlayList>(_createPlayList);
    on<OnAddLocalSongs>(_addLocalSongs);
    on<OnDeleteSongsFromPlayList>(_deleteSongsFromPlayList);
    on<OnDeleteLocalSongs>(_deleteLocalSongs);
    on<OnDeletePlaylists>(_deletePlayLists);
    on<OnAddSongsToPlaylist>(_addSongsToPlaylist);
  }

  Future<void> _getLocalSong(
      OnGetLocalSong event, Emitter<LocalLibState> emit) async {
    final song = await localAudioRepo.getLocalSongs();
    emit(state.copyWith(localSongs: song));
  }

  Future<void> _getPlayList(
      OnGetPlayList event, Emitter<LocalLibState> emit) async {
    final playList = await localAudioRepo.getPlayLists();
    emit(state.copyWith(playLists: playList));
  }

  Future<void> _getSongFromPlayList(
      OnGetSongFromPlayList event, Emitter<LocalLibState> emit) async {
    final sop = await localAudioRepo.getSOP(event.playListId);
    final song = await localAudioRepo.getSongFromPlayList(sop);
    emit(state.copyWith(cacheSongs: song));
  }

  Future<void> _createPlayList(
      OnAddPlayList event, Emitter<LocalLibState> emit) async {
    await localAudioRepo.createPlayList(event.name);
    final playList = await localAudioRepo.getPlayLists();
    emit(state.copyWith(playLists: playList));
  }

  Future<void> _addLocalSongs(
      OnAddLocalSongs event, Emitter<LocalLibState> emit) async {
    await localAudioRepo.addLocalSongs(event.songs);
    final localSong = await localAudioRepo.getLocalSongs();
    emit(state.copyWith(localSongs: localSong));
  }

  Future<void> _addSongsToPlaylist(
      OnAddSongsToPlaylist event, Emitter<LocalLibState> emit) async {
    await localAudioRepo.addSongsToPlayList(event.id, event.songs);
    final sop = await localAudioRepo.getSOP(event.id);
    final song = await localAudioRepo.getSongFromPlayList(sop);
    emit(state.copyWith(cacheSongs: song));
  }

  Future<void> _deleteSongsFromPlayList(OnDeleteSongsFromPlayList event, Emitter<LocalLibState> emit) async {
    await localAudioRepo.deleteSongsFromPlayList(event.songs, event.id);
  }

  Future<void> _deleteLocalSongs(OnDeleteLocalSongs event, Emitter<LocalLibState> emit) async {
    await localAudioRepo.deleteLocalSongs(event.songs);
    final localSong = await localAudioRepo.getLocalSongs();
    emit(state.copyWith(localSongs: localSong));
  }

  Future<void> _deletePlayLists(OnDeletePlaylists event, Emitter<LocalLibState> emit) async {
    for (final playList in event.playLists) {
      await localAudioRepo.deletePlayList(playList.id!);
    }
    final playList = await localAudioRepo.getPlayLists();
    emit(state.copyWith(playLists: playList));
  }
}



final class PlaybackBloc extends Bloc<PlaybackEvent, PlaybackState> {
  PlaybackBloc(super.initialState) {
    on<OnNewSong>(_onNewSong);
    on<OnPositionChange>(_onPositionChange);
    on<OnDurationChange>(_onDurationChange);
    on<OnStateChange>(_onStateChange);
    on<OnPlayAtIndex>(_playAt);
    on<OnSamplesChange>(_onSampleChange);
    on<OnPlayModeChange>(_onPlayModeChange);
  }

  Future<void> _onNewSong(OnNewSong event, Emitter<PlaybackState> emit) async {
    emit(state.copyWith(song: event.song));
  }

  Future<void> _onPositionChange(
      OnPositionChange event, Emitter<PlaybackState> emit) async {
    emit(state.copyWith(position: event.position));
  }

  Future<void> _onDurationChange(
      OnDurationChange event, Emitter<PlaybackState> emit) async {
    emit(state.copyWith(duration: event.duration));
  }

  Future<void> _onStateChange(
      OnStateChange event, Emitter<PlaybackState> emit) async {
    emit(state.copyWith(state: event.state));
  }

  Future<void> _playAt(OnPlayAtIndex event, Emitter<PlaybackState> emit) async {
    emit(state.copyWith(index: event.index));
  }

  Future<void> _onSampleChange(
      OnSamplesChange event, Emitter<PlaybackState> emit) async {
    emit(state.copyWith(samples: event.samples));
  }

  Future<void> _onPlayModeChange(
      OnPlayModeChange event, Emitter<PlaybackState> emit) async {
    emit(state.copyWith(playMode: event.mode));
  }
}

final class GlobalUIBloc extends Bloc<GlobalUIEvent, GlobalUIState> {

  final sharedPref = SharedPreferencesAsync();

  GlobalUIBloc(super.initialState) {
    on(_onChangeTheme);
    on(_onLoadSettings);
  }

  Future<void> _onChangeTheme(OnChangeTheme event, Emitter<GlobalUIState> emit) async {
    emit(state.copyWith(isDark: event.isDark));
    await sharedPref.setBool('isDark', event.isDark);
  }

  Future<void> _onLoadSettings(OnLoadSettings event, Emitter<GlobalUIState> emit) async {
    final isDark = await sharedPref.getBool('isDark');
    if (isDark == null) {
      await sharedPref.setBool('isDark', true);
      emit(state.copyWith(isDark: true));
    } else {
      emit(state.copyWith(isDark: isDark));
    }
  }

}

// extension method for color scheme
extension ThemeExtension on ColorScheme {
  ColorScheme copyWith({
    Color? primary,
    Color? secondary,
    Color? surface,
    Color? error,
    Color? onPrimary,
    Color? onSecondary,
    Color? onSurface,
    Color? onError,
    Brightness? brightness,
  }) {
    return ColorScheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      surface: surface ?? this.surface,
      error: error ?? this.error,
      onPrimary: onPrimary ?? this.onPrimary,
      onSecondary: onSecondary ?? this.onSecondary,
      onSurface: onSurface ?? this.onSurface,
      onError: onError ?? this.onError,
      brightness: brightness ?? this.brightness,
    );
  }
}
