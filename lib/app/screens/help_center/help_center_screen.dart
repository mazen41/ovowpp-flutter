import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/card/my_custom_scaffold.dart';
import 'package:ovowpp/app/components/custom_loader/custom_loader.dart';
import 'package:ovowpp/app/components/text-field/label_text_field.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/controller/help_center/help_center_controller.dart';
import 'package:ovowpp/data/repo/help_center/help_center_repo.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> with SingleTickerProviderStateMixin {
  String comeFrom = '';

  @override
  void initState() {
    Get.put(HelpCenterRepo());
    Get.put(HelpCenterController(helpCenterRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HelpCenterController>(
      builder: (controller) => AnnotatedRegionWidget(
        top: true,
        child: MyCustomScaffold(
          transformValue: -8,
          centerTitle: true,
          appBarHeight: 130,
          pageTitle: MyStrings.helpCenter.tr,
          appBarBgColor: MyColor.getTransparentColor(),
          body: controller.isLoading
              ? const CustomLoader()
              // : controller.langList.isEmpty
              //     ? NoDataWidget()
              : Container(
                  decoration: BoxDecoration(),
                  child: Column(
                    children: [
                      LabelTextField(
                        isRequired: true,
                        // controller: controller.emailController,
                        labelText: MyStrings.yourName.tr,
                        hintText: MyStrings.enteYourName.tr,
                        onChanged: (value) {},
                        // focusNode: controller.emailFocusNode,
                        // nextFocus: controller.passwordFocusNode,
                        textInputType: TextInputType.emailAddress,
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
                      spaceDown(Dimensions.space15.h),
                      LabelTextField(
                        isRequired: true,
                        // controller: controller.emailController,
                        labelText: MyStrings.yourEmail.tr,
                        hintText: MyStrings.enterYourEmail.tr,
                        onChanged: (value) {},
                        // focusNode: controller.emailFocusNode,
                        // nextFocus: controller.passwordFocusNode,
                        textInputType: TextInputType.emailAddress,
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
                      spaceDown(Dimensions.space15.h),
                      LabelTextField(
                        isRequired: true,
                        // controller: controller.emailController,
                        labelText: MyStrings.subject.tr,
                        hintText: MyStrings.enterYourEmail.tr,
                        onChanged: (value) {},
                        // focusNode: controller.emailFocusNode,
                        // nextFocus: controller.passwordFocusNode,
                        textInputType: TextInputType.emailAddress,
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
                      spaceDown(Dimensions.space15.h),
                      LabelTextField(
                        isRequired: true,
                        // controller: controller.emailController,
                        labelText: MyStrings.subject.tr,
                        hintText: MyStrings.enterYourEmail.tr,
                        onChanged: (value) {},
                        maxLines: 5,
                        fillColor: MyColor.white,
                        // focusNode: controller.emailFocusNode,
                        // nextFocus: controller.passwordFocusNode,
                        textInputType: TextInputType.emailAddress,
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
                      spaceDown(Dimensions.space15.h),
                      spaceDown(Dimensions.space16.h),
                      CustomElevatedBtn(text: MyStrings.update.tr, onTap: () {}),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
