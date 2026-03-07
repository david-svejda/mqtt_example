import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:video_player/video_player.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  // Create a [Player] to control playback.
  late final _player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final _controller = VideoController(_player);

  @override
  void initState() {
    super.initState();

    // Play a [Media] or [Playlist].
    String url = kIsWeb ? "http://10.0.1.13:8888/stream/index.m3u8" : "rtsp://10.0.1.13:8554/stream";
    print("Opening video stream: $url");
    _player.open(Media(url));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("IoT Video Stream")),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 9.0 / 16.0,
          // Use [Video] widget to display video output.
          child: Video(controller: _controller),
        ),
      ),
    );
  }
}