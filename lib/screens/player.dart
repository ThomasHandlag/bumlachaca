import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usicat/audio/business/bloc.dart';
import 'package:usicat/helper/clippers.dart';
import 'package:usicat/widgets/custom_netimage.dart';
import 'package:usicat/widgets/visualizer.dart';

class Player extends StatefulWidget {
  const Player({super.key, required this.audioPlayer, required this.bloc});

  final AudioPlayer audioPlayer;
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
                second = (state.position / 1000).floor();
                minute = (second / 60).floor();
                second = second % 60;

                int d_sec = (state.duration / 1000).floor();
                int d_m = (d_sec / 60).floor();
                d_sec = d_sec % 60;

                minLast = d_m - minute;
                secLast = (d_sec - second).abs();
              }

              return Transform.translate(
                  offset: const Offset(0, 10),
                  child: Column(
                    children: [
                      MediaQuery.of(context).size.width > 600
                          ? Container(
                              padding: const EdgeInsets.all(20),
                              child: const Row(
                                children: [
                                  Text("Toolbar"),
                                ],
                              ))
                          : const SizedBox(),
                      Expanded(
                          child: Container(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.02,
                                  bottom:
                                      MediaQuery.of(context).size.height * 0.02,
                                  left:
                                      MediaQuery.of(context).size.width * 0.02,
                                  right:
                                      MediaQuery.of(context).size.width * 0.02),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.8,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(1.0),
                                              spreadRadius: 2,
                                              blurRadius: 7,
                                              offset: const Offset(0, 2),
                                            )
                                          ]),
                                      child: state.song == null
                                          ? Image.asset(
                                              'images/thumb1.jpg',
                                              fit: BoxFit.cover,
                                            )
                                          : CustomNetImage(
                                              url: state.song!.fileThumb,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                            )),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.blue),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          state.song == null
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: SliderTheme(
                                        data: const SliderThemeData(
                                            trackHeight: 3,
                                            thumbShape: RoundSliderThumbShape(
                                                enabledThumbRadius: 5),
                                            overlayShape:
                                                RoundSliderOverlayShape(
                                                    overlayRadius: 10)),
                                        child: Slider(
                                          value: state.song != null
                                              ? state.position.toDouble()
                                              : 0,
                                          max: state.song != null
                                              ? state.duration.toDouble()
                                              : 0,
                                          onChanged: (v) {
                                            widget.audioPlayer.seek(Duration(
                                                milliseconds: v.toInt()));
                                          },
                                        )),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '${minute.toString()}:${(second > 9 ? second : "0$second").toString()}',
                                              style: const TextStyle(
                                                  fontSize: 10)),
                                          Text(
                                              '${minLast.toString()}:${(secLast > 9 ? secLast : "0$secLast").toString()}',
                                              style: const TextStyle(
                                                  fontSize: 10)),
                                        ],
                                      )),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Visualizer(
                                      isPlaying:
                                          state.state == PlayerState.playing,
                                      clipper: const VisualizerClipper(),
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height: 120),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.shuffle),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.skip_previous),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      IconButton.filled(
                                          onPressed: () {
                                            if (state.state ==
                                                PlayerState.playing) {
                                              widget.audioPlayer.pause();
                                            } else {
                                              widget.audioPlayer.resume();
                                            }
                                          },
                                          icon: Icon(
                                              state.state == PlayerState.playing
                                                  ? Icons.pause
                                                  : Icons.play_arrow)),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.skip_next),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.repeat),
                                      ),
                                    ],
                                  )
                                ],
                              )))
                    ],
                  ));
            })
      ],
    );
  }
}
