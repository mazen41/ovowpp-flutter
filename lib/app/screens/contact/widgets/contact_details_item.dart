import 'package:flutter/material.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/utils/util_exporter.dart';
import '../../../components/image/my_asset_widget.dart';
import '../../../components/text/default_text.dart' show DefaultText;

class ContactDetailsItem extends StatelessWidget {
  final String? title, phoneNumber, icon;
  const ContactDetailsItem({super.key, this.title, this.phoneNumber, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.w, vertical: Dimensions.space18.h),
      decoration: BoxDecoration(
        border: Border.all(color: MyColor.dashboardCardBorder),
        borderRadius: BorderRadius.circular(Dimensions.space12.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(Dimensions.space11),
            decoration: BoxDecoration(
              color: MyColor.contactDetailsICon.withAlpha(MyColor.getAlpha(10)),
              borderRadius: BorderRadius.circular(Dimensions.space12.r),
            ),
            child: MyAssetImageWidget(
              boxFit: BoxFit.scaleDown,
              isSvg: true,
              assetPath: icon ?? '',
              height: 20.h,
              width: 20.w,
            ),
          ),
          spaceSide(Dimensions.space12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultText(
                text: title ?? '',
                textStyle: MyTextStyle.subHeading16W400(
                  fontFamily: 'Nunito',
                ).copyWith(fontWeight: FontWeight.w600, fontSize: 12.sp),
              ),
              DefaultText(
                text: phoneNumber ?? '',
                textStyle: MyTextStyle.subHeading16W400(
                  fontFamily: 'Nunito',
                ).copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
