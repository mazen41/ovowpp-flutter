import 'package:flutter/material.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/app/components/badges/status_badge.dart';
import 'package:ovowpp/app/components/column_widget/card_column.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/ticket_helper.dart';
import '../../../../../data/controller/support/ticket_details_controller.dart';

class TicketStatusWidget extends StatelessWidget {
  final TicketDetailsController controller;

  const TicketStatusWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.space15),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.cardColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CardColumn(
                    isOnlyHeader: false,
                    header: "[${MyStrings.ticket.tr}#${controller.model.data?.myTickets?.ticket ?? ''}]",
                    body: controller.model.data?.myTickets?.subject ?? '',
                    bodyMaxLine: 3,
                    space: 7,
                    headerTextStyle: theme.textTheme.titleSmall?.copyWith(color: MyColor.getBodyTextColor()),
                    bodyTextStyle: theme.textTheme.labelMedium?.copyWith(
                      color: MyColor.getBodyTextColor().withValues(alpha: .9),
                    ),
                  ),
                ),
                const SizedBox(width: 25),
                StatusBadge(
                  text: TicketHelper.getStatusText(controller.model.data?.myTickets?.status ?? '0'),
                  color: TicketHelper.getStatusColor(controller.model.data?.myTickets?.status ?? "0"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
