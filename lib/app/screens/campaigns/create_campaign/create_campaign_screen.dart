import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/text-field/label_text_field.dart';
import 'package:ovowpp/app/components/text/default_text.dart';
import 'package:ovowpp/app/screens/campaigns/campaign_bottom_sheet.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_images.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/data/controller/campaigns/campaigns_controller.dart';
import 'package:ovowpp/data/repo/campaign/campaign_repo.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../components/image/my_asset_widget.dart';
import '../../../components/shimmer/home_shimmer.dart';
import '../widgets/send_now_switch.dart';

class CreateCampaignScreen extends StatefulWidget {
  const CreateCampaignScreen({super.key});

  @override
  State<CreateCampaignScreen> createState() => _CreateCampaignScreenState();
}

class _CreateCampaignScreenState extends State<CreateCampaignScreen> {
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  @override
  void initState() {
    Get.put(CampaignRepo());
    final controller = Get.put(CampaignsController(repo: Get.find()));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.createCampaignData();
      controller.initDateTime();
      controller.clearCampaignForm();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CampaignsController>(
      builder: (controller) {
        return AnnotatedRegionWidget(
          statusBarColor: Colors.transparent,
          child: Scaffold(
            backgroundColor: MyColor.white,
            appBar: CustomAppBar(elevation: 0, bgColor: Colors.white, title: MyStrings.createCampaign.tr),
            body: controller.createCampaignLoading
                ? const HomeShimmer()
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.w),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabelTextField(
                              isRequired: true,
                              controller: controller.campaignNameController,
                              labelText: MyStrings.campaignName.tr,
                              hintText: MyStrings.enterCampaignName.tr,
                              onChanged: (String value) {},
                              fillColor: MyColor.campaignFieldFillColor,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return MyStrings.fieldErrorMsg.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                            spaceDown(Dimensions.space16.h),
                            LabelTextField(
                              isRequired: true,
                              onTap: () {
                                CampaignBottomSheet.selectContactList(context, controller);
                              },
                              readOnly: true,
                              controller: controller.selectContactListController,
                              labelText: MyStrings.selectContactList.tr,
                              hintText: MyStrings.selectContactList.tr,
                              onChanged: (String value) {},
                              fillColor: MyColor.campaignFieldFillColor,
                              suffixIcon: MyAssetImageWidget(
                                isSvg: true,
                                assetPath: MyImages.arrowDown,
                                height: 16.h,
                                width: 16.h,
                                boxFit: BoxFit.scaleDown,
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return MyStrings.fieldErrorMsg.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),

                            spaceDown(Dimensions.space16.h),

                            /// new select contact tags
                            LabelTextField(
                              //   isRequired: true,
                              onTap: () {
                                CampaignBottomSheet.selectContactTag(context, controller);
                              },
                              readOnly: true,
                              controller: controller.selectContactTagController,
                              labelText: MyStrings.selectContactTag.tr,
                              hintText: MyStrings.selectContactTag.tr,
                              onChanged: (String value) {},
                              fillColor: MyColor.campaignFieldFillColor,
                              suffixIcon: MyAssetImageWidget(
                                isSvg: true,
                                assetPath: MyImages.arrowDown,
                                height: 16.h,
                                width: 16.h,
                                boxFit: BoxFit.scaleDown,
                              ),
                              // validator: (value) {
                              //   if (value.isEmpty) {
                              //     return MyStrings.fieldErrorMsg.tr;
                              //   } else {
                              //     return null;
                              //   }
                              // },
                            ),
                            spaceDown(Dimensions.space16.h),
                            LabelTextField(
                              //isRequired: true,
                              onTap: () {
                                CampaignBottomSheet.selectWhatsAppAccount(context, controller);
                              },
                              readOnly: true,
                              controller: controller.selectWhatsAppAccount,
                              labelText: MyStrings.selectWhatsAppAccount.tr,
                              hintText: MyStrings.selectWhatsAppAccount.tr,
                              onChanged: (String value) {},
                              fillColor: MyColor.campaignFieldFillColor,
                              suffixIcon: MyAssetImageWidget(
                                isSvg: true,
                                assetPath: MyImages.arrowDown,
                                height: 16.h,
                                width: 16.h,
                                boxFit: BoxFit.scaleDown,
                              ),
                              // validator: (value) {
                              //   if (value.isEmpty) {
                              //     return MyStrings.fieldErrorMsg.tr;
                              //   } else {
                              //     return null;
                              //   }
                              // },
                            ),
                            spaceDown(Dimensions.space16.h),
                            LabelTextField(
                              isRequired: true,
                              onTap: () {
                                CampaignBottomSheet.selectTemplate(context, controller);
                              },
                              readOnly: true,
                              controller: controller.selectTemplateController,
                              labelText: MyStrings.selectTemplate.tr,
                              hintText: MyStrings.chooseAMessageTemplate.tr,
                              onChanged: (String value) {},
                              fillColor: MyColor.campaignFieldFillColor,
                              suffixIcon: MyAssetImageWidget(
                                isSvg: true,
                                assetPath: MyImages.arrowDown,
                                height: 16.h,
                                width: 16.h,
                                boxFit: BoxFit.scaleDown,
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return MyStrings.fieldErrorMsg.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),

                            spaceDown(Dimensions.space8.h),
                            DefaultText(
                              text: MyStrings.messagePreviewLength.tr,
                              textStyle: MyTextStyle.subHeading16W400().copyWith(fontSize: 12.sp),
                            ),
                            spaceDown(Dimensions.space16.h),
                            SwitchWithLeadText(
                              isBorder: true,
                              title: MyStrings.sendNow.tr,
                              description: MyStrings.campaignWillStartImmediately.tr,
                              controller: controller,
                              switchTap: () {
                                controller.changeCampaignSwitch();
                              },
                              value: controller.startCampaignSwitch,
                            ),
                            spaceDown(Dimensions.space14.h),
                            if (controller.startCampaignSwitch) ...[
                              SizedBox.shrink(),
                            ] else ...[
                              DefaultText(
                                text: MyStrings.scheduleCampaign,
                                textStyle: MyTextStyle.subHeading12W400().copyWith(
                                  fontSize: 16.sp,
                                  color: MyColor.ovoTextColor,
                                ),
                              ),
                              spaceDown(Dimensions.space16.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: LabelTextField(
                                      readOnly: true,
                                      controller: controller.dateController,
                                      labelText: MyStrings.date.tr,
                                      onChanged: () {},

                                      onTap: () {
                                        controller.selectDate(context);
                                      },

                                      fillColor: MyColor.campaignFieldFillColor,
                                      prefixIcon: MyAssetImageWidget(
                                        height: 16.h,
                                        width: 16.w,
                                        boxFit: BoxFit.scaleDown,
                                        isSvg: true,
                                        assetPath: MyImages.date,
                                      ),
                                    ),
                                  ),
                                  spaceSide(Dimensions.space12.w),
                                  Expanded(
                                    child: LabelTextField(
                                      readOnly: true,
                                      labelText: MyStrings.time.tr,
                                      onTap: () {
                                        controller.selectTime(context);
                                      },
                                      onChanged: (String value) {},

                                      controller: controller.timeController,
                                      fillColor: MyColor.campaignFieldFillColor,
                                      prefixIcon: MyAssetImageWidget(
                                        height: 16.h,
                                        width: 16.w,
                                        boxFit: BoxFit.scaleDown,
                                        isSvg: true,
                                        assetPath: MyImages.time,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            spaceDown(Dimensions.space16.h),
                            // CampaignSettings(
                            //   controller: controller,
                            // ),  spaceDown(Dimensions.space16.h),
                            CustomElevatedBtn(
                              isLoading: controller.isSaveCampaignLoader,
                              text: MyStrings.saveCampaign.tr,
                              onTap: () {
                                if (formKey.currentState?.validate() ?? false) {
                                  controller.saveCampaign();
                                }
                              },
                            ),
                            spaceDown(Dimensions.space12.h),
                            CustomElevatedBtn(
                              text: MyStrings.cancel,
                              onTap: () {
                                Get.back();
                              },
                              bgColor: MyColor.cancelElevatedBtnBgColor,
                            ),
                            spaceDown(Dimensions.space23.h),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
