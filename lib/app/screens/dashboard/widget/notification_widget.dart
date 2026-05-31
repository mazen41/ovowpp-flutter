import 'package:flutter/material.dart';
import '../../../../core/utils/util_exporter.dart';
import '../../../components/image/my_asset_widget.dart';

class NotificationIcon extends StatelessWidget {
  final bool isShowToggle;
  final VoidCallback onTap;

  const NotificationIcon({super.key, required this.isShowToggle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          color: MyColor.white,
          borderRadius: BorderRadius.circular(Dimensions.space50.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(Dimensions.space50.r),
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.all(Dimensions.space8.r),

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: MyColor.notificationBorder),
              ),
              child: MyAssetImageWidget(isSvg: true, assetPath: MyImages.notificationIcon, height: 27.h, width: 27.w),
            ),
          ),
        ),
        isShowToggle
            ? Positioned(
                top: 3.h,
                right: 6.w,
                child: Container(
                  height: 15.5.h,
                  width: 15.5,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: MyColor.notificationToggle),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
