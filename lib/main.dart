import 'package:flutter/material.dart';
import 'package:musicplayer/screen/splash.dart';

void main() {
  runApp(const MusicApp());
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musicat',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Splash(),
    );
  }
}
