import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/screens/dashboard/widget/quick_action/quick_action_item.dart';
import 'package:ovowpp/data/controller/all_contacts/all_contact_controller.dart';
import 'package:ovowpp/data/repo/all_contact/all_contact_repo.dart';
import '../../../../../core/route/route.dart';
import '../../../../../core/utils/app_permission.dart';
import '../../../../../core/utils/text_style.dart';
import '../../../../../core/utils/util_exporter.dart';
import '../../../../components/text/default_text.dart';

class QuickAction extends StatefulWidget {
  const QuickAction({super.key});

  @override
  State<QuickAction> createState() => _QuickActionState();
}

class _QuickActionState extends State<QuickAction> {
  @override
  void initState() {
    Get.put(AllContactRepo());
    Get.put(AllContactController(repo: Get.find()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllContactController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultText(
              text: MyStrings.quickActions.tr,
              textStyle: MyTextStyle.heading16W600().copyWith(color: MyColor.splashTextColor),
            ),
            spaceDown(Dimensions.space12.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Visibility(
                    visible: MyUtils.checkPermission(AppPermission.addContact),
                    child: QuickActionItem(
                      icon: MyImages.addContact,
                      title: MyStrings.addContact.tr,

                      onTap: () {
                        Get.toNamed(
                          RouteHelper.customerAccountScreen,
                          arguments: [
                            controller.imagePath ?? "", // 0 -> imagePath
                            null, // 1 -> contact
                            false, // 2 -> isUpdate
                            -1, // 3 -> editIndex (int)
                            false, // 4 -> isChatEdit
                          ],
                        )?.then((v) {
                          controller.initData(initPage: true);
                        });
                      },
                    ),
                  ),
                  spaceSide(Dimensions.space8.w),
                  Visibility(
                    visible: MyUtils.checkPermission(AppPermission.addCampaign),
                    child: QuickActionItem(
                      icon: MyImages.newCampaign,
                      title: MyStrings.newCampaign.tr,
                      onTap: () {
                        Get.toNamed(RouteHelper.createCampaignScreen);
                      },
                    ),
                  ),
                  spaceSide(Dimensions.space8.w),
                  Visibility(
                    // visible: MyUtils.checkPermission(AppPermission.contact),
                    child: QuickActionItem(
                      icon: MyImages.link,
                      title: MyStrings.manageContact.tr,
                      onTap: () {
                        Get.toNamed(RouteHelper.manageContactScreen);
                      },
                    ),
                  ),
                  spaceSide(Dimensions.space8.w),
                  Visibility(
                    visible: MyUtils.checkPermission(AppPermission.viewAgent),
                    child: QuickActionItem(
                      icon: MyImages.link,
                      title: MyStrings.manageAgent.tr,
                      onTap: () {
                        Get.toNamed(RouteHelper.manageAgentScreen);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
