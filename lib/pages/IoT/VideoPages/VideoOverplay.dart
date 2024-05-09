import 'package:fire_warning_app/pages/IoT/VideoPages/landspace_video.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoOverlay extends StatefulWidget {
  final VideoPlayerController controller;
  final bool ifFullScreen;
  final String title;

  const VideoOverlay(
      {super.key,
      required this.controller,
      required this.ifFullScreen,
      this.title = ''});

  @override
  State<VideoOverlay> createState() => _VideoOverlayState();
}

class _VideoOverlayState extends State<VideoOverlay> {
  bool _isPlaying = false;
  bool _isShowStatePortrait = false;
  bool _isFirstStatePortrait = true;

  @override
  void initState() {
    super.initState();
    if (widget.ifFullScreen) {
      _isFirstStatePortrait = false;
      _isShowStatePortrait = true;
    } else {
      _isFirstStatePortrait = true;
      _isShowStatePortrait = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _videoDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitHours = twoDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (twoDigitHours == '00') {
      return '$twoDigitMinutes:$twoDigitSeconds';
    } else {
      return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
    }
  }

  Widget buildIndicator() {
    return VideoProgressIndicator(
      widget.controller,
      allowScrubbing: true,
    );
  }

  Widget buildPlay() => widget.controller.value.isPlaying
      ? Container()
      : Container(
          alignment: Alignment.center,
          color: Colors.black26,
          child: IconButton(
              icon: const Icon(Icons.play_arrow, color: Colors.white, size: 50),
              onPressed: () {
                widget.controller.play();
                _togglePlaying();
                if (_isFirstStatePortrait) {
                  _toggleFirst();
                } else {
                  _toggleShowing();
                }
              }),
        );

  void _togglePlaying() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _toggleShowing() {
    setState(() {
      _isShowStatePortrait = !_isShowStatePortrait;
    });
  }

  void _toggleFirst() {
    setState(() {
      if (_isFirstStatePortrait) {
        _isFirstStatePortrait = !_isFirstStatePortrait;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!_isPlaying) {
          widget.controller.play();
          _toggleFirst();
          _togglePlaying();
          if (_isShowStatePortrait) {
            _toggleShowing();
          }
        } else {
          _toggleShowing();
          Future.delayed(const Duration(seconds: 2), () {
            _toggleShowing();
          });
        }
      },
      child: Stack(
        children: <Widget>[
          // Nút dừng video
          if (_isShowStatePortrait && _isPlaying)
            Container(
              alignment: Alignment.center,
              color: Colors.black26,
              child: IconButton(
                  icon: const Icon(Icons.pause, color: Colors.white, size: 50),
                  onPressed: () {
                    widget.controller.pause();
                    _togglePlaying();
                  }),
            ),
          // Nút play video
          buildPlay(),
          // Hiển thị thời lượng video
          if (_isFirstStatePortrait)
            Positioned(
              bottom: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: showLengthVideo(),
              ),
            ),
          // Hiển thị tiêu đề video
          if (_isFirstStatePortrait || _isShowStatePortrait)
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: DefaultTextStyle(
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  child: Text(
                    'abc',
                    softWrap: true,
                  ),
                ),
              ),
            ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Hiển thị thanh trượt video
                if (_isPlaying && !_isShowStatePortrait) buildIndicator(),
                if (_isShowStatePortrait)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          child: ValueListenableBuilder(
                              valueListenable: widget.controller,
                              builder:
                                  (context, VideoPlayerValue value, child) {
                                return DefaultTextStyle(
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                  child: Text(
                                    _videoDuration(value.position),
                                  ),
                                );
                              }),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(child: buildIndicator()),
                        const SizedBox(
                          width: 5,
                        ),
                        showLengthVideo(),
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: IconButton(
                            onPressed: () {
                              if (!widget.ifFullScreen) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LandscapeModeVideos(
                                        controller: widget.controller)));
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            icon: const Icon(
                              Icons.fullscreen,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DefaultTextStyle showLengthVideo() {
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white, fontSize: 12),
      child: Text(
        _videoDuration(widget.controller.value.duration),
      ),
    );
  }
}
