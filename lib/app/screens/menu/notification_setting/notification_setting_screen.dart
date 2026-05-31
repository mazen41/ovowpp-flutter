import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ovowpp/app/components/advance_switch/custom_switch.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/card/custom_app_card.dart';
import 'package:ovowpp/app/components/divider/line.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/app/components/text/default_text.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_images.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/data/controller/notifications/notification_controller.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../data/repo/notification_repo/notification_repo.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() => _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  @override
  void initState() {
    Get.put(NotificationRepo());
    Get.put(NotificationsController(repo: Get.find()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: MyColor.white,
          appBar: CustomAppBar(elevation: 0, bgColor: MyColor.white, title: MyStrings.notificationSettings.tr),
          body: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: Dimensions.space12.w),
            child: Column(
              mainAxisAlignment: .start,
              children: [
                CustomAppCard(
                  backgroundColor: MyColor.searchFieldColor,
                  child: Column(
                    children: [
                      NotificationItem(
                        iconPath: MyImages.notificationIcon,
                        title: MyStrings.receivePushNotification.tr,
                        subtitle: MyStrings.pushNotificationSub.tr,
                        value: controller.pushNotificationValue,
                        switchTap: controller.changePushNotification,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: Dimensions.space16.h),
                        child: Line(lineColor: MyColor.notificationLineColor),
                      ),
                      NotificationItem(
                        iconPath: MyImages.emailFieldPrefixSVG,
                        title: MyStrings.emailNotification.tr,
                        subtitle: MyStrings.emailNotificationSub.tr,
                        value: controller.emailNotificationValue,
                        switchTap: controller.changeEmailNotification,
                      ),
                      spaceDown(Dimensions.space16.h),
                      Line(lineColor: MyColor.notificationLineColor),
                      spaceDown(Dimensions.space16.h),
                      NotificationItem(
                        iconPath: MyImages.promotional,
                        title: MyStrings.promotionalOffer.tr,
                        subtitle: MyStrings.promotionalOfferSub.tr,
                        value: controller.promotionalOffer,
                        switchTap: controller.changePromotionalOffer,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String iconPath, title, subtitle;
  final bool value;
  final VoidCallback switchTap;
  const NotificationItem({
    super.key,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.switchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: .start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: Dimensions.space6.h),
              child: MyAssetImageWidget(
                height: 24.h,
                width: 24.w,
                isSvg: true,
                assetPath: iconPath,
                color: MyColor.getPrimaryColor(),
              ),
            ),
            spaceSide(Dimensions.space10.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: .start,
                children: [
                  DefaultText(
                    text: title,
                    textStyle: MyTextStyle.heading16W600().copyWith(color: MyColor.headingText),
                  ),
                  DefaultText(maxLines: 2, text: subtitle, textStyle: MyTextStyle.subHeading12W400()),
                ],
              ),
            ),
            spaceSide(Dimensions.space10.w),
            CustomSwitch(
              value: value,
              onChanged: (bool value) {
                switchTap();
              },
            ),
          ],
        ),
      ],
    );
  }
}
