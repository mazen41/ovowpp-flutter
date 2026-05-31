import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/route/route.dart' show RouteHelper;
import '../../../../core/utils/app_permission.dart';
import '../../../../core/utils/util_exporter.dart';
import '../../../../data/controller/all_contacts/all_contact_controller.dart';
import '../../../components/image/my_asset_widget.dart';
import '../../../components/text-field/label_text_field.dart';
import '../../dashboard/widget/round_icon_with_bg_color.dart';
import '../../dashboard/widget/user_profile_banner.dart';

class ContactScreenSliverAppBar extends StatefulWidget {
  final bool isBackButton;
  final bool isUpload;
  const ContactScreenSliverAppBar({super.key, this.isBackButton = false, this.isUpload = false});

  @override
  State<ContactScreenSliverAppBar> createState() => _ContactScreenSliverAppBarState();
}

class _ContactScreenSliverAppBarState extends State<ContactScreenSliverAppBar> {
  Timer? _debounceTimer;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllContactController>(
      builder: (controller) {
        return Column(
          children: [
            spaceDown(Dimensions.space20.h),
            UserProfileBanner(
              isBackButton: widget.isBackButton,
              title: MyStrings.contacts.tr,
              subTitle: MyStrings.reachOutStayConnected.tr,
              isUpload: widget.isUpload,
              trailingWidget: (MyUtils.checkPermission(AppPermission.addContact))
                  ? RoundIconWithBgColor(
                      iconColor: MyColor.white,
                      bgColor: MyColor.getPrimaryColor(),
                      icon: MyImages.createNew,
                      isOnTap: true,
                      onTap: () {
                        Get.toNamed(
                          RouteHelper.customerAccountScreen,
                          arguments: [
                            controller.imagePath ?? "", // 0 -> imagePath
                            null, // 1 -> contact
                            false, // 2 -> isUpdate
                            -1, // 3 -> editIndex (int)
                            false, // 4 -> isChatEdit
                          ],
                        )?.then((v) {
                          controller.initData(initPage: true);
                        });
                      },
                    )
                  : const SizedBox.shrink(),
            ),
            spaceDown(Dimensions.space10.h),
            LabelTextField(
              fillColor: MyColor.searchFieldColor,
              labelText: MyStrings.search.tr,
              hideLabel: true,
              hintText: MyStrings.searchNameOfPhoneNumber.tr,
              controller: controller.searchController,
              onChanged: (value) {
                if (_debounceTimer?.isActive ?? false) {
                  _debounceTimer?.cancel();
                }

                _debounceTimer = Timer(const Duration(milliseconds: 500), () {
                  controller.searchQuery = value.trim().toLowerCase();
                  controller.newGetContact(searchQuery: controller.searchQuery, status: controller.status);
                });
              },
              textInputType: TextInputType.emailAddress,
              inputAction: TextInputAction.next,
              radius: Dimensions.largeRadius,
              prefixIcon: Padding(
                padding: EdgeInsets.all(Dimensions.space10),
                child: MyAssetImageWidget(
                  assetPath: MyImages.search,
                  isSvg: true,
                  height: Dimensions.space10.h,
                  width: Dimensions.space10.h,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return MyStrings.fieldErrorMsg.tr;
                } else {
                  return null;
                }
              },
            ),
          ],
        );
      },
    );
  }
}
