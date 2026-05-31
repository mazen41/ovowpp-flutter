import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/alert-dialog/custom_alert_dialog.dart';
import 'package:ovowpp/app/components/alert-dialog/delete_dialogue.dart';
import 'package:ovowpp/app/components/card/my_custom_scaffold.dart';
import 'package:ovowpp/app/components/divider/line.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/app/components/no_data.dart';
import 'package:ovowpp/app/components/shimmer/all_contact_shimmer.dart';
import 'package:ovowpp/app/components/text-field/label_text_field.dart';
import 'package:ovowpp/app/screens/all_contact_list/widgets/add_or_update_contact_dialogue.dart';
import 'package:ovowpp/app/screens/dashboard/widget/round_icon_with_bg_color.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/app_permission.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/controller/all_contact_list/all_contact_list_controller.dart';
import 'package:ovowpp/data/repo/all_contact_list/all_contact_list_repo.dart';

import '../../../core/utils/text_style.dart';
import '../../components/annotated_region/annotated_region_widget.dart' show AnnotatedRegionWidget;
import '../../components/snack_bar/show_custom_snackbar.dart';

class AllContactListScreen extends StatefulWidget {
  const AllContactListScreen({super.key});

  @override
  State<AllContactListScreen> createState() => _AllContactListScreenState();
}

class _AllContactListScreenState extends State<AllContactListScreen> {
  final ScrollController _controller = ScrollController();
  Timer? _debounce;

  void fetchData() {
    Get.find<AllContactListController>().initData();
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      if (Get.find<AllContactListController>().hasNext()) {
        fetchData();
      }
    }
  }

  @override
  void initState() {
    Get.put(AllContactListRepo());
    final controller = Get.put(AllContactListController(repo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.page = 0;
      controller.initData();
      controller.clearActiveNotificationInfo();
      _controller.addListener(_scrollListener);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegionWidget(
      statusBarColor: Colors.transparent,
      top: true,
      child: MyCustomScaffold(
        screenBgColor: MyColor.white,
        appBarBgColor: MyColor.white,
        showAppBarContent: true,

        appBarContent: GetBuilder<AllContactListController>(
          builder: (controller) => Row(
            children: [
              Expanded(child: Text(MyStrings.manageContactList.tr, style: MyTextStyle.heading20W700())),
              spaceSide(Dimensions.space5.w),
              Visibility(
                visible: MyUtils.checkPermission(AppPermission.addContactList),
                child: RoundIconWithBgColor(
                  bgColor: MyColor.getPrimaryColor(),
                  icon: MyImages.add,
                  iconColor: MyColor.white,
                  isOnTap: true,
                  onTap: () {
                    CustomAlertDialog(
                      verticalPadding: 0,
                      isHorizontalPadding: false,
                      child: AddOrUpdateDialogue(id: ""),
                    ).customAlertDialog(context);
                  },
                ),
              ),
              spaceSide(Dimensions.space15),
            ],
          ),
        ),
        transformValue: 1,
        pageTitle: MyStrings.allContacts.tr,
        body: GetBuilder<AllContactListController>(
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
                  controller: controller.searchController,
                  labelText: MyStrings.search.tr,
                  hideLabel: true,
                  hintText: MyStrings.search.tr,
                  onChanged: (value) {
                    if (_debounce?.isActive ?? false) {
                      _debounce?.cancel();
                    }

                    _debounce = Timer(const Duration(milliseconds: 500), () {
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
                spaceDown(Dimensions.space10),
                controller.isLoading
                    ? Expanded(child: const AllContactShimmer(isContactList: true))
                    : controller.allContactListdata.isEmpty
                    ? NoDataWidget(text: MyStrings.noContactListFound.tr)
                    : Expanded(
                        child: ListView.builder(
                          controller: _controller,
                          itemCount: controller.allContactListdata.length + 1,

                          itemBuilder: (context, index) {
                            final bool isLastIndex = index == controller.allContactListdata.length - 1;
                            if (controller.allContactListdata.length == index) {
                              return controller.hasNext()
                                  ? Center(child: CircularProgressIndicator(color: MyColor.getPrimaryColor()))
                                  : const SizedBox();
                            }
                            var item = controller.allContactListdata[index];
                            return Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                    top: Dimensions.space5.h,
                                    bottom: Dimensions.space5.h,
                                    right: 5,
                                  ),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: Dimensions.space10.w),
                                    tileColor: MyColor.white,
                                    splashColor: MyColor.dashboardCardBorder,
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(item.name ?? "", style: MyTextStyle.heading16W600()),
                                              spaceDown(Dimensions.space4.h),
                                              Text(
                                                "${item.contact?.length ?? ""} ${MyStrings.contacts}",
                                                style: MyTextStyle.subHeading15W500FieldTitleColor.copyWith(
                                                  fontSize: 13.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            PopupMenuButton<int>(
                                              itemBuilder: (context) {
                                                if (!MyUtils.checkPermission(AppPermission.editContactList) &&
                                                    !MyUtils.checkPermission(AppPermission.deleteContactList) &&
                                                    !MyUtils.checkPermission(AppPermission.viewListContact)) {
                                                  CustomSnackBar.error(errorList: [MyStrings.permissionDenyMessage]);
                                                }
                                                return [
                                                  if (MyUtils.checkPermission(AppPermission.editContactList))
                                                    PopupMenuItem(
                                                      onTap: () {
                                                        controller.contactNameController.text = item.name ?? '';
                                                        CustomAlertDialog(
                                                          verticalPadding: 0,
                                                          isHorizontalPadding: false,
                                                          child: AddOrUpdateDialogue(
                                                            isUpdate: true,
                                                            id: item.id.toString(),
                                                          ),
                                                        ).customAlertDialog(context);
                                                      },
                                                      child: Text(
                                                        MyStrings.edit.tr,
                                                        style: MyTextStyle.heading16W600(),
                                                      ),
                                                    ),
                                                  if (MyUtils.checkPermission(AppPermission.deleteContactList))
                                                    PopupMenuItem(
                                                      onTap: () {
                                                        controller.userId = item.id.toString();
                                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                                          CustomAlertDialog(
                                                            verticalPadding: 0,
                                                            isHorizontalPadding: true,
                                                            child: GetBuilder<AllContactListController>(
                                                              builder: (context) {
                                                                return DeleteDialogue(
                                                                  warningText: MyStrings
                                                                      .areYouSureYouWantToDeleteThisContactList
                                                                      .tr,
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

                                                      child: Text(
                                                        MyStrings.delete.tr,
                                                        style: MyTextStyle.heading16W600(),
                                                      ),
                                                    ),
                                                  if (MyUtils.checkPermission(AppPermission.viewListContact))
                                                    PopupMenuItem(
                                                      onTap: () {
                                                        Get.toNamed(
                                                          RouteHelper.viewContactListScreen,
                                                          arguments: [item.id, item.name],
                                                        )?.then((_) {
                                                          controller.initData(initPage: true);
                                                        });
                                                      },
                                                      child: Text(
                                                        MyStrings.viewContactList.tr,
                                                        style: MyTextStyle.heading16W600(),
                                                      ),
                                                    ),
                                                ];
                                              },
                                              offset: const Offset(0, 30),
                                              color: MyColor.white,
                                              elevation: 1,
                                              onSelected: (value) {},
                                              child: Icon(Icons.more_vert),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                isLastIndex ? SizedBox.shrink() : Line(),
                              ],
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
