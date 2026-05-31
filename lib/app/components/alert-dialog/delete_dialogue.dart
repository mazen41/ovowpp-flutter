import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_images.dart';
import 'package:ovowpp/core/utils/my_strings.dart';

class DeleteDialogue extends StatelessWidget {
  final Callback onTap;
  final bool isLoading;
  final String? warningText;
  const DeleteDialogue({super.key, required this.onTap, required this.isLoading, this.warningText});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          MyAssetImageWidget(
            assetPath: MyImages.danger,
            width: Dimensions.space40.h,
            height: Dimensions.space40.h,
            color: MyColor.lightError,
          ),
          spaceDown(Dimensions.space14),
          Text(
            MyStrings.pleaseConfirm.tr,
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 22, color: MyColor.black),
          ),
          spaceDown(Dimensions.space10),
          Text(
            warningText ?? MyStrings.areYouSureYouWantToDeleteThisAgent.tr,
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400, fontSize: 14, color: MyColor.black),
          ),
          spaceDown(Dimensions.space14),
          Row(
            children: [
              Expanded(
                child: CustomElevatedBtn(
                  isLoading: false,
                  bgColor: MyColor.white,
                  borderColor: MyColor.getBorderColor(),
                  text: MyStrings.no.tr,
                  onTap: () {
                    Get.back();
                  },
                ),
              ),
              spaceSide(Dimensions.space15),
              Expanded(
                child: CustomElevatedBtn(
                  isLoading: isLoading,
                  text: MyStrings.yes.tr,
                  loaderColor: MyColor.lightPrimary,
                  bgColor: MyColor.white,
                  textColor: MyColor.lightSuccess,
                  borderColor: MyColor.lightSuccess,
                  onTap: onTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
