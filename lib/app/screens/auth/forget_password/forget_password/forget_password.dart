import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/image_bg_widget.dart';
import 'package:ovowpp/app/components/text-field/label_text_field.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/data/controller/auth/forget_password/forget_password_controller.dart';
import 'package:ovowpp/data/repo/auth/login_repo.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/components/text/default_text.dart';

import '../../../../../core/utils/util_exporter.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Get.put(LoginRepo());
    Get.put(ForgetPasswordController(loginRepo: Get.find()));

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ImageBgWidget(
      isAppBar: true,
      customAppBar: CustomAppBar(
        fromAuth: true,
        isShowBackBtn: true,
        title: MyStrings.forgetPassword.tr,
        bgColor: Colors.transparent,
      ),
      screen: GetBuilder<ForgetPasswordController>(
        builder: (auth) => SingleChildScrollView(
          padding: Dimensions.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spaceDown(Dimensions.space30.h),
                DefaultText(text: MyStrings.recoverAccount.tr, textStyle: MyTextStyle.heading20W700()),
                spaceDown(Dimensions.space12.h),
                DefaultText(text: MyStrings.forgetPasswordSubText.tr, textStyle: MyTextStyle.subHeading15W400()),

                const SizedBox(height: Dimensions.space40),
                LabelTextField(
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  labelText: MyStrings.usernameOrEmail.tr,
                  hintText: MyStrings.usernameOrEmailHint.tr,
                  textInputType: TextInputType.emailAddress,
                  inputAction: TextInputAction.done,
                  controller: auth.emailOrUsernameController,
                  onChanged: (value) {
                    return;
                  },
                  validator: (value) {
                    if (auth.emailOrUsernameController.text.isEmpty) {
                      return MyStrings.enterEmailOrUserName.tr;
                    } else {
                      return null;
                    }
                  },
                  prefixIcon: Icon(
                    CupertinoIcons.mail,
                    color: MyColor.fieldTitleTextColor,
                    size: Dimensions.inputIconSize + 2,
                  ),
                ),
                const SizedBox(height: Dimensions.space25),
                CustomElevatedBtn(
                  isLoading: auth.submitLoading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      auth.submitForgetPassCode();
                    }
                  },
                  text: MyStrings.submit.tr,
                ),
                const SizedBox(height: Dimensions.space40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
