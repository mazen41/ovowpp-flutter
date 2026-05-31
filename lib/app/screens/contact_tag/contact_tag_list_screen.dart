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
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/app/screens/contact_tag/widget/add_or_update_tag.dart';
import 'package:ovowpp/app/screens/dashboard/widget/round_icon_with_bg_color.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/controller/contact_tag/contact_tag_list_controller.dart';
import 'package:ovowpp/data/repo/contact_tag/contact_tag_list_repo.dart';

import '../../../core/utils/app_permission.dart';
import '../../components/annotated_region/annotated_region_widget.dart';
import '../../components/text-field/label_text_field.dart';

class ContactTagListScreen extends StatefulWidget {
  const ContactTagListScreen({super.key});

  @override
  State<ContactTagListScreen> createState() => _ContactTagListScreenState();
}

class _ContactTagListScreenState extends State<ContactTagListScreen> {
  final ScrollController _controller = ScrollController();
  Timer? debounce;

  void fetchData() {
    Get.find<ContactTagListController>().initData();
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      if (Get.find<ContactTagListController>().hasNext()) {
        fetchData();
      }
    }
  }

  @override
  void initState() {
    Get.put(ContactTagListRepo());
    final controller = Get.put(ContactTagListController(repo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.page = 0;
      controller.initData();
      controller.clearActiveNotificationInfo();
      _controller.addListener(_scrollListener);
    });
  }

  Timer? _debounceTimer;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AnnotatedRegionWidget(
      statusBarColor: Colors.transparent,
      top: true,
      child: MyCustomScaffold(
        showAppBarContent: true,
        appBarContent: GetBuilder<ContactTagListController>(
          builder: (controller) => Row(
            children: [
              Expanded(
                child: Text(
                  MyStrings.manageContactTag.tr,
                  style: theme.textTheme.headlineMedium?.copyWith(color: MyColor.getHeadingTextColor()),
                ),
              ),
              spaceSide(Dimensions.space5.w),
              Visibility(
                visible: MyUtils.checkPermission(AppPermission.addContactTag),
                child: RoundIconWithBgColor(
                  bgColor: MyColor.getPrimaryColor(),
                  icon: MyImages.add,
                  iconColor: MyColor.white,
                  isOnTap: true,
                  onTap: () {
                    controller.contactNameController.clear();
                    CustomAlertDialog(
                      verticalPadding: 0,
                      isHorizontalPadding: false,
                      child: AddOrUpdateTagDialogue(isUpdate: false, id: ""),
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
        body: GetBuilder<ContactTagListController>(
          builder: (controller) => RefreshIndicator(
            color: MyColor.getPrimaryColor(),
            backgroundColor: MyColor.getBackgroundColor(),
            onRefresh: () async {
              controller.page = 0;
              await controller.initData(initPage: true);
            },
            child: controller.isLoading
                ? Expanded(child: const AllContactShimmer(isViewContactTagList: true))
                : controller.allContactListdata.isEmpty
                ? const NoDataWidget()
                : Column(
                    children: [
                      LabelTextField(
                        labelText: MyStrings.search.tr,
                        hideLabel: true,
                        hintText: MyStrings.search.tr,
                        controller: controller.searchController,
                        onChanged: (value) {
                          if (_debounceTimer?.isActive ?? false) {
                            _debounceTimer?.cancel();
                          }

                          _debounceTimer = Timer(const Duration(milliseconds: 500), () {
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

                      Expanded(
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
                            final bool isLastIndex = index == controller.allContactListdata.length - 1;
                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: Dimensions.space5.h),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
                                  child: ListTile(
                                    tileColor: MyColor.white,
                                    contentPadding: EdgeInsets.zero,

                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [Text(item.name ?? "", style: MyTextStyle.heading16W600())],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            PopupMenuButton<int>(
                                              itemBuilder: (context) {
                                                if (!MyUtils.checkPermission(AppPermission.editContactTag) &&
                                                    (!MyUtils.checkPermission(AppPermission.deleteContactTag))) {
                                                  CustomSnackBar.error(errorList: [MyStrings.permissionDenyMessage]);
                                                }

                                                return [
                                                  if (MyUtils.checkPermission(AppPermission.editContactTag))
                                                    PopupMenuItem(
                                                      onTap: () {
                                                        controller.contactNameController.text = item.name ?? '';
                                                        CustomAlertDialog(
                                                          verticalPadding: 0,
                                                          isHorizontalPadding: false,
                                                          child: AddOrUpdateTagDialogue(
                                                            isUpdate: true,
                                                            id: item.id.toString(),
                                                          ),
                                                        ).customAlertDialog(context);
                                                      },
                                                      child: Text(MyStrings.edit.tr),
                                                    ),
                                                  if (MyUtils.checkPermission(AppPermission.deleteContactTag))
                                                    PopupMenuItem(
                                                      onTap: () {
                                                        controller.userId = item.id.toString();
                                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                                          CustomAlertDialog(
                                                            verticalPadding: 0,
                                                            isHorizontalPadding: true,
                                                            child: GetBuilder<ContactTagListController>(
                                                              builder: (context) {
                                                                return DeleteDialogue(
                                                                  warningText: MyStrings
                                                                      .areYouSureYouWantToDeleteThisContactTagList
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

                                                      child: Text(MyStrings.delete.tr),
                                                    ),
                                                ];
                                              },
                                              offset: const Offset(0, 30),
                                              color: MyColor.white,
                                              elevation: 1,
                                              //  onSelected: (value) {},
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
