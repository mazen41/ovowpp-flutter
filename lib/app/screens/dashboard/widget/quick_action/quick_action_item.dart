import 'package:flutter/material.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import '../../../../../core/utils/util_exporter.dart';
import '../../../../components/image/my_asset_widget.dart';
import '../../../../components/text/default_text.dart';

class QuickActionItem extends StatelessWidget {
  final VoidCallback onTap;
  final String icon, title;
  const QuickActionItem({super.key, required this.onTap, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(Dimensions.space50.r),
      color: MyColor.white,

      child: InkWell(
        borderRadius: BorderRadius.circular(Dimensions.space50.r),

        onTap: () {
          onTap();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.space20.w, vertical: Dimensions.space8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.space50.r),
            border: Border.all(color: MyColor.dashboardCardBorder),
          ),
          child: Row(
            children: [
              MyAssetImageWidget(isSvg: true, assetPath: icon, height: 15.h, width: 15.w),
              spaceSide(Dimensions.space4),
              DefaultText(
                text: title,
                textStyle: MyTextStyle.subHeading12W600().copyWith(color: MyColor.planStatusTextColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
