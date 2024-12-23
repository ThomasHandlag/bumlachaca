import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usicat/audio/business/blocs.dart';
import 'package:usicat/audio/data/service/service.dart';
import 'package:usicat/main.dart';
import 'package:usicat/widgets/audio_widget_context.dart';
import 'package:usicat/widgets/custom_lists.dart';
import 'package:usicat/widgets/custom_netimage.dart';
import 'package:usicat/widgets/pulse_container.dart';
import 'package:usicat/widgets/song_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  bool showCheckBox = false;

  Widget createPSongItem(Song song) {
    return SizedBox(
        width: 120,
        height: 120,
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(255 ~/ 2),
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
                        AudioWidgetContext.of(context)!.audioPlayer.setSource(
                              '$url/${song.fileUrl}',
                            );
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

  late TabController tabController;

  @override
  Widget build(BuildContext context) {
    var apiBloc = BlocProvider.of<APIBloc>(context);
    var localBloc = BlocProvider.of<LocalLibBloc>(context);
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
                child: state.newSongs.isNotEmpty
                    ? CustomNetImage(
                        url: state.newSongs[0].fileThumb, height: 250)
                    : const PulseContainer(
                        height: 250,
                      ),
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
              color: Theme.of(context).colorScheme.surface.withAlpha(255 ~/ 2),
            ),
          ),
        )),
        Container(
            height: 250,
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
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
                              child: state.newSongs.isNotEmpty
                                  ? CustomNetImage(
                                      url: state.newSongs[0].fileThumb,
                                      width: 150,
                                      height: 150)
                                  : const PulseContainer(
                                      height: 150,
                                    )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
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
                              : state.newSongs.isNotEmpty
                                  ? Container(
                                      constraints:
                                          const BoxConstraints(maxWidth: 100),
                                      child: Text(
                                        state.newSongs[0].title,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize:
                                                MusicAppThemeData.of(context)
                                                    .textSizeScheme
                                                    .labelMedium,
                                            fontWeight: FontWeight.w600),
                                      ))
                                  : const PulseContainer(
                                      height: 20,
                                    ),
                          const SizedBox(height: 5),
                          state.status == FetChStatus.loading ||
                                  state.status == FetChStatus.error
                              ? PulseContainer(
                                  width: 120,
                                  height: 20,
                                  borderRadius: BorderRadius.circular(10),
                                )
                              : state.newSongs.isNotEmpty
                                  ? Text(
                                      state.newSongs[0].artist,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize:
                                              MusicAppThemeData.of(context)
                                                  .textSizeScheme
                                                  .labelSmall),
                                    )
                                  : const PulseContainer(height: 15),
                          IconButton.filled(
                              onPressed: () {
                                if (state.newSongs.isNotEmpty) {
                                  BlocProvider.of<PlaybackBloc>(context)
                                      .add(OnNewSong(state.newSongs[0]));
                                  String url = AudioApiService.baseUrl;
                                  url = url.replaceAll('/api/v2', '');
                                  AudioWidgetContext.of(context)!
                                      .audioPlayer
                                      .setSource(
                                        '$url/${state.newSongs[0].fileUrl}',
                                      );
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
                    if (state.popularSongs.isNotEmpty) {
                      return createPSongItem(state.popularSongs[index]);
                    } else {
                      return const PulseContainer(width: 120, height: 120);
                    }
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
                  dividerHeight: 1,
                  controller: tabController,
                  tabs: [
                    Tab(
                      child: Text(
                        "Suggest",
                        style: TextStyle(
                            fontSize: MusicAppThemeData.of(context)
                                .textSizeScheme
                                .labelLarge,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Local",
                        style: TextStyle(
                            fontSize: MusicAppThemeData.of(context)
                                .textSizeScheme
                                .labelLarge,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Playlist",
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
                    child: TabBarView(controller: tabController, children: [
                  BlocBuilder<APIBloc, APIState>(
                      bloc: apiBloc..add(OnGetSongs()),
                      builder: (context, state) {
                        return ListChildRender(songs: state.searchSongs);
                      }),
                  BlocBuilder<LocalLibBloc, LocalLibState>(
                      bloc: localBloc..add(OnGetLocalSong()),
                      builder: (_, state) {
                        return LocalSongList(songs: state.localSongs);
                      }),
                  BlocBuilder<LocalLibBloc, LocalLibState>(
                      bloc: localBloc..add(OnGetPlayList()),
                      builder: (_, state) {
                        return PlaylistView(playLists: state.playLists);
                      })
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
                      height: 1,
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
  const ListChildRender({super.key, required this.songs, this.item});
  final List<Song> songs;
  final Widget? item;

  @override
  State<ListChildRender> createState() => _ListChildRenderState();
}

class _ListChildRenderState extends State<ListChildRender> {
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(20),
      child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: widget.item == null
              ? ListView.separated(
                  itemBuilder: (_, index) {
                    return widget.songs.isNotEmpty
                        ? SongItem(song: widget.songs[index])
                        : ListTile(
                            title: PulseContainer(
                              borderRadius: BorderRadius.circular(10),
                              height: 50,
                            ),
                          );
                  },
                  separatorBuilder: (_, index) => const SizedBox(
                        height: 5,
                      ),
                  itemCount: widget.songs.isNotEmpty ? widget.songs.length : 6)
              : widget.item!));
}
