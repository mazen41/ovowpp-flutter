import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/translations/strings_enum.dart';
import 'package:ovowpp/data/controller/home/home_controller.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:ovowpp/app/components/avatar/alphabet_avatar.dart';
import 'package:ovowpp/app/components/text/default_text.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/controller/chat/chat_controller.dart';
import '../../../../core/utils/app_permission.dart';
import '../../../../data/controller/all_contacts/all_contact_controller.dart';
import '../../../components/snack_bar/show_custom_snackbar.dart';
import '../../contact/widgets/contact_item.dart';
import '../widget/template_picker.dart';
import '../widget/interactive_list_picker.dart';
import '../widget/cta_url_picker.dart';

class AppBarContents extends StatefulWidget {
  const AppBarContents({super.key});

  @override
  State<AppBarContents> createState() => _AppBarContentsState();
}

class _AppBarContentsState extends State<AppBarContents> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      builder: (controller) => ShowUpAnimation(
        curve: Curves.easeIn,
        direction: Direction.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // ── Avatar ────────────────────────────────────────────────────
            controller.contact?.imageSrc != null
                ? GestureDetector(
                    onTap: () => _openDetails(controller),
                    child: CircleAvatar(
                      maxRadius: 20.r,
                      backgroundImage: NetworkImage(controller.contact?.imageSrc ?? ''),
                    ),
                  )
                : GestureDetector(
                    onTap: () => _openDetails(controller),
                    child: AlphabetAvatar(
                      size: 30.w,
                      firstname: controller.contact?.firstname ?? '',
                      lastName: controller.contact?.lastname ?? '',
                    ),
                  ),
            spaceSide(Dimensions.space10.w),

            // ── Name / phone ──────────────────────────────────────────────
            isContactFromChat
                ? Expanded(
                    child: GestureDetector(
                      onTap: () => _openDetails(controller),
                      child: GetBuilder<AllContactController>(
                        builder: (ctrl) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DefaultText(
                              text:
                                  '${ctrl.newAllContactsData[ctrl.currentIndex].firstname ?? ''} '
                                  '${ctrl.newAllContactsData[ctrl.currentIndex].lastname ?? ''}',
                              textStyle:
                                  MyTextStyle.heading16W600().copyWith(color: MyColor.usdTextColor),
                              maxLines: 1,
                            ),
                            spaceDown(Dimensions.space3.h),
                            DefaultText(
                              text:
                                  '+${ctrl.newAllContactsData[ctrl.currentIndex].mobileCode ?? ''} '
                                  '${ctrl.newAllContactsData[ctrl.currentIndex].mobile ?? ''}',
                              textStyle: MyTextStyle.subHeading14W600FieldTitleColor().copyWith(
                                color: MyColor.appBarSmallText,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: GestureDetector(
                      onTap: () => _openDetails(controller),
                      child: GetBuilder<HomeController>(
                        builder: (ctrl) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DefaultText(
                              text:
                                  '${ctrl.newChatData[ctrl.currentChatIndex].contact?.firstname ?? ''} '
                                  '${ctrl.newChatData[ctrl.currentChatIndex].contact?.lastname ?? ''}',
                              textStyle:
                                  MyTextStyle.heading16W600().copyWith(color: MyColor.usdTextColor),
                              maxLines: 1,
                            ),
                            spaceDown(Dimensions.space3.h),
                            DefaultText(
                              text:
                                  '+${ctrl.newChatData[ctrl.currentChatIndex].contact?.mobileCode ?? ''} '
                                  '${ctrl.newChatData[ctrl.currentChatIndex].contact?.mobile ?? ''}',
                              textStyle: MyTextStyle.subHeading14W600FieldTitleColor().copyWith(
                                color: MyColor.appBarSmallText,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

            // ── More menu ─────────────────────────────────────────────────
            PopupMenuButton<_ChatAction>(
              offset: const Offset(0, 50),
              menuPadding: EdgeInsets.zero,
              color: MyColor.white,
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              onSelected: (action) => _handleAction(context, action, controller),
              itemBuilder: (context) => [
                if (MyUtils.checkPermission(AppPermission.viewContactProfile))
                  _menuItem(
                    action: _ChatAction.details,
                    icon: Icons.info_outline_rounded,
                    label: Strings.details.tr,
                  ),
                _menuItem(
                  action: _ChatAction.sendTemplate,
                  icon: Icons.description_outlined,
                  label: Strings.sendTemplates.tr,
                ),
                _menuItem(
                  action: _ChatAction.interactiveList,
                  icon: Icons.format_list_bulleted_rounded,
                  label: 'Interactive List',
                ),
                _menuItem(
                  action: _ChatAction.ctaUrl,
                  icon: Icons.link_rounded,
                  label: 'CTA URL Button',
                ),
                _menuItem(
                  action: _ChatAction.location,
                  icon: Icons.location_on_outlined,
                  label: 'Send Location',
                ),
                PopupMenuItem<_ChatAction>(
                  enabled: false,
                  height: 1,
                  padding: EdgeInsets.zero,
                  child: Divider(height: 1, color: MyColor.borderColor),
                ),
                _menuItem(
                  action: _ChatAction.block,
                  icon: controller.isBlocked
                      ? Icons.lock_open_rounded
                      : Icons.block_rounded,
                  label: controller.isBlocked ? 'Unblock Contact' : 'Block Contact',
                  destructive: controller.isBlocked ? false : true,
                ),
                _menuItem(
                  action: _ChatAction.clearChat,
                  icon: Icons.delete_sweep_outlined,
                  label: 'Clear Chat',
                  destructive: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<_ChatAction> _menuItem({
    required _ChatAction action,
    required IconData icon,
    required String label,
    bool destructive = false,
  }) {
    final color = destructive ? MyColor.getErrorColor() : MyColor.getBodyTextColor();
    return PopupMenuItem<_ChatAction>(
      value: action,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20.sp),
          spaceSide(Dimensions.space10.w),
          Text(
            label,
            style: MyTextStyle.subHeading14W600FieldTitleColor().copyWith(
              color: color,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void _openDetails(ChatController controller) {
    if (MyUtils.checkPermission(AppPermission.viewContactProfile)) {
      Get.toNamed(RouteHelper.chatPersonDetailsScreen, arguments: [controller.conversationId]);
    } else {
      CustomSnackBar.error(errorList: [Strings.permissionDenyMessage]);
    }
  }

  Future<void> _handleAction(
    BuildContext context,
    _ChatAction action,
    ChatController controller,
  ) async {
    switch (action) {
      case _ChatAction.details:
        _openDetails(controller);
        break;

      case _ChatAction.sendTemplate:
        // Load if needed
        if (controller.templates.isEmpty) await controller.loadInboxData();
        if (context.mounted) TemplatePicker.show(context);
        break;

      case _ChatAction.interactiveList:
        if (controller.interactiveLists.isEmpty) await controller.loadInboxData();
        if (context.mounted) InteractiveListPicker.show(context);
        break;

      case _ChatAction.ctaUrl:
        if (controller.ctaUrls.isEmpty) await controller.loadInboxData();
        if (context.mounted) CtaUrlPicker.show(context);
        break;

      case _ChatAction.location:
        await controller.sendCurrentLocation();
        break;

      case _ChatAction.block:
        final contactId = controller.contact?.id?.toString() ?? '';
        if (contactId.isEmpty) return;
        final confirm = await _showConfirmDialog(
          context,
          title: controller.isBlocked ? 'Unblock Contact?' : 'Block Contact?',
          body: controller.isBlocked
              ? 'Messages from this contact will be received again.'
              : 'You will not be able to send or receive messages from this contact.',
          confirmLabel: controller.isBlocked ? 'Unblock' : 'Block',
          destructive: !controller.isBlocked,
        );
        if (confirm == true) await controller.toggleBlockContact(contactId);
        break;

      case _ChatAction.clearChat:
        final confirm = await _showConfirmDialog(
          context,
          title: 'Clear Chat?',
          body: 'This will permanently delete ALL messages in this conversation. This action cannot be undone.',
          confirmLabel: 'Clear',
          destructive: true,
        );
        if (confirm == true) await controller.clearChat();
        break;
    }
  }

  Future<bool?> _showConfirmDialog(
    BuildContext context, {
    required String title,
    required String body,
    required String confirmLabel,
    bool destructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(title, style: MyTextStyle.heading16W600()),
        content: Text(body, style: MyTextStyle.subHeading14W400().copyWith(color: MyColor.getBodyTextColor())),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(Strings.cancel.tr, style: TextStyle(color: MyColor.getBodyTextColor())),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              confirmLabel,
              style: TextStyle(color: destructive ? MyColor.getErrorColor() : MyColor.getPrimaryColor()),
            ),
          ),
        ],
      ),
    );
  }
}

enum _ChatAction {
  details,
  sendTemplate,
  interactiveList,
  ctaUrl,
  location,
  block,
  clearChat,
}
