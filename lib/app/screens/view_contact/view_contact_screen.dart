import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/alert-dialog/custom_alert_dialog.dart';
import 'package:ovowpp/app/components/alert-dialog/delete_dialogue.dart';
import 'package:ovowpp/app/components/avatar/alphabet_avatar.dart';
import 'package:ovowpp/app/components/card/my_custom_scaffold.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/app/components/no_data.dart';
import 'package:ovowpp/app/components/shimmer/all_contact_shimmer.dart';
import 'package:ovowpp/app/components/text-field/label_text_field.dart';
import 'package:ovowpp/app/screens/dashboard/widget/round_icon_with_bg_color.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/controller/view_contact/view_contact_controller.dart';
import 'package:ovowpp/data/repo/view_contact/view_contact_repo.dart';

import '../../../core/utils/app_permission.dart';
import '../../../core/utils/text_style.dart';
import '../../components/annotated_region/annotated_region_widget.dart';

class ViewContactScreen extends StatefulWidget {
  const ViewContactScreen({super.key});

  @override
  State<ViewContactScreen> createState() => _ViewContactScreenState();
}

class _ViewContactScreenState extends State<ViewContactScreen> {
  final ScrollController _controller = ScrollController();
  Timer? debounce;

  void fetchData() {
    Get.find<ViewContactController>().initData();
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      if (Get.find<ViewContactController>().hasNext()) {
        fetchData();
      }
    }
  }

  @override
  void initState() {
    Get.put(ViewContactRepo());
    final controller = Get.put(ViewContactController(repo: Get.find()));

    super.initState();
    controller.id = Get.arguments[0];
    controller.name = Get.arguments[1];
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.page = 0;
      controller.initData();
      controller.clearActiveNotificationInfo();
      _controller.addListener(_scrollListener);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ViewContactController>(
      builder: (controller) => AnnotatedRegionWidget(
        statusBarColor: Colors.transparent,
        top: true,
        child: MyCustomScaffold(
          showAppBarContent: true,
          appBarContent: GetBuilder<ViewContactController>(
            builder: (controller) => Row(
              children: [
                Expanded(
                  child: Text(
                    "${controller.name}-${MyStrings.viewContactList.tr}",
                    style: MyTextStyle.heading20W700().copyWith(color: MyColor.appBarTitleColor),
                  ),
                ),
                spaceSide(Dimensions.space5.w),
                Visibility(
                  visible: MyUtils.checkPermission(AppPermission.addContactToList),
                  child: RoundIconWithBgColor(
                    bgColor: MyColor.getPrimaryColor(),
                    icon: MyImages.add,
                    iconColor: MyColor.white,
                    isOnTap: true,
                    onTap: () {
                      Get.toNamed(RouteHelper.addNewContactGroupListScreen, arguments: [controller.id])?.then((_) {
                        controller.initData(initPage: true);
                      });
                    },
                  ),
                ),
                spaceSide(Dimensions.space15),
              ],
            ),
          ),
          transformValue: 1,
          pageTitle: MyStrings.allContacts.tr,
          body: GetBuilder<ViewContactController>(
            builder: (controller) => RefreshIndicator(
              color: MyColor.getPrimaryColor(),
              backgroundColor: MyColor.getBackgroundColor(),
              onRefresh: () async {
                controller.page = 0;
                await controller.initData(initPage: true);
              },
              child: Column(
                children: [
                  LabelTextField(
                    labelText: MyStrings.search.tr,
                    hideLabel: true,
                    hintText: MyStrings.search.tr,
                    onChanged: (value) {
                      debounce = Timer(const Duration(milliseconds: 800), () {
                        controller.searchQuery = value.trim().toLowerCase();
                        controller.initData(initPage: true);
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
                  spaceDown(Dimensions.space10.h),
                  controller.isLoading
                      ? Expanded(child: const AllContactShimmer(isViewContactList: true))
                      : controller.allContactListdata.isEmpty
                      ? Expanded(child: NoDataWidget(text: MyStrings.noContactListFound.tr))
                      : Expanded(
                          child: ListView.builder(
                            controller: _controller,
                            itemCount: controller.allContactListdata.length + 1,
                            itemBuilder: (context, index) {
                              if (controller.allContactListdata.length == index) {
                                return controller.hasNext()
                                    ? Center(child: CircularProgressIndicator(color: MyColor.getPrimaryColor()))
                                    : const SizedBox();
                              }
                              var item = controller.allContactListdata[index];
                              return Container(
                                padding: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: MyColor.getCardBackgroundColor(),
                                ),
                                child: ListTile(
                                  leading: item.contact?.image != null
                                      ? CircleAvatar(
                                          maxRadius: 25,
                                          backgroundImage: NetworkImage(
                                            "${UrlContainer.domainUrl}/${controller.imagePath.toString()}/${item.contact?.image}",
                                          ),
                                        )
                                      : AlphabetAvatar(
                                          firstname: item.contact?.firstname ?? "",
                                          lastName: item.contact?.lastname ?? '',
                                        ),
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${item.contact?.firstname ?? ""}${item.contact?.lastname ?? ""}",
                                              style: MyTextStyle.subHeading16W400().copyWith(
                                                color: MyColor.ovoTextColor,
                                              ),
                                            ),
                                            spaceDown(Dimensions.space4.h),
                                            Text(
                                              "+${item.contact?.mobileCode ?? ""}${item.contact?.mobile ?? ""}",
                                              style: MyTextStyle.subHeading14W600FieldTitleColor().copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          spaceSide(Dimensions.space10),
                                          Visibility(
                                            visible: MyUtils.checkPermission(AppPermission.removeContactFromList),
                                            child: InkWell(
                                              onTap: () {
                                                controller.userId = item.id.toString();
                                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                                  return CustomAlertDialog(
                                                    verticalPadding: 0,
                                                    isHorizontalPadding: true,
                                                    child: GetBuilder<ViewContactController>(
                                                      builder: (controller) {
                                                        return DeleteDialogue(
                                                          warningText:
                                                              MyStrings.areYouSureYouWantToDeleteThisContact.tr,
                                                          isLoading: controller.isDeleting,
                                                          onTap: () {
                                                            controller.deleteMessage(index);
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ).customAlertDialog(context);
                                                });
                                              },
                                              child: MyAssetImageWidget(
                                                assetPath: MyImages.delete,
                                                isSvg: true,
                                                height: Dimensions.space20.h,
                                                width: Dimensions.space20.h,
                                                color: MyColor.getErrorColor(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
