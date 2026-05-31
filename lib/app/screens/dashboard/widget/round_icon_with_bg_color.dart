import 'package:flutter/material.dart';
import '../../../../core/utils/util_exporter.dart';
import '../../../components/image/my_asset_widget.dart';

class RoundIconWithBgColor extends StatelessWidget {
  final Color bgColor;
  final String icon;
  final bool isOnTap;
  final double height, width;
  final Color? iconColor;
  final Color? borderColor;
  final VoidCallback? onTap;

  const RoundIconWithBgColor({
    super.key,
    required this.bgColor,
    required this.icon,
    this.isOnTap = false,
    this.onTap,
    this.height = 27,
    this.width = 27,
    this.iconColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return isOnTap
        ? Material(
            borderRadius: BorderRadius.circular(Dimensions.space50.r),
            color: bgColor,
            child: InkWell(
              borderRadius: BorderRadius.circular(Dimensions.space50.r),
              onTap: onTap,
              child: containerImage(),
            ),
          )
        : containerImage();
  }

  Container containerImage() {
    return Container(
      padding: EdgeInsets.all(Dimensions.space8.r),
      decoration: BoxDecoration(
        border: borderColor != null ? Border.all(color: borderColor!, width: 1) : null,

        color: isOnTap ? null : bgColor,
        shape: BoxShape.circle,
      ),
      child: MyAssetImageWidget(
        isSvg: true,
        assetPath: icon,
        height: height.h,
        width: width.h,
        color: iconColor ?? MyColor.getPrimaryColor(),
      ),
    );
  }
}
