import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usicat/audio/business/bloc.dart';
import 'package:usicat/audio/data/service/local_lib.dart';
import 'package:usicat/audio/data/service/service.dart';
import 'package:usicat/screens/home.dart';
import 'package:usicat/screens/playlist_ui.dart';
import 'package:usicat/widgets/audio_widget_context.dart';
import 'package:usicat/widgets/more_btn.dart';

class LocalSongList extends StatefulWidget {
  final List<Song> songs;
  const LocalSongList({super.key, required this.songs});
  @override
  State<LocalSongList> createState() => _LocalSongListState();
}

class _LocalSongListState extends State<LocalSongList>
    with TickerProviderStateMixin {
  List<bool> checkList = [];
  bool showCheckBox = false;
  bool _checkAll = false;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    checkList = List.generate(widget.songs.length, (index) => false);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  List<Song> _deleteSongs() {
    final temp = <Song>[];
    checkList.asMap().forEach((i, val) {
      val ? temp.add(widget.songs[i]) : null;
    });
    return temp;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = AudioWidgetContext.of(context)!.audioPlayer;
    final localBloc = BlocProvider.of<LocalLibBloc>(context);
    final playerBloc = BlocProvider.of<PlaybackBloc>(context);
    return ListChildRender(
        songs: widget.songs,
        item: Column(
          children: [
            SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    !showCheckBox
                        ? ElevatedButton.icon(
                            onPressed: () {
                              FilePicker.platform
                                  .pickFiles(
                                allowMultiple: true,
                                type: FileType.audio,
                                allowedExtensions: const ["mp3", "wav", "flac"],
                                lockParentWindow: true,
                                dialogTitle: "Add song",
                              )
                                  .then((rs) {
                                if (rs != null && rs.files.isNotEmpty) {
                                  final songs = <Song>[];
                                  for (final file in rs.files) {
                                    songs.add(Song(
                                        title: file.name,
                                        fileUrl:
                                            file.path!.replaceAll("\\", "/")));
                                  }
                                  localBloc.add(OnAddLocalSongs(songs));
                                }
                              });
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Add Song"))
                        : ElevatedButton(
                            onPressed: () {
                              setState(() {
                                showCheckBox = false;
                              });
                              for (int i = 0; i < checkList.length; i++) {
                                checkList[i] = false;
                              }
                            },
                            child: const Text("Cancel")),
                    showCheckBox
                        ? ElevatedButton.icon(
                            onPressed: () {
                              localBloc.add(OnDeleteLocalSongs(_deleteSongs()));
                            },
                            icon: const Icon(Icons.delete),
                            label: const Text("Delete"))
                        : Container(),
                    showCheckBox
                        ? Checkbox(
                            value: _checkAll,
                            onChanged: (_) {
                              setState(() {
                                _checkAll = !_checkAll;
                              });
                              final temp = checkList.map((val) => _checkAll);
                              for (int i = 0; i < checkList.length; i++) {
                                checkList[i] = temp.elementAt(i);
                              }
                            })
                        : Container(),
                  ],
                )),
            const Divider(
              height: 2,
              color: Colors.grey,
            ),
            Expanded(
                child: ListView.separated(
                    itemBuilder: (_, index) {
                      final bool isPlaying =
                          playerBloc.state.song == widget.songs[index];
                      return ListTile(
                          onTap: () {
                            audioPlayer.play(UrlSource(
                                widget.songs[index].fileUrl
                                    .replaceAll('\\', '/'),
                                mimeType: "audio/mpeg"));
                            final i = localBloc.state.localSongs.indexWhere(
                                (element) => element == widget.songs[index]);
                            playerBloc.add(OnPlayAtIndex(i));
                            playerBloc.add(OnNewSong(widget.songs[index]));
                          },
                          onLongPress: () {
                            setState(() {
                              showCheckBox = true;
                            });
                            checkList[index] = true;
                          },
                          leading: isPlaying
                              ? AnimatedBuilder(
                                  animation: _controller,
                                  builder: (_, child) {
                                    return CustomPaint(
                                      painter: MiniVisualizer(
                                          waveData: [0, 0, 0],
                                          isPlaying: isPlaying,
                                          delta: _controller.value),
                                      child: const SizedBox(
                                        width: 30,
                                        height: 20,
                                      ),
                                    );
                                  })
                              : Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFF3465F3),
                                      shape: BoxShape.circle),
                                ),
                          title: Text(widget.songs[index].title),
                          subtitle: const Text("Unknown"),
                          trailing: showCheckBox
                              ? Checkbox(
                                  value: checkList[index],
                                  onChanged: (val) {
                                    setState(() {
                                      checkList[index] = val!;
                                    });
                                  })
                              : MoreButton(children: [
                                  PopupMenuItem(
                                    child: const Text("Add to playlist"),
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            final playLists =
                                                localBloc.state.playLists;
                                            return Dialog(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                width: 300,
                                                height: 500,
                                                child: Column(
                                                  children: [
                                                    const Text(
                                                        "Add to playlist"),
                                                    const Divider(
                                                      height: 2,
                                                    ),
                                                    Expanded(
                                                        child: ListView.builder(
                                                            itemCount: playLists
                                                                .length,
                                                            itemBuilder:
                                                                ((_, pIndex) {
                                                              return ListTile(
                                                                title: Text(
                                                                    playLists[
                                                                            pIndex]
                                                                        .name),
                                                                onTap: () {
                                                                  localBloc.add(
                                                                      OnAddSongsToPlaylist([
                                                                    widget.songs[
                                                                        index]
                                                                  ], playLists[pIndex].id!));
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              );
                                                            }))),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            "Cancel"))
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                ]));
                    },
                    separatorBuilder: (_, index) => const SizedBox(),
                    itemCount: widget.songs.length))
          ],
        ));
  }
}

class PlaylistView extends StatefulWidget {
  final List<PlayList> playLists;
  const PlaylistView({super.key, required this.playLists});
  @override
  State<PlaylistView> createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  List<bool> checkList = [];
  bool showCheckBox = false;
  bool _checkAll = false;
  @override
  void initState() {
    super.initState();
    checkList = List.generate(widget.playLists.length, (index) => false);
  }

  List<PlayList> _deleteList() {
    final temp = <PlayList>[];
    checkList.asMap().forEach((i, val) {
      val ? temp.add(widget.playLists[i]) : null;
    });
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = AudioWidgetContext.of(context)!.audioPlayer;
    final localBloc = BlocProvider.of<LocalLibBloc>(context);
    final playerBloc = BlocProvider.of<PlaybackBloc>(context);
    return Column(
      children: [
        SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                showCheckBox
                    ? ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showCheckBox = false;
                          });
                          for (int i = 0; i < checkList.length; i++) {
                            checkList[i] = false;
                          }
                        },
                        child: const Text("Cancel"))
                    : Container(),
                showCheckBox
                    ? ElevatedButton.icon(
                        onPressed: () {
                          localBloc.add(OnDeletePlaylists(_deleteList()));
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text("Delete"))
                    : Container(),
                showCheckBox
                    ? Checkbox(
                        value: _checkAll,
                        onChanged: (_) {
                          setState(() {
                            _checkAll = !_checkAll;
                          });
                          final temp = checkList.map((val) => _checkAll);
                          for (int i = 0; i < checkList.length; i++) {
                            checkList[i] = temp.elementAt(i);
                          }
                        })
                    : Container(),
              ],
            )),
        const Divider(
          height: 2,
          color: Colors.grey,
        ),
        Expanded(
            child: ListView.separated(
                itemBuilder: (_, index) {
                  return ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) =>
                              BlocBuilder<LocalLibBloc, LocalLibState>(
                                  bloc: localBloc
                                    ..add(OnGetSongFromPlayList(
                                        widget.playLists[index].id!)),
                                  builder: (_, state) {
                                    return DetailPlayList(
                                        id: widget.playLists[index].id!,
                                        audioPlayer: audioPlayer,
                                        playbackBloc: playerBloc,
                                        bloc: localBloc,
                                        songs: state.cacheSongs);
                                  }));
                    },
                    internalAddSemanticForOnTap: true,
                    hoverColor: Colors.blue,
                    onLongPress: () {
                      setState(() {
                        showCheckBox = true;
                      });
                      checkList[index] = true;
                    },
                    leading: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                          color: Color(0xFF346523), shape: BoxShape.circle),
                    ),
                    title: Text(widget.playLists[index].name),
                    subtitle: Text("${widget.playLists[index].count} songs"),
                    trailing: showCheckBox
                        ? Checkbox(
                            value: checkList[index],
                            onChanged: (val) {
                              setState(() {
                                checkList[index] = val!;
                              });
                            })
                        : MoreButton(children: [
                            PopupMenuItem(
                                child: const Text("Delete"),
                                onTap: () {
                                  localBloc.add(OnDeletePlaylists(
                                      [widget.playLists[index]]));
                                })
                          ]),
                  );
                },
                separatorBuilder: (_, index) => const SizedBox(),
                itemCount: widget.playLists.length))
      ],
    );
  }
}

class MiniVisualizer extends CustomPainter {
  final List<double> waveData;
  bool isPlaying;
  final double delta;
  MiniVisualizer(
      {required this.waveData, this.isPlaying = false, required this.delta});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final path = Path();
    int barCount = 3;
    final random = Random();
    waveData[0] = random.nextDouble();
    waveData[1] = random.nextDouble();
    waveData[2] = random.nextDouble();
    // Bar width and spacing
    double barWidth = size.width / (barCount * 1.5); // Spacing between bars
    double spacing = barWidth / 2;
    final maxV =
        waveData.reduce((value, element) => value > element ? value : element);
    for (int i = 0; i < barCount; i++) {
      var barHeight = waveData[i] / maxV * delta * size.height;
      if (barHeight > size.height) {
        barHeight = size.height;
      }
      double x = i * (barWidth + spacing);
      Rect barRect =
          Rect.fromLTWH(x, size.height - barHeight, barWidth, barHeight);
      // Draw the bar
      canvas.drawRect(barRect, paint);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(MiniVisualizer oldDelegate) =>
      waveData != oldDelegate.waveData && isPlaying;
}
