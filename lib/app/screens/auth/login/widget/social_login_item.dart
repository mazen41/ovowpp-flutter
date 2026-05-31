import 'package:flutter/material.dart';
import '../../../../../core/utils/util_exporter.dart';
import '../../../../components/image/my_asset_widget.dart';

class SocialLoginItem extends StatelessWidget {
  final VoidCallback onSocialTap;
  final bool isLoading;
  final String iconPath;
  const SocialLoginItem({super.key, required this.onSocialTap, required this.iconPath, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.space12),
      child: Material(
        borderRadius: BorderRadius.circular(Dimensions.space12.r),
        color: MyColor.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(Dimensions.space12.r),
          onTap: onSocialTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.space12, vertical: Dimensions.space12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.space12.r),
              border: Border.all(color: MyColor.socialContainerBorder.withAlpha(102), width: 1.311),
            ),
            child: isLoading
                ? Center(
                    child: SizedBox(
                      width: Dimensions.space25,
                      height: Dimensions.space25,
                      child: CircularProgressIndicator(color: MyColor.getPrimaryColor()),
                    ),
                  )
                : MyAssetImageWidget(assetPath: iconPath, isSvg: true, height: 24.h, width: 20.w),
          ),
        ),
      ),
    );
  }
}
