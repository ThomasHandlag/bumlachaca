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
  });

  final List<Song> localSongs;
  final List<PlayList> playLists;
  final List<SOP> sop;

  LocalLibState copyWith({
    List<Song>? localSongs,
    List<PlayList>? playLists,
    List<SOP>? sop,
  }) {
    return LocalLibState(
        localSongs: localSongs ?? this.localSongs,
        playLists: playLists ?? this.playLists,
        sop: sop ?? this.sop);
  }

  @override
  List<Object?> get props => [localSongs, playLists, sop];
}

class PlaybackState extends Equatable {
  final Song? song;
  final int position;
  final int duration;
  final PlayerState? state;

  const PlaybackState(
      {this.song, this.position = 0, this.duration = 0, this.state});

  PlaybackState copyWith({
    Song? song,
    int? position,
    int? duration,
    PlayerState? state,
  }) {
    return PlaybackState(
        song: song ?? this.song,
        position: position ?? this.position,
        duration: duration ?? this.duration,
        state: state ?? this.state);
  }

  @override
  List<Object?> get props => [song, position, duration, state];
}
