import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/controller/chat/chat_controller.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({super.key});

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus && Get.isRegistered<ChatController>()) {
      Get.find<ChatController>().seenMessage();
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<ChatController>(
      id: 'chat_screen_main',
      builder: (controller) => SizedBox(
        height: 48,
        width: MediaQuery.of(context).size.width * .61,
        child: TextFormField(
          focusNode: _focusNode,
          controller: controller.chatController,
          textAlign: TextAlign.start,
          style: theme.textTheme.bodyLarge?.copyWith(color: MyColor.black),
          maxLines: null,
          keyboardType: TextInputType.multiline,
          onChanged: (_) => controller.onTextChanged(),

          decoration: InputDecoration(
            // prefixIcon: InkWell(
            //   onTap: (){},
            //   child: MyAssetImageWidget(
            //
            //       height: 20.h,
            //       width: 20.w,
            //       boxFit: BoxFit.scaleDown,
            //       isSvg: true,
            //       assetPath: MyImages.selectEmoji),
            // ),
            hintText: MyStrings.typeAMessage,
            hintStyle: MyTextStyle.subHeading12W400().copyWith(fontSize: 14.sp, color: MyColor.chatBoxHintColor),
            contentPadding: EdgeInsets.only(bottom: Dimensions.space5.h, left: Dimensions.space10.w),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyColor.dashboardCardBorder),
              borderRadius: BorderRadius.circular(Dimensions.space50.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyColor.dashboardCardBorder),
              borderRadius: BorderRadius.circular(Dimensions.space50.r),
            ),

            //  prefix: spaceSide(Dimensions.space10),
            // suffixIcon: GestureDetector(
            //   onTap: () {
            //     if (MyUtils.checkPermission(AppPermission.sendMessage)) {
            //       controller.sendMessage();
            //     } else {
            //       CustomSnackBar.error(errorList: [MyStrings.permissionDenyMessage]);
            //     }
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.all(Dimensions.space8),
            //     child: controller.sendingMessage
            //         ? SizedBox(
            //             height: 20,
            //             width: 20,
            //             child: CircularProgressIndicator(
            //               color: MyColor.getPrimaryColor(),
            //               strokeWidth: 2,
            //             ),
            //           )
            //         : MyAssetImageWidget(
            //             assetPath: MyImages.send,
            //             isSvg: true,
            //             boxFit: BoxFit.fitWidth,
            //             height: 20,
            //             width: 20,
            //           ),
            //   ),
            // ),
            filled: true,
            fillColor: MyColor.searchFieldColor,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: MyColor.dashboardCardBorder),
              borderRadius: BorderRadius.circular(Dimensions.space50.r),
            ),
          ),
        ),
      ),
    );
  }
}
