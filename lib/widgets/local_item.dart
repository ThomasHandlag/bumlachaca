import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usicat/audio/business/blocs.dart';
import 'package:usicat/audio/data/service/service.dart';
import 'package:usicat/widgets/audio_widget_context.dart';
import 'package:usicat/widgets/custom_lists.dart';
import 'package:usicat/widgets/more_btn.dart';

class LocalItem extends StatefulWidget {
  final Song song;
  final Function onTap;
  final Function(int id) onLongPress;
  final Function(int id) onCheck;
  final bool checked;
  final bool showCheckBox;
  const LocalItem(
      {super.key,
      required this.song,
      required this.onTap,
      required this.onLongPress,
      required this.checked,
      required this.showCheckBox,
      required this.onCheck});

  @override
  State<LocalItem> createState() => _LocalItemState();
}

class _LocalItemState extends State<LocalItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _timer;
  List<double> waveData = [0, 2, 1];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _controller.forward();
    final Random random = Random();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      waveData = List.generate(3, (index) => random.nextDouble() * 15);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = AudioWidgetContext.of(context)!.audioPlayer;
    final playerBloc = BlocProvider.of<PlaybackBloc>(context);
    final localBloc = BlocProvider.of<LocalLibBloc>(context);
    return BlocBuilder<PlaybackBloc, PlaybackState>(builder: (_, state) {
      final isPlaying = state.song?.id == widget.song.id;
      return ListTile(
          onTap: () {
            final i = localBloc.state.localSongs
                .indexWhere((element) => element == widget.song);
            playerBloc.add(OnPlayAtIndex(i));
            playerBloc.add(OnNewSong(widget.song));
            audioPlayer.setSource(
              widget.song.fileUrl.replaceAll('\\', '/'),
            );
            audioPlayer.play();
          },
          onLongPress: () {
            widget.onLongPress(widget.song.id!);
          },
          leading: isPlaying
              ? AnimatedBuilder(
                  animation: _controller,
                  builder: (_, child) {
                    return CustomPaint(
                      painter: MiniVisualizer(
                          waveData: waveData,
                          isPlaying: isPlaying,
                          delta: _controller.value),
                      child: const SizedBox(
                        width: 30,
                        height: 15,
                      ),
                    );
                  })
              : Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                      color: Color(0xFF3465F3), shape: BoxShape.circle),
                ),
          title: Text(widget.song.title),
          subtitle: const Text("Unknown"),
          trailing: widget.showCheckBox
              ? Checkbox(
                  value: widget.checked,
                  onChanged: (val) {
                    widget.onCheck(widget.song.id!);
                  })
              : MoreButton(children: [
                  PopupMenuItem(
                    child: const Text("Add to playlist"),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            final playLists = localBloc.state.playLists;
                            return Dialog(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                width: 300,
                                height: 500,
                                child: Column(
                                  children: [
                                    const Text("Add to playlist"),
                                    const Divider(
                                      height: 2,
                                    ),
                                    Expanded(
                                        child: ListView.builder(
                                            itemCount: playLists.length,
                                            itemBuilder: ((_, pIndex) {
                                              return ListTile(
                                                title: Text(
                                                    playLists[pIndex].name),
                                                onTap: () {
                                                  localBloc.add(
                                                      OnAddSongsToPlaylist([
                                                    widget.song
                                                  ], playLists[pIndex].id!));
                                                  Navigator.pop(context);
                                                },
                                              );
                                            }))),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"))
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ]));
    });
  }
}
