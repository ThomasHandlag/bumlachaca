import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usicat/audio/business/blocs.dart';
import 'package:usicat/audio/data/service/local_lib.dart';
import 'package:usicat/audio/data/service/service.dart';
import 'package:usicat/screens/home.dart';
import 'package:usicat/screens/playlist_ui.dart';
import 'package:usicat/widgets/audio_widget_context.dart';
import 'package:usicat/widgets/local_item.dart';
import 'package:usicat/widgets/more_btn.dart';

class LocalSongList extends StatefulWidget {
  final List<Song> songs;
  const LocalSongList({super.key, required this.songs});
  @override
  State<LocalSongList> createState() => _LocalSongListState();
}

class _LocalSongListState extends State<LocalSongList> {
  List<bool> checkList = [];
  bool showCheckBox = false;
  bool _checkAll = false;

  @override
  void initState() {
    super.initState();
    checkList = List.generate(widget.songs.length, (index) => false);
  }

  List<Song> _deleteSongs() {
    final temp = <Song>[];
    checkList.asMap().forEach((i, val) {
      val ? temp.add(widget.songs[i]) : null;
    });
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    final localBloc = BlocProvider.of<LocalLibBloc>(context);
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
                      return LocalItem(
                          song: widget.songs[index],
                          onTap: () {
                            BlocProvider.of<PlaybackBloc>(context)
                                .add(OnNewSong(widget.songs[index]));
                          },
                          onLongPress: (int id) {
                            setState(() {
                              showCheckBox = true;
                            });
                            final i = widget.songs.indexWhere((s) => s.id == id);
                            checkList[i]= true;
                          },
                          checked: checkList[index],
                          showCheckBox: showCheckBox,
                          onCheck: (int id) {
                            final i = widget.songs.indexWhere((s) => s.id == id);
                            setState(() {
                              checkList[i] = !checkList[i];
                            });
                          });
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
  bool isPlaying;
  double delta;
  List<double> waveData;
  MiniVisualizer(
      {this.isPlaying = false, required this.delta, required this.waveData});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final path = Path();
    // Bar width and spacing
    double barWidth = size.width / (3 * 2); // Spacing between bars
    double spacing = barWidth / 2;

    for (int i = 0; i < 3; i++) {
      var barHeight = waveData[i] * delta;
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
      delta != oldDelegate.delta && isPlaying;
}
