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
import 'package:ovowpp/core/translations/strings_enum.dart';
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
          appBar: CustomAppBar(title: Strings.editProfile.tr),
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
                      labelText: Strings.firstName.tr,
                      hintText: Strings.enterYourFirstName.tr,
                      onChanged: (value) {},
                      textInputType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      radius: Dimensions.largeRadius,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return Strings.fieldErrorMsg.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    spaceDown(Dimensions.space15.h),

                    LabelTextField(
                      controller: controller.lastNameController,
                      labelText: Strings.lastName.tr,
                      hintText: Strings.enterYourLastName.tr,
                      onChanged: (value) {},

                      textInputType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      radius: Dimensions.largeRadius,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return Strings.fieldErrorMsg.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    spaceDown(Dimensions.space15.h),
                    LabelTextField(
                      controller: controller.stateController,
                      labelText: Strings.state.tr,
                      hintText: Strings.enterYourState.tr,
                      onChanged: (value) {},

                      textInputType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      radius: Dimensions.largeRadius,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return Strings.fieldErrorMsg.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    spaceDown(Dimensions.space15.h),
                    LabelTextField(
                      controller: controller.zipCodeController,
                      labelText: Strings.zipCode.tr,
                      hintText: Strings.enterYourZipCode.tr,
                      onChanged: (value) {},

                      textInputType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      radius: Dimensions.largeRadius,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return Strings.fieldErrorMsg.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    spaceDown(Dimensions.space15.h),
                    LabelTextField(
                      controller: controller.cityController,
                      labelText: Strings.city.tr,
                      hintText: Strings.enterYourCity.tr,
                      onChanged: (value) {},

                      textInputType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      radius: Dimensions.largeRadius,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return Strings.fieldErrorMsg.tr;
                        } else {
                          return null;
                        }
                      },
                    ),

                    spaceDown(Dimensions.space15.h),
                    LabelTextField(
                      controller: controller.addressController,
                      labelText: Strings.address.tr,
                      hintText: Strings.address.tr,
                      onChanged: (value) {},
                      textInputType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      radius: Dimensions.largeRadius,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return Strings.fieldErrorMsg.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    spaceDown(Dimensions.space15.h),

                    LabelTextField(
                      readOnly: true,
                      controller: controller.countryController,
                      labelText: Strings.country.tr,
                      hintText: Strings.country.tr,
                      onChanged: (value) {},

                      textInputType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      radius: Dimensions.largeRadius,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return Strings.fieldErrorMsg.tr;
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
                      text: Strings.update.tr,
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
