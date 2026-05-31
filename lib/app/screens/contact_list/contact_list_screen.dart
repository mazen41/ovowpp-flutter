import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/card/my_custom_scaffold.dart';
import 'package:ovowpp/app/components/circle_icon_button.dart';
import 'package:ovowpp/app/components/custom_loader/custom_loader.dart';
import 'package:ovowpp/app/components/image/custom_svg_picture.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/app/components/no_data.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/app/components/text/build_rich_text.dart';
import 'package:ovowpp/app/screens/chat/widget/chat_box.dart';
import 'package:ovowpp/core/helper/date_converter.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_icons.dart';
import 'package:ovowpp/core/utils/my_images.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/data/controller/contact_list/contact_list_controller.dart';
import 'package:ovowpp/data/repo/contact_list/contact_list_repo.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  String comeFrom = '';

  @override
  void initState() {
    Get.put(ContactListRepo());
    final controller = Get.put(ContactListController(repo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getContactListData();
      controller.scrollController.addListener(controller.scrollListener);
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<ContactListController>(
      builder: (controller) {
        final fileType = MyUtils.getFileType(controller.selectedFile?.path ?? "");
        return MyCustomScaffold(
          transformValue: -8,
          appBarBgColor: MyColor.white,
          pageTitle: MyStrings.contactList.tr,
          body: controller.isLoading
              ? const CustomLoader()
              : controller.getCurrentChatData().isEmpty
              ? NoDataWidget()
              : Container(
                  padding: EdgeInsets.only(bottom: 50),
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(MyImages.chatBackground), fit: BoxFit.cover),
                  ),
                  child: ListView.builder(
                    controller: controller.scrollController,
                    reverse: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.getCurrentChatData().length + 1,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemBuilder: (context, index) {
                      if (controller.getCurrentChatData().length == index) {
                        return controller.hasNext()
                            ? Container(
                                child: controller.isSearch ? SizedBox() : const CustomLoader(isPagination: true),
                              )
                            : const SizedBox();
                      }
                      final item = controller.getCurrentChatData()[index];
                      final isSender = item.type == "1";
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                            child: IntrinsicWidth(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSender ? MyColor.lightSplashBodyText : MyColor.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(12),
                                    topRight: const Radius.circular(12),
                                    bottomLeft: Radius.circular(isSender ? 12 : 0),
                                    bottomRight: Radius.circular(isSender ? 0 : 12),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (item.message != null)
                                      InkWell(
                                        onDoubleTap: () {
                                          Clipboard.setData(ClipboardData(text: item.message.toString()));
                                          CustomSnackBar.success(successList: [MyStrings.messageCopiedToClipBoard.tr]);
                                        },
                                        child: buildRichText(
                                          item.message.toString(),
                                          theme.textTheme.bodyLarge?.copyWith(
                                            fontSize: Dimensions.space15.sp,
                                            color: MyColor.getHeadingTextColor(),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 4),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        DateConverter.convertUtcToLocalTime(item.createdAt.toString()),
                                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                                      ),
                                    ),
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
          floatingActionButton: controller.isSearch
              ? SizedBox()
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.space15),
                    child: Column(
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
                                            ? const CustomSvgPicture(image: MyIcons.xlsx, height: 45, width: 45)
                                            : fileType == 'word'
                                            ? const CustomSvgPicture(image: MyIcons.doc, height: 45, width: 45)
                                            : fileType == 'video'
                                            ? const Icon(Icons.videocam, size: 45, color: MyColor.lightBodyText)
                                            : const CustomSvgPicture(image: MyIcons.pdfFile, height: 45, width: 45),
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
                                      child: Icon(Icons.close, color: MyColor.white, size: Dimensions.space12),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                        // Buttons Row
                        Row(
                          mainAxisSize: MainAxisSize.min,
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
                                        MyStrings.document.tr,
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
                                      Icon(Icons.videocam, size: Dimensions.space25.h, color: MyColor.lightBodyText),
                                      spaceSide(Dimensions.space5),
                                      Text(
                                        MyStrings.video.tr,
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
                                padding: EdgeInsets.all(Dimensions.space12.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.space8.h),
                                  color: MyColor.white,
                                ),
                                child: MyAssetImageWidget(
                                  assetPath: MyImages.add,
                                  isSvg: true,
                                  color: MyColor.getPrimaryColor(),
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
                                padding: EdgeInsets.all(Dimensions.space12.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.space8.h),
                                  color: MyColor.white,
                                ),
                                child: MyAssetImageWidget(
                                  assetPath: MyImages.gallery,
                                  isSvg: true,
                                  color: MyColor.getPrimaryColor(),
                                  height: Dimensions.space24.h,
                                  width: Dimensions.space24.h,
                                ),
                              ),
                            ),
                            spaceSide(Dimensions.space8.w),
                            ChatBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
