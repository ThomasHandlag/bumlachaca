import 'package:flutter/material.dart';
import 'package:musicplayer/screens/default.dart';
import 'package:musicplayer/screens/splash.dart';
import 'package:platform/platform.dart';

void main() {
  Platform platform = const LocalPlatform();
  runApp(MusicApp(platform: platform));
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key, required this.platform});
  final Platform platform;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musicat',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: (platform.isAndroid || platform.isIOS)
          ? const Default()
          : const Splash(),
    );
  }
}
