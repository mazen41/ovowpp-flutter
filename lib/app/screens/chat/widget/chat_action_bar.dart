import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/screens/chat/widget/tag_picker.dart';
import 'package:ovowpp/core/translations/strings_enum.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/data/controller/chat/chat_controller.dart';

/// Row of conversation action chips under the chat header.
///
/// Order is written left-to-right for LTR; in RTL the first child is the
/// rightmost chip, matching the reference design (follow, reopen, assign).
/// The AI auto-reply chip is shown only when the conversation details include
/// ai_reply (the route POST inbox/conversation/ai-reply/{id} is registered).
class ChatActionBar extends StatelessWidget {
  const ChatActionBar({super.key, required this.controller});

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    final busy = controller.changingStatus;
    final isDone = controller.conversationStatus == 1;
    final isFollowed = controller.conversationStatus == 3;

    return Container(
      color: MyColor.white,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _chip(
              icon: isFollowed ? Icons.star_rounded : Icons.star_outline_rounded,
              label: Strings.chatFollow.tr,
              active: isFollowed,
              enabled: !busy,
              onTap: controller.toggleFollow,
            ),
            if (isDone)
              _chip(
                icon: Icons.replay_rounded,
                label: Strings.chatReopen.tr,
                enabled: !busy,
                onTap: controller.reopenConversation,
              ),
            if (controller.aiReplyKnown)
              _chip(
                icon: Icons.smart_toy_outlined,
                label: controller.aiReplyOn ? Strings.chatAutoReplyStop.tr : Strings.chatAutoReplyStart.tr,
                active: controller.aiReplyOn,
                enabled: !controller.changingAiReply && !busy,
                onTap: controller.toggleAiReply,
              ),
            _chip(
              icon: Icons.person_outline_rounded,
              label: Strings.chatAssign.tr,
              enabled: true,
              onTap: () async {
                await controller.loadTagsForPicker();
                if (context.mounted) TagPicker.show(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip({
    required IconData icon,
    required String label,
    required bool enabled,
    required Future<void> Function() onTap,
    bool active = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: Material(
          color: active ? MyColor.chatChipActiveBg : MyColor.chatChipBg,
          borderRadius: BorderRadius.circular(12.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: enabled ? () => onTap() : null,
            child: SizedBox(
              width: 84.w,
              height: 58.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20.sp, color: MyColor.chatHeaderGreen),
                  SizedBox(height: 4.h),
                  Text(
                    label,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: MyColor.chatHeaderGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
