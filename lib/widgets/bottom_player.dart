import 'package:audiopc/audiopc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usicat/audio/business/blocs.dart';
import 'package:usicat/screens/player.dart';
import 'package:usicat/widgets/audio_widget_context.dart';
import 'package:usicat/widgets/custom_netimage.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaybackBloc, PlaybackState>(
      bloc: BlocProvider.of<PlaybackBloc>(context),
      builder: (context, state) {
        return Container(
            height: 60,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(255 ~/ 2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Material(
                child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isDismissible: false,
                          showDragHandle: true,
                          isScrollControlled: true,
                          barrierColor: Colors.transparent,
                          elevation: 10,
                          constraints: BoxConstraints(
                              // minHeight: kBottomNavigationBarHeight,
                              maxHeight: MediaQuery.of(context).size.height),
                          builder: (_) {
                            return Player(
                              audioPlayer:
                                  AudioWidgetContext.of(context)!.audioPlayer,
                              bloc: BlocProvider.of<PlaybackBloc>(context),
                            );
                          });
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          LinearProgressIndicator(
                            value: state.duration == 0
                                ? 0
                                : state.position / state.duration,
                            backgroundColor: Colors.transparent,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.blueAccent),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: state.song == null ||
                                                  state.song!.fileThumb == ""
                                              ? Image.asset(
                                                  'images/thumb1.jpg',
                                                  width: 50,
                                                  height: 50,
                                                )
                                              : CustomNetImage(
                                                  url: state.song!.fileThumb,
                                                  width: 50,
                                                  height: 50,
                                                )),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(state.song == null
                                              ? "No song playing"
                                              : state.song!.title),
                                          Text(state.song == null
                                              ? "No artist"
                                              : state.song!.artist),
                                        ],
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(
                                        state.state == AudiopcState.playing
                                            ? Icons.pause
                                            : Icons.play_arrow),
                                    onPressed: () {
                                      final audioPlayer =
                                          AudioWidgetContext.of(context)!
                                              .audioPlayer;
                                        if (audioPlayer.state ==
                                            AudiopcState.playing) {
                                          audioPlayer.pause();
                                        } else if (audioPlayer.state ==
                                            AudiopcState.paused) {
                                          audioPlayer.play();
                                        }
                                    },
                                  ),
                                ],
                              ))
                        ]))));
      },
    );
  }
}
