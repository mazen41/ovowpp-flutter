import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/app/components/text-field/label_text_field.dart';
import 'package:ovowpp/app/components/text/default_text.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_images.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/text_style.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.white,
      appBar: CustomAppBar(title: MyStrings.contactSupport.tr, elevation: 0, bgColor: Colors.white),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              LabelTextField(
                labelText: MyStrings.subject.tr,
                hintText: MyStrings.subjectFieldHint.tr,
                onChanged: () {},
                fillColor: MyColor.searchFieldColor,
              ),
              spaceDown(Dimensions.space11.h),
              LabelTextField(
                labelText: MyStrings.issueCategory.tr,
                onChanged: () {},
                fillColor: MyColor.searchFieldColor,
              ),
              spaceDown(Dimensions.space11.h),
              LabelTextField(
                labelText: MyStrings.message.tr,
                hintText: MyStrings.describeIssue,
                onChanged: () {},
                fillColor: MyColor.searchFieldColor,
                maxLines: 6,
              ),
              spaceDown(Dimensions.space11.h),
              LabelTextField(
                readOnly: true,
                labelText: MyStrings.attachmentOptional.tr,
                hintText: MyStrings.attachAFile,
                prefixIcon: MyAssetImageWidget(
                  assetPath: MyImages.attach,
                  isSvg: true,
                  height: 16.h,
                  width: 16.w,
                  boxFit: BoxFit.scaleDown,
                ),
                onChanged: () {},
                fillColor: MyColor.searchFieldColor,
              ),
              spaceDown(Dimensions.space26.h),
              DefaultText(
                text: MyStrings.supportTeamHelp24Hours,
                textStyle: MyTextStyle.subHeading12W400().copyWith(fontSize: 14.sp),
              ),
              spaceDown(Dimensions.space26.h),
              CustomElevatedBtn(text: MyStrings.sendMessages, onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
