import 'package:flutter/material.dart';
import 'package:ovowpp/app/screens/dashboard/widget/round_icon_with_bg_color.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/utils/util_exporter.dart';
import '../../../components/image/my_asset_widget.dart';
import '../../../components/text/default_text.dart';

class ProfileEditAndCancelBtn extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ProfileEditAndCancelBtn({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Stack(
          children: [
            MyAssetImageWidget(assetPath: MyImages.profile, boxFit: BoxFit.scaleDown),
            text == MyStrings.cancel
                ? Positioned(
                    bottom: -10,
                    right: 0,
                    child: RoundIconWithBgColor(
                      onTap: () {},
                      borderColor: MyColor.dashboardCardBorder,
                      isOnTap: true,
                      bgColor: MyColor.white,
                      icon: MyImages.camera,
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
        Material(
          color: text == MyStrings.edit ? MyColor.getPrimaryColor() : MyColor.campaignFieldFillColor,
          borderRadius: BorderRadius.circular(Dimensions.space12.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(Dimensions.space12.r),
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.space20.w, vertical: Dimensions.space6.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: text == MyStrings.edit ? MyColor.getPrimaryColor() : MyColor.dashboardCardBorder,
                ),

                borderRadius: BorderRadius.circular(Dimensions.space12.r),
              ),
              child: DefaultText(
                text: text == MyStrings.edit ? text : MyStrings.cancel,
                textStyle: MyTextStyle.subHeading16W400(
                  fontFamily: 'Albert Sans',
                ).copyWith(color: text == MyStrings.edit ? MyColor.white : MyColor.dark, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
