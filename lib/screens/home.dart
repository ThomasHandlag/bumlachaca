import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:usicat/audio/model/song.dart';
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

  List<Song> songs = [
    Song(
      id: '1',
      title: 'Song 1',
      artist: 'Artist 1',
      thumb: 'https://via.placeholder.com/150',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    ),
    Song(
      id: '2',
      title: 'Song 2',
      artist: 'Artist 2',
      thumb: 'https://via.placeholder.com/150',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    ),
    Song(
      id: '3',
      title: 'Song 3',
      artist: 'Artist 3',
      thumb: 'https://via.placeholder.com/150',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    ),
    Song(
      id: '4',
      title: 'Song 4',
      artist: 'Artist 4',
      thumb: 'https://via.placeholder.com/150',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
    ),
    Song(
      id: '5',
      title: 'Song 5',
      artist: 'Artist 5',
      thumb: 'https://via.placeholder.com/150',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
    ),
    Song(
      id: '6',
      title: 'Song 6',
      artist: 'Artist 6',
      thumb: 'https://via.placeholder.com/150',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
    ),
    Song(
      id: '7',
      title: 'Song 7',
      artist: 'Artist 7',
      thumb: 'https://via.placeholder.com/150',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
    ),
    Song(
      id: '8',
      title: 'Song 8',
      artist: 'Artist 8',
      thumb: 'https://via.placeholder.com/150',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
    ),
    Song(
      id: '8',
      title: 'Song 8',
      artist: 'Artist 8',
      thumb: 'https://via.placeholder.com/150',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
    ),
    Song(
      id: '8',
      title: 'Song 8',
      artist: 'Artist 8',
      thumb: 'https://via.placeholder.com/150',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
    ),
    Song(
      id: '8',
      title: 'Song 8',
      artist: 'Artist 8',
      thumb: 'https://via.placeholder.com/150',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
    ),
    Song(
      id: '8',
      title: 'Song 8',
      artist: 'Artist 8',
      thumb: 'https://via.placeholder.com/150',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
    ),
    Song(
      id: '8',
      title: 'Song 8',
      artist: 'Artist 8',
      thumb: 'https://via.placeholder.com/150',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
    ),
    Song(
      id: '8',
      title: 'Song 8',
      artist: 'Artist 8',
      thumb: 'https://via.placeholder.com/150',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
    )
  ];

  @override
  Widget build(BuildContext context) {
    final Widget _newReleases = Stack(
      children: <Widget>[
        Container(
          height: 200,
          constraints: BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  image: AssetImage('images/thumb1.jpg'), fit: BoxFit.cover)),
        ),
        ClipRect(
            child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            height: 200,
            constraints: BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: Colors.grey.shade200.withOpacity(0.6),
            ),
          ),
        )),
        Container(
            height: 200,
            padding: EdgeInsets.all(20),
            constraints: BoxConstraints(maxWidth: 500),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                        image: AssetImage('images/thumb1.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(
                  width: 20,
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
                    const Text(
                      "Far Away",
                      style: TextStyle(fontSize: 20),
                    ),
                    const Text(
                      "NCS",
                      style: TextStyle(fontSize: 15),
                    ),
                    ElevatedButton(
                        onPressed: () {}, child: Icon(Icons.play_arrow))
                  ],
                ))
              ],
            ))
      ],
    );

    Widget _popularText = const Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Popular"),
          ],
        ));

    Widget _popular = SizedBox(
        height: 120,
        child: ListView.separated(
            padding: const EdgeInsets.all(10),
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemBuilder: (_, index) {
              return index == 3
                  ? TextButton(
                      onPressed: () {},
                      child: const Text("More"),
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: AssetImage('images/thumb${index + 1}.jpg'),
                              fit: BoxFit.cover)),
                    );
            },
            separatorBuilder: (_, index) {
              return const SizedBox(
                width: 10,
              );
            },
            itemCount: 4));

    Widget _recentPlayed = SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const TabBar(
                  dividerHeight: 0,
                  tabs: [
                    Tab(
                      child: Text(
                        "Recently",
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Top Charts",
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Recommended",
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
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
      _popularText,
      _popular,
      _recentPlayed,
      const SizedBox(
        height: 10,
      )
    ];

    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Container(),
            ListView.separated(
                itemBuilder: (_, index) {
                  return items[index];
                },
                separatorBuilder: (_, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: 5)
          ],
        ));
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
      padding: EdgeInsets.all(20),
      child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: ListView.separated(
              itemBuilder: (_, index) {
                return SongItem();
              },
              separatorBuilder: (_, index) => const SizedBox(
                    height: 10,
                  ),
              itemCount: widget.songs.length)));
}
