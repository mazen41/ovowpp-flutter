import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/no_data.dart';
import 'package:ovowpp/app/components/text/default_text.dart';
import 'package:ovowpp/data/controller/campaigns/campaigns_controller.dart';
import '../../../core/utils/text_style.dart';
import '../../../core/utils/util_exporter.dart';
import '../../components/annotated_region/annotated_region_widget.dart';
import '../../components/bottom-sheet/bottom_sheet_close_button.dart';
import '../../components/bottom-sheet/custom_bottom_sheet_plus.dart';
import '../../components/divider/line.dart';

class CampaignBottomSheet {
  static void selectTemplate(BuildContext context, CampaignsController controller) {
    CustomBottomSheetPlus(
      isDismissable: false,
      enableDrag: true,
      bgColor: Colors.grey,
      barrierColor: Colors.grey.withValues(alpha: 0.1),
      isNeedPadding: false,
      child: GetBuilder<CampaignsController>(
        builder: (controller) {
          return AnnotatedRegionWidget(
            child: Container(
              height: MediaQuery.of(context).size.height * .7,

              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              decoration: BoxDecoration(
                color: MyColor.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                boxShadow: MyUtils.getShadow(),
              ),
              child: Column(
                children: [
                  spaceDown(Dimensions.space10.h),

                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          DefaultText(
                            text: MyStrings.selectTemplate.tr,
                            textStyle: MyTextStyle.heading20W700().copyWith(
                              color: MyColor.regularHederColor,
                              fontSize: 16.sp,
                            ),
                          ),
                          BottomSheetCloseButton(),
                        ],
                      ),
                    ],
                  ),
                  spaceDown(Dimensions.space20.h),
                  if (controller.templatesList.isEmpty) ...[
                    Column(
                      children: [
                        spaceDown(Dimensions.space50),
                        NoDataWidget(text: MyStrings.noTemplateAvailable.tr),
                      ],
                    ),
                  ] else ...[
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.templatesList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Material(
                                child: InkWell(
                                  onTap: () {
                                    controller.selectedTemplateId = controller.templatesList[index].id.toString();
                                    Get.back();
                                    controller.selectTemplateController.text =
                                        controller.templatesList[index].name ?? "";
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            DefaultText(
                                              text: controller.templatesList[index].name ?? "",
                                              textStyle: MyTextStyle.heading20W700(fontFamily: 'Nunito').copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.sp,
                                                color: MyColor.fieldTitleTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              Line(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    ).show(context);
  }

  static void selectWhatsAppAccount(BuildContext context, CampaignsController controller) {
    CustomBottomSheetPlus(
      isDismissable: false,
      enableDrag: true,
      bgColor: Colors.grey,
      barrierColor: Colors.grey.withValues(alpha: 0.1),
      isNeedPadding: false,
      child: GetBuilder<CampaignsController>(
        builder: (controller) {
          return AnnotatedRegionWidget(
            child: Container(
              height: MediaQuery.of(context).size.height * .7,

              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              decoration: BoxDecoration(
                color: MyColor.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                boxShadow: MyUtils.getShadow(),
              ),
              child: Column(
                children: [
                  spaceDown(Dimensions.space10.h),

                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          DefaultText(
                            text: MyStrings.selectWhatsAppAccount.tr,
                            textStyle: MyTextStyle.heading20W700().copyWith(
                              color: MyColor.regularHederColor,
                              fontSize: 16.sp,
                            ),
                          ),
                          BottomSheetCloseButton(),
                        ],
                      ),
                    ],
                  ),
                  spaceDown(Dimensions.space20.h),
                  if (controller.whatsappAccountList.isEmpty) ...[
                    Column(
                      children: [
                        spaceDown(Dimensions.space50),
                        NoDataWidget(text: MyStrings.noAccountFound.tr),
                      ],
                    ),
                  ] else ...[
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.whatsappAccountList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Material(
                                child: InkWell(
                                  onTap: () {
                                    controller.selectedWhatsAppAccountId = controller.whatsappAccountList[index].id
                                        .toString();
                                    Get.back();
                                    controller.selectWhatsAppAccount.text =
                                        "${controller.whatsappAccountList[index].businessName} (${controller.whatsappAccountList[index].phoneNumber ?? ''})";
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            DefaultText(
                                              text:
                                                  "${controller.whatsappAccountList[index].businessName} (${controller.whatsappAccountList[index].phoneNumber ?? ''})",
                                              textStyle: MyTextStyle.heading20W700(fontFamily: 'Nunito').copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.sp,
                                                color: MyColor.fieldTitleTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              Line(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    ).show(context);
  }

  static void selectContactList(BuildContext context, CampaignsController controller) {
    CustomBottomSheetPlus(
      isDismissable: false,
      enableDrag: true,
      bgColor: Colors.grey,
      barrierColor: Colors.grey.withValues(alpha: 0.1),
      isNeedPadding: false,
      child: GetBuilder<CampaignsController>(
        builder: (controller) {
          return AnnotatedRegionWidget(
            child: Container(
              height: MediaQuery.of(context).size.height * .7,

              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              decoration: BoxDecoration(
                color: MyColor.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                boxShadow: MyUtils.getShadow(),
              ),
              child: Column(
                children: [
                  spaceDown(Dimensions.space10.h),

                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          DefaultText(
                            text: MyStrings.selectContactList.tr,
                            textStyle: MyTextStyle.heading20W700().copyWith(
                              color: MyColor.regularHederColor,
                              fontSize: 16.sp,
                            ),
                          ),
                          BottomSheetCloseButton(),
                        ],
                      ),
                    ],
                  ),
                  spaceDown(Dimensions.space20.h),

                  if (controller.contactList.isEmpty) ...[
                    Column(
                      children: [
                        spaceDown(Dimensions.space50),
                        DefaultText(
                          text: MyStrings.noContactAvailable.tr,
                          textStyle: MyTextStyle.heading20W700().copyWith(
                            color: MyColor.regularHederColor,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.contactList.length,
                        itemBuilder: (context, index) {
                          final item = controller.contactList[index];
                          final isSelected = controller.selectContactList.contains(item.id.toString());

                          return Column(
                            children: [
                              Material(
                                child: InkWell(
                                  onTap: () {
                                    controller.selectCountry(item.id.toString());

                                    controller.selectContactListController.text =
                                        controller.selectContactList.isNotEmpty
                                        ? "${MyStrings.selectedContactList.tr} (${controller.selectContactList.length})"
                                        : MyStrings.selectContactList.tr;
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: Dimensions.space12.h,
                                      horizontal: Dimensions.space12.w,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        DefaultText(
                                          text: item.name ?? '',
                                          textStyle: MyTextStyle.heading20W700(fontFamily: 'Nunito').copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.sp,
                                            color: MyColor.fieldTitleTextColor,
                                          ),
                                        ),
                                        Icon(
                                          isSelected ? Icons.check_circle : Icons.circle_outlined,
                                          color: isSelected ? MyColor.getPrimaryColor() : MyColor.fieldTitleTextColor,
                                          size: 18.sp,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Line(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                  if (controller.contactList.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: Dimensions.space16.h),
                      child: CustomElevatedBtn(
                        text: MyStrings.done.tr,
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    ).show(context);
  }

  static void selectContactTag(BuildContext context, CampaignsController controller) {
    CustomBottomSheetPlus(
      isDismissable: false,
      enableDrag: true,
      bgColor: Colors.grey,
      barrierColor: Colors.grey.withValues(alpha: 0.1),
      isNeedPadding: false,
      child: GetBuilder<CampaignsController>(
        builder: (controller) {
          return AnnotatedRegionWidget(
            child: Container(
              height: MediaQuery.of(context).size.height * .7,

              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              decoration: BoxDecoration(
                color: MyColor.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                boxShadow: MyUtils.getShadow(),
              ),
              child: Column(
                children: [
                  spaceDown(Dimensions.space10.h),

                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          DefaultText(
                            text: MyStrings.selectContactTag.tr,
                            textStyle: MyTextStyle.heading20W700().copyWith(
                              color: MyColor.regularHederColor,
                              fontSize: 16.sp,
                            ),
                          ),
                          BottomSheetCloseButton(),
                        ],
                      ),
                    ],
                  ),
                  spaceDown(Dimensions.space20.h),

                  if (controller.contactTag.isEmpty) ...[
                    DefaultText(
                      text: MyStrings.noContactTagAvailable.tr,
                      textStyle: MyTextStyle.heading20W700().copyWith(
                        color: MyColor.regularHederColor,
                        fontSize: 16.sp,
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.contactTag.length,
                        itemBuilder: (context, index) {
                          final item = controller.contactTag[index];
                          final isSelected = controller.selectContactTag.contains(item.id.toString());

                          return Column(
                            children: [
                              Material(
                                child: InkWell(
                                  onTap: () {
                                    controller.selectTags(item.id.toString());

                                    controller.selectContactTagController.text = controller.selectContactTag.isNotEmpty
                                        ? "${MyStrings.selectedContactTags.tr} (${controller.selectContactTag.length})"
                                        : MyStrings.selectContactTag.tr;
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: Dimensions.space12.h,
                                      horizontal: Dimensions.space12.w,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        DefaultText(
                                          text: item.name ?? '',
                                          textStyle: MyTextStyle.heading20W700(fontFamily: 'Nunito').copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.sp,
                                            color: MyColor.fieldTitleTextColor,
                                          ),
                                        ),
                                        Icon(
                                          isSelected ? Icons.check_circle : Icons.circle_outlined,
                                          color: isSelected ? MyColor.getPrimaryColor() : MyColor.fieldTitleTextColor,
                                          size: 18.sp,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Line(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],

                  if (controller.contactTag.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: Dimensions.space16),
                      child: CustomElevatedBtn(
                        text: MyStrings.done.tr,
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    ).show(context);
  }
}
