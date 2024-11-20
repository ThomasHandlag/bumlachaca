import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usicat/audio/data/repository/audio_repository.dart';
import 'package:usicat/audio/data/service/local_lib.dart';
import 'package:usicat/audio/data/service/service.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'event.dart';
part 'state.dart';

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
    emit(state.copyWith(localSongs: song));
  }

  Future<void> _createPlayList(
      OnAddPlayList event, Emitter<LocalLibState> emit) async {
    await localAudioRepo.createPlayList(event.name);
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
}
