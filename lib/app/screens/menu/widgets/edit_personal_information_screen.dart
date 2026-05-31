import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/app/components/text-field/label_text_field.dart';
import 'package:ovowpp/app/screens/menu/widgets/profile_edit_and_cancel_btn.dart';
import '../../../../core/utils/util_exporter.dart';
import '../../../components/app-bar/custom_app_bar.dart';

class EditPersonalInformationScreen extends StatelessWidget {
  const EditPersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.white,
      appBar: CustomAppBar(elevation: 0, bgColor: MyColor.white, title: MyStrings.personalInformation.tr),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.w),
        child: Column(
          children: [
            ProfileEditAndCancelBtn(
              text: MyStrings.cancel,
              onTap: () {
                Get.back();
              },
            ),
            spaceDown(Dimensions.space26.h),
            LabelTextField(
              isShadow: true,
              isRequired: true,
              labelText: MyStrings.fullName.tr,
              onChanged: () {},
              fillColor: MyColor.searchFieldColor,
            ),
            spaceDown(Dimensions.space12.h),
            LabelTextField(
              isShadow: true,
              labelText: MyStrings.number.tr,
              onChanged: () {},
              fillColor: MyColor.searchFieldColor,
            ),
            spaceDown(Dimensions.space12.h),
            LabelTextField(
              isShadow: true,
              labelText: MyStrings.email.tr,
              onChanged: () {},
              fillColor: MyColor.searchFieldColor,
            ),
            spaceDown(Dimensions.space12.h),
            LabelTextField(
              readOnly: true,
              isShadow: true,
              suffixIcon: MyAssetImageWidget(
                height: 20.h,
                width: 20.w,
                boxFit: BoxFit.scaleDown,
                isSvg: true,
                assetPath: MyImages.arrowDown,
              ),
              labelText: MyStrings.country.tr,
              onChanged: () {},
              fillColor: MyColor.searchFieldColor,
            ),
            spaceDown(Dimensions.space28.h),
            CustomElevatedBtn(text: MyStrings.save, onTap: () {}),
          ],
        ),
      ),
    );
  }
}
