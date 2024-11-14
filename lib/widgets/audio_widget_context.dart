import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioWidgetContext extends InheritedWidget {
  const AudioWidgetContext({
    super.key,
    required super.child,
    required this.audioPlayer,
  });

  final AudioPlayer audioPlayer;

  static AudioWidgetContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AudioWidgetContext>();
  }

  @override
  bool updateShouldNotify(AudioWidgetContext oldWidget) =>
      (oldWidget.audioPlayer != audioPlayer);
}
