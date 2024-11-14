import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usicat/audio/business/bloc.dart';
import 'package:usicat/audio/business/state.dart';
import 'package:usicat/audio/data/service/service.dart';
import 'package:usicat/main.dart';
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

  List<Song> songs = [];

  @override
  Widget build(BuildContext context) {
    final Widget _newReleases = Stack(
      children: <Widget>[
        Container(
          height: 250,
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  image: AssetImage('images/thumb2.jpg'), fit: BoxFit.cover)),
        ),
        ClipRect(
            child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            height: 250,
            constraints: BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: Colors.grey.shade200.withOpacity(0.4),
            ),
          ),
        )),
        Container(
            height: 250,
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxWidth: 400),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                        image: AssetImage('images/thumb2.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
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
                          child: Center(
                              child: Text(
                            "rock",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
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
                            child: Center(
                                child: Text(
                              "edm",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            ))),
                        MediaQuery.of(context).size.width > 500
                            ? Container(
                                width: 50,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
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
                    Text(
                      "Love u",
                      style: TextStyle(
                          fontSize: MusicAppThemeData.of(context)
                              .textSizeScheme
                              .headlineSmall,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "NCS",
                      style: TextStyle(fontSize: 15),
                    ),
                    IconButton.filled(
                        onPressed: () {
                          // AudioWidgetContext.of(context)!.audioPlayer.play()
                        },
                        icon: const Icon(Icons.play_arrow))
                  ],
                ))
              ],
            ))
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

    Widget _popular = Container(
        height: 170,
        child: ListView.separated(
            padding: const EdgeInsets.all(5),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, index) {
              return index == 3
                  ? TextButton(
                      onPressed: () {},
                      child: const Text("More"),
                    )
                  : SizedBox(
                      width: 120,
                      height: 120,
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
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
                                image: DecorationImage(
                                    image: AssetImage(
                                        'images/thumb${index + 1}.jpg'),
                                    fit: BoxFit.cover)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("Sky full of stars",
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: MusicAppThemeData.of(context)
                                      .textSizeScheme
                                      .labelMedium)),
                        ],
                      ));
            },
            separatorBuilder: (_, index) {
              return const SizedBox(
                width: 12,
              );
            },
            itemCount: 4));

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
                  ListChildRender(songs: songs),
                  ListChildRender(songs: songs),
                  ListChildRender(songs: songs)
                ]))
              ],
            )));

    List<Widget> items = [
      _newReleases,
      popular,
      resPlaylist,
      const SizedBox(
        height: 10,
      )
    ];

    return Stack(
      children: <Widget>[
        Container(),
        BlocBuilder<PlaybackBloc, PlaybackState>(builder: (context, state) {
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
