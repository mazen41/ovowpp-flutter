import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';

class MenuCards extends StatelessWidget {
  final String prefixIcon;
  final String title;
  final bool isSignOut;
  final bool isSvg;
  final Callback? onTap;
  const MenuCards({
    super.key,
    this.onTap,
    required this.prefixIcon,
    required this.title,
    this.isSignOut = false,
    this.isSvg = true,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: Dimensions.space16.h),
        decoration: BoxDecoration(
          color: MyColor.getCardBackgroundColor(),
          borderRadius: BorderRadius.circular(Dimensions.space8),
        ),
        child: Row(
          children: [
            MyAssetImageWidget(
              assetPath: prefixIcon,
              isSvg: isSvg,
              height: Dimensions.space18.h,
              width: Dimensions.space18.h,
              color: isSignOut ? MyColor.getErrorColor() : null,
            ),
            spaceSide(Dimensions.space14.w),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: Dimensions.space14.h,
                  color: isSignOut ? MyColor.getErrorColor() : MyColor.getHeadingTextColor(),
                ),
              ),
            ),
            isSignOut
                ? SizedBox()
                : MyAssetImageWidget(
                    assetPath: MyImages.arrowForward,
                    isSvg: true,
                    height: Dimensions.space20.h,
                    width: Dimensions.space20.h,
                  ),
          ],
        ),
      ),
    );
  }
}
