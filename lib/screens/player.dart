import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:usicat/helper/clippers.dart';
import 'package:usicat/widgets/visualizer.dart';

class Player extends StatefulWidget {
  const Player({super.key, required this.audioPlayer});

  final AudioPlayer audioPlayer;

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

  double _duration = 0;

  double _audioDuration = 0;

  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      widget.audioPlayer.getDuration().then((value) {
        setState(() {
          if (value != null) {
            _audioDuration = value.inMilliseconds.toDouble();
          }
        });
      });
    }

    double tempM = (_duration / 60000);

    int second = ((tempM - tempM.floorToDouble()) * 100).toInt();

    int minute = tempM.floor();

    double tempLast = 0;
    int secLast = 0;
    int minLast = 0;
    if (_audioDuration > 0) {
      tempLast = (_audioDuration - _duration) / 60000;
      secLast = ((tempLast - tempLast.floorToDouble()) * 100).toInt();
      minLast = tempLast.floor();
    }

    return Stack(
      children: [
        Container(),
        Transform.translate(
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
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: const DecorationImage(
                                      image: AssetImage('images/thumb1.jpg'),
                                      fit: BoxFit.cover),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(1.0),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: const Offset(0, 2),
                                    )
                                  ]),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Lost in the middle",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "NCS",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Icon(
                                    Icons.favorite,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: SliderTheme(
                                  data: const SliderThemeData(
                                      trackHeight: 3,
                                      thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: 5),
                                      overlayShape: RoundSliderOverlayShape(
                                          overlayRadius: 10)),
                                  child: Slider(
                                    value: _audioDuration != 0 ? _duration : 0,
                                    max: _audioDuration != 0
                                        ? _audioDuration
                                        : 0,
                                    onChanged: (v) {
                                      setState(() {
                                        _duration = v;
                                      });
                                      widget.audioPlayer.seek(Duration(
                                          milliseconds: _duration.toInt()));
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
                                        '${minute.toString()}:${second.toString()}',
                                        style: const TextStyle(fontSize: 10)),
                                    Text(
                                        '${minLast.toString()}:${secLast.toString()}',
                                        style: const TextStyle(fontSize: 10)),
                                  ],
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            Visualizer(
                                clipper: VisualizerClipper(),
                                width: MediaQuery.of(context).size.width * 0.8,
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
                                    onPressed: () {},
                                    icon: const Icon(Icons.play_arrow)),
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
            ))
      ],
    );
  }
}
