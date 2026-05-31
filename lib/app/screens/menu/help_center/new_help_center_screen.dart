import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/components/card/custom_app_card.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/app/components/text-field/label_text_field.dart';
import 'package:ovowpp/app/components/text/default_text.dart';
import 'package:ovowpp/app/screens/dashboard/widget/round_icon_with_bg_color.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_images.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/text_style.dart';

class NewHelpCenterScreen extends StatelessWidget {
  const NewHelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.white,
      appBar: CustomAppBar(title: MyStrings.helpCenter.tr, elevation: 0, bgColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.space16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              spaceDown(Dimensions.space4.h),
              LabelTextField(
                hideLabel: true,
                hintText: MyStrings.searchForHelp,
                onChanged: () {},
                prefixIcon: MyAssetImageWidget(
                  isSvg: true,
                  height: 20.h,
                  width: 20.w,
                  boxFit: BoxFit.scaleDown,
                  assetPath: MyImages.search,
                ),
                fillColor: MyColor.searchFieldColor,
              ),
              spaceDown(Dimensions.space24.h),
              Column(
                children: [
                  HelpCenterItem(
                    title: MyStrings.gettingStarted.tr,
                    subTitle: MyStrings.gettingStartedSub.tr,
                    iconPath: MyImages.gettingStart,
                    onTap: () {},
                  ),
                  HelpCenterItem(
                    title: MyStrings.accountAndBilling.tr,
                    subTitle: MyStrings.accountAndBillingSub.tr,
                    iconPath: MyImages.accountAndBilling,
                    onTap: () {},
                  ),
                  HelpCenterItem(
                    title: MyStrings.templatesAndAutomation.tr,
                    subTitle: MyStrings.templatesAndAutomationSub.tr,
                    iconPath: MyImages.templatesAndAutomation,
                    onTap: () {},
                  ),
                  HelpCenterItem(
                    title: MyStrings.troubleshooting.tr,
                    subTitle: MyStrings.troubleshootingSub.tr,
                    iconPath: MyImages.troubleshooting,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HelpCenterItem extends StatelessWidget {
  final String? title, subTitle, iconPath;
  final VoidCallback onTap;
  const HelpCenterItem({super.key, required this.onTap, this.title, this.subTitle, this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.space6.h),
      child: Material(
        borderRadius: BorderRadius.circular(Dimensions.cardExtraRadius),
        color: MyColor.searchFieldColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(Dimensions.cardExtraRadius),
          onTap: onTap,
          child: CustomAppCard(
            backgroundColor: MyColor.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                RoundIconWithBgColor(
                  height: 16.h,
                  width: 16.w,
                  bgColor: MyColor.helpCenterItemBgColor,
                  icon: iconPath ?? '',
                ),
                spaceSide(Dimensions.space16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      DefaultText(
                        text: title ?? '',
                        textStyle: MyTextStyle.subHeading12W400().copyWith(
                          fontSize: 16.sp,
                          color: MyColor.ovoTextColor,
                        ),
                      ),

                      DefaultText(
                        text: subTitle ?? '',
                        maxLines: 2,
                        textStyle: MyTextStyle.subHeading12W400().copyWith(
                          fontSize: 14.sp,
                          color: MyColor.fieldTitleTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                MyAssetImageWidget(
                  assetPath: MyImages.arrowForward,
                  isSvg: true,
                  height: 20.h,
                  width: 20.w,
                  color: MyColor.updatedTextColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
