import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/helper/string_format_helper.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/data/controller/manage_agent/agent_permission_controller.dart';

import '../../../../data/model/manage_agent/agent_permission_response_model.dart';

class PermissionTitle extends StatelessWidget {
  final Permission permission;

  const PermissionTitle({super.key, required this.permission});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return GetBuilder<AgentPermissionController>(
      builder: (controller) {
        bool isActive = controller.activePermissionIds.contains(permission.id);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  permission.name?.toTitleCase() ?? "",
                  style: MyTextStyle.subHeading14W600FieldTitleColor(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              Checkbox(
                value: isActive,
                onChanged: (v) {
                  controller.addPermissionCheckbox(permission.id.toString());
                },
                activeColor: theme.primaryColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
