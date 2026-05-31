import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/shimmer/edit_profile_shimmer.dart';
import 'package:ovowpp/app/screens/edit_profile/widget/profile_form.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/controller/account/profile_controller.dart';
import 'package:ovowpp/data/repo/account/profile_repo.dart';

import '../../components/app-bar/custom_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    Get.put(ProfileRepo());
    final controller = Get.put(ProfileController(profileRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadProfileInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) => AnnotatedRegionWidget(
        child: Scaffold(
          backgroundColor: MyColor.white,
          appBar: CustomAppBar(elevation: 0, bgColor: MyColor.white, title: MyStrings.personalInformation.tr),
          body: controller.isLoading ? const EditProfileShimmer() : ProfileForm(),
        ),
      ),
    );
  }
}
