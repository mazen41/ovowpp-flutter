import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/buttons/my_text_button.dart';
import 'package:ovowpp/app/components/checkbox/single_custom_check_box.dart';
import 'package:ovowpp/app/components/text-field/label_text_field.dart';
import 'package:ovowpp/app/components/text/default_text.dart';
import 'package:ovowpp/app/screens/auth/login/widget/or_line.dart';
import 'package:ovowpp/app/screens/auth/login/widget/social_login_section.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/controller/auth/login_controller.dart';
import 'package:ovowpp/data/controller/auth/social_login_controller.dart';
import 'package:ovowpp/data/repo/auth/login_repo.dart';
import 'package:ovowpp/data/repo/auth/social_login_repo.dart';
import '../../../components/image/text_field_prefix_icon.dart';
import '../../splash/splash_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Get.put(LoginRepo());
    Get.put(LoginController(loginRepo: Get.find()));
    Get.put(SocialLoginRepo());
    Get.put(SocialLoginController(repo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<LoginController>().remember = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) => AnnotatedRegionWidget(
        statusBarColor: MyColor.transparent,
        child: Scaffold(
          backgroundColor: MyColor.loginScreenBackground,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SplashBgImage(),
                DefaultText(
                  text: MyStrings.welcomeBack.tr,
                  textStyle: MyTextStyle.heading20W700().copyWith(fontSize: 24.sp),
                ),

                spaceDown(Dimensions.space20.h),

                /// ========== SOCIAL LOGIN PART ========
                SocialLoginSection(),
                spaceDown(Dimensions.space10.h),

                Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OrLine(),
                        spaceDown(Dimensions.space25.h),

                        LabelTextField(
                          labelText: MyStrings.usernameOrEmail.tr,
                          hintText: MyStrings.enterYourEmailOrUserName,
                          controller: controller.emailController,
                          focusNode: controller.emailFocusNode,
                          prefixIcon: TextFieldPrefixIcon(imagePath: MyImages.emailFieldPrefixSVG),
                          onChanged: (value) {},
                          textInputType: TextInputType.text,
                          inputAction: TextInputAction.next,
                          radius: Dimensions.largeRadius,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return MyStrings.fieldErrorMsg.tr;
                            } else {
                              return null;
                            }
                          },
                        ),
                        spaceDown(Dimensions.space12),

                        LabelTextField(
                          labelText: MyStrings.password.tr,
                          hintText: MyStrings.enterYourPassword_,
                          controller: controller.passwordController,
                          focusNode: controller.passwordFocusNode,
                          onChanged: (value) {},
                          isPassword: true,
                          textInputType: TextInputType.text,
                          inputAction: TextInputAction.done,
                          radius: Dimensions.largeRadius,
                          prefixIcon: TextFieldPrefixIcon(imagePath: MyImages.passwordFieldPrefixSVG),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return MyStrings.fieldErrorMsg.tr;
                            } else {
                              return null;
                            }
                          },
                        ),
                        spaceDown(Dimensions.space18),

                        /// REMEMBER ME
                        Row(
                          children: [
                            Expanded(
                              child: SingleCustomCheckbox(
                                value: controller.remember,
                                onChanged: () {
                                  controller.changeRememberMe();
                                },
                                isRememberMeTextShow: true,
                              ),
                            ),

                            //   CustomTextButton(text: , onTap: (){})
                            // recognizer: TapGestureRecognizer()..onTap = termsOfServiceTap,
                            DefaultText(
                              isOnTap: true,
                              onTap: () {
                                Get.toNamed(RouteHelper.forgotPasswordScreen);
                              },
                              text: MyStrings.forgetPassword.tr,
                              textStyle: MyTextStyle.subHeading16W400().copyWith(
                                fontSize: 14.sp,
                                color: MyColor.forgotPasswordColor,
                              ),
                            ),
                          ],
                        ),

                        spaceDown(Dimensions.space26.h),
                        CustomElevatedBtn(
                          isLoading: controller.isSubmitLoading,
                          text: MyStrings.signIn.tr,
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              controller.loginUser();
                            }

                            //  Get.toNamed(RouteHelper.dashboardScreen);
                          },
                          height: 55,
                          radius: Dimensions.largeRadius,
                        ),
                        spaceDown(Dimensions.space24.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DefaultText(text: MyStrings.doNotHaveAccount.tr, textStyle: MyTextStyle.heading16W400()),
                            const SizedBox(width: Dimensions.space5),
                            CustomTextButton(
                              onTap: () {
                                Get.toNamed(RouteHelper.registrationScreen);
                              },
                              text: MyStrings.registerHere.tr,
                              style: MyTextStyle.heading16W400().copyWith(
                                decorationColor: MyColor.getPrimaryColor(),
                                decoration: TextDecoration.underline,
                                color: MyColor.getPrimaryColor(),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        spaceDown(Dimensions.space40.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
