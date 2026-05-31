import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/components/custom_loader/custom_loader.dart';
import 'package:ovowpp/app/screens/auth/two_factor/two_factor_setup_screen/sections/two_factor_disable_section.dart';
import 'package:ovowpp/app/screens/auth/two_factor/two_factor_setup_screen/sections/two_factor_enable_section.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import '../../../../../core/utils/my_strings.dart';
import '../../../../../core/utils/util_exporter.dart' show SizeExtension;
import '../../../../../data/controller/account/profile_controller.dart';
import '../../../../../data/controller/auth/two_factor_controller.dart';
import '../../../../../data/repo/account/profile_repo.dart';
import '../../../../../data/repo/auth/two_factor_repo.dart';

class TwoFactorSetupScreen extends StatefulWidget {
  const TwoFactorSetupScreen({super.key});

  @override
  State<TwoFactorSetupScreen> createState() => _TwoFactorSetupScreenState();
}

class _TwoFactorSetupScreenState extends State<TwoFactorSetupScreen> {
  @override
  void initState() {
    Get.put(TwoFactorRepo());
    final controller = Get.put(TwoFactorController(repo: Get.find()));
    Get.put(ProfileRepo());
    final pcontroller = Get.put(ProfileController(profileRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      pcontroller.loadProfileInfo();
      controller.get2FaCode();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TwoFactorController>(
      builder: (controller) {
        return GetBuilder<ProfileController>(
          builder: (profileController) {
            return AnnotatedRegionWidget(
              child: Scaffold(
                appBar: CustomAppBar(elevation: 0, title: MyStrings.twoFactorAuth.tr, fontSize: 16.sp),
                backgroundColor: MyColor.white,

                body: controller.isLoading || profileController.isLoading
                    ? const CustomLoader()
                    : profileController.user2faIsOne == false
                    ? const TwoFactorEnableSection()
                    : const TwoFactorDisableSection(),
              ),
            );
          },
        );
      },
    );
  }
}
