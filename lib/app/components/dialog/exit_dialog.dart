import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_images.dart';
import 'package:ovowpp/core/utils/my_strings.dart';

Future<void> showExitDialog() async {
  await Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyAssetImageWidget(assetPath: MyImages.danger, width: 40, height: 40, color: MyColor.lightError),
            spaceDown(Dimensions.space14),
            Text(
              MyStrings.pleaseConfirm.tr,
              style: Get.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 22, color: MyColor.black),
              textAlign: TextAlign.center,
            ),
            spaceDown(Dimensions.space10),
            Text(
              MyStrings.areYouSureYouwanttoExitTheApp.tr,
              style: Get.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400, fontSize: 14, color: MyColor.black),
              textAlign: TextAlign.center,
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
                    onTap: () => Get.back(),
                  ),
                ),
                spaceSide(Dimensions.space15),
                Expanded(
                  child: CustomElevatedBtn(
                    isLoading: false,
                    text: MyStrings.yes.tr,
                    loaderColor: MyColor.lightPrimary,
                    bgColor: MyColor.white,
                    textColor: MyColor.getErrorColor(),
                    borderColor: MyColor.lightSuccess,
                    onTap: () => SystemNavigator.pop(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: true,
  );
}
