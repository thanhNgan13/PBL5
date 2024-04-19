import 'package:fire_warning_app/pages/home/VideoPages/VideoOverplay.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TemplateLongVideo extends StatefulWidget {
  final String urlVideo;
  final String title;

  const TemplateLongVideo({
    super.key,
    required this.urlVideo,
    required this.title,
  });

  @override
  State<TemplateLongVideo> createState() => _TemplateLongVideoState();
}

class _TemplateLongVideoState extends State<TemplateLongVideo> {
  late VideoPlayerController controller;
  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.urlVideo))
      ..initialize().then((_) {
        controller.pause();
        setState(() {});
      })
      ..setLooping(true);
  }

  @override
  void dispose() {
    controller.pause();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Stack(children: [
                Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  ),
                ),
                Positioned.fill(
                    child: VideoOverlay(
                  controller: controller,
                  ifFullScreen: false,
                  title: widget.title,
                )),
              ]),
            ],
          )),
    );
  }
}
