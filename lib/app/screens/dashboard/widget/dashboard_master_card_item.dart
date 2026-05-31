import 'package:flutter/material.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/utils/util_exporter.dart';
import '../../../components/image/my_asset_widget.dart';
import '../../../components/text/default_text.dart';

class DashBoardMasterCardItem extends StatelessWidget {
  final String? image, amount, type;
  final Color bgColor, gradientColor;
  final VoidCallback? onTap;

  const DashBoardMasterCardItem({
    super.key,
    this.image,
    this.amount,
    this.type,
    required this.bgColor,
    required this.gradientColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(Dimensions.space16.r),

      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(Dimensions.space16.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.space16.r),

            border: Border.all(color: MyColor.dashboardCardBorder),
            gradient: LinearGradient(
              begin: AlignmentDirectional.topEnd,
              end: AlignmentDirectional.center,
              colors: [gradientColor, MyColor.white],
            ),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(Dimensions.space8.r),
                decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
                child: MyAssetImageWidget(
                  isSvg: true,
                  assetPath: image ?? "",
                  height: 27.h,
                  width: 27.w,
                  color: MyColor.white,
                ),
              ),
              DefaultText(
                text: amount.toString(),
                textStyle: MyTextStyle.heading20W700().copyWith(
                  color: MyColor.usdTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              DefaultText(text: type ?? "", textStyle: MyTextStyle.subHeading14W400()),
            ],
          ),
        ),
      ),
    );
  }
}
