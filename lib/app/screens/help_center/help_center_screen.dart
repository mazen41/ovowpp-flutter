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
import 'package:ovowpp/core/translations/strings_enum.dart';
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
          pageTitle: Strings.helpCenter.tr,
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
                        labelText: Strings.yourName.tr,
                        hintText: Strings.enteYourName.tr,
                        onChanged: (value) {},
                        // focusNode: controller.emailFocusNode,
                        // nextFocus: controller.passwordFocusNode,
                        textInputType: TextInputType.emailAddress,
                        inputAction: TextInputAction.next,
                        radius: Dimensions.largeRadius,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Strings.fieldErrorMsg.tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                      spaceDown(Dimensions.space15.h),
                      LabelTextField(
                        isRequired: true,
                        // controller: controller.emailController,
                        labelText: Strings.yourEmail.tr,
                        hintText: Strings.enterYourEmail.tr,
                        onChanged: (value) {},
                        // focusNode: controller.emailFocusNode,
                        // nextFocus: controller.passwordFocusNode,
                        textInputType: TextInputType.emailAddress,
                        inputAction: TextInputAction.next,
                        radius: Dimensions.largeRadius,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Strings.fieldErrorMsg.tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                      spaceDown(Dimensions.space15.h),
                      LabelTextField(
                        isRequired: true,
                        // controller: controller.emailController,
                        labelText: Strings.subject.tr,
                        hintText: Strings.enterYourEmail.tr,
                        onChanged: (value) {},
                        // focusNode: controller.emailFocusNode,
                        // nextFocus: controller.passwordFocusNode,
                        textInputType: TextInputType.emailAddress,
                        inputAction: TextInputAction.next,
                        radius: Dimensions.largeRadius,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Strings.fieldErrorMsg.tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                      spaceDown(Dimensions.space15.h),
                      LabelTextField(
                        isRequired: true,
                        // controller: controller.emailController,
                        labelText: Strings.subject.tr,
                        hintText: Strings.enterYourEmail.tr,
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
                            return Strings.fieldErrorMsg.tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                      spaceDown(Dimensions.space15.h),
                      spaceDown(Dimensions.space16.h),
                      CustomElevatedBtn(text: Strings.update.tr, onTap: () {}),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
