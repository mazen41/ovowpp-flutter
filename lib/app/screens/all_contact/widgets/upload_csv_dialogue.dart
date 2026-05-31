import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/controller/all_contacts/all_contact_controller.dart';

class UploadCsvDialogue extends StatefulWidget {
  const UploadCsvDialogue({super.key});

  @override
  State<UploadCsvDialogue> createState() => _UploadCsvDialogueState();
}

class _UploadCsvDialogueState extends State<UploadCsvDialogue> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<AllContactController>(
      builder: (controller) => Column(
        children: [
          Container(
            padding: EdgeInsets.all(Dimensions.space16),
            decoration: BoxDecoration(
              color: MyColor.lightTextFieldFillColor.withValues(alpha: .40),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.space8),
                topRight: Radius.circular(Dimensions.space8),
              ),
            ),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  MyStrings.importContact.tr,
                  style: theme.textTheme.headlineMedium?.copyWith(color: MyColor.getHeadingTextColor()),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: MyAssetImageWidget(
                    assetPath: MyImages.roundedCancel,
                    isSvg: true,
                    height: Dimensions.space24.h,
                    width: Dimensions.space24.h,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.horizontalScreenPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    controller.pickFile();
                  },
                  child: Container(
                    height: Dimensions.space150.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.defaultRadius - 5),
                      border: Border.all(color: MyColor.getBorderColor()),
                    ),
                    child: Center(
                      child: controller.isFile(controller.csvFile.toString())
                          ? MyAssetImageWidget(assetPath: MyIcons.xlsx, isSvg: true)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.upload_file_outlined, color: MyColor.getBodyTextColor()),
                                Text(MyStrings.upload.tr, style: theme.textTheme.bodyLarge),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          spaceDown(Dimensions.space30.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.horizontalScreenPadding),
            child: CustomElevatedBtn(
              isLoading: controller.uploadCsv,
              text: MyStrings.upload.tr,
              onTap: () {
                controller.uploadCsvFile();
              },
            ),
          ),
          spaceDown(Dimensions.space30.h),
        ],
      ),
    );
  }
}
