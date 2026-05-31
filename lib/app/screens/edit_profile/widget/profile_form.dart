import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/screens/edit_profile/widget/profile_image.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/controller/account/profile_controller.dart';
import '../../menu/personal_information/personal_information_screen.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        return Form(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.w),
              child: Column(
                children: [
                  ProfileWidget(isEdit: true, imagePath: controller.imageUrl, onClicked: () async {}),
                  const SizedBox(height: Dimensions.space20),
                  spaceDown(Dimensions.space12.h),
                  PersonalInformationItem(title: MyStrings.firstName.tr, value: controller.firstName.toString()),
                  spaceDown(Dimensions.space12.h),
                  PersonalInformationItem(title: MyStrings.lastName.tr, value: controller.lastName.toString()),
                  spaceDown(Dimensions.space12.h),
                  PersonalInformationItem(title: MyStrings.state.tr, value: controller.stateStr.toString()),
                  spaceDown(Dimensions.space12.h),
                  PersonalInformationItem(title: MyStrings.zipCode.tr, value: controller.zipCodeStr.toString()),
                  spaceDown(Dimensions.space12.h),
                  PersonalInformationItem(title: MyStrings.city.tr, value: controller.cityStr.toString()),
                  spaceDown(Dimensions.space12.h),
                  PersonalInformationItem(title: MyStrings.address.tr, value: controller.addressStr.toString()),
                  spaceDown(Dimensions.space12.h),
                  PersonalInformationItem(title: MyStrings.country.tr, value: controller.countryStr.toString()),

                  spaceDown(Dimensions.space30.h),
                  const SizedBox(height: Dimensions.space30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
