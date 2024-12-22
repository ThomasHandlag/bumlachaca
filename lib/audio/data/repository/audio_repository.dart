import 'package:usicat/audio/data/service/local_lib.dart';
import 'package:usicat/audio/data/service/service.dart';

class AudioRepository {
  final AudioApiService apiService;

  AudioRepository(this.apiService);

  Future<List<Song>> getSongs() async {
    return await apiService.getSongs();
  }

  Future<List<Song>> getSongById(String id) async {
    return await apiService.getSongById(id);
  }

  Future<List<Song>> getSongByKeyword(String keyword) async {
    return await apiService.getSongByKeyword(keyword);
  }

  Future<List<Song>> getSongByGenre(String genre) async {
    return await apiService.getSongByGenre(genre);
  }

  Future<List<Song>> getMostPopularSong() async {
    return await apiService.getMostPopularSong();
  }

  Future<List<Song>> getNewSong() async {
    return await apiService.getNewestSong();
  }
}

class LocalAudioRepo {
  final DatabaseHelper db;
  LocalAudioRepo(this.db);
  Future<List<Song>> getLocalSongs() async {
    return await db.getSongs();
  }

  Future<List<PlayList>> getPlayLists() async {
    return await db.getPlayLists();
  }

  Future<List<Song>> getSongFromPlayList(List<SOP> sop) async {
    return await db.getSongFromPlayList(sop.map((e) => e.songId).toList());
  }

  Future<List<SOP>> getSOP(int id) async {
    return await db.getSOP(id);
  }

  Future<void> createPlayList(String name) async {
    await db.createPlayList(PlayList(name: name));
  }

  Future<void> deletePlayList(int id) async {
    await db.deletePlayList(id);
  }

  Future<void> addLocalSongs(List<Song> songs) async {
    for (final song in songs) {
      await db.addSong(song);
    }
  }

  Future<void> deleteLocalSongs(List<Song> songs) async {
    for (final song in songs) {
      await db.deleteSong(song.id!);
    }
  }

  Future<void> deleteSongsFromPlayList(List<Song> songs, int id) async {
    for (final song in songs) {
      await db.deleteSongfromPlayList(song.id!, id);
    }
  }

  Future<void> addSongsToPlayList(int id, List<Song> songs) async {
    for (final song in songs) {
      await db.addSOP(SOP(playlistId: id, songId: song.id!).toMap());
    }
  }
}
