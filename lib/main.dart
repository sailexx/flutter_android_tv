import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_android_tv/video_player_widget.dart';
import 'package:video_player/video_player.dart';

import 'VideoAppScreen.dart';
import 'key_code.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'android tv',
        home: HomePage(),
        routes: {
          VideoApp.routeName: (ctx) => VideoApp()
        },
      ),
    );
class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FocusNode vidButton = FocusNode();
  FocusNode testButton = FocusNode();
  var isFirstIn = true;

  @override
  void dispose() {
    vidButton.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstIn) {
      FocusScope.of(context).requestFocus(vidButton);
      isFirstIn = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Android tv test'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          new Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(5.0),
            child: new RawKeyboardListener(
              focusNode: vidButton,
              onKey: (RawKeyEvent event) {
                print(event.data.toString());
                if (event is RawKeyDownEvent &&
                    event.data is RawKeyEventDataAndroid) {
                  RawKeyDownEvent rawKeyDownEvent = event;
                  RawKeyEventDataAndroid rawKeyEventDataAndroid =
                      rawKeyDownEvent.data as RawKeyEventDataAndroid;
                  print("Focus Node 0 ${rawKeyEventDataAndroid.keyCode}");
                  if(rawKeyEventDataAndroid.keyCode == KEY_CENTER){
                    Navigator.of(context).pushNamed(VideoApp.routeName);
                  }
                  // setState(() {});
                }
              },
              child: new RaisedButton(
                child: new Container(
                    alignment: Alignment.center,
                    width: 160.0,
                    height: 100,
                    child: new Text('Bunny')),
                color: vidButton.hasFocus ? Colors.red : Colors.grey,
                onPressed: () {
                  Navigator.of(context).pushNamed(VideoApp.routeName);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//
//
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/foundation.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Shortcuts(
//       shortcuts: {
//         LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
//       },
//       child: MaterialApp(
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//         ),
//         home: VideoPlayerScreen(
//             url:
//             'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'),
//       ),
//     );
//   }
// }
//
// class VideoPlayerScreen extends StatefulWidget {
//   VideoPlayerScreen({Key? key, required this.url}) : super(key: key);
//
//   final String url;
//
//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }
//
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//
//   // final FocusNode _focusNode = FocusNode();
//
//   var _playBackPosition = 0;
//   var _videoLength = '';
//   var _playBackFomattedPosition = '';
//   bool _controls = false;
//
//   @override
//   void initState() {
//     _controller = VideoPlayerController.network(
//       widget.url,
//     );
//     _initializeVideoPlayerFuture = _controller.initialize();
//
//     _controls = true;
//
//     _controller.play();
//
//     Future.delayed(const Duration(seconds: 5), () {
//       _controls = false;
//     });
//
//     _controller.addListener(() {
//       var minutesTotal = (_controller.value.duration.inSeconds ~/ 60)
//           .toString()
//           .padLeft(1, '0');
//       var secondsTotal = (_controller.value.duration.inSeconds % 60)
//           .toString()
//           .padLeft(2, '0');
//       _videoLength = "$minutesTotal:$secondsTotal";
//
//       _playBackPosition = _controller.value.position.inSeconds;
//       var minutes = (_playBackPosition ~/ 60).toString().padLeft(1, '0');
//       var seconds = (_playBackPosition % 60).toString().padLeft(2, '0');
//       setState(() {
//         _playBackPosition = _playBackPosition;
//         _playBackFomattedPosition = "$minutes:$seconds / $_videoLength";
//       });
//     });
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void controls() {
//     setState(() {
//       _controls = true;
//       Future.delayed(const Duration(seconds: 5), () {
//         _controls = false;
//       });
//     });
//   }
//
//   // _handleKeyEvent(RawKeyEvent event) {
//   //   setState(() {
//   //     if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
//   //         event.logicalKey == LogicalKeyboardKey.arrowRight ||
//   //         event.logicalKey == LogicalKeyboardKey.arrowDown ||
//   //         event.logicalKey == LogicalKeyboardKey.arrowUp) {
//   //       controls();
//   //     }
//   //   });
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//         future: _initializeVideoPlayerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return AspectRatio(
//               aspectRatio: _controller.value.aspectRatio,
//               child: Stack(
//                 alignment: Alignment.bottomCenter,
//                 children: <Widget>[
//                   // RawKeyboardListener(
//                   //   focusNode: _focusNode,
//                   //   onKey: (RawKeyEvent event){
//                   //     if(!_controls) {
//                   //       _handleKeyEvent(event);
//                   //     }
//                   //   },
//                   //   child: VideoPlayer(_controller),
//                   // ),
//                   VideoPlayer(_controller),
//                   AnimatedSwitcher(
//                     duration: Duration(milliseconds: 500),
//                     reverseDuration: Duration(milliseconds: 500),
//                     child: _controls
//                         ? Positioned(
//                       bottom: 0,
//                       child: Container(
//                         height: 120,
//                         color: Colors.black54,
//                       ),
//                     )
//                         : null,
//                   ),
//                   Positioned(
//                     bottom: 50.0,
//                     left: 20.0,
//                     child: Center(
//                       child: Text(
//                         '$_playBackFomattedPosition',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 50.0,
//                     right: 160.0,
//                     child: RawMaterialButton(
//                       shape: CircleBorder(),
//                       padding: const EdgeInsets.all(10.0),
//                       focusColor: Colors.grey[600],
//                       fillColor: Colors.black,
//                       // autofocus: true,
//                       child: Icon(
//                         _controller.value.isPlaying
//                             ? Icons.pause
//                             : Icons.play_arrow,
//                         size: 28,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           if (_controller.value.isPlaying) {
//                             controls();
//                             _controller.pause();
//                           } else {
//                             _controller.play();
//                           }
//                         });
//                       },
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 50.0,
//                     right: 80.0,
//                     child: RawMaterialButton(
//                       shape: CircleBorder(),
//                       padding: const EdgeInsets.all(10.0),
//                       focusColor: Colors.grey[600],
//                       fillColor: Colors.black,
//                       child: Icon(
//                         Icons.arrow_left,
//                         size: 28,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         controls();
//                         _controller
//                             .seekTo(Duration(seconds: _playBackPosition - 10));
//                       },
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 50.0,
//                     right: 0.0,
//                     child: RawMaterialButton(
//                       shape: CircleBorder(),
//                       padding: const EdgeInsets.all(10.0),
//                       focusColor: Colors.grey[600],
//                       fillColor: Colors.black,
//                       child: Icon(
//                         Icons.arrow_right,
//                         size: 28,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         controls();
//                         _controller
//                             .seekTo(Duration(seconds: _playBackPosition + 10));
//                       },
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 5.0,
//                     left: 20.0,
//                     right: 20.0,
//                     child: Slider(
//                       activeColor: Colors.red[900],
//                       value: _playBackPosition.toDouble(),
//                       min: 0,
//                       max: _controller.value.duration.inSeconds.toDouble(),
//                       onChanged: (v) {
//                         controls();
//                         _controller.seekTo(Duration(seconds: v.toInt()));
//                       },
//                     ),
//                   ),
//                   VideoProgressIndicator(_controller, allowScrubbing: true),
//                 ],
//               ),
//             );
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }
