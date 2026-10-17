import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/custom_loader/custom_loader.dart';
import 'package:ovowpp/app/components/image/my_network_image_widget.dart';
import 'package:ovowpp/app/screens/chat/widget/video_player_bubble.dart';
import 'package:ovowpp/app/screens/chat/widget/voice_message_player.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/app_status.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/data/controller/chat/chat_controller.dart';
import 'package:ovowpp/data/model/chat/chat_data_response_model.dart';

/// Chat attachments: image, video, audio and document bubbles.
///
/// The message type decides how a message is rendered. The file extension is
/// only a fallback when the type is missing or unknown. Missing or unsupported
/// media shows a small placeholder, never an error.

const Set<String> _mediaMessageTypes = {
  AppStatus.IMAGE_TYPE_MESSAGE,
  AppStatus.VIDEO_TYPE_MESSAGE,
  AppStatus.DOCUMENT_TYPE_MESSAGE,
  AppStatus.AUDIO_TYPE_MESSAGE,
};

const Set<String> _imageExtensions = {'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'};
const Set<String> _audioExtensions = {'mp3', 'ogg', 'opus', 'wav', 'm4a', 'aac', 'mpeg', 'amr', 'flac', 'wma', 'aiff', 'alac'};
const Set<String> _videoExtensions = {'mp4', 'mov', 'webm', '3gp', 'mkv', 'avi', 'quicktime'};
const Set<String> _documentExtensions = {'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt', 'csv'};

enum _MediaKind { image, audio, video, document, unknown }

/// True when the message type is an image, video, document or audio message.
bool isMediaMessage(MessagesData item) => _mediaMessageTypes.contains(item.messageType);

/// Stream endpoint for audio and video. Seekable, and works for old rows without
/// media_path. The Bearer token must be sent as a header (see ApiService.mediaHeadersFor).
String mediaStreamUrl(String mediaId) => '${UrlContainer.baseUrl}${UrlContainer.streamMediaDataEndPoint}$mediaId';

/// The URL the bubble should load, or null when there is nothing to load.
String? resolveMediaUrl(MessagesData item, String mediaBasePath) {
  final mediaId = item.safeMediaId;
  final type = item.messageType;

  if ((type == AppStatus.AUDIO_TYPE_MESSAGE || type == AppStatus.VIDEO_TYPE_MESSAGE) && mediaId != null) {
    return mediaStreamUrl(mediaId);
  }

  final path = item.safeMediaPath;
  if (path == null) return null;
  return _joinMediaUrl(UrlContainer.domainUrl, mediaBasePath, path);
}

/// File extension used for labels and as the fallback for the kind.
String mediaExtension(MessagesData item) {
  final filename = item.safeMediaFilename;
  if (filename != null && filename.contains('.')) {
    return filename.split('.').last.toLowerCase();
  }
  final mime = (item.safeMimeType ?? '').split(';').first.trim().toLowerCase();
  if (mime.contains('/')) return mime.split('/').last;
  return '';
}

/// Joins domain, base path and file path without double slashes.
String _joinMediaUrl(String domain, String basePath, String filePath) {
  final base = domain.replaceAll(RegExp(r'/+$'), '');
  final mid = basePath.replaceAll(RegExp(r'^/+|/+$'), '');
  final end = filePath.replaceAll(RegExp(r'^/+|/+$'), '').replaceAll('\\', '/');
  return mid.isEmpty ? '$base/$end' : '$base/$mid/$end';
}

_MediaKind _kindFor(String? messageType, String extension) {
  switch (messageType) {
    case AppStatus.IMAGE_TYPE_MESSAGE:
      return _MediaKind.image;
    case AppStatus.VIDEO_TYPE_MESSAGE:
      return _MediaKind.video;
    case AppStatus.DOCUMENT_TYPE_MESSAGE:
      return _MediaKind.document;
    case AppStatus.AUDIO_TYPE_MESSAGE:
      return _MediaKind.audio;
  }

  // Message type missing or unknown: fall back to the extension.
  final ext = extension.toLowerCase();
  if (_imageExtensions.contains(ext)) return _MediaKind.image;
  if (_audioExtensions.contains(ext)) return _MediaKind.audio;
  if (_videoExtensions.contains(ext)) return _MediaKind.video;
  if (_documentExtensions.contains(ext)) return _MediaKind.document;
  return _MediaKind.unknown;
}

Widget buildMediaWidget(
  String? url,
  String msgType,
  String? mediaId,
  String extension,
  int index,
  ChatController controller,
) {
  final kind = _kindFor(msgType, extension);

  switch (kind) {
    case _MediaKind.image:
      if (url == null || url.isEmpty) {
        return _placeholder(Icons.image_not_supported_outlined, 'Image unavailable');
      }
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: GestureDetector(
          onTap: () {
            Get.toNamed(RouteHelper.previewImageScreen, arguments: [url, mediaId, index, extension]);
          },
          child: MyNetworkImageWidget(imageUrl: url, boxFit: BoxFit.cover, height: 200, width: 200),
        ),
      );

    case _MediaKind.audio:
      if (url == null || url.isEmpty) {
        return _placeholder(Icons.mic_off_outlined, 'Voice message unavailable');
      }
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: VoiceMessagePlayer(
          key: ValueKey(url),
          audioPath: url,
          isLocal: false,
          activeColor: MyColor.getPrimaryColor(),
          icon: (extension == 'ogg' || extension == 'opus') ? Icons.mic : Icons.music_note,
        ),
      );

    case _MediaKind.video:
      if (url == null || url.isEmpty) {
        return _placeholder(Icons.videocam_off_outlined, 'Video unavailable');
      }
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: VideoPlayerBubble(key: ValueKey(url), videoUrl: url),
      );

    case _MediaKind.document:
      if (mediaId == null || mediaId.isEmpty) {
        return _placeholder(Icons.insert_drive_file_outlined, 'Document unavailable');
      }
      // Documents download through the download endpoint (not the stream).
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: GetBuilder<ChatController>(
          builder: (chat) {
            return GestureDetector(
              onTap: () => chat.downloadAttachment(mediaId, index, extension),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: MyColor.dashboardCardBorder.withAlpha(MyColor.getAlpha(30))),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.insert_drive_file,
                      size: Dimensions.space20,
                      color: MyColor.getBodyTextColor().withValues(alpha: .7),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '$mediaId.${extension.isEmpty ? 'file' : extension}',
                        style: TextStyle(fontSize: Dimensions.space14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    chat.downloadingFile && chat.selectedIndex == index
                        ? CustomLoader(loaderSize: 6)
                        : Icon(
                            Icons.download,
                            size: Dimensions.space24,
                            color: MyColor.getBodyTextColor().withValues(alpha: .7),
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      );

    case _MediaKind.unknown:
      return _placeholder(Icons.attach_file, 'Unsupported attachment');
  }
}

Widget _placeholder(IconData icon, String label) {
  return Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: MyColor.getBodyTextColor().withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: MyColor.getBodyTextColor().withValues(alpha: .6)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: MyColor.getBodyTextColor().withValues(alpha: .6)),
            ),
          ),
        ],
      ),
    ),
  );
}
