import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/card/custom_app_card.dart';
import 'package:ovowpp/app/components/card/my_custom_scaffold.dart';
import 'package:ovowpp/app/components/divider/custom_divider.dart';
import 'package:ovowpp/app/components/shimmer/permission_shimmer.dart';
import 'package:ovowpp/app/screens/manage_agent/widget/new_role_and_permission_list_tile.dart';
import 'package:ovowpp/core/helper/string_format_helper.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/controller/manage_agent/agent_permission_controller.dart';
import 'package:ovowpp/data/model/manage_agent/agent_list_response_model.dart';
import 'package:ovowpp/data/repo/manage_agent/agent_permission_repo.dart';

import '../../../core/utils/app_permission.dart';
import '../../../data/model/manage_agent/agent_permission_response_model.dart';
import '../../components/advance_switch/custom_switch.dart';
import '../../components/annotated_region/annotated_region_widget.dart';

class AgentPermissionScreen extends StatefulWidget {
  const AgentPermissionScreen({super.key});

  @override
  State<AgentPermissionScreen> createState() => _AgentPermissionScreenState();
}

class _AgentPermissionScreenState extends State<AgentPermissionScreen> {
  @override
  void initState() {
    AgentData agentData = Get.arguments;

    Get.put(AgentPermissionRepo());
    final controller = Get.put(AgentPermissionController(repo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getPermissionData(agent: agentData);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AgentPermissionController>(
      builder: (controller) => AnnotatedRegionWidget(
        statusBarColor: Colors.transparent,
        top: true,
        child: MyCustomScaffold(
          screenBgColor: MyColor.white,
          pageTitle: MyStrings.agentPermission.tr,
          appBarBgColor: MyColor.white,
          actionButton: [
            Visibility(
              visible: controller.isLoading == false,
              child: Padding(
                padding: EdgeInsets.only(right: 15.w),
                child: CustomSwitch(
                  value: controller.selectAll,
                  onChanged: (v) {
                    controller.selectAllItems();
                  },
                ),
              ),
            ),
          ],
          body: controller.isLoading
              ? PaymentMethodShimmer()
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      spaceDown(Dimensions.space10),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.groupNames.length,
                        itemBuilder: (context, groupIndex) {
                          String groupName = controller.groupNames[groupIndex];
                          List<Permission> groupPermissions = controller.groupedPermissions[groupName] ?? [];

                          return CustomAppCard(
                            onPressed: () {
                              controller.toggleGroup(groupIndex);
                            },
                            radius: Dimensions.space10,
                            margin: EdgeInsetsDirectional.symmetric(vertical: Dimensions.space5),
                            padding: EdgeInsets.zero,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.symmetric(
                                    vertical: Dimensions.space12,
                                    horizontal: Dimensions.space12,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        groupName.toTitleCase(),
                                        style: MyTextStyle.heading16W600UseTextColor().copyWith(fontSize: 15.sp),
                                      ),
                                      CustomSwitch(
                                        value: controller.isGroupSwitchOn(groupIndex),
                                        onChanged: (v) {
                                          controller.toggleGroupSwitch(groupIndex);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                controller.expandedGroupIndex == groupIndex ? CustomDivider(thickness: 1) : SizedBox(),
                                controller.expandedGroupIndex == groupIndex
                                    ? CustomAppCard(
                                        padding: EdgeInsetsDirectional.symmetric(horizontal: Dimensions.space12),
                                        radius: 0,
                                        showBorder: false,
                                        child: Column(
                                          children: [
                                            ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: groupPermissions.length,
                                              itemBuilder: (context, i) {
                                                return PermissionTitle(permission: groupPermissions[i]);
                                              },
                                            ),
                                            spaceDown(Dimensions.space20),
                                          ],
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          );
                        },
                      ),
                      spaceDown(Dimensions.space100),
                    ],
                  ),
                ),
          isCenterFloating: true,
          floatingActionButton: Visibility(
            visible: MyUtils.checkPermission(AppPermission.assignPermission),
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: Dimensions.space15.w, vertical: 15),
              child: CustomElevatedBtn(
                isLoading: controller.submitLoading,
                text: MyStrings.savePermission.tr,
                onTap: () {
                  controller.updatePermission();
                },
                height: Dimensions.space56.h,
                radius: Dimensions.largeRadius,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
