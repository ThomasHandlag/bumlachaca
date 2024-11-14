import 'dart:convert';
import 'package:http/http.dart' as http;

class Song {
  final int id;
  final String title;
  final String artist;
  final String genre;
  final String fileThumb;
  final String fileUrl;
  final int playCount;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.genre,
    required this.fileThumb,
    required this.fileUrl,
    required this.playCount,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      genre: json['genre'],
      fileThumb: json['file_thumb'],
      fileUrl: json['file_url'],
      playCount: json['play_count'],
    );
  }
}

class AudioApiService {
  final String baseUrl = '';

  Future<List<Song>> getSongs() async {
    final response = await http.get(Uri.parse('$baseUrl/getSongs'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Song.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load audio files');
    }
  }

  Future<Map<String, Song>> getSongById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/getSong/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load song');
    }
  }

// get song by keyword
  Future<List<Song>> getSongByKeyword(String keyword) async {
    final response =
        await http.get(Uri.parse('$baseUrl/getSongByKeyword/$keyword'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load song by keyword');
    }
  }

// get song by genre
  Future<List<Song>> getSongByGenre(String genre) async {
    final response =
        await http.get(Uri.parse('$baseUrl/getSongByGenre/$genre'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load song by genre');
    }
  }

// get the most popular song
  Future<Map<String, Song>> getMostPopularSong() async {
    final response = await http.get(Uri.parse('$baseUrl/getMostPopularSong'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load most popular song');
    }
  }

// get song by data
  Future<List<Song>> getSongByData() async {
    final response = await http.get(Uri.parse('$baseUrl/getSongByData'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load song by data');
    }
  }

// get the newest song
  Future<Map<String, Song>> getNewestSong() async {
    final response = await http.get(Uri.parse('$baseUrl/getNewestSong'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load newest song');
    }
  }

// get song by tag integer
  Future<List<Song>> getSongByTagInt(int tagInt) async {
    final response =
        await http.get(Uri.parse('$baseUrl/getSongByTagInt/$tagInt'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load song by tag');
    }
  }
}

class LocalAudioService {
  getLocalSongs() {}

  getLocalSongById(String id) {}
}
