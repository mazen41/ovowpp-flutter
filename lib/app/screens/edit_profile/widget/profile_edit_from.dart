import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/text-field/label_text_field.dart';
import 'package:ovowpp/app/screens/edit_profile/widget/profile_image.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/controller/account/profile_controller.dart';

class ProfileEditForm extends StatefulWidget {
  const ProfileEditForm({super.key});

  @override
  State<ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) => AnnotatedRegionWidget(
        child: Scaffold(
          backgroundColor: MyColor.white,
          appBar: CustomAppBar(title: MyStrings.editProfile.tr),
          body: Form(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.w),
                child: Column(
                  children: [
                    ProfileWidget(isEdit: false, imagePath: controller.imageUrl, onClicked: () async {}),

                    const SizedBox(height: Dimensions.space20),

                    LabelTextField(
                      controller: controller.firstNameController,
                      labelText: MyStrings.firstName.tr,
                      hintText: MyStrings.enterYourFirstName.tr,
                      onChanged: (value) {},
                      textInputType: TextInputType.text,
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
                    spaceDown(Dimensions.space15.h),

                    LabelTextField(
                      controller: controller.lastNameController,
                      labelText: MyStrings.lastName.tr,
                      hintText: MyStrings.enterYourLastName.tr,
                      onChanged: (value) {},

                      textInputType: TextInputType.text,
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
                    spaceDown(Dimensions.space15.h),
                    LabelTextField(
                      controller: controller.stateController,
                      labelText: MyStrings.state.tr,
                      hintText: MyStrings.enterYourState.tr,
                      onChanged: (value) {},

                      textInputType: TextInputType.text,
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
                    spaceDown(Dimensions.space15.h),
                    LabelTextField(
                      controller: controller.zipCodeController,
                      labelText: MyStrings.zipCode.tr,
                      hintText: MyStrings.enterYourZipCode.tr,
                      onChanged: (value) {},

                      textInputType: TextInputType.text,
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
                    spaceDown(Dimensions.space15.h),
                    LabelTextField(
                      controller: controller.cityController,
                      labelText: MyStrings.city.tr,
                      hintText: MyStrings.enterYourCity.tr,
                      onChanged: (value) {},

                      textInputType: TextInputType.text,
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

                    spaceDown(Dimensions.space15.h),
                    LabelTextField(
                      controller: controller.addressController,
                      labelText: MyStrings.address.tr,
                      hintText: MyStrings.address.tr,
                      onChanged: (value) {},
                      textInputType: TextInputType.text,
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
                    spaceDown(Dimensions.space15.h),

                    LabelTextField(
                      readOnly: true,
                      controller: controller.countryController,
                      labelText: MyStrings.country.tr,
                      hintText: MyStrings.country.tr,
                      onChanged: (value) {},

                      textInputType: TextInputType.text,
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
                    spaceDown(Dimensions.space30.h),

                    CustomElevatedBtn(
                      isLoading: controller.isSubmitLoading,
                      onTap: () {
                        controller.updateProfile();
                      },
                      text: MyStrings.update.tr,
                    ),
                    const SizedBox(height: Dimensions.space30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
