import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/checkbox/single_custom_check_box.dart';
import 'package:ovowpp/app/components/text-field/label_text_field.dart';
import 'package:ovowpp/app/screens/auth/registration/widget/privacy_policy_terms_of_services.dart';
import 'package:ovowpp/app/screens/auth/registration/widget/validation_widget.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/controller/auth/auth/registration_controller.dart';

import '../../../../components/image/text_field_prefix_icon.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<RegistrationController>(
      builder: (controller) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelTextField(
                labelText: MyStrings.firstName.tr,
                hintText: MyStrings.enterYourFirstName.tr,
                controller: controller.fNameController,
                focusNode: controller.firstNameFocusNode,
                textInputType: TextInputType.text,
                inputAction: TextInputAction.next,
                prefixIcon: TextFieldPrefixIcon(imagePath: MyImages.firstNameFieldIcon),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return MyStrings.enterYourFirstName.tr;
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  return;
                },
              ),
              spaceDown(Dimensions.space12.h),
              LabelTextField(
                labelText: MyStrings.lastName.tr,
                hintText: MyStrings.lastName.tr,
                controller: controller.lNameController,
                focusNode: controller.lastNameFocusNode,
                textInputType: TextInputType.text,
                inputAction: TextInputAction.next,
                prefixIcon: TextFieldPrefixIcon(imagePath: MyImages.firstNameFieldIcon),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return MyStrings.enterYourLastName.tr;
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  return;
                },
              ),
              spaceDown(Dimensions.space12.h),
              LabelTextField(
                labelText: MyStrings.yourEmail.tr,
                hintText: MyStrings.enterYourEmailOrUserName.tr,
                controller: controller.emailController,
                focusNode: controller.emailFocusNode,
                textInputType: TextInputType.emailAddress,
                inputAction: TextInputAction.next,
                prefixIcon: TextFieldPrefixIcon(imagePath: MyImages.emailFieldPrefixSVG),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return MyStrings.enterYourEmail.tr;
                  } else if (!MyStrings.emailValidatorRegExp.hasMatch(value ?? '')) {
                    return MyStrings.invalidEmailMsg.tr;
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  return;
                },
              ),
              spaceDown(Dimensions.space12.h),
              Focus(
                onFocusChange: (hasFocus) {
                  controller.changePasswordFocus(hasFocus);
                },
                child: LabelTextField(
                  isPassword: true,
                  labelText: MyStrings.password.tr,
                  hintText: MyStrings.enterYourPassword_.tr,
                  controller: controller.passwordController,
                  focusNode: controller.passwordFocusNode,
                  nextFocus: controller.confirmPasswordFocusNode,
                  textInputType: TextInputType.text,
                  prefixIcon: TextFieldPrefixIcon(imagePath: MyImages.passwordFieldPrefixSVG),

                  onChanged: (value) {
                    if (controller.checkPasswordStrength) {
                      controller.updateValidationList(value);
                    }
                  },
                  validator: (value) {
                    return controller.validatePassword(value ?? '');
                  },
                  labelTextStyle: theme.textTheme.titleSmall?.copyWith(),
                ),
              ),
              Visibility(
                visible: controller.hasPasswordFocus && controller.checkPasswordStrength,
                child: ValidationWidget(list: controller.passwordValidationRules),
              ),
              spaceDown(Dimensions.space12.h),
              LabelTextField(
                labelText: MyStrings.confirmPassword.tr,
                hintText: MyStrings.confirmYourPassword.tr,
                controller: controller.cPasswordController,
                focusNode: controller.confirmPasswordFocusNode,
                inputAction: TextInputAction.done,
                prefixIcon: TextFieldPrefixIcon(imagePath: MyImages.passwordFieldPrefixSVG),
                isPassword: true,
                onChanged: (value) {},
                validator: (value) {
                  if (controller.passwordController.text.toLowerCase() !=
                      controller.cPasswordController.text.toLowerCase()) {
                    return MyStrings.kMatchPassError.tr;
                  } else {
                    return null;
                  }
                },
              ),
              spaceDown(Dimensions.space14.h),
              Visibility(
                visible: controller.needAgree,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleCustomCheckbox(
                      value: controller.agreeTC,
                      onChanged: () {
                        controller.updateAgreeTC();
                        //  controller.changeRememberMe();
                      },
                      isRememberMeTextShow: true,
                      checkText: MyStrings.iAgreeToThe.tr,
                    ),
                    Expanded(
                      child: PrivacyPolicyTermsOfServices(
                        privacyPolicyTap: () {
                          Get.toNamed(RouteHelper.privacyScreen);
                        },
                        termsOfServiceTap: () {
                          Get.toNamed(RouteHelper.privacyScreen);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              spaceDown(Dimensions.space24.h),
              CustomElevatedBtn(
                isLoading: controller.submitLoading,
                text: MyStrings.createNewAccount.tr,
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    controller.signUpUser();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
