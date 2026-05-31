import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/components/buttons/category_button.dart';
import 'package:ovowpp/app/components/custom_loader/custom_loader.dart';
import 'package:ovowpp/app/components/shimmer/privacy_policy_shimmer.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/controller/privacy/privacy_controller.dart';
import 'package:ovowpp/data/repo/privacy_repo/privacy_repo.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  void initState() {
    Get.put(PrivacyRepo());
    final controller = Get.put(PrivacyController(repo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AnnotatedRegionWidget(
      child: Scaffold(
        backgroundColor: MyColor.white,
        appBar: CustomAppBar(title: MyStrings.privacyPolicy.tr, elevation: 0, bgColor: MyColor.white),
        body: GetBuilder<PrivacyController>(
          builder: (controller) => SizedBox(
            width: MediaQuery.of(context).size.width,
            child: controller.isLoading
                ? const PrivacyPolicyShimmer()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: Dimensions.space10, top: Dimensions.space15),
                        child: SizedBox(
                          height: 30,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(
                                controller.list.length,
                                (index) => Row(
                                  children: [
                                    CategoryButton(
                                      color: controller.selectedIndex == index
                                          ? MyColor.getPrimaryColor()
                                          : MyColor.getBorderColor().withValues(alpha: .2),
                                      horizontalPadding: 8,
                                      verticalPadding: 7,
                                      textColor: controller.selectedIndex == index ? MyColor.white : MyColor.black,
                                      text: controller.list[index].dataValues?.title ?? '',
                                      onTap: () {
                                        controller.changeIndex(index);
                                      },
                                    ),
                                    const SizedBox(width: Dimensions.space10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.space15),
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              width: double.infinity,
                              color: Colors.transparent,
                              child: HtmlWidget(
                                controller.selectedHtml,
                                textStyle: theme.textTheme.labelMedium?.copyWith(
                                  color: Theme.of(context).textTheme.titleLarge?.color,
                                ),
                                onLoadingBuilder: (context, element, loadingProgress) =>
                                    const Center(child: CustomLoader()),
                              ),
                            ),
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
