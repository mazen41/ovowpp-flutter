import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/screens/onboard/widgets/onboard_screen_item.dart';
import 'package:ovowpp/app/screens/onboard/widgets/onboard_transparent_image.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/controller/onboard/onboard_controller.dart';
import 'package:get/get.dart';

import '../../../data/services/shared_pref_service.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  @override
  void initState() {
    Get.put(OnboardController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardController>(
      builder: (controller) {
        return AnnotatedRegionWidget(
          statusBarColor: MyColor.transparent,
          child: Scaffold(
            backgroundColor: MyColor.splashScreenBackground,
            body: Column(
              children: [
                OnboardTransparentImageAndSkip(
                  isShowSkip: controller.currentIndex < controller.onBoardDataList.length - 1,
                  skipTap: () async {
                    await SharedPreferenceService.setOnBoardStatus(false).whenComplete(() {
                      Get.toNamed(RouteHelper.loginScreen);
                    });
                  },
                ),

                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    itemCount: controller.onBoardDataList.length,
                    onPageChanged: (i) {
                      controller.setCurrentIndex(i);
                    },
                    itemBuilder: (context, index) {
                      final item = controller.onBoardDataList[index];
                      return OnboardScreenItem(item: item, index: index);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(controller.onBoardDataList.length, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: Dimensions.space3),
                      height: Dimensions.space12.h,
                      width: Dimensions.space12.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: index == controller.currentIndex ? Colors.green : Colors.grey,
                          width: 1.7,
                        ),
                      ),
                    );
                  }),
                ),
                spaceDown(Dimensions.space35.h),
                CustomElevatedBtn(
                  paddingLeft: Dimensions.space16,
                  paddingRight: Dimensions.space16,
                  text: controller.currentIndex != controller.onBoardDataList.length - 1
                      ? MyStrings.next
                      : MyStrings.continueText,
                  onTap: () async {
                    if (controller.currentIndex < controller.onBoardDataList.length - 1) {
                      controller.pageController?.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      await SharedPreferenceService.setOnBoardStatus(false).whenComplete(() {
                        Get.toNamed(RouteHelper.loginScreen);
                      });
                    }
                  },
                  isArrowRight: true,
                ),
                spaceDown(Dimensions.space35.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
