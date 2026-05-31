import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/avatar/alphabet_avatar.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/card/my_custom_scaffold.dart';
import 'package:ovowpp/app/components/divider/custom_divider.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/app/components/image/my_network_image_widget.dart';
import 'package:ovowpp/app/components/shimmer/customer_details_shimmer.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/app/components/text-field/custom_text_field.dart';
import 'package:ovowpp/app/screens/customer_details/widgets/details.dart';
import 'package:ovowpp/app/screens/customer_details/widgets/notes_card.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_images.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/data/controller/customer_details/customer_details_controller.dart';
import 'package:ovowpp/data/repo/customer_detais/customer_details_repo.dart';

class CustomerDetailsScreen extends StatefulWidget {
  const CustomerDetailsScreen({super.key});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> with SingleTickerProviderStateMixin {
  String comeFrom = '';

  @override
  void initState() {
    Get.put(CustomerDetailsRepo());
    final controller = Get.put(CustomerDetailsController(repo: Get.find()));

    super.initState();
    controller.tabController = TabController(length: 2, vsync: this);
    controller.id = Get.arguments[0];
    controller.tabController.addListener(() {
      if (controller.tabController.indexIsChanging) {
        controller.changeIndicator();
      } else if (controller.tabController.index != controller.tabController.previousIndex) {
        controller.changeIndicator();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.customerDetailsData();
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<CustomerDetailsController>(
      builder: (controller) => AnnotatedRegionWidget(
        top: true,
        child: MyCustomScaffold(
          transformValue: -8,
          centerTitle: true,
          pageTitle: MyStrings.customerDetails.tr,
          appBarBgColor: MyColor.getTransparentColor(),
          body: controller.isLoading
              ? const CustomerDetailsShimmer()
              : Container(
                  decoration: BoxDecoration(),
                  child: Column(
                    children: [
                      spaceDown(Dimensions.space25.h),
                      Row(
                        children: [
                          controller.contact?.image != null
                              ? Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(shape: BoxShape.circle),
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: MyNetworkImageWidget(
                                      height: 40,
                                      width: 40,
                                      imageUrl:
                                          "${UrlContainer.domainUrl}/${controller.imagePath}/${controller.contact?.image}",
                                      boxFit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : AlphabetAvatar(
                                  firstname: controller.contact?.firstname ?? "",
                                  lastName: controller.contact?.lastname ?? '',
                                ),
                          spaceSide(Dimensions.space16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${controller.contact?.firstname ?? ""} ${controller.contact?.lastname ?? ""}",
                                      style: theme.textTheme.headlineSmall,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(
                                          RouteHelper.customerAccountScreen,
                                          arguments: [controller.imagePath, controller.contact, true],
                                        )?.then((_) {
                                          controller.customerDetailsData(forceLoad: false);
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          MyAssetImageWidget(
                                            assetPath: MyImages.edit,
                                            isSvg: true,
                                            height: Dimensions.space16.h,
                                            width: Dimensions.space16.h,
                                          ),
                                          spaceSide(Dimensions.space4),
                                          Text(MyStrings.edit.tr, style: theme.textTheme.titleSmall),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                spaceDown(Dimensions.space4.h),
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: controller.contact?.mobile ?? "")).then((_) {
                                      CustomSnackBar.success(successList: [MyStrings.contactCopiedToClipBioard.tr]);
                                    });
                                  },
                                  child: Text(
                                    "+${controller.contact?.mobileCode}${controller.contact?.mobile ?? ""}",
                                    style: theme.textTheme.labelMedium?.copyWith(color: MyColor.getBodyTextColor()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      spaceDown(Dimensions.space25.h),
                      DefaultTabController(
                        length: 2,
                        child: TabBar(
                          controller: controller.tabController,
                          onTap: (value) {
                            controller.changeIndicator();
                          },
                          labelPadding: EdgeInsets.all(0),
                          indicatorColor: MyColor.getTransparentColor(),
                          dividerColor: MyColor.transparent,
                          tabs: [
                            Tab(
                              child: Container(
                                margin: EdgeInsets.only(right: Dimensions.space4.w),
                                decoration: BoxDecoration(
                                  color: controller.currentIndex == 0 ? MyColor.getPrimaryColor() : MyColor.white,
                                  borderRadius: BorderRadius.circular(Dimensions.space8.w),
                                ),
                                child: Center(
                                  child: Text(
                                    MyStrings.details.tr,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: controller.currentIndex == 0
                                          ? MyColor.getHeadingTextColor()
                                          : MyColor.getBodyTextColor(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                margin: EdgeInsets.only(left: Dimensions.space4.w),
                                decoration: BoxDecoration(
                                  color: controller.currentIndex == 1 ? MyColor.getPrimaryColor() : MyColor.white,
                                  borderRadius: BorderRadius.circular(Dimensions.space8.w),
                                ),
                                child: Center(
                                  child: Text(
                                    MyStrings.notes.tr,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: controller.currentIndex == 1
                                          ? MyColor.getHeadingTextColor()
                                          : MyColor.getBodyTextColor(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: controller.tabController,
                          children: [
                            Details(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                spaceDown(Dimensions.space24.h),
                                CustomTextField(
                                  labelText: MyStrings.addNote.tr,
                                  needOutlineBorder: true,
                                  fillColor: MyColor.getCardBackgroundColor(),
                                  hintText: MyStrings.writeDescription.tr,
                                  isPassword: false,
                                  controller: controller.noteController,
                                  maxLines: 4,
                                  isShowSuffixIcon: false,
                                  onSuffixTap: () {},
                                  onChanged: (value) {},
                                ),
                                spaceDown(Dimensions.space25.h),
                                CustomElevatedBtn(
                                  isLoading: controller.noteLoading,
                                  text: MyStrings.add.tr,
                                  onTap: () {
                                    controller.addNote();
                                  },
                                ),
                                CustomDivider(),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: controller.notes.length,
                                    itemBuilder: (context, index) => NotesCard(index: index),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
