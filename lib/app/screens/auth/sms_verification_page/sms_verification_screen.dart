import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/otp_field_widget/otp_field_widget.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/app/components/text/small_text.dart';
import 'package:ovowpp/app/components/will_pop_widget.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_images.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/controller/auth/auth/sms_verification_controler.dart';
import 'package:ovowpp/data/repo/auth/sms_email_verification_repo.dart';

import '../../../components/image/custom_svg_picture.dart';

class SmsVerificationScreen extends StatefulWidget {
  const SmsVerificationScreen({super.key});

  @override
  State<SmsVerificationScreen> createState() => _SmsVerificationScreenState();
}

class _SmsVerificationScreenState extends State<SmsVerificationScreen> {
  @override
  void initState() {
    Get.put(SmsEmailVerificationRepo());
    final controller = Get.put(SmsVerificationController(repo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.intData();
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
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: CustomAppBar(
          fromAuth: true,
          title: MyStrings.smsVerification.tr,
          isShowBackBtn: true,
          isShowActionBtn: false,
          bgColor: theme.appBarTheme.backgroundColor,
        ),
        body: GetBuilder<SmsVerificationController>(
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
                              text: MyStrings.smsVerificationMsg.tr,
                              maxLine: 3,
                              textAlign: TextAlign.center,
                              textStyle: theme.textTheme.labelMedium!.copyWith(color: MyColor.getBodyTextColor()),
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
                            text: MyStrings.verify.tr,
                            borderColor: controller.currentText.length != 6
                                ? MyColor.lightTextFieldFillColor
                                : MyColor.lightButtonBorderBorder,
                            bgColor: controller.currentText.length != 6
                                ? MyColor.lightTextFieldFillColor
                                : MyColor.getPrimaryColor(),
                            textColor: controller.currentText.length != 6
                                ? MyColor.getBorderColor()
                                : MyColor.getHeadingTextColor(),
                            isLoading: controller.submitLoading,
                            onTap: () {
                              if (controller.currentText.length == 6) {
                                controller.verifyYourSms(controller.currentText);
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
                                      margin: const EdgeInsets.all(5),
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
                                          decoration: TextDecoration.underline,
                                          color: MyColor.getPrimaryColor(),
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
