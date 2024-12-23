import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usicat/audio/business/blocs.dart';
import 'package:usicat/audio/data/service/service.dart';
import 'package:usicat/widgets/audio_widget_context.dart';
import 'package:usicat/widgets/custom_netimage.dart';

class SongItem extends StatefulWidget {
  const SongItem({super.key, required this.song, this.child});
  final Song song;
  final Widget? child;
  @override
  State<SongItem> createState() => _SongItemState();
}

class _SongItemState extends State<SongItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
                onTap: () {
                  BlocProvider.of<PlaybackBloc>(context)
                      .add(OnNewSong(widget.song));
                  AudioWidgetContext.of(context)!.audioPlayer.setSource(
                      '${AudioApiService.baseUrl.replaceAll("/api/v2", '')}/${widget.song.fileUrl}');
                },
                splashColor: const Color(0xA1CEC7FF),
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
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: CustomNetImage(url: widget.song.fileThumb),
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width > 500 ? 500 : 200, minWidth: 200),
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.song.title,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.song.artist,
                               overflow: TextOverflow.fade,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.normal),
                            )
                          ],
                        ),
                        ),
                      ],
                    ),
                   widget.child ?? const SizedBox()
                  ],
                ))));
  }
}
