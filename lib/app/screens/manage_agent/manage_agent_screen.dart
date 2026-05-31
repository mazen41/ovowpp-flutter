import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/alert-dialog/delete_dialogue.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/app/components/no_data.dart';
import 'package:ovowpp/app/components/permission_denied_component.dart';
import 'package:ovowpp/app/components/shimmer/all_contact_shimmer.dart';
import 'package:ovowpp/app/screens/dashboard/widget/round_icon_with_bg_color.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/repo/manage_agent/manage_agent_repo.dart';
import '../../../core/utils/app_permission.dart';
import '../../../data/controller/manage_agent/manage_agent_controller.dart';
import '../../components/alert-dialog/custom_alert_dialog.dart';
import '../../components/avatar/alphabet_avatar.dart';
import '../../components/divider/line.dart';
import '../../components/snack_bar/show_custom_snackbar.dart';
import '../../components/text-field/label_text_field.dart';

class ManageAgentScreen extends StatefulWidget {
  const ManageAgentScreen({super.key});

  @override
  State<ManageAgentScreen> createState() => _ManageAgentScreenState();
}

class _ManageAgentScreenState extends State<ManageAgentScreen> {
  final ScrollController _controller = ScrollController();

  void fetchData() {
    Get.find<ManageAgentController>().initData();
  }

  void _scrollListener() {
    if (_controller.position.pixels >= _controller.position.maxScrollExtent) {
      if (Get.find<ManageAgentController>().hasNext()) {
        fetchData();
      }
    }
  }

  @override
  void initState() {
    Get.put(ManageAgentRepo());
    final controller = Get.put(ManageAgentController(repo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.page = 0;
      controller.initData();
      _controller.addListener(_scrollListener);
    });
  }

  Timer? _debounceTimer;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<ManageAgentController>(
      builder: (controller) {
        if (!MyUtils.checkPermission(AppPermission.viewAgent)) {
          return PermissionDeniedComponent();
        }
        return Scaffold(
          backgroundColor: MyColor.white,
          appBar: CustomAppBar(
            title: MyStrings.agentList.tr,

            elevation: 0,
            bgColor: MyColor.white,
            action: [
              Visibility(
                visible: MyUtils.checkPermission(AppPermission.addAgent),
                child: Padding(
                  padding: EdgeInsets.only(right: Dimensions.space16.w),
                  child: RoundIconWithBgColor(
                    bgColor: MyColor.getPrimaryColor(),
                    icon: MyImages.add,
                    iconColor: MyColor.white,
                    isOnTap: true,
                    onTap: () {
                      Get.toNamed(RouteHelper.addNewAgentScreen)?.then((value) {
                        controller.initData(initPage: true);
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            color: MyColor.getPrimaryColor(),
            backgroundColor: MyColor.getBackgroundColor(),
            onRefresh: () async {
              controller.page = 0;
              await controller.initData();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.w, vertical: Dimensions.space5.h),
              child: Column(
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

                  controller.isLoading
                      ? Expanded(child: const AllContactShimmer(isContactList: true))
                      : controller.agentList.isEmpty
                      ? Column(
                          children: [
                            spaceDown(context.height * .2),
                            NoDataWidget(text: MyStrings.noAgentFound.tr),
                          ],
                        )
                      : Expanded(
                          child: ListView.builder(
                            controller: _controller,
                            itemCount: controller.agentList.length + 1,
                            padding: EdgeInsets.only(top: 12),
                            itemBuilder: (context, index) {
                              if (controller.agentList.length == index) {
                                return controller.hasNext()
                                    ? Center(child: CircularProgressIndicator(color: MyColor.getPrimaryColor()))
                                    : const SizedBox();
                              }
                              final bool isLastIndex = index == controller.agentList.length - 1;
                              return buildAgentListCard(controller, index, theme, context, isLastIndex);
                            },
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildAgentListCard(
    ManageAgentController controller,
    int index,
    ThemeData theme,
    BuildContext context,
    bool isLastIndex,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: Dimensions.space5.h, bottom: Dimensions.space5.h),
          margin: const EdgeInsets.only(),
          decoration: BoxDecoration(color: MyColor.white, borderRadius: BorderRadius.circular(4)),
          child: ListTile(
            leading: controller.agentList[index].image != null
                ? CircleAvatar(
                    maxRadius: 23,
                    backgroundImage: NetworkImage(
                      "${UrlContainer.domainUrl}/${controller.imagePath}/${controller.agentList[index].image}",
                    ),
                  )
                : AlphabetAvatar(
                    firstname: controller.agentList[index].firstname?.substring(0, 2).toUpperCase() ?? "",
                    lastName: controller.agentList[index].lastname?.substring(0, 2).toUpperCase() ?? '',
                  ),

            title: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${controller.agentList[index].firstname ?? ""} ${controller.agentList[index].lastname ?? ""}",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: MyColor.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      spaceDown(Dimensions.space4.h),
                      Text(
                        controller.agentList[index].username ?? "",
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: MyColor.darkSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    spaceSide(Dimensions.space20.w),

                    PopupMenuButton<int>(
                      itemBuilder: (context) {
                        if (!MyUtils.checkPermission(AppPermission.editAgent) &&
                            !MyUtils.checkPermission(AppPermission.deleteAgent) &&
                            !MyUtils.checkPermission(AppPermission.viewPermission)) {
                          [
                            CustomSnackBar.error(errorList: [MyStrings.permissionDenyMessage]),
                          ];
                        }

                        return [
                          /// EDIT AGENT PERMISSION
                          if (MyUtils.checkPermission(AppPermission.editAgent))
                            PopupMenuItem(
                              onTap: () {
                                Get.toNamed(RouteHelper.editAgentScreen, arguments: controller.agentList[index])?.then((
                                  value,
                                ) {
                                  controller.initData(initPage: true);
                                });
                              },
                              child: Text(MyStrings.edit.tr),
                            ),

                          /// DELETE AGENT PERMISSION
                          if (MyUtils.checkPermission(AppPermission.deleteAgent))
                            PopupMenuItem(
                              onTap: () {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  CustomAlertDialog(
                                    verticalPadding: 0,
                                    isHorizontalPadding: true,
                                    child: GetBuilder<ManageAgentController>(
                                      builder: (context) {
                                        return DeleteDialogue(
                                          isLoading: controller.isDeleteLoading,
                                          onTap: () {
                                            controller.deleteAgent(index, agent: controller.agentList[index]);
                                          },
                                        );
                                      },
                                    ),
                                  ).customAlertDialog(context);
                                });
                              },

                              child: Text(MyStrings.delete.tr),
                            ),

                          /// PERMISSION
                          if (MyUtils.checkPermission(AppPermission.viewPermission))
                            PopupMenuItem(
                              onTap: () {
                                Get.toNamed(RouteHelper.agentPermissionScreen, arguments: controller.agentList[index]);
                              },
                              child: Text(MyStrings.permission.tr),
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
  }
}
