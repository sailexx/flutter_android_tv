import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_android_tv/video_costume_progress_indicator.dart';
import 'package:video_player/video_player.dart';

import 'key_code.dart';

class VideoIndicator extends StatefulWidget {
  final VideoPlayerController controller;
  const VideoIndicator({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _VideoIndicatorState createState() => _VideoIndicatorState();
}

class _VideoIndicatorState extends State<VideoIndicator> {
  FocusNode playPauseFocusNode = FocusNode();
  FocusNode fastRewind = FocusNode();
  FocusNode fastForward = FocusNode();
  FocusNode videoIndicator = FocusNode();

  var _playBackPosition = 0;
  var _videoLength = '';
  var _playBackFomattedPosition = '';
  bool _controls = false;

  void _setKeyEvent(RawKeyEvent event, VoidCallback fun) {
    // _setControllerState();
    if (event is RawKeyDownEvent && event.data is RawKeyEventDataAndroid) {
      RawKeyDownEvent rawKeyDownEvent = event;
      RawKeyEventDataAndroid rawKeyEventDataAndroid =
          rawKeyDownEvent.data as RawKeyEventDataAndroid;
      if (rawKeyEventDataAndroid.keyCode == KEY_CENTER) {
        fun();
      }
    }
  }

  void playPauseFun() {
    setState(() {
      widget.controller.value.isPlaying
          ? widget.controller.pause()
          : widget.controller.play();
    });
  }

  void forward10Seconds() {
    goToPosition((currentPosition) => currentPosition + Duration(seconds: 10));
  }

  void rewind10Seconds() {
    goToPosition((currentPosition) => currentPosition - Duration(seconds: 10));
  }

  Future goToPosition(
    Duration Function(Duration currentPosition) builder,
  ) async {
    final currentPosition = await widget.controller.position;
    final newPosition = builder(currentPosition!);
    await widget.controller.seekTo(newPosition);
  } 

  @override
  void initState() {
    widget.controller.addListener(() {
      var minutesTotal = (widget.controller.value.duration.inSeconds ~/ 60)
          .toString()
          .padLeft(1, '0');
      var secondsTotal = (widget.controller.value.duration.inSeconds % 60)
          .toString()
          .padLeft(2, '0');
      _videoLength = "$minutesTotal:$secondsTotal";

      _playBackPosition = widget.controller.value.position.inSeconds;
      var minutes = (_playBackPosition ~/ 60).toString().padLeft(1, '0');
      var seconds = (_playBackPosition % 60).toString().padLeft(2, '0');
      setState(() {
        _playBackPosition = _playBackPosition;
        _playBackFomattedPosition = "$minutes:$seconds / $_videoLength";
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _timeOut();
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 8),
          child: Text(
            '$_playBackFomattedPosition',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        RawKeyboardListener(
          focusNode: videoIndicator,
          onKey: (RawKeyEvent event) {
            if (event is RawKeyDownEvent &&
                event.data is RawKeyEventDataAndroid) {
              RawKeyDownEvent rawKeyDownEvent = event;
              RawKeyEventDataAndroid rawKeyEventDataAndroid =
                  rawKeyDownEvent.data as RawKeyEventDataAndroid;
              switch (rawKeyEventDataAndroid.keyCode) {
                case KEY_CENTER:
                  playPauseFun();
                  break;
                case KEY_UP:
                  FocusScope.of(context).requestFocus(playPauseFocusNode);
                  break;
                case KEY_DOWN:
                  FocusScope.of(context).requestFocus(playPauseFocusNode);
                  break;
                case KEY_LEFT:
                  rewind10Seconds();
                  break;
                case KEY_RIGHT:
                  forward10Seconds();
                  break;
                default:
                  break;
              }
              setState(() {});
            }
          },
          child: Container(
            child: CostumeVideoProgressIndicator(
              widget.controller,
              allowScrubbing: true,
              colors: VideoProgressColors(
                  playedColor:
                      videoIndicator.hasFocus ? Colors.red : Colors.blue),
            ),
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                child: RawKeyboardListener(
                  focusNode: fastRewind,
                  onKey: (RawKeyEvent event) {
                    _setKeyEvent(event, rewind10Seconds);
                  },
                  child: ElevatedButton(
                      autofocus: false,
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              fastRewind.hasFocus ? Colors.red : Colors.blue)),
                      onPressed: () {
                        rewind10Seconds();
                      },
                      child: Icon(
                        Icons.fast_rewind,
                        color: Colors.white,
                      )),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Container(
                child: RawKeyboardListener(
                  focusNode: playPauseFocusNode,
                  onKey: (RawKeyEvent event) =>
                      _setKeyEvent(event, playPauseFun),
                  child: ElevatedButton(
                      autofocus: false,
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              playPauseFocusNode.hasFocus
                                  ? Colors.red
                                  : Colors.blue)),
                      onPressed: () {
                        playPauseFun();
                      },
                      child: Icon(
                        widget.controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                      )),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Container(
                child: RawKeyboardListener(
                  focusNode: fastForward,
                  onKey: (RawKeyEvent event) =>
                      _setKeyEvent(event, forward10Seconds),
                  child: ElevatedButton(
                      autofocus: false,
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              fastForward.hasFocus ? Colors.red : Colors.blue)),
                      onPressed: () {
                        forward10Seconds();
                      },
                      child: Icon(
                        Icons.fast_forward,
                        color: Colors.white,
                      )),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
