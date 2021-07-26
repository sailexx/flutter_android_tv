
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_android_tv/video_player_widget.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  const VideoApp({Key? key}) : super(key: key);
  static const routeName = 'video';

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController? _controller;


  @override
  void initState() {
    _controller = VideoPlayerController.network('https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8')
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => _controller!.play());
    super.initState();
  }
  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VideoPlayerWidget(controller: _controller!,),
    );
  }
}