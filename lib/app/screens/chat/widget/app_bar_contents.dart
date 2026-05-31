import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/data/controller/home/home_controller.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:ovowpp/app/components/avatar/alphabet_avatar.dart';
import 'package:ovowpp/app/components/text/default_text.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/controller/chat/chat_controller.dart';
import '../../../../core/utils/app_permission.dart';
import '../../../../data/controller/all_contacts/all_contact_controller.dart';
import '../../../components/snack_bar/show_custom_snackbar.dart';
import '../../contact/widgets/contact_item.dart';

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
        // offset: -0.5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            controller.contact?.imageSrc != null
                ? GestureDetector(
                    onTap: () {
                      if (MyUtils.checkPermission(AppPermission.viewContactProfile)) {
                        [
                          Get.toNamed(RouteHelper.chatPersonDetailsScreen, arguments: [controller.conversationId]),
                        ];
                      } else {
                        CustomSnackBar.error(errorList: [MyStrings.permissionDenyMessage]);
                      }
                    },
                    child: CircleAvatar(
                      maxRadius: 20.r,
                      backgroundImage: NetworkImage(controller.contact?.imageSrc ?? ''),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      if (MyUtils.checkPermission(AppPermission.viewContactProfile)) {
                        Get.toNamed(RouteHelper.chatPersonDetailsScreen, arguments: [controller.conversationId]);
                      } else {
                        CustomSnackBar.error(errorList: [MyStrings.permissionDenyMessage]);
                      }
                    },

                    child: AlphabetAvatar(
                      size: 30.w,
                      firstname: controller.contact?.firstname ?? "",
                      lastName: controller.contact?.lastname ?? '',
                    ),
                  ),
            spaceSide(Dimensions.space10.w),

            isContactFromChat
                ? Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (MyUtils.checkPermission(AppPermission.viewContactProfile)) {
                          Get.toNamed(RouteHelper.chatPersonDetailsScreen, arguments: [controller.conversationId]);
                        } else {
                          CustomSnackBar.error(errorList: [MyStrings.permissionDenyMessage]);
                        }
                      },
                      child: GetBuilder<AllContactController>(
                        builder: (controller) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DefaultText(
                                text:
                                    "${controller.newAllContactsData[controller.currentIndex].firstname ?? ""} "
                                    "${controller.newAllContactsData[controller.currentIndex].lastname ?? ""}",
                                textStyle: MyTextStyle.heading16W600().copyWith(color: MyColor.usdTextColor),
                                maxLines: 1,
                              ),
                              spaceDown(Dimensions.space3.h),
                              DefaultText(
                                text:
                                    "+${controller.newAllContactsData[controller.currentIndex].mobileCode ?? ""} "
                                    "${controller.newAllContactsData[controller.currentIndex].mobile ?? ""} ",
                                textStyle: MyTextStyle.subHeading14W600FieldTitleColor().copyWith(
                                  color: MyColor.appBarSmallText,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  )
                : Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (MyUtils.checkPermission(AppPermission.viewContactProfile)) {
                          Get.toNamed(RouteHelper.chatPersonDetailsScreen, arguments: [controller.conversationId]);
                        } else {
                          CustomSnackBar.error(errorList: [MyStrings.permissionDenyMessage]);
                        }
                      },
                      child: GetBuilder<HomeController>(
                        builder: (controller) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DefaultText(
                                text:
                                    "${controller.newChatData[controller.currentChatIndex].contact?.firstname ?? ""} "
                                    "${controller.newChatData[controller.currentChatIndex].contact?.lastname ?? ""}",
                                textStyle: MyTextStyle.heading16W600().copyWith(color: MyColor.usdTextColor),
                                maxLines: 1,
                              ),
                              spaceDown(Dimensions.space3.h),
                              DefaultText(
                                text:
                                    "+${controller.newChatData[controller.currentChatIndex].contact?.mobileCode ?? ''} ${controller.newChatData[controller.currentChatIndex].contact?.mobile ?? ''} ",
                                textStyle: MyTextStyle.subHeading14W600FieldTitleColor().copyWith(
                                  color: MyColor.appBarSmallText,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
            //  Spacer(),
            PopupMenuButton<int>(
              offset: Offset(0, 50),
              menuPadding: EdgeInsets.zero,
              itemBuilder: (context) {
                if (!MyUtils.checkPermission(AppPermission.viewContactProfile)) {
                  CustomSnackBar.error(errorList: [MyStrings.permissionDenyMessage]);
                }

                return [
                  if (MyUtils.checkPermission(AppPermission.viewContactProfile))
                    PopupMenuItem(
                      onTap: () {
                        Get.toNamed(RouteHelper.chatPersonDetailsScreen, arguments: [controller.conversationId]);
                      },

                      child: Row(
                        children: [
                          Icon(Icons.info, color: MyColor.getBodyTextColor()),
                          spaceSide(Dimensions.space10.w),
                          Text(
                            MyStrings.details.tr,
                            style: MyTextStyle.subHeading14W600FieldTitleColor().copyWith(
                              color: MyColor.getBodyTextColor(),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }
}
