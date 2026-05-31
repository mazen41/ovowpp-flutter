import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:ovowpp/app/screens/campaigns/widgets/send_now_switch.dart';
import 'package:ovowpp/data/controller/campaigns/campaigns_controller.dart';
import '../../../../core/utils/text_style.dart' show MyTextStyle;
import '../../../../core/utils/util_exporter.dart';
import '../../../components/text/default_text.dart';

class CampaignSettings extends StatelessWidget {
  final CampaignsController controller;
  const CampaignSettings({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.space17.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.space16.r),
        color: MyColor.white,
        border: Border.all(color: MyColor.dashboardCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultText(
            text: MyStrings.campaignSettings.tr,
            textStyle: MyTextStyle.subHeading12W400().copyWith(fontSize: 16.sp, color: MyColor.ovoTextColor),
          ),
          spaceDown(Dimensions.space18.h),
          SwitchWithLeadText(
            title: MyStrings.enableTracking.tr,
            description: MyStrings.trackMessageDeliveryStatus.tr,
            controller: controller,

            switchTap: () {
              controller.changeTrackingSwitch();
            },
            value: controller.enableTrackingSwitch,
          ),
          spaceDown(Dimensions.space16.h),
          SwitchWithLeadText(
            title: MyStrings.autoRetryFailed.tr,
            description: MyStrings.retryFailedMessageAfter1Hour.tr,
            controller: controller,

            switchTap: () {
              controller.autoRetryFailed();
            },
            value: controller.autoRetryFailedSwitch,
          ),
        ],
      ),
    );
  }
}
