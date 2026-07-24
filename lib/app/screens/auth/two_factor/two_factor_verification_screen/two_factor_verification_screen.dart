import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/image/custom_svg_picture.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_images.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/controller/auth/two_factor_controller.dart';
import 'package:ovowpp/data/repo/auth/two_factor_repo.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/components/text/small_text.dart';
import 'package:ovowpp/app/components/will_pop_widget.dart';

class TwoFactorVerificationScreen extends StatefulWidget {
  const TwoFactorVerificationScreen({super.key});

  @override
  State<TwoFactorVerificationScreen> createState() => _TwoFactorVerificationScreenState();
}

class _TwoFactorVerificationScreenState extends State<TwoFactorVerificationScreen> {
  @override
  void initState() {
    Get.put(TwoFactorRepo());
    Get.put(TwoFactorController(repo: Get.find()));
    super.initState();
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
        appBar: CustomAppBar(title: MyStrings.twoFactorAuth.tr, fromAuth: true),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage(MyImages.chatBackground))),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15, vertical: Dimensions.space20),
            child: GetBuilder<TwoFactorController>(
              builder: (controller) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: Dimensions.space20),
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
                        text: MyStrings.twoFactorMsg.tr,
                        maxLine: 3,
                        textAlign: TextAlign.center,
                        textStyle: theme.textTheme.labelMedium!.copyWith(color: MyColor.getBodyTextColor()),
                      ),
                    ),
                    const SizedBox(height: Dimensions.space50),
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
                          fillColor: MyColor.getTransparentColor(),
                          filledFillColor: MyColor.getTransparentColor(),
                          filledBorderColor: MyColor.getPrimaryColor(),
                          focusedFillColor: MyColor.getTransparentColor(),
                          focusedBorderColor: MyColor.getPrimaryColor(),
                          textStyle: theme.textTheme.labelMedium?.copyWith(color: MyColor.getBodyTextColor()),
                          obscuringCharacter: '*',
                          cursorColor: MyColor.white,
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
                    const SizedBox(height: Dimensions.space30),
                    CustomElevatedBtn(
                      isLoading: controller.submitLoading,
                      onTap: () {
                        controller.verify2FACode(controller.currentText);
                      },
                      text: MyStrings.verify.tr,
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
