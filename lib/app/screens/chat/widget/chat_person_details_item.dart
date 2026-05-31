import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import '../../../../core/utils/app_style.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_images.dart';
import '../../../../core/utils/text_style.dart';
import '../../../components/divider/line.dart';
import '../../../components/image/my_asset_widget.dart';
import '../../../components/text/default_text.dart';

class ChatPersonDetailsItem extends StatelessWidget {
  final String? iconPath, text, title, value;
  final VoidCallback onTap;
  final bool isLine;
  final bool isShowArrow;
  final bool isRating;

  const ChatPersonDetailsItem({
    super.key,
    this.iconPath,
    this.text,
    required this.onTap,
    this.isLine = true,
    this.isShowArrow = true,
    this.title,
    this.value,
    this.isRating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: MyColor.searchFieldColor,
          borderRadius: BorderRadius.circular(Dimensions.space6.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(Dimensions.space6.r),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.space12.h),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.space8.w),

                    child: Row(
                      children: [
                        isShowArrow
                            ? MyAssetImageWidget(
                                boxFit: BoxFit.scaleDown,
                                isSvg: true,
                                assetPath: iconPath ?? '',
                                height: 24.h,
                                width: 24.w,
                              )
                            : SizedBox.shrink(),
                        spaceSide(Dimensions.space18.w),
                        DefaultText(
                          text: isShowArrow ? text ?? '' : title ?? '',
                          textStyle: MyTextStyle.subHeading15W500FieldTitleColor.copyWith(
                            fontSize: 16.sp,
                            color: MyColor.usdTextColor,
                          ),
                        ),
                        Spacer(),
                        isShowArrow == true
                            ? MyAssetImageWidget(
                                boxFit: BoxFit.scaleDown,
                                isSvg: true,
                                assetPath: MyImages.arrowForward,
                                height: 24.h,
                                width: 24.w,
                                color: MyColor.chatPersonItemArrow,
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DefaultText(
                                    text: value ?? '',
                                    textStyle: MyTextStyle.subHeading15W500FieldTitleColor.copyWith(
                                      fontSize: 16.sp,
                                      color: MyColor.usdTextColor,
                                    ),
                                  ),
                                  isRating
                                      ? Padding(
                                          padding: EdgeInsets.only(left: Dimensions.space6.h),
                                          child: Icon(Icons.star, color: MyColor.ratingStar, size: 24.sp),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        isLine ? Line(left: Dimensions.space30.w) : SizedBox.shrink(),
      ],
    );
  }
}
