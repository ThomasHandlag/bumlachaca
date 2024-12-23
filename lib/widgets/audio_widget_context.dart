import 'package:audiopc/audiopc.dart';
import 'package:flutter/material.dart';

class AudioWidgetContext extends InheritedWidget {
  const AudioWidgetContext({
    super.key,
    required super.child,
    required this.audioPlayer,
  });

  final Audiopc audioPlayer;

  static AudioWidgetContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AudioWidgetContext>();
  }

  @override
  bool updateShouldNotify(AudioWidgetContext oldWidget) =>
      (oldWidget.audioPlayer != audioPlayer);
}
