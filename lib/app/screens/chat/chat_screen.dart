import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/circle_icon_button.dart';
import 'package:ovowpp/app/components/custom_loader/custom_loader.dart';
import 'package:ovowpp/app/components/image/custom_svg_picture.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/app/components/image/my_network_image_widget.dart';
import 'package:ovowpp/app/components/no_data.dart';
import 'package:ovowpp/app/components/shimmer/chat_shimmer.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/app/components/text/default_text.dart';
import 'package:ovowpp/app/screens/chat/widget/app_bar_contents.dart';
import 'package:ovowpp/app/screens/chat/widget/voice_message_player.dart';
import 'package:ovowpp/app/screens/chat/widget/chat_box.dart';
import 'package:ovowpp/app/screens/dashboard/widget/round_icon_with_bg_color.dart';
import 'package:ovowpp/core/helper/date_converter.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_icons.dart';
import 'package:ovowpp/core/utils/my_images.dart';
import 'package:ovowpp/core/translations/strings_enum.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/data/controller/chat/chat_controller.dart';
import 'package:ovowpp/data/repo/chat/chat_repo.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/utils/app_status.dart';
import '../../../core/utils/app_permission.dart';
import '../../../data/controller/chat/pusher_p2p_chat_service_controller.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String comeFrom = '';

  @override
  void initState() {
    Get.put(ChatRepo());
    final controller = Get.put(ChatController(repo: Get.find()));
    final pusherController = Get.put(PusherChatServiceController(repo: Get.find()));
    super.initState();
    controller.conversationId = Get.arguments[0];
    controller.lastseen = Get.arguments[1];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await controller.getChatsData().then((v) async {
        pusherController.ensureConnection("private-receive-message-${controller.whatsappAccountId}");
      });
      controller.scrollController.addListener(controller.scrollListener);
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<ChatController>(
      id: 'chat_screen_main',
      builder: (controller) {
        final fileType = MyUtils.getFileType(controller.selectedFile?.path ?? "");
        return AnnotatedRegionWidget(
          child: Scaffold(
            backgroundColor: MyColor.white,
            appBar: AppBar(
              actionsPadding: EdgeInsets.zero,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: MyAssetImageWidget(assetPath: MyImages.arrowBack, isSvg: true, boxFit: BoxFit.scaleDown),
              ),
              scrolledUnderElevation: 0,
              backgroundColor: MyColor.white,
              elevation: 0,
              centerTitle: false,
              title: AppBarContents(),
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(MyImages.newChatBackground), fit: BoxFit.cover),
              ),
              child: Column(
                children: [
                  controller.isLoading
                      ? Expanded(child: const ChatListShimmer())
                      : controller.messages.isEmpty
                      ? Expanded(child: NoDataWidget())
                      : Expanded(
                          child: ListView.builder(
                            controller: controller.scrollController,
                            reverse: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.messages.length + 1,
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            itemBuilder: (context, index) {
                              if (controller.messages.length == index) {
                                return controller.hasNext()
                                    ? Container(
                                        child: controller.isSearch
                                            ? SizedBox()
                                            : const CustomLoader(isPagination: true),
                                      )
                                    : const SizedBox();
                              }
                              final item = controller.messages[index];
                              final isSender = item.type == "1";
                              return Row(
                                key: ValueKey(item.id),
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                                    child: IntrinsicWidth(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 12.w),
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: isSender ? MyColor.sendMessage : MyColor.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(12),
                                            topRight: const Radius.circular(12),
                                            bottomLeft: Radius.circular(isSender ? 12 : 0),
                                            bottomRight: Radius.circular(isSender ? 0 : 12),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (item.message != null)
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Flexible(
                                                    child: InkWell(
                                                      onDoubleTap: () {
                                                        Clipboard.setData(ClipboardData(text: item.message.toString()));
                                                        CustomSnackBar.success(
                                                          successList: [Strings.messageCopiedToClipBoard.tr],
                                                        );
                                                      },
                                                      child: buildRichText(
                                                        item.message.toString(),
                                                        theme.textTheme.bodyLarge?.copyWith(
                                                          fontSize: Dimensions.space15.sp,
                                                          color: MyColor.getHeadingTextColor(),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            if (item.mediaPath != null)
                                              buildMediaWidget(
                                                "${UrlContainer.domainUrl}/${controller.mediaPath}/${item.mediaPath}",
                                                item.messageType.toString(),
                                                item.mediaId ?? "",
                                                item.mimeType ?? "",
                                                index,
                                                controller,
                                              ),
                                            if (item.messageType.toString() == "3" ||
                                                item.messageType.toString() == "4" ||
                                                item.messageType.toString() == "5")
                                              buildMediaWidget(
                                                "${item.mediaUrl}",
                                                item.messageType.toString(),
                                                item.mediaId ?? "",
                                                item.mimeType ?? "",
                                                index,
                                                controller,
                                              ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                DefaultText(
                                                  text: DateConverter.convertUtcToLocalTime(item.createdAt.toString()),
                                                  textStyle: MyTextStyle.subHeading16W400(fontFamily: 'SFPRODISPLAY')
                                                      .copyWith(
                                                        color: MyColor.dashboardCardBorder.withAlpha(
                                                          MyColor.getAlpha(50),
                                                        ),
                                                        fontSize: 11.sp,
                                                      ),
                                                ),
                                                if (isSender) ...[
                                                  spaceSide(Dimensions.space4.w),
                                                  InkWell(
                                                    onTap: () {
                                                      if (item.status == AppStatus.FAILED) {
                                                        controller.sendMessage(chatId: item.id, index: index);
                                                      }
                                                    },
                                                    child: Icon(
                                                      item.status == AppStatus.SENT
                                                          ? Icons.done
                                                          : item.status == AppStatus.DELIVERED
                                                          ? Icons.done_all
                                                          : item.status == AppStatus.READ
                                                          ? Icons.done_all
                                                          : item.status == AppStatus.FAILED
                                                          ? Icons.refresh
                                                          : null,
                                                      color: item.status == AppStatus.READ
                                                          ? MyColor.getPrimaryColor()
                                                          : item.status == AppStatus.FAILED
                                                          ? MyColor.pendingColor
                                                          : MyColor.getBodyTextColor(),
                                                      size: Dimensions.space17.h,
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                            // const SizedBox(height: 4),
                                            // // Align(
                                            // //   alignment: Alignment.bottomRight,
                                            // //   child: Text(DateConverter.convertUtcToLocalTime(item.createdAt.toString()), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                            // // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                  controller.isSearch
                      ? SizedBox()
                      : Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: Dimensions.space12.h,
                              horizontal: Dimensions.space16.w,
                            ),
                            decoration: BoxDecoration(
                              color: MyColor.white,
                              border: Border(top: BorderSide(color: MyColor.dashboardCardBorder, width: 1)),
                            ),
                            child: GetBuilder<ChatController>(
                              id: 'recording_area',
                              builder: (controller) {
                                return (controller.isRecording || controller.isPreviewing)
                                    ? _buildRecordingOverlay(controller)
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          controller.selectedFile != null
                                              ? Stack(
                                                  children: [
                                                    if (fileType == 'image')
                                                      Container(
                                                        margin: const EdgeInsets.all(Dimensions.space5),
                                                        decoration: const BoxDecoration(),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                                                          child: Image.file(
                                                            controller.selectedFile!,
                                                            width: context.width / 7,
                                                            height: context.width / 7,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      )
                                                    else
                                                      Container(
                                                        width: context.width / 5,
                                                        height: context.width / 5,
                                                        decoration: BoxDecoration(
                                                          color: MyColor.white,
                                                          borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                                                          border: Border.all(color: MyColor.getBorderColor(), width: 1),
                                                        ),
                                                        child: Center(
                                                          child: fileType == 'excel'
                                                              ? const CustomSvgPicture(
                                                                  image: MyIcons.xlsx,
                                                                  height: 45,
                                                                  width: 45,
                                                                )
                                                              : fileType == 'word'
                                                              ? const CustomSvgPicture(
                                                                  image: MyIcons.doc,
                                                                  height: 45,
                                                                  width: 45,
                                                                )
                                                              : fileType == 'video'
                                                              ? const Icon(
                                                                  Icons.videocam,
                                                                  size: 45,
                                                                  color: MyColor.lightBodyText,
                                                                )
                                                              : fileType == 'audio'
                                                              ? const Icon(
                                                                  Icons.audiotrack,
                                                                  size: 45,
                                                                  color: MyColor.lightBodyText,
                                                                )
                                                              : const CustomSvgPicture(
                                                                  image: MyIcons.pdfFile,
                                                                  height: 45,
                                                                  width: 45,
                                                                ),
                                                        ),
                                                      ),

                                                    // Close button
                                                    Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: CircleIconButton(
                                                        onTap: () {
                                                          controller.removeAttachmentFromList();
                                                        },
                                                        height: Dimensions.space20,
                                                        width: Dimensions.space20,
                                                        backgroundColor: MyColor.getErrorColor(),
                                                        child: Icon(
                                                          Icons.close,
                                                          color: MyColor.white,
                                                          size: Dimensions.space12,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : SizedBox(),
                                          // Buttons Row
                                          Container(
                                            color: MyColor.white,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                PopupMenuButton<int>(
                                                  itemBuilder: (context) => [
                                                    PopupMenuItem(
                                                      onTap: () {
                                                        controller.pickDocs();
                                                      },
                                                      value: 1,
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.file_present,
                                                            size: Dimensions.space25.h,
                                                            color: MyColor.lightBodyText,
                                                          ),
                                                          spaceSide(Dimensions.space5),
                                                          Text(
                                                            Strings.document.tr,
                                                            style: theme.textTheme.titleMedium?.copyWith(
                                                              color: MyColor.getBodyTextColor(),
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    PopupMenuItem(
                                                      onTap: () {
                                                        controller.pickFile(1);
                                                      },
                                                      value: 2,
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.videocam,
                                                            size: Dimensions.space25.h,
                                                            color: MyColor.lightBodyText,
                                                          ),
                                                          spaceSide(Dimensions.space5),
                                                          Text(
                                                            Strings.video.tr,
                                                            style: theme.textTheme.titleMedium?.copyWith(
                                                              color: MyColor.getBodyTextColor(),
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                  offset: const Offset(-10, -130),
                                                  color: MyColor.white,
                                                  elevation: 1,
                                                  onSelected: (value) {},
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(Dimensions.space8.h),
                                                      color: MyColor.white,
                                                    ),
                                                    child: MyAssetImageWidget(
                                                      assetPath: MyImages.add,
                                                      isSvg: true,
                                                      color: MyColor.recentlyActivityIconColor,
                                                      height: Dimensions.space24.h,
                                                      width: Dimensions.space24.h,
                                                    ),
                                                  ),
                                                ),
                                                spaceSide(Dimensions.space8.w),
                                                GestureDetector(
                                                  onTap: () {
                                                    controller.pickFile(0);
                                                  },
                                                  child: Container(
                                                    //  padding: EdgeInsets.all(Dimensions.space12.h),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(Dimensions.space8.h),
                                                      color: MyColor.white,
                                                    ),
                                                    child: MyAssetImageWidget(
                                                      assetPath: MyImages.gallery,
                                                      isSvg: true,
                                                      color: MyColor.recentlyActivityIconColor,
                                                      height: Dimensions.space24.h,
                                                      width: Dimensions.space24.h,
                                                    ),
                                                  ),
                                                ),
                                                spaceSide(Dimensions.space8.w),
                                                // Mic button (tap or long-press to record)
                                                GestureDetector(
                                                  behavior: HitTestBehavior.opaque,
                                                  onTap: () {
                                                    FocusManager.instance.primaryFocus?.unfocus();
                                                    if (MyUtils.checkPermission(AppPermission.sendMessage)) {
                                                      controller.startRecording();
                                                    } else {
                                                      CustomSnackBar.error(
                                                        errorList: [Strings.permissionDenyMessage],
                                                      );
                                                    }
                                                  },
                                                  onLongPress: () {
                                                    FocusManager.instance.primaryFocus?.unfocus();
                                                    if (MyUtils.checkPermission(AppPermission.sendMessage)) {
                                                      controller.startRecording();
                                                    } else {
                                                      CustomSnackBar.error(
                                                        errorList: [Strings.permissionDenyMessage],
                                                      );
                                                    }
                                                  },
                                                  onLongPressEnd: (_) {
                                                    if (controller.isRecording && !controller.isRecordingLocked) {
                                                      controller.stopAndSendRecording();
                                                    }
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(Dimensions.space8.h),
                                                      color: MyColor.white,
                                                    ),
                                                    child: Icon(
                                                      Icons.mic,
                                                      color: MyColor.recentlyActivityIconColor,
                                                      size: Dimensions.space24.h,
                                                    ),
                                                  ),
                                                ),
                                                spaceSide(Dimensions.space8.w),
                                                Expanded(child: ChatBox()),

                                                // Send button (always visible)
                                                GestureDetector(
                                                  onTap: () {
                                                    if (MyUtils.checkPermission(AppPermission.sendMessage)) {
                                                      controller.sendMessage();
                                                    } else {
                                                      CustomSnackBar.error(
                                                        errorList: [Strings.permissionDenyMessage],
                                                      );
                                                    }
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.all(Dimensions.space8.r),
                                                    child: controller.sendingMessage
                                                        ? Padding(
                                                            padding: EdgeInsets.only(left: Dimensions.space6.w),
                                                            child: SizedBox(
                                                              height: 25.h,
                                                              width: 25.w,
                                                              child: CircularProgressIndicator(
                                                                color: MyColor.getPrimaryColor(),
                                                                strokeWidth: 3,
                                                              ),
                                                            ),
                                                          )
                                                        : RoundIconWithBgColor(
                                                            height: 15.h,
                                                            width: 15.w,
                                                            bgColor: MyColor.chatMessageSendBgColor,
                                                            icon: MyImages.sendMessage,
                                                            iconColor: MyColor.white,
                                                          ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                              },
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecordingOverlay(ChatController controller) {
    if (controller.isPreviewing && controller.recordedFilePath != null) {
      return Row(
        children: [
          // Delete button
          GestureDetector(
            onTap: () => controller.cancelRecording(),
            child: Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: MyColor.getErrorColor().withAlpha(MyColor.getAlpha(15)),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.delete_outline, color: MyColor.getErrorColor(), size: 22.h),
            ),
          ),
          SizedBox(width: 12.w),
          // Preview player
          Expanded(
            child: VoiceMessagePlayer(
              key: ValueKey(controller.recordedFilePath),
              audioPath: controller.recordedFilePath!,
              isLocal: true,
              activeColor: MyColor.getErrorColor(),
              icon: Icons.mic,
            ),
          ),
          SizedBox(width: 12.w),
          // Send button
          GestureDetector(
            onTap: () => controller.sendPreview(),
            child: Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(color: MyColor.chatMessageSendBgColor, shape: BoxShape.circle),
              child: controller.sendingMessage
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(color: MyColor.white, strokeWidth: 2),
                    )
                  : Icon(Icons.send, color: MyColor.white, size: 20.h),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        // Cancel button
        GestureDetector(
          onTap: () => controller.cancelRecording(),
          child: Container(
            height: 40.h,
            width: 40.w,
            decoration: BoxDecoration(
              color: MyColor.getErrorColor().withAlpha(MyColor.getAlpha(15)),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.delete_outline, color: MyColor.getErrorColor(), size: 22.h),
          ),
        ),
        SizedBox(width: 12.w),
        // Recording indicator + duration
        Expanded(
          child: Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: MyColor.getErrorColor().withAlpha(MyColor.getAlpha(8)),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Row(
              children: [
                GetBuilder<ChatController>(
                  id: 'recording_duration',
                  builder: (controller) {
                    return Text(
                      controller.recordingDuration,
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: MyColor.getErrorColor()),
                    );
                  },
                ),
                SizedBox(width: 15.w),
                // Visualization
                Expanded(
                  child: GetBuilder<ChatController>(
                    id: 'recording_duration',
                    builder: (controller) {
                      return SizedBox(
                        height: 30.h,
                        child: CustomPaint(
                          painter: VoiceWaveformPainter(
                            amplitudes: controller.amplitudes,
                            color: MyColor.getErrorColor().withValues(alpha: 0.8),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        // Stop button (enters preview)
        GestureDetector(
          onTap: () => controller.stopRecording(),
          child: Container(
            height: 40.h,
            width: 40.w,
            decoration: BoxDecoration(color: MyColor.getErrorColor(), shape: BoxShape.circle),
            child: Icon(Icons.stop, color: MyColor.white, size: 20.h),
          ),
        ),
      ],
    );
  }
}

Widget buildMediaWidget(
  String? mediaPath,
  String msgType,
  String? mediaId,
  String extension,
  int index,
  ChatController controller,
) {
  if (mediaPath == null || mediaPath.isEmpty) return const SizedBox();

  final String url = mediaPath.replaceAll('\\', '/');
  final String lowerPath = url.toLowerCase();
  final String lowerExtension = extension.toLowerCase();

  // Check for images - use both path and extension
  final bool isImage =
      lowerPath.endsWith('.jpg') ||
      lowerPath.endsWith('.jpeg') ||
      lowerPath.endsWith('.png') ||
      lowerPath.endsWith('.gif') ||
      lowerPath.endsWith('.bmp') ||
      lowerPath.endsWith('.webp') ||
      lowerExtension == 'jpg' ||
      lowerExtension == 'jpeg' ||
      lowerExtension == 'png' ||
      lowerExtension == 'gif' ||
      lowerExtension == 'bmp' ||
      lowerExtension == 'webp';

  if (isImage) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: GestureDetector(
        onTap: () {
          Get.toNamed(RouteHelper.previewImageScreen, arguments: [url, mediaId, index, extension]);
        },
        child: MyNetworkImageWidget(imageUrl: url, boxFit: BoxFit.cover, height: 200, width: 200),
      ),
    );
  }

  // Check for audio
  final bool isAudio =
      lowerPath.endsWith('.mp3') ||
      lowerPath.endsWith('.ogg') ||
      lowerPath.endsWith('.wav') ||
      lowerPath.endsWith('.m4a') ||
      lowerPath.endsWith('.aac') ||
      lowerPath.endsWith('.mpeg') ||
      lowerPath.endsWith('.opus') ||
      lowerPath.endsWith('.amr') ||
      lowerPath.endsWith('.flac') ||
      lowerPath.endsWith('.wma') ||
      lowerPath.endsWith('.aiff') ||
      lowerPath.endsWith('.alac') ||
      lowerExtension == 'mp3' ||
      lowerExtension == 'ogg' ||
      lowerExtension == 'wav' ||
      lowerExtension == 'm4a' ||
      lowerExtension == 'aac' ||
      lowerExtension == 'mpeg' ||
      lowerExtension == 'opus' ||
      lowerExtension == 'amr' ||
      lowerExtension == 'flac' ||
      lowerExtension == 'wma' ||
      lowerExtension == 'aiff' ||
      lowerExtension == 'alac';

  if (isAudio) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: VoiceMessagePlayer(
        key: ValueKey(url),
        audioPath: url,
        isLocal: false,
        activeColor: MyColor.getPrimaryColor(),
        icon: (lowerPath.endsWith('.ogg') || lowerExtension == 'ogg') ? Icons.mic : Icons.music_note,
      ),
    );
  }

  // For file attachments (msgType 3 or 4)
  if (msgType == "3" || msgType == "4") {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: GetBuilder<ChatController>(
        builder: (controller) {
          return GestureDetector(
            onTap: () {
              controller.downloadAttachment(mediaId ?? "", index, extension);
            },
            child: Container(
              padding: EdgeInsets.all(8),
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
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "${mediaId ?? "file"}.$extension",
                      style: TextStyle(fontSize: Dimensions.space14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(width: 8),
                  controller.downloadingFile && controller.selectedIndex == index
                      ? CustomLoader()
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
  }

  return const SizedBox();
}

// Add this new function to detect and make URLs clickable
Widget buildRichText(String text, TextStyle? style) {
  final urlPattern = RegExp(
    r'(?:(?:https?|ftp):\/\/)?(?:www\.)?[a-zA-Z0-9-]+(?:\.[a-zA-Z]{2,})+(?:\/[^\s]*)?',
    caseSensitive: false,
  );

  final matches = urlPattern.allMatches(text);

  if (matches.isEmpty) {
    return Text(text, style: style);
  }

  List<TextSpan> spans = [];
  int currentPosition = 0;

  for (final match in matches) {
    // Add text before URL
    if (match.start > currentPosition) {
      spans.add(TextSpan(text: text.substring(currentPosition, match.start), style: style));
    }

    // Add the URL
    final url = match.group(0) ?? '';
    spans.add(
      TextSpan(
        text: '\n$url', // Add newline before URL
        style: style?.copyWith(
          color: MyColor.getPrimaryColor(),
          // decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            String urlToLaunch = url;
            if (!url.startsWith('http://') && !url.startsWith('https://')) {
              urlToLaunch = 'https://$url';
            }

            try {
              final uri = Uri.parse(urlToLaunch);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                CustomSnackBar.error(errorList: ['Could not open URL']);
              }
            } catch (e) {
              CustomSnackBar.error(errorList: ['Invalid URL']);
            }
          },
      ),
    );

    currentPosition = match.end;
  }

  // Add remaining text
  if (currentPosition < text.length) {
    spans.add(TextSpan(text: text.substring(currentPosition), style: style));
  }

  return RichText(text: TextSpan(children: spans));
}

class VoiceWaveformPainter extends CustomPainter {
  final List<double> amplitudes;
  final Color color;

  VoiceWaveformPainter({required this.amplitudes, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    if (amplitudes.isEmpty) return;

    final double spacing = 4.0;
    final double totalWidth = amplitudes.length * spacing;
    final double startX = (size.width - totalWidth) / 2;

    for (int i = 0; i < amplitudes.length; i++) {
      final double x = startX + (i * spacing);
      final double amp = amplitudes[i];
      final double height = (size.height * amp).clamp(4.0, size.height);

      final double top = (size.height - height) / 2;
      final double bottom = top + height;

      canvas.drawLine(Offset(x, top), Offset(x, bottom), paint);
    }
  }

  @override
  bool shouldRepaint(covariant VoiceWaveformPainter oldDelegate) {
    return oldDelegate.amplitudes != amplitudes;
  }
}
