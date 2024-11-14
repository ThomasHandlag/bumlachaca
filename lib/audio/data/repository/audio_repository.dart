import 'package:usicat/audio/data/service/service.dart';

class AudioRepository {
  final AudioApiService apiService;

  AudioRepository(this.apiService);

  Future<List<Song>> getAudioFiles() async {
    return await apiService.getSongs();
  }

  Future<Map<String, Song>> getAudioFileById(String id) async {
    return await apiService.getSongById(id);
  }

  Future<List<Song>> getAudioFileByKeyword(String keyword) async {
    return await apiService.getSongByKeyword(keyword);
  }

  Future<List<Song>> getAudioFileByGenre(String genre) async {
    return await apiService.getSongByGenre(genre);
  }

  Future<Map<String, Song>> getMostPopularAudioFile() async {
    return await apiService.getMostPopularSong();
  }
}

class LocalAudioRepo {
  final LocalAudioService localAudioService;

  LocalAudioRepo(this.localAudioService);

  Future<List<Song>> getLocalAudioFiles() async {
    return await localAudioService.getLocalSongs();
  }

  Future<Map<String, Song>> getLocalAudioFileById(String id) async {
    return await localAudioService.getLocalSongById(id);
  }
}
