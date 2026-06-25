import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'my_color.dart';
import '../translations/strings_enum.dart';

class TicketHelper {
  static Color getStatusColor(String status) {
    late Color statusColor;
    statusColor = status == '1'
        ? MyColor.getInformationColor()
        : status == '2'
        ? MyColor.getWarningColor()
        : status == '3'
        ? MyColor.getErrorColor()
        : MyColor.getSuccessColor();

    return statusColor;
  }

  static Color getPriorityColor(String priority) {
    late Color priorityColor;

    priorityColor = priority == '1'
        ? MyColor.getInformationColor()
        : priority == '2'
        ? MyColor.getWarningColor()
        : priority == '3'
        ? MyColor.getErrorColor()
        : MyColor.getSuccessColor();

    return priorityColor;
  }

  static String getPriorityText(String priority) {
    String priorityText = '';
    priorityText = priority == '1'
        ? Strings.low.tr
        : priority == '2'
        ? Strings.medium.tr
        : priority == '3'
        ? Strings.high.tr
        : '';
    return priorityText;
  }

  static String getStatusText(String status) {
    String statusText = '';
    statusText = status == '0'
        ? Strings.open.tr
        : status == '1'
        ? Strings.answered.tr
        : status == '2'
        ? Strings.replied.tr
        : status == '3'
        ? Strings.closed.tr
        : '';
    return statusText;
  }
}
