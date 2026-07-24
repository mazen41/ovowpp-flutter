import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_images.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/controller/auth/forget_password/verify_password_controller.dart';
import 'package:ovowpp/data/repo/auth/login_repo.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/components/image/custom_svg_picture.dart';
import 'package:ovowpp/app/components/text/default_text.dart';

import '../../../../components/image_bg_widget.dart';

class VerifyForgetPassScreen extends StatefulWidget {
  const VerifyForgetPassScreen({super.key});

  @override
  State<VerifyForgetPassScreen> createState() => _VerifyForgetPassScreenState();
}

class _VerifyForgetPassScreenState extends State<VerifyForgetPassScreen> {
  @override
  void initState() {
    Get.put(LoginRepo());
    final controller = Get.put(VerifyPasswordController(loginRepo: Get.find()));

    controller.email = Get.arguments;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ImageBgWidget(
      isAppBar: true,
      customAppBar: CustomAppBar(isShowBackBtn: true, title: MyStrings.forgetPassword.tr, bgColor: Colors.transparent),
      screen: GetBuilder<VerifyPasswordController>(
        builder: (controller) => controller.isLoading
            ? Center(child: CircularProgressIndicator(color: MyColor.getPrimaryColor()))
            : SingleChildScrollView(
                padding: Dimensions.screenPadding,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      spaceDown(Dimensions.space50),
                      Container(
                        height: 100,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: MyColor.getPrimaryColor().withValues(alpha: .07),
                          shape: BoxShape.circle,
                        ),
                        child: CustomSvgPicture(
                          image: MyImages.emailVerifyImage,
                          height: 50,
                          width: 50,
                          color: MyColor.getPrimaryColor(),
                        ),
                      ),
                      spaceDown(Dimensions.space25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: DefaultText(
                          text: '${MyStrings.verifyPasswordSubText.tr} : ${controller.getFormatedMail().tr}',
                          textAlign: TextAlign.center,
                          textColor: MyColor.getBodyTextColor(),
                        ),
                      ),
                      spaceDown(Dimensions.space40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.space30),
                        child: MaterialPinField(
                          length: 6,
                          obscureText: false,
                          blinkWhenObscuring: false,
                          theme: MaterialPinTheme(
                            shape: MaterialPinShape.outlined,
                            cellSize: const Size(40, 40),
                            spacing: 8,
                            borderWidth: 1,
                            focusedBorderWidth: 1,
                            borderRadius: BorderRadius.circular(5),
                            borderColor: MyColor.getBorderColor(),
                            fillColor: MyColor.getScaffoldBackgroundColor(),
                            filledFillColor: MyColor.getScaffoldBackgroundColor(),
                            filledBorderColor: MyColor.getPrimaryColor(),
                            focusedFillColor: MyColor.getScaffoldBackgroundColor(),
                            focusedBorderColor: MyColor.getPrimaryColor(),
                            textStyle: theme.textTheme.labelMedium?.copyWith(color: MyColor.getBodyTextColor()),
                            obscuringCharacter: '*',
                            cursorColor: MyColor.getBodyTextColor(),
                            entryAnimation: MaterialPinAnimation.fade,
                            animationDuration: const Duration(milliseconds: 100),
                          ),
                          keyboardType: TextInputType.number,
                          enablePaste: true,
                          onChanged: (value) {
                            setState(() {
                              controller.currentText = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: Dimensions.space25),
                      CustomElevatedBtn(
                        isLoading: controller.verifyLoading,
                        onTap: () {
                          if (controller.currentText.length != 6) {
                            controller.hasError = true;
                          } else {
                            controller.verifyForgetPasswordCode(controller.currentText);
                          }
                        },
                        text: MyStrings.submit.tr,
                      ),
                      const SizedBox(height: Dimensions.space25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DefaultText(text: MyStrings.didNotReceiveCode.tr, textColor: MyColor.getBodyTextColor()),
                          spaceSide(Dimensions.space5),
                          controller.isResendLoading
                              ? SizedBox(
                                  height: 17,
                                  width: 17,
                                  child: CircularProgressIndicator(color: MyColor.getPrimaryColor()),
                                )
                              : TextButton(
                                  onPressed: () {
                                    controller.resendForgetPassCode();
                                  },
                                  child: DefaultText(text: MyStrings.resend.tr, textColor: MyColor.getPrimaryColor()),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
