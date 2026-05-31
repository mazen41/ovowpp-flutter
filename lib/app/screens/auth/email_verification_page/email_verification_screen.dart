import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_images.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/controller/auth/auth/email_verification_controler.dart';
import 'package:ovowpp/data/repo/auth/general_setting_repo.dart';
import 'package:ovowpp/data/repo/auth/sms_email_verification_repo.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/components/text/small_text.dart';
import 'package:ovowpp/app/components/will_pop_widget.dart';

import '../../../components/image/custom_svg_picture.dart';
import '../../../components/image_bg_widget.dart';
import '../../../components/otp_field_widget/otp_field_widget.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  @override
  void initState() {
    Get.put(SmsEmailVerificationRepo());
    Get.put(GeneralSettingRepo());
    final controller = Get.put(EmailVerificationController(repo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return WillPopWidget(
      nextRoute: RouteHelper.loginScreen,
      child: ImageBgWidget(
        isAppBar: true,
        customAppBar: CustomAppBar(
          fromAuth: true,
          isShowBackBtn: true,
          title: MyStrings.emailVerification.tr,
          bgColor: Colors.transparent,
        ),
        screen: GetBuilder<EmailVerificationController>(
          builder: (controller) => controller.isLoading
              ? Center(child: CircularProgressIndicator(color: MyColor.getPrimaryColor()))
              : Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage(MyImages.chatBackground))),
                  child: SingleChildScrollView(
                    padding: Dimensions.screenPadding,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: Dimensions.space30),
                          Container(
                            height: 100,
                            width: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: MyColor.getPrimaryColor().withValues(alpha: .075),
                              shape: BoxShape.circle,
                            ),
                            child: CustomSvgPicture(
                              image: MyImages.emailVerifyImage,
                              height: 50,
                              width: 50,
                              color: MyColor.getPrimaryColor(),
                            ),
                          ),
                          const SizedBox(height: Dimensions.space50),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .07),
                            child: SmallText(
                              text: MyStrings.viaEmailVerify.tr,
                              maxLine: 3,
                              textAlign: TextAlign.center,
                              textStyle: theme.textTheme.labelMedium?.copyWith(color: MyColor.getBodyTextColor()),
                            ),
                          ),
                          const SizedBox(height: 30),
                          OTPFieldWidget(
                            onChanged: (value) {
                              controller.currentText = value;
                              controller.update();
                            },
                          ),
                          const SizedBox(height: Dimensions.space30),
                          CustomElevatedBtn(
                            isLoading: controller.submitLoading,
                            borderColor: controller.currentText.length != 6
                                ? MyColor.lightTextFieldFillColor
                                : MyColor.lightButtonBorderBorder,
                            bgColor: controller.currentText.length != 6
                                ? MyColor.lightTextFieldFillColor
                                : MyColor.getPrimaryColor(),
                            textColor: controller.currentText.length != 6
                                ? MyColor.getBorderColor()
                                : MyColor.getHeadingTextColor(),
                            text: MyStrings.verify.tr,
                            onTap: () {
                              if (controller.currentText.length == 6) {
                                controller.verifyEmail(controller.currentText);
                              } else {
                                CustomSnackBar.error(errorList: [MyStrings.verificationCodeisRequired.tr]);
                              }
                            },
                          ),
                          const SizedBox(height: Dimensions.space30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                MyStrings.didNotReceiveCode.tr,
                                style: theme.textTheme.labelMedium?.copyWith(color: MyColor.getBodyTextColor()),
                              ),
                              const SizedBox(width: Dimensions.space10),
                              controller.resendLoading
                                  ? Container(
                                      margin: const EdgeInsets.only(left: 5, top: 5),
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(color: MyColor.getPrimaryColor()),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        controller.sendCodeAgain();
                                      },
                                      child: Text(
                                        MyStrings.resendCode.tr,
                                        style: theme.textTheme.labelMedium?.copyWith(
                                          color: MyColor.getPrimaryColor(),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
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
