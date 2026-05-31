import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/app/components/image_bg_widget.dart';
import 'package:ovowpp/app/components/text/default_text.dart';
import 'package:ovowpp/app/screens/auth/login/widget/or_line.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/data/controller/auth/auth/registration_controller.dart';
import 'package:ovowpp/data/repo/auth/general_setting_repo.dart';
import 'package:ovowpp/data/repo/auth/signup_repo.dart';
import 'package:ovowpp/app/components/buttons/my_text_button.dart';
import 'package:ovowpp/app/components/custom_no_data_found_class.dart';
import 'package:ovowpp/app/screens/auth/registration/widget/registration_form.dart';
import 'package:get/get.dart';
import '../../../../core/utils/util_exporter.dart';
import '../login/widget/social_login_section.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  void initState() {
    Get.put(GeneralSettingRepo());
    Get.put(RegistrationRepo());
    Get.put(RegistrationController(registrationRepo: Get.find(), generalSettingRepo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<RegistrationController>().initData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegistrationController>(
      builder: (controller) => ImageBgWidget(
        screen: controller.noInternet
            ? NoDataOrInternetScreen(
                isNoInternet: true,
                onChanged: (value) {
                  controller.changeInternet(value);
                },
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      spaceDown(Dimensions.space50.h),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: MyAssetImageWidget(
                              assetPath: MyImages.arrowBack,
                              isSvg: true,
                              height: Dimensions.space30.h,
                              width: Dimensions.space30.w,
                              boxFit: BoxFit.scaleDown,
                            ),
                          ),
                          DefaultText(
                            text: MyStrings.createYourAccount2.tr,
                            textStyle: MyTextStyle.heading20W700().copyWith(fontSize: 24.sp),
                          ),
                        ],
                      ),
                      spaceDown(Dimensions.space12.h),
                      DefaultText(
                        text: MyStrings.registrationDescription.tr,
                        textStyle: MyTextStyle.subHeading16W400(fontFamily: 'Nunito'),
                        textAlign: TextAlign.center,
                      ),
                      spaceDown(Dimensions.space24.h),

                      ///=========== SOCIAL LOGIN ===============
                      SocialLoginSection(),

                      spaceDown(Dimensions.space24.h),
                      OrLine(),
                      spaceDown(Dimensions.space24.h),
                      const RegistrationForm(),

                      SizedBox(height: Dimensions.space28.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            MyStrings.alreadyAccount.tr,
                            overflow: TextOverflow.ellipsis,
                            style: MyTextStyle.subHeading16W400().copyWith(color: MyColor.regularHederColor),
                          ),
                          const SizedBox(width: Dimensions.space5),
                          CustomTextButton(
                            onTap: () {
                              Get.back();
                            },
                            text: MyStrings.loginHere.tr,
                            style: MyTextStyle.subHeading16W400().copyWith(
                              decorationColor: MyColor.getPrimaryColor(),
                              decoration: TextDecoration.underline,
                              color: MyColor.getPrimaryColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      spaceDown(Dimensions.space20.h),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
