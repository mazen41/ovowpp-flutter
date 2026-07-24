import 'package:flutter/material.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/controller/support/ticket_details_controller.dart';
import 'package:get/get.dart';
import '../widget/ticket_list_item.dart';

class MessageListSection extends StatelessWidget {
  const MessageListSection({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<TicketDetailsController>(
      builder: (controller) => controller.messageList.isEmpty
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.space20, vertical: Dimensions.space20),
              decoration: BoxDecoration(
                color: MyColor.getBodyTextColor().withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    MyStrings.noMSgFound.tr,
                    style: theme.textTheme.labelMedium?.copyWith(color: MyColor.getBorderColor()),
                  ),
                ],
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.messageList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => TicketListItem(
                  index: index,
                  mediabasePath: controller.mediaBasePath,
                  messages: controller.messageList[index],
                ),
              ),
            ),
    );
  }
}
