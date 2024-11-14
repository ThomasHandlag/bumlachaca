import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usicat/audio/business/bloc.dart';
import 'package:usicat/audio/business/event.dart';
import 'package:usicat/audio/business/state.dart';
import 'package:usicat/screens/player.dart';
import 'package:usicat/widgets/audio_widget_context.dart';

class BottomPlayer extends StatefulWidget {
  const BottomPlayer({super.key});

  @override
  State<BottomPlayer> createState() => _BottomPlayerState();
}

class _BottomPlayerState extends State<BottomPlayer> {
  @override
  void initState() {
    super.initState();
  }

  bool _isPlaying = false;
  Duration _duration = Duration(seconds: 0);
  Duration _audioDuration = Duration(seconds: 0);

  @override
  Widget build(BuildContext context) {
    AudioWidgetContext.of(context)!.audioPlayer.getDuration().then((value) {
      setState(() {
        if (value != null) {
          _audioDuration = value;
        }
      });
    });

    AudioWidgetContext.of(context)!.audioPlayer.onPlayerStateChanged.listen(
      (state) {
        if (state == PlayerState.playing) {
          setState(() {
            _isPlaying = true;
          });
        } else {
          setState(() {
            _isPlaying = false;
          });
        }
      },
    );
    AudioWidgetContext.of(context)!.audioPlayer.onPositionChanged.listen(
      (duration) {
        setState(() {
          _duration = duration;
        });
      },
    );
    return BlocBuilder<PlaybackBloc, PlaybackState>(
      builder: (context, state) {
        return Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Material(
                color: Colors.white,
                child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isDismissible: false,
                          showDragHandle: true,
                          isScrollControlled: true,
                          barrierColor: Colors.transparent,
                          backgroundColor: Colors.white,
                          elevation: 10,
                          constraints: BoxConstraints(
                              // minHeight: kBottomNavigationBarHeight,
                              maxHeight: MediaQuery.of(context).size.height -
                                  kToolbarHeight),
                          builder: (_) {
                            return Player(
                              audioPlayer:
                                  AudioWidgetContext.of(context)!.audioPlayer,
                            );
                          });
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          LinearProgressIndicator(
                            value: _audioDuration.inSeconds == 0
                                ? 0
                                : _duration.inMilliseconds /
                                    _audioDuration.inMilliseconds,
                            backgroundColor: Colors.transparent,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.blueAccent),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        AssetImage('images/thumb1.jpg'),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Song Title"),
                                      Text("Artist Name"),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(_isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow),
                                onPressed: () {
                                  final audioPlayer =
                                      AudioWidgetContext.of(context)!
                                          .audioPlayer;
                                  if (audioPlayer.source != null) {
                                    if (audioPlayer.state ==
                                        PlayerState.playing) {
                                      audioPlayer.pause();
                                    } else if (audioPlayer.state ==
                                        PlayerState.paused) {
                                      audioPlayer.resume();
                                    }
                                  } else {
                                    // play the lastest played song
                                  }
                                },
                              ),
                            ],
                          )
                        ]))));
      },
    );
  }
}
