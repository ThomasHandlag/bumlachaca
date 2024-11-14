import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usicat/audio/business/bloc.dart';
import 'package:usicat/audio/business/event.dart';
import 'package:usicat/audio/business/state.dart';
import 'package:usicat/audio/data/service/service.dart';
import 'package:usicat/main.dart';
import 'package:usicat/screens/home.dart';
import 'package:usicat/widgets/audio_widget_context.dart';
import 'package:usicat/widgets/bottom_player.dart';

class CustomScaffold extends StatefulWidget {
  const CustomScaffold({super.key, required this.player});

  final AudioPlayer player;

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  bool _extended = false;
  Song? _lastPlayedSong = null;

  final List<Widget> pages = [const Home()];

  final PlaybackBloc playbackBloc = PlaybackBloc(AudioPlaybackState(
      Song(
          id: 1,
          artist: "NCS",
          fileThumb: "",
          fileUrl: "D:/Downloads/mine.mp3",
          genre: "",
          playCount: 10,
          title: "Mine"),
      0,
      0));

  @override
  void initState() {
    super.initState();
    _createListener();
  }

  @override
  void dispose() {
    widget.player.dispose();
    super.dispose();
  }

  void _createListener() {
    if (mounted) {
      return;
    }
    widget.player.onDurationChanged.listen((event) {
      playbackBloc.add(OnDurationChange(event.inMilliseconds));
    });
    widget.player.onPositionChanged.listen((event) {
      playbackBloc.add(OnPositionChange(event.inMilliseconds));
    });
  }

  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget? appBar;
    Widget? bottomPlayer;
    final String location = GoRouterState.of(context).uri.path;
    if (MediaQuery.of(context).size.width < 600 &&
        location.compareTo('/home') == 0) {
      appBar = AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
        title: Text(
          "usicat",
          style: GoogleFonts.getFont("Itim",
              fontSize:
                  MusicAppThemeData.of(context).textSizeScheme.displaySmall),
        ),
      );
      bottomPlayer = AudioWidgetContext(
          audioPlayer: widget.player, child: const BottomPlayer());
    } else {
      appBar = null;
      bottomPlayer = null;
    }

    return Scaffold(
      appBar: appBar,
      bottomNavigationBar:
          BlocProvider(create: (context) => playbackBloc, child: bottomPlayer),
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
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
            ),
          )),
          Row(
            children: [
              MediaQuery.of(context).size.width > 600
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
                child: BlocProvider(
                    create: (context) => playbackBloc,
                    child: Expanded(child: pages[_pageIndex])),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
