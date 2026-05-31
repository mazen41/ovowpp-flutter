import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ovowpp/app/components/image/my_network_image_widget.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/text_style.dart';

import '../../../components/text/default_text.dart';

class LanguageCard extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final bool isShowTopRight;
  final String langeName;
  final String imagePath;

  const LanguageCard({
    super.key,
    required this.index,
    required this.selectedIndex,
    this.isShowTopRight = false,
    required this.langeName,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimensions.space8.h, horizontal: Dimensions.space16.w),
      padding: EdgeInsetsDirectional.symmetric(vertical: Dimensions.space20.w, horizontal: Dimensions.space16.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: MyColor.dashboardCardBorder),
        color: MyColor.searchFieldColor,
        borderRadius: BorderRadius.circular(Dimensions.space20.r),
      ),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MyNetworkImageWidget(imageUrl: imagePath, boxFit: BoxFit.contain, width: 25.w, height: 25.h),
          spaceSide(Dimensions.space12.w),
          const SizedBox(height: Dimensions.space10),
          DefaultText(
            text: langeName.tr,
            textStyle: MyTextStyle.heading16W600().copyWith(color: MyColor.headingText),
          ),
          Spacer(),
          Icon(
            index == selectedIndex ? Icons.check : Icons.arrow_forward_ios_rounded,
            color: index == selectedIndex
                ? MyColor.getPrimaryColor()
                : MyColor.getBodyTextColor().withValues(alpha: 0.5),
            size: Dimensions.space16.w,
          ),
        ],
      ),
    );
  }
}
