import 'package:audiopc/audiopc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usicat/audio/business/blocs.dart';
import 'package:usicat/audio/data/service/service.dart';
import 'package:usicat/widgets/audio_widget_context.dart';
import 'package:usicat/widgets/error_container.dart';

class PlaylistUI extends StatefulWidget {
  const PlaylistUI({super.key});

  @override
  State createState() => _PlaylistUIState();
}

class _PlaylistUIState extends State<PlaylistUI> {
  void _createPlayList() {
    final bloc = BlocProvider.of<LocalLibBloc>(context);

    showDialog(
        context: context,
        builder: (context) {
          String playlistName = 'Unamed Playlist';
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Create Playlist'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: TextEditingController(text: playlistName),
                    decoration: const InputDecoration(
                      labelText: 'Playlist Name',
                    ),
                    onChanged: (value) => playlistName = value,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      bloc.add(OnAddPlayList(playlistName));
                      Navigator.pop(context);
                    },
                    child: const Text('Create'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showDetailDialog(int id) {
    final playbackBloc = BlocProvider.of<PlaybackBloc>(context);
    final audioPlayer = AudioWidgetContext.of(context)!.audioPlayer;
    final localLibBloc = BlocProvider.of<LocalLibBloc>(context);
    showDialog(
        context: context,
        builder: (context) {
          return BlocBuilder<LocalLibBloc, LocalLibState>(
              bloc: localLibBloc..add(OnGetSongFromPlayList(id)),
              builder: (_, state) {
                return DetailPlayList(
                    audioPlayer: audioPlayer,
                    playbackBloc: playbackBloc,
                    id: id,
                    bloc: localLibBloc,
                    songs: state.cacheSongs);
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LocalLibBloc>(context);
    return SizedBox(
      child: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    _createPlayList();
                  },
                  child: const Text('New Playlist'))
            ],
          ),
          BlocBuilder<LocalLibBloc, LocalLibState>(
              builder: (context, state) {
                if (state.playLists.isEmpty) {
                  return const Center(
                    child: ErrorContainer(
                      width: 300,
                      height: 300,
                      message: 'No playlist found',
                    ),
                  );
                }
                return Expanded(
                    child: ListView.builder(
                  itemCount: state.playLists.length,
                  itemBuilder: (context, index) {
                    final playLists = state.playLists[index];
                    return ListTile(
                      leading: Container(
                        width: 15,
                        height: 15,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      title: Text(playLists.name),
                      subtitle: Text('${playLists.count} songs'),
                      onTap: () {
                        setState(() {
                          _showDetailDialog(playLists.id!);
                        });
                      },
                    );
                  },
                ));
              },
              bloc: bloc..add(OnGetPlayList()))
        ],
      ),
    );
  }
}

class DetailPlayList extends StatefulWidget {
  final int id;
  final LocalLibBloc bloc;
  final PlaybackBloc? playbackBloc;
  final List<Song> songs;
  final Audiopc? audioPlayer;
  const DetailPlayList(
      {super.key,
      required this.id,
      required this.bloc,
      required this.songs,
      this.playbackBloc,
      this.audioPlayer});

  @override
  State createState() => _DetailPlayListState();
}

class _DetailPlayListState extends State<DetailPlayList> {
  List<bool> checkList = [];
  bool showCheckBox = false;
  bool _checkAll = false;
  @override
  void initState() {
    super.initState();
    checkList = List.generate(widget.songs.length, (index) => false);
  }

  List<Song> _deleteList() {
    final temp = <Song>[];
    checkList.asMap().forEach((i, val) {
      val ? temp.add(widget.songs[i]) : null;
    });
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
        insetAnimationCurve: Curves.bounceIn,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                height: kToolbarHeight + 10,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 10),
                    const Text('Playlist Detail'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
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
                            widget.bloc.add(OnDeleteSongsFromPlayList(
                                _deleteList(), widget.id));
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
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.songs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Container(
                        width: 15,
                        height: 15,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      title: Text(widget.songs[index].title),
                      onTap: () {
                        if (widget.audioPlayer != null) {
                          final i = widget.bloc.state.localSongs.indexWhere(
                              (element) => element == widget.songs[index]);
                          widget.playbackBloc!.add(OnPlayAtIndex(i));
                          widget.playbackBloc!
                              .add(OnNewSong(widget.bloc.state.localSongs[i]));
                          widget.audioPlayer!.setSource(
                              widget.bloc.state.localSongs[i].fileUrl);
                        }
                      },
                      onLongPress: () {
                        setState(() {
                          showCheckBox = true;
                        });
                        checkList[index] = true;
                      },
                      trailing: showCheckBox
                          ? Checkbox(
                              value: checkList[index],
                              onChanged: (val) {
                                setState(() {
                                  checkList[index] = val!;
                                });
                              },
                            )
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
