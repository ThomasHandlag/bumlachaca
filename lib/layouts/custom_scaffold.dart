import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usicat/main.dart';
import 'package:usicat/widgets/bottom_player.dart';
import 'package:usicat/widgets/flow_menu.dart';

class CustomScaffold extends StatefulWidget {
  const CustomScaffold({super.key, required this.child});
  final Widget child;

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    debugPrint(location);
    if (location.compareTo("/home") == 0) {
      return 1;
    }
    if (location.compareTo('/home/player') == 0) {
      return 2;
    }

    return 1;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        setState(() {
          _extended = !_extended;
        });
      case 1:
        GoRouter.of(context).go('/home');
      case 2:
        GoRouter.of(context).go('/home/player');
    }
  }

  bool _extended = false;

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
                  MusicAppThemeData.of(context).textSizeScheme.headlineLarge),
        ),
      );
      bottomPlayer = const BottomPlayer();
    } else {
      appBar = null;
      bottomPlayer = null;
    }

    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: bottomPlayer,
      body: Stack(
        children: [
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
                      selectedIndex: _calculateSelectedIndex(context),
                      onDestinationSelected: (int index) {
                        _onItemTapped(index, context);
                      },
                    )
                  : const SizedBox(),
              Expanded(child: widget.child),
            ],
          ),
        ],
      ),
    );
  }
}
