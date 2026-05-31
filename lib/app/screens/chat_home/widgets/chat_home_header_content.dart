import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/shimmer/my_shimmer_widget.dart';
import 'package:ovowpp/app/components/text/default_text.dart';
import 'package:ovowpp/core/utils/app_permission.dart';
import '../../../../core/route/route.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/utils/util_exporter.dart';
import '../../../../data/controller/home/home_controller.dart';
import '../../../components/image/my_asset_widget.dart';
import '../../../components/text-field/label_text_field.dart';
import '../../dashboard/widget/round_icon_with_bg_color.dart';

class HeaderContent extends StatelessWidget {
  final HomeController controller;

  const HeaderContent(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    final double availableHeight = settings?.currentExtent ?? 0;
    Timer? debounce;

    return SizedBox(
      height: availableHeight.h,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            spaceDown(Dimensions.space18.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultText(
                      text: MyStrings.whatsappNumber.tr,
                      textStyle: MyTextStyle.heading20W700().copyWith(fontWeight: FontWeight.w600),
                    ),
                    controller.isHomeDataLoading
                        ? MyShimmerWidget(
                            child: Container(
                              height: Dimensions.space22,
                              width: Dimensions.space100.w,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(Dimensions.space12.r),
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            child: PopupMenuButton(
                              menuPadding: EdgeInsets.only(left: Dimensions.space4.w, right: Dimensions.space4.w),
                              itemBuilder: (context) => controller.whatsappNumbers
                                  .map(
                                    (e) => PopupMenuItem(
                                      height: Dimensions.space35.h,
                                      padding: EdgeInsets.zero,
                                      value: e,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          DefaultText(
                                            text: e.phoneNumber.toString(),
                                            textStyle: MyTextStyle.subHeading12W600().copyWith(
                                              color: e.isDefault.toString() == "1"
                                                  ? MyColor.getPrimaryColor()
                                                  : MyColor.getBodyTextColor(),
                                            ),
                                          ),

                                          e.isDefault.toString() == "1"
                                              ? Icon(
                                                  Icons.check_circle,
                                                  size: Dimensions.space15.sp,
                                                  color: e.isDefault.toString() == "1"
                                                      ? MyColor.getPrimaryColor()
                                                      : MyColor.getBodyTextColor(),
                                                )
                                              : Icon(
                                                  Icons.circle_outlined,
                                                  size: Dimensions.space15.sp,
                                                  color: MyColor.getBodyTextColor(),
                                                ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                              offset: const Offset(0, 30),
                              color: MyColor.white,
                              elevation: 1,
                              onOpened: () {
                                controller.changeStatus();
                              },
                              onSelected: (value) {
                                controller.webId = value.id.toString();
                                controller.selectedNumber = value.phoneNumber.toString();
                                controller.switchNumber();
                              },
                              onCanceled: () {
                                controller.changeStatus();
                              },
                              child: Row(
                                children: [
                                  DefaultText(
                                    text: controller.selectedNumber.toString(),
                                    textStyle: MyTextStyle.subHeading12W600().copyWith(
                                      color: MyColor.getHeadingTextColor(),
                                    ),
                                  ),
                                  RotatedBox(
                                    quarterTurns: controller.numShowed ? 10 : 0,
                                    child: MyAssetImageWidget(
                                      boxFit: BoxFit.scaleDown,
                                      assetPath: MyImages.arrowDown,
                                      height: Dimensions.space20.h,
                                      width: Dimensions.space20.h,
                                      isSvg: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
                Visibility(
                  visible: MyUtils.checkPermission(AppPermission.addContact),
                  child: RoundIconWithBgColor(
                    isOnTap: true,
                    onTap: () {
                      Get.toNamed(
                        RouteHelper.customerAccountScreen,
                        arguments: [controller.imagePath, null, false, -1, false],
                      );
                    },
                    bgColor: MyColor.getPrimaryColor(),
                    icon: MyImages.add,
                    iconColor: MyColor.white,
                  ),
                ),
              ],
            ),
            spaceDown(Dimensions.space8.h),
            LabelTextField(
              controller: controller.searchController,
              labelText: MyStrings.search.tr,
              hideLabel: true,
              hintText: MyStrings.searchNameOfPhoneNumber.tr,
              onChanged: (value) {
                if (debounce?.isActive ?? false) {
                  debounce?.cancel();
                }
                debounce = Timer(const Duration(milliseconds: 500), () {
                  controller.searchQuery = value.trim().toLowerCase();
                  controller.newChatMethod(searchQuery: controller.searchQuery, status: controller.status);
                });
              },
              textInputType: TextInputType.emailAddress,
              inputAction: TextInputAction.next,
              radius: Dimensions.largeRadius,
              fillColor: MyColor.searchFieldColor,
              prefixIcon: Padding(
                padding: EdgeInsets.all(Dimensions.space10),
                child: MyAssetImageWidget(
                  assetPath: MyImages.search,
                  isSvg: true,
                  height: Dimensions.space10.h,
                  width: Dimensions.space10.h,
                ),
              ),
            ),
            spaceDown(Dimensions.space12.h),
          ],
        ),
      ),
    );
  }
}
