import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/data/controller/contact/contact_screen_controller.dart';
import '../../../core/utils/util_exporter.dart';
import '../../components/annotated_region/annotated_region_widget.dart';
import '../../components/app-bar/custom_app_bar.dart';
import '../../components/buttons/custom_elevated_button.dart';
import '../../components/image/my_asset_widget.dart';
import '../../components/text-field/label_text_field.dart';

class AddNewContact extends StatefulWidget {
  const AddNewContact({super.key});

  @override
  State<AddNewContact> createState() => _AddNewContactState();
}

class _AddNewContactState extends State<AddNewContact> {
  @override
  void initState() {
    Get.put(ContactScreenController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContactScreenController>(
      builder: (controller) {
        return AnnotatedRegionWidget(
          statusBarColor: Colors.transparent,
          child: Scaffold(
            backgroundColor: MyColor.white,
            appBar: CustomAppBar(elevation: 0, bgColor: Colors.white, title: MyStrings.addNewContact.tr),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelTextField(
                      isRequired: true,
                      controller: controller.fullNameController,
                      labelText: MyStrings.fullName.tr,
                      hintText: MyStrings.enterFullName.tr,
                      onChanged: () {},
                      fillColor: MyColor.campaignFieldFillColor,
                      isShadow: true,
                    ),
                    spaceDown(Dimensions.space16.h),
                    LabelTextField(
                      isRequired: true,
                      //   readOnly: true,
                      controller: controller.phoneNumberController,
                      labelText: MyStrings.phoneNumber.tr,
                      hintText: MyStrings.phoneNumber.tr,
                      onChanged: () {},
                      fillColor: MyColor.campaignFieldFillColor,
                    ),
                    spaceDown(Dimensions.space16.h),
                    LabelTextField(
                      controller: controller.emailController,
                      labelText: MyStrings.emailOptional.tr,
                      hintText: MyStrings.emailExample.tr,
                      onChanged: () {},
                      fillColor: MyColor.campaignFieldFillColor,
                      suffixIcon: MyAssetImageWidget(
                        isSvg: true,
                        assetPath: MyImages.arrowDown,
                        height: 16.h,
                        width: 16.h,
                        boxFit: BoxFit.scaleDown,
                      ),
                    ),
                    spaceDown(Dimensions.space16.h),
                    LabelTextField(
                      controller: controller.tagController,
                      labelText: MyStrings.tag.tr,
                      hintText: MyStrings.lead.tr,
                      onChanged: () {},
                      fillColor: MyColor.campaignFieldFillColor,
                      suffixIcon: MyAssetImageWidget(
                        isSvg: true,
                        assetPath: MyImages.arrowDown,
                        height: 16.h,
                        width: 16.h,
                        boxFit: BoxFit.scaleDown,
                      ),
                    ),
                    spaceDown(Dimensions.space16.h),
                    LabelTextField(
                      maxLines: 6,
                      controller: controller.notesController,
                      labelText: MyStrings.notesOptional.tr,
                      hintText: MyStrings.addNoteAboutThisContact.tr,
                      onChanged: () {},
                      fillColor: MyColor.campaignFieldFillColor,
                    ),
                    spaceDown(Dimensions.space16.h),

                    spaceDown(Dimensions.space16.h),
                    CustomElevatedBtn(text: MyStrings.saveContact.tr, onTap: () {}),
                    spaceDown(Dimensions.space12.h),
                    CustomElevatedBtn(
                      text: MyStrings.cancel.tr,
                      onTap: () {},
                      bgColor: MyColor.cancelElevatedBtnBgColor,
                    ),
                    spaceDown(Dimensions.space23.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
