import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/app_permission.dart';
import '../../../../core/route/route.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/utils/util_exporter.dart';
import '../../../../data/controller/campaigns/campaigns_controller.dart';
import '../../../components/image/text_field_prefix_icon.dart';
import '../../../components/text-field/label_text_field.dart';
import '../../dashboard/widget/round_icon_with_bg_color.dart';
import '../../dashboard/widget/user_profile_banner.dart';

class UserBannerAndSearchSlivers extends StatefulWidget {
  const UserBannerAndSearchSlivers({super.key});

  @override
  State<UserBannerAndSearchSlivers> createState() => _UserBannerAndSearchSliversState();
}

class _UserBannerAndSearchSliversState extends State<UserBannerAndSearchSlivers> {
  Timer? _debounce;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CampaignsController>(
      builder: (controller) {
        return Column(
          children: [
            spaceDown(Dimensions.space20.h),
            UserProfileBanner(
              title: MyStrings.campaign,
              subTitle: MyStrings.reachMorePeopleCloseMoreDetails,
              trailingWidget: Visibility(
                visible: MyUtils.checkPermission(AppPermission.addCampaign),
                child: RoundIconWithBgColor(
                  bgColor: MyColor.getPrimaryColor(),
                  iconColor: MyColor.white,
                  icon: MyImages.createNew,
                  isOnTap: true,
                  onTap: () {
                    Get.toNamed(RouteHelper.createCampaignScreen);
                  },
                ),
              ),
            ),
            spaceDown(Dimensions.space10.h),
            LabelTextField(
              controller: controller.searchController,
              hideLabel: true,
              labelText: MyStrings.search.tr,
              hintText: MyStrings.search.tr,
              hintStyle: MyTextStyle.subHeading16W400(),
              onChanged: (value) {
                if (_debounce?.isActive ?? false) {
                  _debounce?.cancel();
                }
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  controller.searchQuery = value.trim().toLowerCase();
                  controller.getCampaignData(searchQuery: controller.searchQuery);
                });
              },
              fillColor: MyColor.searchFieldColor,
              prefixIcon: TextFieldPrefixIcon(imagePath: MyImages.search),
              radius: Dimensions.space12.r,
            ),
            spaceSide(Dimensions.space12.w),
          ],
        );
      },
    );
  }
}
