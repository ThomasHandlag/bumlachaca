import 'dart:math';
import 'dart:ui';
import 'package:audiopc/audiopc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usicat/audio/business/blocs.dart';
import 'package:usicat/audio/data/repository/audio_repository.dart';
import 'package:usicat/audio/data/service/service.dart';
import 'package:usicat/main.dart';
import 'package:usicat/screens/about.dart';
import 'package:usicat/screens/home.dart';
import 'package:usicat/screens/playlist_ui.dart';
import 'package:usicat/screens/setting.dart';
import 'package:usicat/widgets/audio_widget_context.dart';
import 'package:usicat/widgets/bottom_player.dart';

class CustomScaffold extends StatefulWidget {
  const CustomScaffold({super.key, required this.player});

  final Audiopc player;

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  bool _extended = false;

  final List<Widget> pages = [
    const Home(),
    const PlaylistUI(),
    const Setting(),
    const About()
  ];

  final PlaybackBloc playbackBloc = PlaybackBloc(const PlaybackState());
  final APIBloc apiBloc = APIBloc(AudioRepository(AudioApiService()));
  final LocalLibBloc localLibBloc = LocalLibBloc();

  @override
  void initState() {
    super.initState();
    _createListener();
  }

  @override
  void dispose() {
    widget.player.close();
    super.dispose();
  }

  void _createListener() {
    widget.player.onDurationChanged = ((duration) {
      playbackBloc.add(OnDurationChange(duration));
    });
    widget.player.onPositionChanged = ((position) {
      playbackBloc.add(OnPositionChange(position));
    });
    widget.player.onStateChanged = ((state) {
      playbackBloc.add(OnStateChange(state));
    });

    widget.player.onSamplesChanged = ((samples) {
      playbackBloc.add(OnSamplesChange(samples));
    });

    widget.player.onPlayerCompleted = ((event) {
      if (localLibBloc.state.localSongs.isNotEmpty &&
          playbackBloc.state.song != null) {
        var index = playbackBloc.state.index ?? 0;
        if (index < localLibBloc.state.localSongs.length - 1) {
          if (playbackBloc.state.playMode == 0) {
            playbackBloc.add(OnPlayAtIndex(index + 1));
          } else if (playbackBloc.state.playMode == 1) {
            playbackBloc.add(OnPlayAtIndex(index));
          } else if (playbackBloc.state.playMode == -1) {
            final random = Random();
            playbackBloc.add(OnPlayAtIndex(random.nextInt(localLibBloc.state.localSongs.length-1)));
          }
          index = playbackBloc.state.index!;
          playbackBloc.add(OnNewSong(localLibBloc.state.localSongs[index]));
          widget.player.setSource(localLibBloc.state.localSongs[index].fileUrl);
          widget.player.play();
        } else {
          playbackBloc.add(OnPlayAtIndex(0));
          playbackBloc.add(OnNewSong(localLibBloc.state.localSongs[0]));
          widget.player.setSource(localLibBloc.state.localSongs[0].fileUrl);
          widget.player.play();
        }
      }
    });
  }

  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget? appBar;
    Widget? bottomPlayer;
    Drawer? drawer;
    if (MediaQuery.of(context).size.width < 500) {
      appBar = AppBar(
        title: Text(
          "usicat",
          style: TextStyle(
              fontFamily: "Itim",
              fontSize:
                  MusicAppThemeData.of(context).textSizeScheme.displaySmall),
        ),
      );
      bottomPlayer = MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => playbackBloc),
            BlocProvider(create: (context) => apiBloc),
            BlocProvider(create: (context) => localLibBloc)
          ],
          child: AudioWidgetContext(
              audioPlayer: widget.player, child: const BottomPlayer()));

      drawer = Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "usicat",
                style: TextStyle(fontFamily: "Itim", fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text("Home"),
              onTap: () {
                setState(() {
                  _pageIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Playlists"),
              onTap: () {
                setState(() {
                  _pageIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Settings"),
              onTap: () {
                setState(() {
                  _pageIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("About"),
              onTap: () {
                setState(() {
                  _pageIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    } else {
      appBar = null;
      bottomPlayer = null;
      drawer = null;
    }

    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: bottomPlayer,
      drawer: drawer,
      body: Stack(
        children: [
          Transform.translate(
              offset: const Offset(-20, 400),
              child: Container(
                width: 400,
                height: 400,
                decoration: const BoxDecoration(
                    color: Color(0xA011FFFF), shape: BoxShape.circle),
              )),
          ClipRect(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surface
                      .withAlpha(255 ~/ 2)),
            ),
          )),
          Row(
            children: [
              MediaQuery.of(context).size.width > 500
                  ? NavigationRail(
                      extended: _extended,
                      elevation: 10,
                      destinations: const [
                        // todo: custom navigation rail
                        NavigationRailDestination(
                          icon: Icon(Icons.menu),
                          label: SizedBox(),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.favorite_border),
                          selectedIcon: Icon(Icons.favorite),
                          label: Text('Favorites'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.bookmark_border),
                          selectedIcon: Icon(Icons.bookmark),
                          label: Text('Books'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.star_border),
                          selectedIcon: Icon(Icons.star),
                          label: Text('Authors'),
                        ),
                      ],
                      selectedIndex: 0,
                      onDestinationSelected: (int index) {},
                    )
                  : const SizedBox(),
              AudioWidgetContext(
                audioPlayer: widget.player,
                child: MultiBlocProvider(providers: [
                  BlocProvider(create: (context) => playbackBloc),
                  BlocProvider(create: (context) => apiBloc),
                  BlocProvider(create: (context) => localLibBloc)
                ], child: Expanded(child: pages[_pageIndex])),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
