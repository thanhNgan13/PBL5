import 'package:fire_warning_app/pages/IoT/VideoPages/VideoOverplay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class LandscapeModeVideos extends StatefulWidget {
  const LandscapeModeVideos({super.key, required this.controller});

  final VideoPlayerController controller;
  @override
  State<LandscapeModeVideos> createState() => _LandscapeModeVideosState();
}

class _LandscapeModeVideosState extends State<LandscapeModeVideos> {
  Future<void> _setLandscapeMode() async {
    try {
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: []); // Ẩn thanh trạng thái
    } catch (e) {
      // Xử lý lỗi
    }
  }

  Future<void> _resetOrientation() async {
    try {
      await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values); // Hiện lại thanh trạng thái
    } catch (e) {
      // Xử lý lỗi
    }
  }

  @override
  void initState() {
    super.initState();
    _setLandscapeMode();
  }

  @override
  void dispose() {
    _resetOrientation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.black,
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: AspectRatio(
          aspectRatio: widget.controller.value.aspectRatio,
          child: VideoPlayer(widget.controller),
        ),
      ),
      Positioned.fill(
          child:
              VideoOverlay(controller: widget.controller, ifFullScreen: true)),
    ]);
  }
}
