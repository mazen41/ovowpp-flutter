import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/screens/profile/widget/profile_top_section.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/controller/account/profile_controller.dart';
import 'package:ovowpp/data/repo/account/profile_repo.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/components/custom_loader/custom_loader.dart';

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<ProfileController>(
      builder: (controller) => Scaffold(
        appBar: CustomAppBar(title: MyStrings.profile.tr, bgColor: theme.appBarTheme.backgroundColor),
        body: controller.isLoading
            ? const CustomLoader()
            : const Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: Dimensions.space15,
                    right: Dimensions.space15,
                    top: Dimensions.space20,
                    bottom: Dimensions.space20,
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ProfileTopSection()]),
                ),
              ),
      ),
    );
  }
}
