import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/model/authorization/authorization_response_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/model/manage_agent/agent_list_response_model.dart';
import 'package:ovowpp/data/repo/manage_agent/agent_permission_repo.dart';
import '../../model/manage_agent/agent_permission_response_model.dart';
import '../../model/profile/profile_response_model.dart';

class AgentPermissionController extends GetxController {
  AgentPermissionRepo repo;
  ProfileResponseModel model = ProfileResponseModel();

  AgentPermissionController({required this.repo});

  TextEditingController methodNameController = TextEditingController();

  List<Permission> permissions = [];

  bool isLoading = false;

  String searchQuery = '';

  Map<String, List<Permission>> groupedPermissions = {};
  List<String> groupNames = [];

  List<String> activePermissionIds = [];
  List<String> newlyAddedPermissionIds = [];

  AgentData? agentData;

  void getPermissionData({AgentData? agent}) async {
    agentData = agent;

    permissions = [];
    groupedPermissions.clear();
    groupNames.clear();
    activePermissionIds.clear();
    isLoading = true;
    update();

    ResponseModel responseModel = await repo.getPermissionData(agentData?.id.toString() ?? "-1");

    if (responseModel.statusCode == 200) {
      AgentPermissionResponseModel model = AgentPermissionResponseModel.fromJson(responseModel.responseJson);

      if (model.status.toString() == MyStrings.success.toLowerCase()) {
        permissions.addAll(model.data?.permissions ?? []);

        activePermissionIds = model.data?.existingPermissions?.map((e) => e.id ?? "").toList() ?? [];

        for (var permission in permissions) {
          if (permission.groupName != null) {
            groupedPermissions.putIfAbsent(permission.groupName!, () => []);
            groupedPermissions[permission.groupName!]!.add(permission);
          }
        }

        groupNames = groupedPermissions.keys.toList();

        for (var i = 0; i < groupNames.length; i++) {
          if (isGroupSwitchOn(i) == false) {
            selectAll = false;
            break;
          }
        }

        isLoading = false;
        update();
      } else {
        CustomSnackBar.error(errorList: model.message ?? [MyStrings.requestFail.tr]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isLoading = false;
    update();
  }

  int expandedGroupIndex = 0;

  void toggleGroup(int index) {
    if (expandedGroupIndex == index) {
      expandedGroupIndex = -1;
    } else {
      expandedGroupIndex = index;
    }
    update();
  }

  bool selectAll = true;
  void selectAllItems() {
    selectAll = !selectAll;
    toggleAllGroupsSelection(selectAll);
    update();
  }

  Map<int, bool> groupSwitchStates = {};

  bool isGroupSwitchOn(int groupIndex) {
    String groupName = groupNames[groupIndex];
    List<Permission> groupPermissions = groupedPermissions[groupName] ?? [];

    bool isOn =
        groupPermissions.isNotEmpty &&
        groupPermissions.every((permission) => activePermissionIds.contains(permission.id ?? ""));

    groupSwitchStates[groupIndex] = isOn;

    return isOn;
  }

  void toggleGroupSwitch(int groupIndex) {
    bool newState = !(groupSwitchStates[groupIndex] ?? false);

    groupSwitchStates[groupIndex] = newState;
    update();

    toggleGroupPermissions(groupIndex, newState);
  }

  void toggleGroupPermissions(int groupIndex, bool value) {
    String groupName = groupNames[groupIndex];
    List<Permission> groupPermissions = groupedPermissions[groupName] ?? [];

    if (value) {
      for (var permission in groupPermissions) {
        if (!activePermissionIds.contains(permission.id ?? "")) {
          activePermissionIds.add(permission.id ?? "");
        }
      }
    } else {
      for (var permission in groupPermissions) {
        activePermissionIds.remove(permission.id ?? "");
      }
    }

    groupSwitchStates[groupIndex] = value;

    update();
  }

  void toggleAllGroupsSelection(bool selectAll) {
    for (int i = 0; i < groupNames.length; i++) {
      groupSwitchStates[i] = selectAll;
      toggleGroupPermissions(i, selectAll);
    }

    update();
  }

  void addPermissionCheckbox(String id) {
    if (activePermissionIds.contains(id)) {
      activePermissionIds.remove(id);
    } else {
      activePermissionIds.add(id);
    }
    update();
  }

  bool submitLoading = false;

  void updatePermission() async {
    submitLoading = true;
    update();

    Map<String, dynamic> body = {};
    int i = 0;
    for (var v in activePermissionIds) {
      body.addAll({'permissions[$i]': v});
      i++;
    }

    ResponseModel responseModel = await repo.updatePermission(agentData?.id.toString() ?? "-1", body);

    if (responseModel.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(responseModel.responseJson);

      if (model.status.toString() == MyStrings.success.toString().toLowerCase()) {
        Get.back();
        isLoading = false;
        update();
        CustomSnackBar.success(successList: model.message ?? [MyStrings.success]);
      } else {
        CustomSnackBar.error(errorList: model.message ?? [MyStrings.requestFail.tr]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    submitLoading = false;
    update();
  }
}
