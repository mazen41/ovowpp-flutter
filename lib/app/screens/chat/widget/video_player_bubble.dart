import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/translations/strings_enum.dart';
import 'package:video_player/video_player.dart';
import 'package:ovowpp/data/services/api_service.dart';

/// Inline video player bubble for chat messages.
/// Shows a thumbnail with play/pause control and a scrubber bar.
/// API stream URLs are loaded with the Bearer token; public file URLs are not.
class VideoPlayerBubble extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerBubble({super.key, required this.videoUrl});

  @override
  State<VideoPlayerBubble> createState() => _VideoPlayerBubbleState();
}

class _VideoPlayerBubbleState extends State<VideoPlayerBubble> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _isBuffering = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    try {
      final url = widget.videoUrl.trim();
      if (url.isEmpty) throw StateError('Empty video URL');

      final controller = VideoPlayerController.networkUrl(
        Uri.parse(url),
        httpHeaders: await ApiService.mediaHeadersFor(url),
      );
      await controller.initialize();

      if (_disposed) {
        controller.dispose();
        return;
      }

      controller.addListener(_onVideoListener);
      setState(() {
        _controller = controller;
        _isInitialized = true;
      });
    } catch (error) {
      debugPrint('Video load error: $error');
      if (!_disposed && mounted) setState(() => _hasError = true);
    }
  }

  void _onVideoListener() {
    final controller = _controller;
    if (!mounted || controller == null) return;
    setState(() => _isBuffering = controller.value.isBuffering);
  }

  @override
  void dispose() {
    _disposed = true;
    _controller?.removeListener(_onVideoListener);
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    final controller = _controller;
    if (controller == null) return;
    setState(() {
      controller.value.isPlaying ? controller.pause() : controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    const double bubbleWidth = 220;

    if (_hasError) {
      return Container(
        width: bubbleWidth,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.videocam_off_rounded, color: Colors.grey, size: 36),
              SizedBox(height: 6),
              Text(Strings.videoUnavailable.tr, style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      );
    }

    final controller = _controller;
    if (!_isInitialized || controller == null) {
      return Container(
        width: bubbleWidth,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GestureDetector(
        onTap: _togglePlayback,
        child: Container(
          width: bubbleWidth,
          color: Colors.black,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: controller.value.aspectRatio.clamp(0.5, 2.0).toDouble(),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(controller),
                    // Buffering spinner
                    if (_isBuffering)
                      Container(
                        color: Colors.black26,
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        ),
                      ),
                    // Play/pause overlay
                    if (!controller.value.isPlaying && !_isBuffering)
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30),
                      ),
                    // Duration badge (top-right)
                    Positioned(
                      top: 6,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _formatDuration(controller.value.duration),
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Scrubber bar
              VideoProgressIndicator(
                controller,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: Theme.of(context).primaryColor,
                  bufferedColor: Colors.white30,
                  backgroundColor: Colors.white10,
                ),
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
