import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/data/controller/dashboard/dashboard_controller.dart';

import '../../../../../../core/route/route.dart';
import '../../../../../../core/utils/dimensions.dart';
import '../../../../../../core/utils/my_color.dart';
import '../../../../../../core/translations/strings_enum.dart';

class KYCWarningSection extends StatelessWidget {
  final DashboardController controller;
  const KYCWarningSection({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return controller.isKycVerified == "1" || controller.isLoading
        ? const SizedBox.shrink()
        : Container(
            padding: const EdgeInsetsDirectional.only(top: Dimensions.space15, bottom: Dimensions.space10),
            child: InkWell(
              onTap: () {
                Get.toNamed(RouteHelper.kycScreen);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
                  color: MyColor.pendingColor.withValues(alpha: .1),
                  border: Border.all(color: MyColor.pendingColor, width: .5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.isKycVerified == '2') ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Strings.kycVerificationPending.tr,
                            style: theme.textTheme.headlineSmall?.copyWith(color: MyColor.pendingColor, fontSize: 17),
                          ),
                          const SizedBox(height: Dimensions.space15),
                          Text(
                            Strings.kycVerificationPendingMSg.tr,
                            style: theme.textTheme.bodyMedium?.copyWith(color: MyColor.getBodyTextColor()),
                          ),
                        ],
                      ),
                    ] else ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Strings.kycVerificationRequired.tr,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: MyColor.getErrorColor(),
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: Dimensions.space15),
                          Text(
                            Strings.kycVerificationMsg.tr,
                            style: theme.textTheme.bodyMedium?.copyWith(color: MyColor.getBodyTextColor()),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
  }
}
