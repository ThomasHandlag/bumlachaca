import 'package:flutter/material.dart';
import 'package:musicplayer/helper/clippers.dart';
import 'package:musicplayer/widgets/visualizer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  double _value = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: Stack(
        children: [
          Container(),
          Transform.translate(
              offset: const Offset(0, 10),
              child: Container(
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 242, 242, 242),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(1.0),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 2), // changes position of shadow
                        )
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue,
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
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Lost in the middle",
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                        height: 10,
                      ),
                      const SizedBox(
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "NCS",
                              style: TextStyle(fontSize: 12),
                            ),
                            Icon(Icons.favorite),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 240,
                        child: SliderTheme(
                            data: const SliderThemeData(
                                trackHeight: 3,
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 5),
                                overlayShape:
                                    RoundSliderOverlayShape(overlayRadius: 10)),
                            child: Slider(
                              value: _value,
                              onChanged: (v) {
                                setState(() {
                                  _value = v;
                                });
                              },
                            )),
                      ),
                      const SizedBox(
                          width: 240,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('1:20', style: TextStyle(fontSize: 10)),
                              Text('3:20', style: TextStyle(fontSize: 10)),
                            ],
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      const Visualizer(
                          clipper: VisualizerClipper(), width: 250, height: 80),
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
      ));
}
