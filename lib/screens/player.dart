import 'package:audiopc/audiopc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usicat/audio/business/blocs.dart';
import 'package:usicat/helper/clippers.dart';
import 'package:usicat/widgets/custom_netimage.dart';
import 'package:usicat/widgets/visualizer.dart';

class Player extends StatefulWidget {
  const Player({super.key, required this.audioPlayer, required this.bloc});

  final Audiopc audioPlayer;
  final PlaybackBloc bloc;

  @override
  State<StatefulWidget> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(),
        BlocBuilder<PlaybackBloc, PlaybackState>(
            bloc: widget.bloc,
            builder: (context, state) {
              int second = 0;
              int minute = 0;
              int secLast = 0;
              int minLast = 0;
              if (state.song != null) {
                second = (state.position).floor();
                minute = (second / 60).floor();
                second = second % 60;

                int dSec = (state.duration).floor();
                int dM = (dSec / 60).floor();
                dSec = dSec % 60;

                minLast = dM - minute;
                secLast = (dSec - second).abs();
              }

              return SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02,
                          bottom: MediaQuery.of(context).size.height * 0.02,
                          left: MediaQuery.of(context).size.width * 0.02,
                          right: MediaQuery.of(context).size.width * 0.02),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.width * 0.8,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary
                                          .withAlpha(255 ~/ 2),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: const Offset(0, 2),
                                    )
                                  ]),
                              child: state.song == null ||
                                      state.song!.fileThumb == ""
                                  ? Image.asset(
                                      'images/thumb1.jpg',
                                      fit: BoxFit.cover,
                                    )
                                  : CustomNetImage(
                                      url: state.song!.fileThumb,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.8,
                                    )),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  state.song == null
                                      ? "No song playing"
                                      : state.song!.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.blue),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  state.song == null || state.song!.artist == ""
                                      ? "Unknown"
                                      : state.song!.artist,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const Icon(
                                  Icons.favorite,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: SliderTheme(
                                data: SliderThemeData(
                                    trackHeight: 3,
                                    thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 5),
                                    inactiveTrackColor: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withAlpha(89),
                                    overlayShape: const RoundSliderOverlayShape(
                                        overlayRadius: 10)),
                                child: Slider(
                                  value: state.song != null
                                      ? state.position.toDouble() >
                                              state.duration
                                          ? 0
                                          : state.position.toDouble()
                                      : 0,
                                  max: state.song != null
                                      ? state.duration.toDouble() + 1
                                      : 0,
                                  onChanged: (v) {
                                    widget.audioPlayer.seek(v);
                                  },
                                )),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      '${minute.toString()}:${(second > 9 ? second : "0$second").toString()}',
                                      style: const TextStyle(fontSize: 10)),
                                  Text(
                                      '${minLast.toString()}:${(secLast > 9 ? secLast : "0$secLast").toString()}',
                                      style: const TextStyle(fontSize: 10)),
                                ],
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          Visualizer(
                              samples: state.samples,
                              isPlaying: state.state == AudiopcState.playing,
                              clipper: const VisualizerClipper(),
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 80),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (state.playMode == -1) {
                                    widget.bloc.add(OnPlayModeChange(0));
                                  } else {
                                    widget.bloc.add(OnPlayModeChange(-1));
                                  }
                                },
                                isSelected: state.playMode == -1,
                                selectedIcon: const Icon(Icons.shuffle_on),
                                icon: const Icon(Icons.shuffle),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                onPressed: () {
                                  if (state.position > 10) {
                                    widget.audioPlayer
                                        .seek(state.position - 10);
                                  }
                                },
                                icon: const Icon(Icons.skip_previous),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton.filled(
                                  onPressed: () {
                                    if (state.state == AudiopcState.playing) {
                                      widget.audioPlayer.pause();
                                    } else {
                                      widget.audioPlayer.play();
                                    }
                                  },
                                  icon: Icon(state.state == AudiopcState.playing
                                      ? Icons.pause
                                      : Icons.play_arrow)),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                onPressed: () {
                                  if (state.position < state.duration - 10) {
                                    widget.audioPlayer
                                        .seek(state.position + 10);
                                  }
                                },
                                icon: const Icon(Icons.skip_next),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                onPressed: () {
                                  if (state.playMode == 1) {
                                    widget.bloc.add(OnPlayModeChange(0));
                                  } else {
                                    widget.bloc.add(OnPlayModeChange(1));
                                  }
                                },
                                isSelected: state.playMode == 1,
                                selectedIcon: const Icon(Icons.repeat_on),
                                icon: const Icon(Icons.repeat),
                              ),
                            ],
                          )
                        ],
                      )));
            })
      ],
    );
  }
}
