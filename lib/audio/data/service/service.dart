import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

class Song extends Equatable {
  final int? id;
  final String title;
  final String artist;
  final String genre;
  final String fileThumb;
  final String fileUrl;
  final int playCount;
  final int playListId;

  const Song({
    this.id,
    required this.title,
    this.artist = "",
    this.genre = "",
    this.fileThumb = "",
    required this.fileUrl,
    this.playCount = 0,
    this.playListId = 1,
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

  @override
  List<Object?> get props =>
      [id, title, artist, genre, fileThumb, fileUrl, playCount];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': fileUrl,
    };
  }

  @override
  String toString() {
    return 'Song { id: $id, title: $title, artist: $artist, genre: $genre, fileThumb: $fileThumb, fileUrl: $fileUrl, playCount: $playCount }';
  }
}

class AudioApiService {
  // final String baseUrl = 'https://knowing-ray-trivially.ngrok-free.app/api/v2';
  static String baseUrl = 'http://192.168.100.101:3000/api/v2';

  static String get url => baseUrl;

  Future<List<Song>> getSongs() async {
    final response = await http.get(Uri.parse('$baseUrl/getSongs'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Song.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load audio files');
    }
  }

  Future<List<Song>> getSongById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/getSong/$id'));
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((json) => Song.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load song');
    }
  }

// get song by keyword
  Future<List<Song>> getSongByKeyword(String keyword) async {
    final response =
        await http.get(Uri.parse('$baseUrl/getSongByKeyword/$keyword'));
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((json) => Song.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load song by keyword');
    }
  }

// get song by genre
  Future<List<Song>> getSongByGenre(String genre) async {
    final response =
        await http.get(Uri.parse('$baseUrl/getSongByGenre/$genre'));
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((json) => Song.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load song by genre');
    }
  }

// get the most popular song
  Future<List<Song>> getMostPopularSong() async {
    final response = await http.get(Uri.parse('$baseUrl/getMostPopularSong'));
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((json) => Song.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load most popular song');
    }
  }

// get song by data
  Future<List<Song>> getSongByData() async {
    final response = await http.get(Uri.parse('$baseUrl/getSongByData'));
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((json) => Song.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load song by data');
    }
  }

// get the newest song
  Future<List<Song>> getNewestSong() async {
    final response = await http.get(Uri.parse('$baseUrl/getNewestSong'));
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((json) => Song.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load newest song');
    }
  }

// get song by tag integer
  Future<List<Song>> getSongByTagInt(int tagInt) async {
    final response =
        await http.get(Uri.parse('$baseUrl/getSongByTagInt/$tagInt'));
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((json) => Song.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load song by tag');
    }
  }
}
