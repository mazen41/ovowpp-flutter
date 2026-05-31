import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/app/components/text-field/label_text_field.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/controller/contact_tag/contact_tag_list_controller.dart';

class AddOrUpdateTagDialogue extends StatefulWidget {
  final bool isUpdate;
  final String id;
  const AddOrUpdateTagDialogue({super.key, this.isUpdate = false, required this.id});

  @override
  State<AddOrUpdateTagDialogue> createState() => _AddOrUpdateTagDialogueState();
}

class _AddOrUpdateTagDialogueState extends State<AddOrUpdateTagDialogue> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContactTagListController>(
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
                  widget.isUpdate ? MyStrings.editContactTag.tr : MyStrings.addContactTag.tr,
                  style: MyTextStyle.heading16W600UseTextColor(),
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
                spaceDown(Dimensions.space30),
                LabelTextField(
                  isRequired: true,
                  controller: controller.contactNameController,
                  labelText: MyStrings.name.tr,
                  hintText: MyStrings.enterListName.tr,
                  onChanged: (value) {},
                  textInputType: TextInputType.emailAddress,
                  inputAction: TextInputAction.next,
                  radius: Dimensions.largeRadius,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return MyStrings.fieldErrorMsg.tr;
                    } else {
                      return null;
                    }
                  },
                ),
              ],
            ),
          ),
          spaceDown(Dimensions.space30.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.horizontalScreenPadding),
            child: CustomElevatedBtn(
              isLoading: controller.submitContact,
              text: MyStrings.submit.tr,
              onTap: () {
                if (controller.contactNameController.toString() != "") {
                  controller.id = widget.id;
                  controller.submitContactData();
                } else {
                  CustomSnackBar.error(errorList: [MyStrings.nameIsRequired.tr]);
                }
              },
            ),
          ),
          spaceDown(Dimensions.space30.h),
        ],
      ),
    );
  }
}
