import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/screens/dashboard/widget/round_icon_with_bg_color.dart';
import 'package:ovowpp/core/utils/app_permission.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/data/controller/dashboard/dashboard_controller.dart';
import '../../../../../core/utils/util_exporter.dart';
import '../../../../components/text/default_text.dart';

class PlanStatusAndCreateNewItem extends StatelessWidget {
  final String imagPath;
  final VoidCallback onTap;
  final String title;
  final Color bgColor;
  final bool isTextWhite;
  final bool isTitleText;
  final String? secondText;
  final Color? roundIconBgColor;
  final String? planStatus;
  final bool isShowStatus;
  const PlanStatusAndCreateNewItem({
    super.key,
    required this.imagPath,
    required this.onTap,
    required this.title,
    required this.bgColor,
    this.isTextWhite = false,
    this.isTitleText = false,
    this.secondText,
    this.roundIconBgColor,
    this.planStatus,
    this.isShowStatus = true,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Expanded(
          child: Material(
            color: bgColor,
            borderRadius: BorderRadius.circular(Dimensions.space16.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(Dimensions.space16.r),
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.r, vertical: Dimensions.space12.h),
                decoration: BoxDecoration(
                  border: Border.all(color: isTextWhite ? Colors.transparent : MyColor.dashboardCardBorder),
                  borderRadius: BorderRadius.circular(Dimensions.space16.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RoundIconWithBgColor(
                      iconColor: MyColor.white,
                      bgColor: roundIconBgColor ?? MyColor.planStatusColor,
                      icon: imagPath,
                    ),
                    spaceSide(Dimensions.space5),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: .center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DefaultText(
                            text: title,
                            textStyle: MyTextStyle.subHeading16W400().copyWith(
                              color: isTextWhite ? MyColor.white : MyColor.planStatusTextColor,
                              fontSize: 14.sp,
                            ),
                          ),
                          spaceDown(Dimensions.space2),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: isTitleText
                                ? DefaultText(
                                    text: secondText ?? "",
                                    textStyle: MyTextStyle.heading20W700().copyWith(
                                      color: MyColor.white,
                                      fontSize: 16.sp,
                                    ),
                                  )
                                : Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.space12.w,
                                      vertical: Dimensions.space4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: MyColor.planStatusColor,
                                      borderRadius: BorderRadius.circular(Dimensions.space50.r),
                                    ),
                                    child: DefaultText(
                                      text: isShowStatus
                                          ? controller.dashboardData?.subscription?.plan?.name.toString() ?? ''
                                          : 'N/A',
                                      textStyle: MyTextStyle.heading20W700().copyWith(
                                        color: MyColor.white,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    (MyUtils.checkPermission(AppPermission.addCampaign) &&
                            (!MyUtils.checkPermission(AppPermission.viewSubscription)))
                        ? Expanded(child: SizedBox())
                        : SizedBox.shrink(),
                    (MyUtils.checkPermission(AppPermission.viewSubscription) &&
                            (!MyUtils.checkPermission(AppPermission.addCampaign)))
                        ? Expanded(child: SizedBox())
                        : SizedBox.shrink(),
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
