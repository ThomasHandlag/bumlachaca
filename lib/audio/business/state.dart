part of 'bloc.dart';

enum FetChStatus { loading, loaded, error }

final class APIState extends Equatable {
  const APIState(
      {this.status = FetChStatus.loading,
      this.newSongs = const <Song>[],
      this.popularSongs = const <Song>[],
      this.searchSongs = const <Song>[]});

  final FetChStatus status;
  final List<Song> newSongs;
  final List<Song> popularSongs;
  final List<Song> searchSongs;

  @override
  List<Object?> get props => [status, newSongs, popularSongs, searchSongs];

  APIState copyWith({
    FetChStatus? status,
    List<Song>? newSongs,
    List<Song>? localSongs,
    List<PlayList>? playLists,
    List<Song>? popularSongs,
    List<Song>? searchSongs,
  }) {
    debugPrint(
        'APIState copyWith: $status, $newSongs, $popularSongs, $searchSongs');
    return APIState(
        status: status ?? this.status,
        newSongs: newSongs ?? this.newSongs,
        popularSongs: popularSongs ?? this.popularSongs,
        searchSongs: searchSongs ?? this.searchSongs);
  }

  @override
  String toString() {
    return 'APIState { status: $status, songs: ${newSongs.length}, popularSongs: ${popularSongs.length}, searchSongs: ${searchSongs.length} }';
  }
}

class LocalLibState extends Equatable {
  const LocalLibState({
    this.localSongs = const <Song>[],
    this.playLists = const <PlayList>[],
    this.sop = const <SOP>[],
    this.cacheSongs = const <Song>[],
  });

  final List<Song> localSongs;
  final List<PlayList> playLists;
  final List<SOP> sop;
  final List<Song> cacheSongs;

  LocalLibState copyWith({
    List<Song>? localSongs,
    List<PlayList>? playLists,
    List<SOP>? sop,
    List<Song>? cacheSongs,
  }) {
    return LocalLibState(
        localSongs: localSongs ?? this.localSongs,
        playLists: playLists ?? this.playLists,
        cacheSongs: cacheSongs ?? this.cacheSongs,
        sop: sop ?? this.sop);
  }

  @override
  List<Object?> get props => [localSongs, playLists, sop, cacheSongs];
}

class PlaybackState extends Equatable {
  final Song? song;
  final int position;
  final int duration;
  final PlayerState? state;
  final int? index;

  const PlaybackState(
      {this.song,
      this.position = 0,
      this.duration = 0,
      this.state,
      this.index});

  PlaybackState copyWith({
    Song? song,
    int? position,
    int? duration,
    PlayerState? state,
    int? index,
  }) {
    return PlaybackState(
        song: song ?? this.song,
        position: position ?? this.position,
        duration: duration ?? this.duration,
        index: index ?? this.index,
        state: state ?? this.state);
  }

  @override
  List<Object?> get props => [song, position, duration, state, index];
}
