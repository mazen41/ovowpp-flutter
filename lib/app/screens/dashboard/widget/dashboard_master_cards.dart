import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/screens/dashboard/widget/dashboard_master_card_item.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';

import '../../../../core/helper/string_format_helper.dart';
import '../../../../core/utils/app_permission.dart';
import '../../../../data/controller/dashboard/dashboard_controller.dart';
import '../../../../data/services/shared_pref_service.dart';

class DashboardMasterCards extends StatelessWidget {
  final DashboardController controller;
  final Function(int navIndex)? onMenuTap;
  const DashboardMasterCards({super.key, required this.controller, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              if (!controller.checkAgent) ...[
                if (MyUtils.checkPermission(AppPermission.viewWallet)) ...[
                  Expanded(
                    child: DashBoardMasterCardItem(
                      onTap: () {
                        Get.toNamed(RouteHelper.depositsHistoryScreen);
                      },

                      image: MyImages.walletBalance,
                      amount:
                          "${AppConverter.formatNumber(controller.dashboardData?.walletBalance ?? "")} ${SharedPreferenceService.getCurrencyText()}",
                      type: MyStrings.walletBalance.tr,
                      bgColor: MyColor.getPrimaryColor(),
                      gradientColor: MyColor.getPrimaryColor().withValues(alpha: 0.0),
                    ),
                  ),
                ],
              ],
              !controller.checkAgent ? spaceSide(Dimensions.space16.w) : SizedBox.shrink(),
              if (MyUtils.checkPermission(AppPermission.viewWallet))
                if (MyUtils.checkPermission(AppPermission.viewInbox)) ...[
                  Expanded(
                    child: DashBoardMasterCardItem(
                      onTap: onMenuTap != null ? () => onMenuTap!(1) : null,
                      image: MyImages.message,
                      amount:
                          "${controller.dashboardData?.sentMessage ?? ""}/${controller.dashboardData?.totalMessage ?? ""}",
                      type: MyStrings.messagesSent.tr,
                      bgColor: MyColor.messageSentBgColor,
                      gradientColor: MyColor.messageSentBgColor.withAlpha(1),
                    ),
                  ),
                ],
            ],
          ),
        ),
        if ((MyUtils.checkPermission(AppPermission.viewContact) ||
            (MyUtils.checkPermission(AppPermission.viewCampaign))))
          spaceDown(Dimensions.space16.w),

        IntrinsicHeight(
          child: Row(
            children: [
              if (MyUtils.checkPermission(AppPermission.viewContact)) ...[
                Expanded(
                  child: DashBoardMasterCardItem(
                    onTap: onMenuTap != null ? () => onMenuTap!(3) : null,
                    image: MyImages.totalContacts,
                    amount: "${controller.dashboardData?.contactCount.toString() ?? 0}",
                    type: MyStrings.totalContacts.tr,
                    bgColor: MyColor.totalContactBgColor,
                    gradientColor: MyColor.totalContactBgColor.withValues(alpha: 0.01),
                  ),
                ),
              ],

              if (MyUtils.checkPermission(AppPermission.viewCampaign)) ...[
                if (MyUtils.checkPermission(AppPermission.viewContact)) spaceSide(Dimensions.space16.w),
                Expanded(
                  child: DashBoardMasterCardItem(
                    onTap: onMenuTap != null ? () => onMenuTap!(2) : null,
                    image: MyImages.campaigns,
                    amount:
                        "${(int.tryParse(controller.dashboardData?.activeCampaign.toString() ?? '0') ?? 0) + (int.tryParse(controller.dashboardData?.completedCampaign.toString() ?? '0') ?? 0)}",
                    type: MyStrings.totalCampaigns.tr,
                    bgColor: MyColor.totalCampaignsBgColor,
                    gradientColor: MyColor.totalCampaignsBgColor.withValues(alpha: 0.01),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
