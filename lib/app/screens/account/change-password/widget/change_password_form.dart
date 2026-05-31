import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/text-field/label_text_field.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/controller/account/change_password_controller.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangePasswordController>(
      builder: (controller) => SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              LabelTextField(
                hintText: MyStrings.currentPassword.tr,
                labelText: MyStrings.currentPassword.tr,
                onChanged: (value) {
                  return;
                },
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return MyStrings.enterCurrentPass.tr;
                  } else {
                    return null;
                  }
                },
                controller: controller.currentPassController,
                //   isShowSuffixIcon: true,
                isPassword: true,
              ),
              const SizedBox(height: Dimensions.space20),
              LabelTextField(
                hintText: MyStrings.currentPassword.tr,
                labelText: MyStrings.newPassword.tr,
                onChanged: (value) {
                  return;
                },
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return MyStrings.enterNewPass.tr;
                  } else {
                    return null;
                  }
                },
                controller: controller.passController,
                isPassword: true,
              ),
              const SizedBox(height: Dimensions.space20),
              LabelTextField(
                hintText: MyStrings.currentPassword.tr,
                labelText: MyStrings.confirmPassword.tr,
                onChanged: (value) {
                  return;
                },
                validator: (value) {
                  if (controller.confirmPassController.text != controller.passController.text) {
                    return MyStrings.kMatchPassError.tr;
                  } else {
                    return null;
                  }
                },
                controller: controller.confirmPassController,
                isPassword: true,
              ),
              const SizedBox(height: Dimensions.space25),
              CustomElevatedBtn(
                text: MyStrings.submit,
                isLoading: controller.submitLoading,
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    controller.changePassword();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
