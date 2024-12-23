part of 'blocs.dart';

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

class OnDeleteSongsFromPlayList extends APIEvent {
  final List<Song> songs;
  final int id;
  OnDeleteSongsFromPlayList(this.songs, this.id);
}

class OnDeleteLocalSongs extends APIEvent {
  final List<Song> songs;
  OnDeleteLocalSongs(this.songs);
}

class OnAddLocalSongs extends APIEvent {
  final List<Song> songs;
  OnAddLocalSongs(this.songs);
}

class OnGetSongFromPlayList extends APIEvent {
  final int playListId;

  OnGetSongFromPlayList(this.playListId);
}

class OnAddSongsToPlaylist extends APIEvent {
  final List<Song> songs;
  final int id;

  OnAddSongsToPlaylist(this.songs, this.id);
}

class OnAddPlayList extends APIEvent {
  final String name;

  OnAddPlayList(this.name);
}

class OnDeletePlaylists extends APIEvent {
  final List<PlayList> playLists;

  OnDeletePlaylists(this.playLists);
}

// player event
abstract class PlaybackEvent {}

class OnNewSong extends PlaybackEvent {
  final Song song;

  OnNewSong(this.song);
}

class OnPositionChange extends PlaybackEvent {
  final double position;

  OnPositionChange(this.position);
}

class OnDurationChange extends PlaybackEvent {
  final double duration;

  OnDurationChange(this.duration);
}

class OnStateChange extends PlaybackEvent {
  final AudiopcState state;

  OnStateChange(this.state);
}

class OnPlayFromPlaylist extends PlaybackEvent {
  final List<Song> songs;

  OnPlayFromPlaylist(this.songs);
}

class OnPlayAtIndex extends PlaybackEvent {
  final int index;

  OnPlayAtIndex(this.index);
}

class OnPlayModeChange extends PlaybackEvent {
  final int mode;

  OnPlayModeChange(this.mode);
}

class OnSamplesChange extends PlaybackEvent {
  final List<double> samples;

  OnSamplesChange(this.samples);
}


//
abstract class GlobalUIEvent {}

class OnChangePage extends GlobalUIEvent {
  final int index;

  OnChangePage(this.index);
}

class OnChangeTheme extends GlobalUIEvent {
  final bool isDark;

  OnChangeTheme(this.isDark);
}

class OnChangeColorScheme extends GlobalUIEvent {
  final ColorScheme colorScheme;

  OnChangeColorScheme(this.colorScheme);
}

class OnLoadSettings extends GlobalUIEvent {}
