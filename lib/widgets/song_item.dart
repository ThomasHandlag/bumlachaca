import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:usicat/audio/data/service/service.dart';
import 'package:usicat/widgets/audio_widget_context.dart';
import 'package:usicat/widgets/more_btn.dart';

class SongItem extends StatefulWidget {
  const SongItem({super.key, required this.song});
  final Song song;
  @override
  State<SongItem> createState() => _SongItemState();
}

class _SongItemState extends State<SongItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Color(0xA1CEC7FF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
            color: Color(0xA1CEC7FF),
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
                onTap: () {
                  AudioWidgetContext.of(context)!
                      .audioPlayer
                      .play(UrlSource(widget.song.fileUrl));
                },
                splashColor: Color(0xA1CEC7FF),
                borderRadius: BorderRadius.circular(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                              decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: AssetImage(widget.song.fileThumb),
                                fit: BoxFit.cover),
                          )),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.song.title,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.song.artist,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.normal),
                            )
                          ],
                        ),
                      ],
                    ),
                    MoreButton(
                      children: [
                        const Text('Details'),
                        const Text('Add to Playlist'),
                        const Text('Share'),
                      ],
                    )
                  ],
                ))));
  }
}
