import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/image/my_network_image_widget.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/data/controller/all_contacts/all_contact_controller.dart';
import '../../../../core/utils/app_permission.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/utils/util_exporter.dart';
import '../../../../data/model/customer_details/customer_details_response_model.dart' show Contact;
import '../../../components/alert-dialog/custom_alert_dialog.dart';
import '../../../components/alert-dialog/delete_dialogue.dart';
import '../../../components/avatar/alphabet_avatar.dart';
import '../../../components/snack_bar/show_custom_snackbar.dart';
import '../../../components/text/default_text.dart';

class ContactItem extends StatelessWidget {
  final bool isLastIndex;
  final Contact item;
  final int index;

  const ContactItem({super.key, required this.isLastIndex, required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllContactController>(
      builder: (controller) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (item.image?.isNotEmpty ?? false) ...[
                  MyNetworkImageWidget(imageUrl: '${item.imageSrc}', height: 44.h, width: 44.w, radius: 22.r),
                ] else ...[
                  AlphabetAvatar(firstname: item.firstname ?? "", lastName: item.lastname ?? ''),
                ],

                spaceSide(Dimensions.space8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: DefaultText(
                              text: item.getFullName(),
                              textStyle: MyTextStyle.subHeading16W400().copyWith(color: MyColor.ovoTextColor),
                              maxLines: 2,
                            ),
                          ),
                          spaceSide(Dimensions.space8.w),
                          if (controller.tabController.index == 0) ...[
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.space6.w,
                                vertical: Dimensions.space2.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.space7.r),
                                border: Border.all(
                                  color: item.status == '1'
                                      ? MyColor.campaignsRunning.withAlpha(MyColor.getAlpha(10))
                                      : MyColor.splashTextColor.withAlpha(MyColor.getAlpha(10)),
                                ),
                                color: item.status == '1'
                                    ? MyColor.campaignsRunning.withAlpha(MyColor.getAlpha(10))
                                    : MyColor.splashTextColor.withAlpha(MyColor.getAlpha(10)),
                              ),
                              child: DefaultText(
                                text: item.status == '1' ? MyStrings.active.tr : MyStrings.inactive.tr,

                                textStyle: MyTextStyle.subHeading12W400().copyWith(
                                  color: item.status == '1' ? MyColor.campaignsRunning : MyColor.splashTextColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      spaceDown(Dimensions.space2.h),
                      DefaultText(
                        text: "+${item.mobileCode ?? ""}${item.mobile ?? ""}",
                        textStyle: MyTextStyle.subHeading14W600FieldTitleColor().copyWith(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<int>(
                  itemBuilder: (context) {
                    if (!MyUtils.checkPermission(AppPermission.editContact) &&
                        !MyUtils.checkPermission(AppPermission.deleteContact) &&
                        !MyUtils.checkPermission(AppPermission.sendMessage)) {
                      CustomSnackBar.error(errorList: [MyStrings.permissionDenyMessage]);
                    }
                    return [
                      if (MyUtils.checkPermission(AppPermission.editContact))
                        PopupMenuItem(
                          onTap: () {
                            isContactFromChat = true;
                            Get.toNamed(
                              RouteHelper.customerAccountScreen,
                              arguments: [item.imageSrc, item, true, index, false],
                            );
                          },
                          child: Text(MyStrings.edit.tr),
                        ),
                      if (MyUtils.checkPermission(AppPermission.deleteContact))
                        PopupMenuItem(
                          onTap: () {
                            controller.userId = item.id.toString();

                            // Show dialog after current frame
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              return CustomAlertDialog(
                                verticalPadding: 0,
                                isHorizontalPadding: true,
                                child: GetBuilder<AllContactController>(
                                  builder: (controller) {
                                    return DeleteDialogue(
                                      warningText: MyStrings.areYouSureYouWantToDeleteThisContact.tr,
                                      isLoading: controller.isDeleteLoading,
                                      onTap: () {
                                        controller.deleteMessage(index);
                                      },
                                    );
                                  },
                                ),
                              ).customAlertDialog(context);
                            });
                          },
                          child: Text(MyStrings.delete.tr),
                        ),

                      if (MyUtils.checkPermission(AppPermission.sendMessage))
                        PopupMenuItem(
                          onTap: () {
                            controller.currentIndex = index;
                            isContactFromChat = true;
                            controller.contactId = item.id.toString();
                            controller.createConversation();
                          },

                          child: Text(MyStrings.chats.tr),
                        ),
                    ];
                  },
                  offset: const Offset(0, 30),
                  color: MyColor.white,
                  elevation: 1,
                  onSelected: (value) {},
                  child: Icon(Icons.more_vert),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

bool isContactFromChat = false;
