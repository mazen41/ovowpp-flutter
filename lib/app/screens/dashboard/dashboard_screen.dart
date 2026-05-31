import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/image_bg_widget.dart';
import 'package:ovowpp/app/components/shimmer/dashboard_shimmer.dart';
import 'package:ovowpp/app/screens/dashboard/widget/dashboard_master_cards.dart';
import 'package:ovowpp/app/screens/dashboard/widget/notification_widget.dart';
import 'package:ovowpp/app/screens/dashboard/widget/plan_status_create_new/plan_status_and_create_new.dart';
import 'package:ovowpp/app/screens/dashboard/widget/quick_action/quick_action.dart';
import 'package:ovowpp/app/screens/dashboard/widget/recent_activity/recent_campaign.dart';
import 'package:ovowpp/app/screens/dashboard/widget/user_profile_banner.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/app_permission.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/data/controller/dashboard/dashboard_controller.dart';
import 'package:ovowpp/data/repo/campaign/campaign_repo.dart';
import 'package:ovowpp/data/repo/dashboard/dashboard_repo.dart';
import '../../../data/controller/campaigns/campaigns_controller.dart';
import '../../components/permission_denied_component.dart';
import '../bottom_nav_section/home/widget/kyc_warning_section.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int navIndex)? onMenuTap;
  const DashboardScreen({super.key, this.onMenuTap});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    Get.put(DashboardRepo());
    Get.put(CampaignRepo());
    final campaignController = Get.put(CampaignsController(repo: Get.find()));
    final controller = Get.put(DashboardController(repo: Get.find()));
    campaignController.tabController = TabController(length: 4, vsync: this);
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      controller.refreshGeneralSettings();
      controller.loadData();
      campaignController.getCampaignData();
      printX("======== Campaign data list : ${campaignController.campaignData.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) => controller.isLoading
          ? DashboardShimmer()
          : MyUtils.checkPermission(AppPermission.viewDashboard) == false
          ? PermissionDeniedComponent()
          : ImageBgWidget(
              screen: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.isKycVerified == "1" ? SizedBox() : KYCWarningSection(controller: controller),
                    spaceDown(Dimensions.space40.h),
                    // USER PROFILE BANNER AND NOTIFICATION
                    UserProfileBanner(
                      title: "${controller.user?.firstname ?? ''} ${controller.user?.lastname ?? ''}",
                      subTitle: MyStrings.businessOverView,
                      trailingWidget: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (controller.user?.parentId == "0")
                            _DashboardTopAction(
                              icon: Icons.card_membership_outlined,
                              onTap: () => Get.toNamed(RouteHelper.subscriptionScreen),
                            ),
                          if (controller.user?.parentId == "0") SizedBox(width: Dimensions.space8.w),
                          NotificationIcon(
                            isShowToggle: true,
                            onTap: () {
                              Get.toNamed(RouteHelper.notificationScreen);
                            },
                          ),
                        ],
                      ),
                    ),
                    spaceDown(Dimensions.space12.h),

                    DashboardMasterCards(onMenuTap: widget.onMenuTap, controller: controller),
                    spaceDown(Dimensions.space16.h),
                    // PLAN STATUS AND CREATE NEW
                    PlanStatusAndCreateNew(
                      parentId: controller.user?.parentId.toString() ?? "0",
                      isShowStatus: controller.dashboardData?.subscription?.plan?.name != null ? true : false,
                      planStatusTap: () {
                        Get.toNamed(RouteHelper.subscriptionScreen);
                      },
                      createNewTap: () {
                        Get.toNamed(RouteHelper.createCampaignScreen);
                      },
                    ),
                    spaceDown(Dimensions.space20.h),

                    // QUICK ACTION
                    QuickAction(),
                    spaceDown(Dimensions.space21),

                    // RECENT ACTIVITY
                    if (MyUtils.checkPermission(AppPermission.viewCampaign))
                      RecentCampaign(onMenuTap: widget.onMenuTap),

                    spaceDown(14),
                  ],
                ),
              ),
            ),
    );
  }
}

class _DashboardTopAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardTopAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColor.white,
      borderRadius: BorderRadius.circular(Dimensions.space50.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimensions.space50.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(Dimensions.space10.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: MyColor.notificationBorder),
          ),
          child: Icon(icon, size: 25.sp, color: MyColor.ovoTextColor.withValues(alpha: .7)),
        ),
      ),
    );
  }
}
