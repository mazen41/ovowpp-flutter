import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/components/avatar/alphabet_avatar.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/app/components/text/default_text.dart';
import 'package:ovowpp/app/screens/menu/widgets/account_and_app_setting_item.dart';
import 'package:ovowpp/app/screens/menu/widgets/menu_cards.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/app_permission.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_images.dart';
import 'package:ovowpp/core/translations/strings_enum.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/data/controller/menu/my_menu_controller.dart';
import 'package:ovowpp/data/repo/menu_repo/menu_repo.dart';
import '../../components/alert-dialog/custom_alert_dialog.dart';
import '../../components/alert-dialog/delete_dialogue.dart';
import '../../components/image/my_network_image_widget.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with SingleTickerProviderStateMixin {
  String comeFrom = '';

  @override
  void initState() {
    Get.put(MenuRepo());
    final controller = Get.put(MyMenuController(menuRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyMenuController>(
      builder: (controller) {
        return AnnotatedRegionWidget(
          statusBarColor: MyColor.white,
          top: true,
          child: Scaffold(
            backgroundColor: MyColor.white,
            appBar: CustomAppBar(
              isShowBackBtn: false,
              elevation: 0,
              bgColor: Colors.white,
              title: Strings.accountSetting.tr,
            ),

            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// =========== NRW DESIGN ============
                    Container(
                      padding: EdgeInsets.all(Dimensions.space16.sp),
                      decoration: BoxDecoration(
                        color: MyColor.searchFieldColor,
                        border: Border.all(color: MyColor.dashboardCardBorder),
                        borderRadius: BorderRadius.circular(Dimensions.space16.r),
                      ),
                      child: Row(
                        children: [
                          controller.image != ""
                              ? FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: MyNetworkImageWidget(
                                    isProfile: true,
                                    boxFit: BoxFit.fill,
                                    height: 70,
                                    width: 70,
                                    radius: 100,
                                    imageUrl: controller.fullProfileUrl ?? '',
                                  ),
                                )
                              : AlphabetAvatar(
                                  firstname: controller.firstName ?? '',
                                  lastName: controller.lastName ?? '',
                                ),
                          // MyAssetImageWidget(assetPath: MyImages.profile, height: 56.h, width: 56.w),
                          spaceSide(Dimensions.space12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DefaultText(
                                  text: "${controller.firstName ?? ''} ${controller.lastName ?? ''}",
                                  textStyle: MyTextStyle.heading20W700().copyWith(color: MyColor.ovoTextColor),
                                  maxLines: 1,
                                ),
                                DefaultText(text: "@${controller.username}", textStyle: MyTextStyle.subHeading12W400()),
                              ],
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              Get.toNamed(RouteHelper.profileScreen);
                            },
                            child: MyAssetImageWidget(
                              isSvg: true,
                              assetPath: MyImages.editIcon,
                              height: 20.h,
                              width: 20.w,
                            ),
                          ),
                        ],
                      ),
                    ),
                    spaceDown(Dimensions.space12.h),

                    DefaultText(
                      text: Strings.accountAndAppSetting.tr,
                      textStyle: MyTextStyle.subHeading12W400().copyWith(fontSize: 16.sp, color: MyColor.ovoTextColor),
                    ),
                    spaceDown(Dimensions.space6.h),
                    DefaultText(
                      text: Strings.personalizeYourExperience.tr,
                      textStyle: MyTextStyle.subHeading12W400().copyWith(fontSize: 14.sp),
                    ),
                    spaceDown(Dimensions.space10.h),
                    Material(
                      borderRadius: BorderRadius.circular(Dimensions.space10.r),
                      color: MyColor.searchFieldColor,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.space12.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.space10.r),
                          border: Border.all(color: MyColor.dashboardCardBorder),
                        ),
                        child: Column(
                          children: [
                            AccountAndAppSettingItem(
                              title: Strings.profileSetting.tr,
                              subTitle: Strings.editYourProfileInfo.tr,
                              iconPath: MyImages.profileIcon,
                              onTap: () {
                                Get.toNamed(RouteHelper.profileScreen);
                              },
                            ),

                            AccountAndAppSettingItem(
                              title: Strings.twoFactorAuth.tr,
                              subTitle: Strings.twoFactorAuth.tr,
                              iconPath: MyImages.twoFactorAuth,
                              onTap: () {
                                Get.toNamed(RouteHelper.twoFactorSetupScreen);
                              },
                            ),

                            AccountAndAppSettingItem(
                              title: Strings.changePassword.tr,
                              subTitle: Strings.changePassword.tr,
                              iconPath: MyImages.changePassword,
                              onTap: () {
                                Get.toNamed(RouteHelper.changePasswordScreen);
                              },
                            ),

                            AccountAndAppSettingItem(
                              title: Strings.language.tr,
                              subTitle: controller.selectedLanguage?.tr,
                              iconPath: MyImages.languageIcon,
                              onTap: () {
                                Get.toNamed(RouteHelper.languageScreen);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    spaceDown(Dimensions.space20.h),
                    DefaultText(
                      text: Strings.management.tr,
                      textStyle: MyTextStyle.subHeading12W400().copyWith(fontSize: 16.sp, color: MyColor.ovoTextColor),
                    ),
                    spaceDown(Dimensions.space6.h),
                    DefaultText(
                      text: Strings.managementAccount.tr,
                      textStyle: MyTextStyle.subHeading12W400().copyWith(fontSize: 14.sp),
                    ),
                    spaceDown(Dimensions.space8.h),
                    Material(
                      borderRadius: BorderRadius.circular(Dimensions.space10.r),
                      color: MyColor.searchFieldColor,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.space12.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.space10.r),
                          border: Border.all(color: MyColor.dashboardCardBorder),
                        ),
                        child: Column(
                          children: [
                            spaceDown(Dimensions.space8.h),

                            spaceDown(Dimensions.space8.h),
                            AccountAndAppSettingItem(
                              title: Strings.manageAgent.tr,
                              subTitle: Strings.manageAgent.tr,
                              iconPath: MyImages.group,
                              onTap: () {
                                if (MyUtils.checkPermission(AppPermission.viewContactList)) {
                                  Get.toNamed(RouteHelper.manageAgentScreen);
                                } else {
                                  CustomSnackBar.error(errorList: [Strings.permissionDenyMessage.tr]);
                                }
                              },
                            ),

                            spaceDown(Dimensions.space8.h),

                            AccountAndAppSettingItem(
                              title: Strings.manageContact.tr,
                              subTitle: Strings.manageContact.tr,
                              iconPath: MyImages.contactBook,
                              onTap: () {
                                Get.toNamed(RouteHelper.manageContactScreen);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (!controller.isAgent) ...[
                      spaceDown(Dimensions.space24.h),
                      DefaultText(
                        text: Strings.finance.tr,
                        textStyle: MyTextStyle.subHeading12W400().copyWith(
                          fontSize: 16.sp,
                          color: MyColor.ovoTextColor,
                        ),
                      ),
                      spaceDown(Dimensions.space6.h),
                      DefaultText(
                        text: Strings.personalizeYourExperience.tr,
                        textStyle: MyTextStyle.subHeading12W400().copyWith(fontSize: 14.sp),
                      ),
                      spaceDown(Dimensions.space10.h),
                      Material(
                        borderRadius: BorderRadius.circular(Dimensions.space10.r),
                        color: MyColor.searchFieldColor,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.space12.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.space10.r),
                            border: Border.all(color: MyColor.dashboardCardBorder),
                          ),
                          child: Column(
                            children: [
                              AccountAndAppSettingItem(
                                title: Strings.deposit.tr,
                                subTitle: Strings.deposit.tr,
                                iconPath: MyImages.deposit,
                                onTap: () {
                                  Get.toNamed(RouteHelper.depositsHistoryScreen);
                                },
                              ),

                              AccountAndAppSettingItem(
                                title: Strings.withdraw.tr,
                                subTitle: Strings.withdraw.tr,
                                iconPath: MyImages.upload,
                                onTap: () {
                                  Get.toNamed(RouteHelper.withdrawScreen);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    spaceDown(Dimensions.space24.h),
                    DefaultText(
                      text: Strings.supportAndHelp.tr,
                      textStyle: MyTextStyle.subHeading12W400().copyWith(fontSize: 16.sp, color: MyColor.ovoTextColor),
                    ),
                    spaceDown(Dimensions.space6.h),
                    DefaultText(
                      text: Strings.findHelpOrReadAppPolicy.tr,
                      textStyle: MyTextStyle.subHeading12W400().copyWith(fontSize: 14.sp),
                    ),
                    spaceDown(Dimensions.space10.h),
                    Material(
                      borderRadius: BorderRadius.circular(Dimensions.space10.r),
                      color: MyColor.searchFieldColor,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.space12.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.space10.r),
                          border: Border.all(color: MyColor.dashboardCardBorder),
                        ),
                        child: Column(
                          children: [
                            AccountAndAppSettingItem(
                              title: Strings.helpCenter.tr,
                              subTitle: Strings.browseFAQAndGuides.tr,
                              iconPath: MyImages.messageIcon,
                              onTap: () {
                                Get.toNamed(RouteHelper.faqScreen);
                              },
                            ),

                            spaceDown(Dimensions.space8.h),
                            AccountAndAppSettingItem(
                              title: Strings.supportTicket.tr,
                              subTitle: Strings.supportTicket.tr,
                              iconPath: MyImages.help,
                              onTap: () {
                                Get.toNamed(RouteHelper.allTicketScreen);
                              },
                            ),

                            spaceDown(Dimensions.space8.h),

                            AccountAndAppSettingItem(
                              title: Strings.privacyPolicy.tr,
                              subTitle: Strings.howWeProtectYourData.tr,
                              iconPath: MyImages.protected,
                              onTap: () {
                                Get.toNamed(RouteHelper.privacyScreen);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    controller.logoutLoading
                        ? SizedBox.shrink()
                        : MenuCards(
                            onTap: () {
                              CustomAlertDialog(
                                verticalPadding: 0,
                                isHorizontalPadding: true,
                                child: GetBuilder<MyMenuController>(
                                  builder: (controller) {
                                    return DeleteDialogue(
                                      warningText: Strings.areYouSureYouWantToSignOut.tr,
                                      isLoading: controller.logoutLoading,
                                      onTap: () {
                                        controller.logout();
                                      },
                                    );
                                  },
                                ),
                              ).customAlertDialog(context);
                            },
                            prefixIcon: MyImages.signOut,
                            isSignOut: true,
                            title: Strings.signOut.tr,
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
