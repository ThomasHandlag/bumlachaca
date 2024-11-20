import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usicat/audio/business/bloc.dart';
import 'package:usicat/audio/data/service/service.dart';
import 'package:usicat/main.dart';
import 'package:usicat/widgets/audio_widget_context.dart';
import 'package:usicat/widgets/custom_netimage.dart';
import 'package:usicat/widgets/pulse_container.dart';
import 'package:usicat/widgets/song_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget createPSongItem(Song song) {
    return Container(
        width: 120,
        height: 120,
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Material(
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {
                        BlocProvider.of<PlaybackBloc>(context)
                            .add(OnNewSong(song));
                        String url = AudioApiService.baseUrl;
                        url = url.replaceAll('/api/v2', '');
                        AudioWidgetContext.of(context)!.audioPlayer.play(
                            UrlSource('$url/${song.fileUrl}',
                                mimeType: 'audio/mpeg'));
                      },
                      child: CustomNetImage(
                          url: song.fileThumb, width: 120, height: 120),
                    ))),
            const SizedBox(
              height: 10,
            ),
            Text(song.title,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: MusicAppThemeData.of(context)
                        .textSizeScheme
                        .labelMedium)),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    var apiBloc = BlocProvider.of<APIBloc>(context);
    final Widget newReleases = Stack(
      children: <Widget>[
        BlocBuilder<APIBloc, APIState>(
            builder: (context, state) {
              if (state.status == FetChStatus.loading) {
                return const PulseContainer(
                  height: 250,
                  constraints: BoxConstraints(maxWidth: 500),
                );
              }

              if (state.status == FetChStatus.error) {
                return const PulseContainer(
                    height: 250, constraints: BoxConstraints(maxWidth: 500));
              }
              return Container(
                height: 250,
                constraints: const BoxConstraints(maxWidth: 500),
                child: CustomNetImage(
                    url: state.newSongs[0].fileThumb, height: 250),
              );
            },
            bloc: apiBloc..add(OnGetNewSong())),
        ClipRect(
            child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            height: 250,
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: Colors.grey.shade200.withOpacity(0.4),
            ),
          ),
        )),
        Container(
            height: 250,
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxWidth: 400),
            child: BlocBuilder<APIBloc, APIState>(
                bloc: apiBloc,
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      state.status == FetChStatus.loading ||
                              state.status == FetChStatus.error
                          ? PulseContainer(
                              width: 150,
                              height: 150,
                              borderRadius: BorderRadius.circular(20),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              clipBehavior: Clip.antiAlias,
                              child: CustomNetImage(
                                  url: state.newSongs[0].fileThumb,
                                  width: 150,
                                  height: 150)),
                      const SizedBox(
                        width: 50,
                      ),
                      Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 50,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: Colors.green.shade500,
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Center(
                                    child: Text(
                                  "rock",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                  width: 50,
                                  height: 15,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: const Center(
                                      child: Text(
                                    "edm",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ))),
                              MediaQuery.of(context).size.width > 500
                                  ? Container(
                                      width: 50,
                                      height: 15,
                                      decoration: BoxDecoration(
                                          color: Colors.purple,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: const Center(
                                          child: Text(
                                        "pop",
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      )))
                                  : Container(),
                              const SizedBox(
                                width: 5,
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          state.status == FetChStatus.loading ||
                                  state.status == FetChStatus.error
                              ? PulseContainer(
                                  width: 120,
                                  height: 20,
                                  borderRadius: BorderRadius.circular(10),
                                )
                              : Text(
                                  state.newSongs[0].title,
                                  style: TextStyle(
                                      fontSize: MusicAppThemeData.of(context)
                                          .textSizeScheme
                                          .headlineSmall,
                                      fontWeight: FontWeight.w600),
                                ),
                          const SizedBox(height: 5),
                          state.status == FetChStatus.loading ||
                                  state.status == FetChStatus.error
                              ? PulseContainer(
                                  width: 120,
                                  height: 20,
                                  borderRadius: BorderRadius.circular(10),
                                )
                              : Text(
                                  state.newSongs[0].artist,
                                  style: const TextStyle(fontSize: 15),
                                ),
                          IconButton.filled(
                              onPressed: () {
                                if (state.newSongs.isNotEmpty) {
                                  BlocProvider.of<PlaybackBloc>(context)
                                      .add(OnNewSong(state.newSongs[0]));
                                  String url = AudioApiService.baseUrl;
                                  url = url.replaceAll('/api/v2', '');
                                  AudioWidgetContext.of(context)!
                                      .audioPlayer
                                      .play(UrlSource(
                                          '$url/${state.newSongs[0].fileUrl}',
                                          mimeType: 'audio/mpeg'));
                                }
                              },
                              icon: const Icon(Icons.play_arrow))
                        ],
                      ))
                    ],
                  );
                }))
      ],
    );

    Widget popularText = Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Popular",
                style: TextStyle(
                    fontSize:
                        MusicAppThemeData.of(context).textSizeScheme.labelLarge,
                    fontWeight: FontWeight.w600)),
          ],
        ));

    Widget _popular = SizedBox(
        height: 170,
        child: BlocBuilder<APIBloc, APIState>(
            bloc: apiBloc..add(OnGetMostPopularSong()),
            builder: (context, state) {
              return ListView.separated(
                  padding: const EdgeInsets.all(5),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (_, index) {
                    return createPSongItem(state.popularSongs[index]);
                  },
                  separatorBuilder: (_, index) {
                    return const SizedBox(
                      width: 12,
                    );
                  },
                  itemCount: state.popularSongs.length);
            }));

    Widget popular = Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [popularText, _popular],
      ),
    );

    Widget resPlaylist = SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  dividerHeight: 0,
                  tabs: [
                    Tab(
                      child: Text(
                        "Recently",
                        style: TextStyle(
                            fontSize: MusicAppThemeData.of(context)
                                .textSizeScheme
                                .labelLarge,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Top Charts",
                        style: TextStyle(
                            fontSize: MusicAppThemeData.of(context)
                                .textSizeScheme
                                .labelLarge,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Similar",
                        style: TextStyle(
                            fontSize: MusicAppThemeData.of(context)
                                .textSizeScheme
                                .labelLarge,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                Expanded(
                    child: TabBarView(children: [
                  BlocBuilder<APIBloc, APIState>(
                      bloc: apiBloc..add(OnGetSongs()),
                      builder: (context, state) {
                        return ListChildRender(songs: state.searchSongs);
                      }),
                  ListChildRender(songs: []),
                  ListChildRender(songs: [])
                ]))
              ],
            )));

    List<Widget> items = [
      newReleases,
      popular,
      resPlaylist,
      const SizedBox(
        height: 10,
      )
    ];

    return Stack(
      children: <Widget>[
        Container(),
        BlocBuilder<PlaybackBloc, PlaybackState>(
            bloc: BlocProvider.of<PlaybackBloc>(context),
            builder: (context, state) {
              return ListView.separated(
                  itemBuilder: (_, index) {
                    return items[index];
                  },
                  separatorBuilder: (_, index) {
                    return const SizedBox(
                      height: 5,
                    );
                  },
                  itemCount: 4);
            })
      ],
    );
  }
}

// system context, container, component architexture

class ListChildRender extends StatefulWidget {
  const ListChildRender({super.key, required this.songs});
  final List<Song> songs;

  @override
  State<ListChildRender> createState() => _ListChildRenderState();
}

class _ListChildRenderState extends State<ListChildRender> {
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(20),
      child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: ListView.separated(
              itemBuilder: (_, index) {
                return SongItem(song: widget.songs[index]);
              },
              separatorBuilder: (_, index) => const SizedBox(
                    height: 10,
                  ),
              itemCount: widget.songs.length)));
}
