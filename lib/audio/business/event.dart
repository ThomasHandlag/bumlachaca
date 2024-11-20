part of 'bloc.dart';

abstract class APIEvent {}

class OnGetSongs extends APIEvent {}

class OnGetNewSong extends APIEvent {}

class OnGetSongById extends APIEvent {
  final String id;

  OnGetSongById(this.id);
}

class OnGetSongByKeyword extends APIEvent {
  final String keyword;

  OnGetSongByKeyword(this.keyword);
}

class OnGetSongByGenre extends APIEvent {
  final String genre;

  OnGetSongByGenre(this.genre);
}

class OnGetMostPopularSong extends APIEvent {}

// local event
class OnGetLocalSong extends APIEvent {}

class OnGetPlayList extends APIEvent {}

class OnGetSongFromPlayList extends APIEvent {
  final int playListId;

  OnGetSongFromPlayList(this.playListId);
}

class OnAddPlayList extends APIEvent {
  final String name;

  OnAddPlayList(this.name);
}

// player event
abstract class PlaybackEvent {}

class OnNewSong extends PlaybackEvent {
  final Song song;

  OnNewSong(this.song);
}

class OnPositionChange extends PlaybackEvent {
  final int position;

  OnPositionChange(this.position);
}

class OnDurationChange extends PlaybackEvent {
  final int duration;

  OnDurationChange(this.duration);
}

class OnStateChange extends PlaybackEvent {
  final PlayerState state;

  OnStateChange(this.state);
}
