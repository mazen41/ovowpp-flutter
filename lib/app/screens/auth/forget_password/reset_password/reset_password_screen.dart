import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/text-field/label_text_field.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/screens/auth/registration/widget/validation_widget.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/data/controller/auth/forget_password/reset_password_controller.dart';
import 'package:ovowpp/data/repo/auth/login_repo.dart';
import 'package:ovowpp/app/components/text/default_text.dart';
import 'package:ovowpp/app/components/will_pop_widget.dart';

import '../../../../../core/utils/text_style.dart' show MyTextStyle;
import '../../../../../core/utils/util_exporter.dart';
import '../../../../components/image_bg_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Get.put(LoginRepo());
    final controller = Get.put(ResetPasswordController(loginRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.email = Get.arguments[0];
      controller.code = Get.arguments[1];
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      nextRoute: RouteHelper.loginScreen,
      child: ImageBgWidget(
        isAppBar: true,
        customAppBar: CustomAppBar(
          fromAuth: true,
          isShowBackBtn: true,
          title: MyStrings.forgetPassword.tr,
          bgColor: Colors.transparent,
        ),
        screen: GetBuilder<ResetPasswordController>(
          builder: (controller) => SingleChildScrollView(
            padding: Dimensions.screenPadding,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  spaceDown(Dimensions.space25.h),
                  DefaultText(text: MyStrings.resetPassword.tr, textStyle: MyTextStyle.heading20W700()),
                  spaceDown(Dimensions.space12.h),
                  DefaultText(text: MyStrings.resetPassContent.tr, textStyle: MyTextStyle.subHeading15W400()),

                  spaceDown(Dimensions.space15),
                  Focus(
                    onFocusChange: (hasFocus) {
                      controller.changePasswordFocus(hasFocus);
                    },
                    child: LabelTextField(
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      focusNode: controller.passwordFocusNode,
                      nextFocus: controller.confirmPasswordFocusNode,
                      hintText: MyStrings.enterNewPassword,
                      labelText: MyStrings.password,
                      isPassword: true,
                      textInputType: TextInputType.text,
                      controller: controller.passController,
                      validator: (value) {
                        return controller.validatePassword(value);
                      },
                      onChanged: (value) {
                        if (controller.checkPasswordStrength) {
                          controller.updateValidationList(value);
                        }
                        return;
                      },
                      prefixIcon: Icon(Icons.lock, color: MyColor.splashTextColor),
                    ),
                  ),
                  Visibility(
                    visible: controller.hasPasswordFocus && controller.checkPasswordStrength,
                    child: ValidationWidget(list: controller.passwordValidationRules, fromReset: true),
                  ),
                  const SizedBox(height: Dimensions.space15),
                  LabelTextField(
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    inputAction: TextInputAction.done,
                    isPassword: true,
                    labelText: MyStrings.confirmPassword.tr,
                    controller: controller.confirmPassController,
                    hintText: MyStrings.enterConfirmPassword,
                    onChanged: (value) {
                      return;
                    },
                    validator: (value) {
                      if (controller.passController.text.toLowerCase() !=
                          controller.confirmPassController.text.toLowerCase()) {
                        return MyStrings.kMatchPassError.tr;
                      } else {
                        return null;
                      }
                    },
                    prefixIcon: Icon(Icons.lock, color: MyColor.splashTextColor),
                  ),
                  const SizedBox(height: Dimensions.space35),
                  CustomElevatedBtn(
                    isLoading: controller.submitLoading,
                    text: MyStrings.submit.tr,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        controller.resetPassword();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
