import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:ovowpp/core/utils/my_color.dart';

class VoiceMessagePlayer extends StatefulWidget {
  final String audioPath;
  final bool isLocal;
  final Color? activeColor;
  final IconData? icon;

  const VoiceMessagePlayer({super.key, required this.audioPath, this.isLocal = false, this.activeColor, this.icon});

  @override
  State<VoiceMessagePlayer> createState() => _VoiceMessagePlayerState();
}

class _VoiceMessagePlayerState extends State<VoiceMessagePlayer> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(covariant VoiceMessagePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    String oldPath = oldWidget.audioPath.trim();
    String newPath = widget.audioPath.trim();

    if (oldPath != newPath) {
      _controller?.dispose();
      _controller = null;
      _isInitialized = false;
      _hasError = false;
      _initializePlayer();
    }
  }

  void _initializePlayer() {
    if (widget.audioPath.isEmpty) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
      return;
    }

    if (_isInitialized && _controller?.dataSource == widget.audioPath) {
      return;
    }

    _controller = widget.isLocal
        ? VideoPlayerController.file(File(widget.audioPath))
        : VideoPlayerController.networkUrl(Uri.parse(widget.audioPath));

    _controller
        ?.initialize()
        .then((_) {
          if (mounted) {
            setState(() {
              _isInitialized = true;
            });
          }
        })
        .catchError((error) {
          if (mounted) {
            setState(() {
              _hasError = true;
            });
          }
          debugPrint("Audio Player Error: $error");
        });

    _controller?.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(color: Colors.red.withAlpha(50), borderRadius: BorderRadius.circular(10.r)),
        child: const Icon(Icons.error_outline, color: Colors.red),
      );
    }

    if (!_isInitialized || _controller == null) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(8.r),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: widget.activeColor ?? MyColor.getPrimaryColor()),
          ),
        ),
      );
    }

    final duration = _controller?.value.duration ?? Duration.zero;
    final position = _controller?.value.position ?? Duration.zero;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: (widget.activeColor ?? MyColor.getPrimaryColor()).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              if (_controller == null) return;
              if (_controller!.value.isPlaying) {
                _controller!.pause();
              } else {
                if (position >= duration) {
                  _controller!.seekTo(Duration.zero);
                }
                _controller!.play();
              }
            },
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(color: widget.activeColor ?? MyColor.getPrimaryColor(), shape: BoxShape.circle),
              child: Icon(
                (_controller?.value.isPlaying ?? false) ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 20.r,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2.h,
                    showValueIndicator: ShowValueIndicator.never,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 12.r),
                    activeTrackColor: widget.activeColor ?? MyColor.getPrimaryColor(),
                    inactiveTrackColor: (widget.activeColor ?? MyColor.getPrimaryColor()).withValues(alpha: 0.3),
                    thumbColor: widget.activeColor ?? MyColor.getPrimaryColor(),
                  ),
                  child: Slider(
                    value: position.inMilliseconds.toDouble(),
                    max: duration.inMilliseconds.toDouble(),
                    onChanged: (value) {
                      _controller?.seekTo(Duration(milliseconds: value.toInt()));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(position),
                        style: TextStyle(fontSize: 10.sp, color: MyColor.getBodyTextColor()),
                      ),
                      Text(
                        _formatDuration(duration),
                        style: TextStyle(fontSize: 10.sp, color: MyColor.getBodyTextColor()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.icon != null) ...[
            SizedBox(width: 8.w),
            Icon(widget.icon, size: 20.r, color: widget.activeColor ?? MyColor.getPrimaryColor()),
          ],
        ],
      ),
    );
  }
}
