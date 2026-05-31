import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// Video Player Screen for local playback
class InlineVideoPlayer extends StatefulWidget {
  final String videoPath;

  const InlineVideoPlayer({super.key, required this.videoPath});

  @override
  State<InlineVideoPlayer> createState() => _InlineVideoPlayerState();
}

class _InlineVideoPlayerState extends State<InlineVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Player'), backgroundColor: Colors.black),
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isPlaying ? _controller.pause() : _controller.play();
                            _isPlaying = !_isPlaying;
                          });
                        },
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 50),
                      ),
                      IconButton(
                        onPressed: () {
                          _controller.seekTo(Duration.zero);
                          setState(() {
                            _isPlaying = false;
                          });
                        },
                        icon: Icon(Icons.replay, color: Colors.white, size: 30),
                      ),
                    ],
                  ),
                  // Video progress bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: VideoProgressIndicator(_controller, allowScrubbing: true, padding: EdgeInsets.all(8)),
                  ),
                ],
              )
            : CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
