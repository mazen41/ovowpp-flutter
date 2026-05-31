import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/badges/priority_badge.dart';
import 'package:ovowpp/app/components/badges/status_badge.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/column_widget/card_column.dart';

import '../../../../../core/utils/dimensions.dart';
import '../../../../../core/utils/my_color.dart';
import '../../../../../core/utils/my_strings.dart';

class AllTicketListItem extends StatelessWidget {
  final String ticketNumber;
  final String subject;
  final String status;
  final Color statusColor;
  final String priority;
  final Color priorityColor;
  final String time;

  const AllTicketListItem({
    super.key,
    required this.ticketNumber,
    required this.subject,
    required this.status,
    required this.priority,
    required this.statusColor,
    required this.priorityColor,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space15),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
        border: Border.all(color: MyColor.dashboardCardBorder),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: Dimensions.space10),
                  child: Column(
                    children: [
                      CardColumn(
                        header: "[${MyStrings.ticket.tr}#$ticketNumber]",
                        body: subject.tr,
                        space: 5,
                        headerTextStyle: theme.textTheme.labelMedium?.copyWith(
                          color: MyColor.getBodyTextColor(),
                          fontWeight: FontWeight.w700,
                        ),
                        bodyTextStyle: theme.textTheme.labelMedium?.copyWith(color: MyColor.getHeadingTextColor()),
                      ),
                    ],
                  ),
                ),
              ),
              StatusBadge(text: status, color: statusColor),
            ],
          ),
          const SizedBox(height: Dimensions.space15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PriorityBadge(text: priority, color: priorityColor),
              Text(
                time,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontSize: Dimensions.fontSmall,
                  fontStyle: FontStyle.italic,
                  color: MyColor.getBodyTextColor(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
