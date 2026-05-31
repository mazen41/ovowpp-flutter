import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/data/controller/account/change_password_controller.dart';
import 'package:ovowpp/data/repo/account/change_password_repo.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/screens/account/change-password/widget/change_password_form.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  void initState() {
    Get.put(ChangePasswordRepo());
    Get.put(ChangePasswordController(changePasswordRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ChangePasswordController>().clearData();
    });
  }

  @override
  void dispose() {
    Get.find<ChangePasswordController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.white,
      appBar: CustomAppBar(
        isShowBackBtn: true,
        elevation: 0,
        bgColor: MyColor.white,
        title: MyStrings.changePassword.tr,
      ),
      body: GetBuilder<ChangePasswordController>(
        builder: (controller) => SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: Dimensions.space20.h, horizontal: Dimensions.space16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  MyStrings.createPasswordSubText.tr,
                  style: MyTextStyle.subHeading12W400().copyWith(fontSize: 14.sp),
                ),
                SizedBox(height: Dimensions.space20),
                const ChangePasswordForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
