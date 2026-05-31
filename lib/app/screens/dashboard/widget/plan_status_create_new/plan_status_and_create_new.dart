import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:ovowpp/app/screens/dashboard/widget/plan_status_create_new/plan_status_and_create_new_item.dart';
import '../../../../../core/utils/app_permission.dart';
import '../../../../../core/utils/util_exporter.dart';

class PlanStatusAndCreateNew extends StatelessWidget {
  final VoidCallback planStatusTap;
  final VoidCallback createNewTap;
  final bool isShowStatus;
  final String parentId;
  const PlanStatusAndCreateNew({
    super.key,
    required this.planStatusTap,
    required this.createNewTap,
    this.isShowStatus = true,
    required this.parentId,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: .center,
        children: [
          Visibility(
            visible: MyUtils.checkPermission(AppPermission.viewSubscription),
            child: PlanStatusAndCreateNewItem(
              title: MyStrings.planStatus.tr,
              imagPath: MyImages.planStatus,
              bgColor: MyColor.white,
              onTap: () {
                if (parentId == "0") {
                  planStatusTap();
                }
              },
              isShowStatus: isShowStatus,
            ),
          ),

          if (MyUtils.checkPermission(AppPermission.addCampaign)) ...[
            MyUtils.checkPermission(AppPermission.viewSubscription)
                ? spaceSide(Dimensions.space16.w)
                : SizedBox.shrink(),
            PlanStatusAndCreateNewItem(
              title: MyStrings.createNew.tr,
              imagPath: MyImages.createNew,
              roundIconBgColor: MyColor.white.withAlpha(55),
              bgColor: MyColor.getPrimaryColor(),
              isTextWhite: true,
              isTitleText: true,
              secondText: MyStrings.campaign,
              onTap: () {
                createNewTap();
              },
            ),
          ],
        ],
      ),
    );
  }
}
