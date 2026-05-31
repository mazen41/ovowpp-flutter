import 'package:flutter/material.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/utils/util_exporter.dart';
import '../../../components/text/default_text.dart';
import '../../dashboard/widget/round_icon_with_bg_color.dart';

class RecentlyActivityItem extends StatelessWidget {
  final String icon, text, subText;
  final Color? iconColor;
  const RecentlyActivityItem({
    super.key,
    required this.icon,
    required this.text,
    required this.subText,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.space8.h),
      child: Row(
        children: [
          RoundIconWithBgColor(
            bgColor: MyColor.contactDetailsICon.withAlpha(MyColor.getAlpha(10)),
            icon: icon,
            height: 18,
            width: 18,
            iconColor: iconColor,
          ),
          spaceSide(Dimensions.space12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultText(
                text: text,
                textStyle: MyTextStyle.subHeading12W400().copyWith(fontSize: 16.sp, color: MyColor.ovoTextColor),
              ),

              DefaultText(text: subText, textStyle: MyTextStyle.subHeading12W400()),
            ],
          ),
        ],
      ),
    );
  }
}
