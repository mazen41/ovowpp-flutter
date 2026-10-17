import 'dart:io';
import 'package:ovowpp/core/translations/strings_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/data/services/api_service.dart';

/// Plays a WhatsApp voice note or audio file in a chat bubble.
///
/// Uses video_player (already a dependency). On Android its ExoPlayer plays
/// OGG/Opus voice notes.
///
/// iOS cannot play OGG/Opus (AVPlayer). On iOS this widget shows the
/// "Audio unavailable" state. Server-side transcoding to AAC is the planned fix if
/// iOS is ever released. The current release target is Google Play (Android).
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

  // Incremented on every load so a slow, superseded load cannot overwrite a newer one.
  int _loadToken = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant VoiceMessagePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.audioPath.trim() != widget.audioPath.trim() || oldWidget.isLocal != widget.isLocal) {
      _disposeController();
      _load();
    }
  }

  void _disposeController() {
    _loadToken++;
    _controller?.dispose();
    _controller = null;
    _isInitialized = false;
    _hasError = false;
  }

  Future<void> _load() async {
    final path = widget.audioPath.trim();
    final token = ++_loadToken;

    if (path.isEmpty) {
      _setError();
      return;
    }

    try {
      final VideoPlayerController controller = widget.isLocal
          ? VideoPlayerController.file(File(path))
          : VideoPlayerController.networkUrl(
              Uri.parse(path),
              // API stream URLs need the Bearer token; public file URLs get none.
              httpHeaders: await ApiService.mediaHeadersFor(path),
            );

      await controller.initialize();

      if (!mounted || token != _loadToken) {
        controller.dispose();
        return;
      }

      controller.addListener(_onControllerTick);
      setState(() {
        _controller = controller;
        _isInitialized = true;
        _hasError = false;
      });
    } catch (error) {
      debugPrint('Voice message load error: $error');
      if (token == _loadToken) _setError();
    }
  }

  void _setError() {
    if (!mounted) return;
    setState(() {
      _hasError = true;
      _isInitialized = false;
    });
  }

  void _onControllerTick() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _loadToken++;
    _controller?.removeListener(_onControllerTick);
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 6),
            Text(Strings.audioUnavailable.tr, style: TextStyle(color: Colors.red, fontSize: 12)),
          ],
        ),
      );
    }

    final controller = _controller;
    if (!_isInitialized || controller == null) {
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

    final duration = controller.value.duration;
    final position = controller.value.position;
    final isPlaying = controller.value.isPlaying;
    final activeColor = widget.activeColor ?? MyColor.getPrimaryColor();
    final durationMs = duration.inMilliseconds.toDouble();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: activeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              if (isPlaying) {
                controller.pause();
              } else {
                if (duration > Duration.zero && position >= duration) {
                  controller.seekTo(Duration.zero);
                }
                controller.play();
              }
            },
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(color: activeColor, shape: BoxShape.circle),
              child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 20.r),
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
                    activeTrackColor: activeColor,
                    inactiveTrackColor: activeColor.withValues(alpha: 0.3),
                    thumbColor: activeColor,
                  ),
                  child: Slider(
                    value: position.inMilliseconds.toDouble().clamp(0.0, durationMs > 0 ? durationMs : 1.0).toDouble(),
                    max: durationMs > 0 ? durationMs : 1,
                    onChanged: duration.inMilliseconds > 0
                        ? (value) => controller.seekTo(Duration(milliseconds: value.toInt()))
                        : null,
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
            Icon(widget.icon, size: 20.r, color: activeColor),
          ],
        ],
      ),
    );
  }
}
