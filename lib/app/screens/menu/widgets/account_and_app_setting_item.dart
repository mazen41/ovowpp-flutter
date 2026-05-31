import 'package:flutter/material.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/utils/util_exporter.dart';
import '../../../components/image/my_asset_widget.dart';
import '../../../components/text/default_text.dart';

class AccountAndAppSettingItem extends StatelessWidget {
  final String? title, subTitle, iconPath;
  final VoidCallback onTap;
  final Color? color;

  const AccountAndAppSettingItem({
    super.key,
    this.title,
    this.subTitle,
    this.iconPath,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.space8.h),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Row(
          children: [
            MyAssetImageWidget(isSvg: true, assetPath: iconPath ?? '', height: 20.h, width: 20.w),

            spaceSide(Dimensions.space12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultText(
                  text: title ?? '',
                  textStyle: MyTextStyle.subHeading12W400().copyWith(fontSize: 16.sp, color: MyColor.ovoTextColor),
                ),
                DefaultText(
                  text: subTitle ?? '',
                  textStyle: MyTextStyle.subHeading12W400().copyWith(fontSize: 14.sp),
                ),
              ],
            ),
            Spacer(),
            MyAssetImageWidget(
              isSvg: true,
              assetPath: MyImages.arrowForward,
              height: 20.h,
              width: 20.w,
              color: MyColor.updatedTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
