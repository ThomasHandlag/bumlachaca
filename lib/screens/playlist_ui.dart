import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usicat/audio/business/bloc.dart';
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
                    decoration: const InputDecoration(
                      labelText: 'Playlist Name',
                    ),
                    onChanged: (value) => playlistName = value,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<LocalLibBloc>(context)
                          .add(OnAddPlayList(playlistName));
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
    final localLibBloc = BlocProvider.of<LocalLibBloc>(context);
    showDialog(
        context: context,
        builder: (context) {
          return Dialog.fullscreen(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10),
                    height: kToolbarHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                  Expanded(
                    child: BlocBuilder<LocalLibBloc, LocalLibState>(
                        bloc: localLibBloc..add(OnGetSongFromPlayList(id)),
                        builder: (context, state) {
                          return ListView.builder(
                            itemCount: state.localSongs.length,
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
                                title: Text(state.localSongs[index].title),
                                onTap: () {
                                  final url =
                                      "${AudioApiService.url.replaceAll("/api/v2", "")}/${state.localSongs[index].fileUrl}";
                                  AudioWidgetContext.of(context)!
                                      .audioPlayer
                                      .play(UrlSource(url));
                                  BlocProvider.of<PlaybackBloc>(context)
                                      .add(OnNewSong(state.localSongs[index]));
                                },
                              );
                            },
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                if (state.localSongs.isEmpty) {
                  return const Center(
                    child: ErrorContainer(
                      width: 300,
                      height: 300,
                      message: 'No playlist found',
                    ),
                  );
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.playLists.length,
                        itemBuilder: (context, index) {
                          final playLists = state.playLists[index];
                          return ListTile(
                            title: Text(playLists.name),
                            onTap: () {
                              setState(() {
                                _showDetailDialog(playLists.id ?? 1);
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
              bloc: BlocProvider.of<LocalLibBloc>(context))
        ],
      ),
    );
  }
}
