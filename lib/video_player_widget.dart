import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_android_tv/video_overlay.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController controller;
  const VideoPlayerWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {


  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          (widget.controller != null && widget.controller.value.isInitialized)
              ? Container(
                  alignment: Alignment.topCenter,
                  child: buildVideo(),
                )
              : Container(
                  child: Center(child: CircularProgressIndicator()),
                ),
    );
  }

  Widget buildVideo() => Stack(
        children: [
          buildVideoPlayer(),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child:VideoIndicator(controller: widget.controller)
              )
        ],
      );

  Widget buildVideoPlayer() => AspectRatio(
        aspectRatio: widget.controller.value.aspectRatio,
        child: VideoPlayer(widget.controller),
      );
}
