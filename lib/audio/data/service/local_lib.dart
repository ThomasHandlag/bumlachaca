import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite_common/sqflite.dart';
import 'package:usicat/audio/data/service/service.dart';

enum LocalQueryType { all, byId, byName, byPlaylist }

class PlayList extends Equatable {
  final int? id;
  final String name;
  final int count;
  const PlayList({this.id, required this.name, this.count = 0});

  @override
  List<Object?> get props => [id, name, count];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'PlayList { id: $id, name: $name }';
  }
}

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final dbPath = await databaseFactory.getDatabasesPath();
    final path = join(dbPath, 'usicat.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE playlists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');

        await db.execute('''
      CREATE TABLE songs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        url TEXT NOT NULL UNIQUE
      )
    ''');

        await db.execute('''
      CREATE TABLE sop (
        playlistId INTEGER NOT NULL,
        songId INTEGER NOT NULL,
        PRIMARY KEY (playlistId, songId),
        FOREIGN KEY (playlistId) REFERENCES playlists (id) ON DELETE CASCADE,
        FOREIGN KEY (songId) REFERENCES songs (id) ON DELETE CASCADE
      )
    ''');
      },
    );
  }

  // CRUD Operations
  Future<int> addSong(Song item) async {
    final db = await database;
    return await db.insert('songs', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Song>> getSongs() async {
    final db = await database;
    final List<Map<String, dynamic>> list = await db.query('songs');
    return [
      for (final {
            'id': id as int,
            'title': name as String,
            'url': url as String,
          } in list)
        Song(id: id, title: name, fileUrl: url),
    ];
  }

  Future<int> addSOP(Map<String, dynamic> item) async {
    final db = await database;
    return await db.insert(
      'sop',
      item,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> createPlayList(PlayList playList) async {
    final db = await database;
    return await db.insert('playlists', playList.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<PlayList>> getPlayLists() async {
    final db = await database;
    final List<Map<String, dynamic>> counts = await db.rawQuery(
        "SELECT COUNT(songId) as scount FROM sop GROUP BY playlistId");
    final List<Map<String, dynamic>> maps = await db.query('playlists');
    debugPrint(counts.length.toString());
    final List<PlayList> playList = List.generate(maps.length, (i) {
      return PlayList(
        id: maps[i]['id'],
        name: maps[i]['name'],
        count: counts.isNotEmpty ? counts[i]['scount'] : 0,
      );
    });

    return playList;
  }

  Future<int> deletePlayList(int id) async {
    final db = await database;
    return await db.delete(
      'playlists',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updatePlayList(PlayList playList) async {
    final db = await database;
    return await db.update(
      'playlists',
      playList.toMap(),
      where: 'id = ?',
      whereArgs: [playList.id],
    );
  }

  Future<int> deleteSongfromPlayList(int songid, int id) async {
    final db = await database;
    return await db.delete(
      'sop',
      where: 'songId = ? AND playlistId = ?',
      whereArgs: [songid, id],
    );
  }

  Future<List<SOP>> getSOP(int playListId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('sop', where: 'playlistId = ?', whereArgs: [playListId]);
    return [
      for (final {
            'playlistId': playlistId as int,
            'songId': songId as int,
          } in maps)
        SOP(playlistId: playlistId, songId: songId),
    ];
  }

  Future<List<Song>> getSongFromPlayList(List<int> sop) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('songs',
        where: 'id IN (${sop.map((_) => '?').join(', ')})', whereArgs: sop);
    return List.generate(maps.length, (i) {
      return Song(
        id: maps[i]['id'],
        title: maps[i]['title'],
        fileUrl: maps[i]['url'],
      );
    });
  }

  Future<void> deleteSong(int id) async {
    final db = await database;
    await db.delete(
      'songs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class SOP extends Equatable {
  final int playlistId;
  final int songId;

  const SOP({required this.playlistId, required this.songId});

  Map<String, dynamic> toMap() {
    return {
      'playlistId': playlistId,
      'songId': songId,
    };
  }

  @override
  List<Object?> get props => [playlistId, songId];
}
