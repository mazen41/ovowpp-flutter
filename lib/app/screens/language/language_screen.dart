import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/shimmer/language_shimmer.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/controller/my_language_controller/my_language_controller.dart';
import 'package:ovowpp/data/repo/auth/general_setting_repo.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/no_data.dart';
import 'package:ovowpp/app/screens/language/widget/language_card.dart';
import 'package:get/get.dart';

import '../../components/annotated_region/annotated_region_widget.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String comeFrom = '';

  @override
  void initState() {
    Get.put(GeneralSettingRepo());
    final controller = Get.put(MyLanguageController(repo: Get.find()));

    comeFrom = Get.arguments ?? '';

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadLanguage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegionWidget(
      child: GetBuilder<MyLanguageController>(
        builder: (controller) => Scaffold(
          backgroundColor: MyColor.white,
          appBar: CustomAppBar(bgColor: MyColor.white, isShowBackBtn: true, elevation: 0, title: MyStrings.language.tr),
          body: controller.isLoading
              ? const LanguageShimmer()
              : controller.langList.isEmpty
              ? NoDataWidget()
              : SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    addAutomaticKeepAlives: true,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemCount: controller.langList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: MediaQuery.of(context).size.width > 200 ? 2 : 1, crossAxisSpacing: 12, mainAxisSpacing: 12, mainAxisExtent: 150),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        controller.changeSelectedIndex(index);
                      },
                      child: LanguageCard(
                        index: index,
                        selectedIndex: controller.selectedIndex,
                        langeName: controller.langList[index].languageName,
                        isShowTopRight: true,
                        imagePath: "${controller.languageImagePath}/${controller.langList[index].imageUrl}",
                      ),
                    ),
                  ),
                ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              vertical: Dimensions.space15,
              horizontal: Dimensions.space15,
            ),
            child: CustomElevatedBtn(
              text: MyStrings.confirm.tr,
              isLoading: controller.isChangeLangLoading,
              onTap: () {
                controller.changeLanguage(controller.selectedIndex);
              },
            ),
          ),
        ),
      ),
    );
  }
}
