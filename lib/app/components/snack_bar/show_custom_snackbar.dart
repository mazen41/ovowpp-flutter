import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/helper/string_format_helper.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:toastification/toastification.dart';

class CustomSnackBar {
  static void error({required List<String> errorList, int duration = 5}) {
    String message = '';
    if (errorList.isEmpty) {
      message = MyStrings.somethingWentWrong.tr;
    } else {
      for (var element in errorList) {
        String tempMessage = element.tr;
        message = message.isEmpty ? tempMessage : "$message\n$tempMessage";
      }
    }
    message = AppConverter.removeQuotationAndSpecialCharacterFromString(message);
    toastification.show(
      context: Get.context,
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      title: Text(message, maxLines: 10, style: Get.theme.textTheme.bodyMedium?.copyWith(color: MyColor.white)),
      // description: Text("Component updates available."),
      alignment: Alignment.topCenter,
      foregroundColor: MyColor.white,
      primaryColor: MyColor.getErrorColor(),
      // backgroundColor: MyColor.redCancelTextColor.withValues(alpha:0.6),
      showProgressBar: false,
      autoCloseDuration: Duration(seconds: duration),
      borderRadius: BorderRadius.circular(12.0),
      applyBlurEffect: false,
    );
  }

  static void success({required List<String> successList, int duration = 5}) {
    String message = '';
    if (successList.isEmpty) {
      message = MyStrings.somethingWentWrong.tr;
    } else {
      for (var element in successList) {
        String tempMessage = element.tr;
        message = message.isEmpty ? tempMessage : "$message\n$tempMessage";
      }
    }
    message = AppConverter.removeQuotationAndSpecialCharacterFromString(message);
    toastification.show(
      context: Get.context,
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      title: Text(message, maxLines: 10, style: Get.theme.textTheme.bodyMedium?.copyWith(color: MyColor.white)),
      // description: Text("Component updates available."),
      alignment: Alignment.topCenter,
      foregroundColor: MyColor.white,
      primaryColor: MyColor.getSuccessColor(),
      // backgroundColor: MyColor.redCancelTextColor.withValues(alpha:0.6),
      showProgressBar: false,
      autoCloseDuration: Duration(seconds: duration),
      borderRadius: BorderRadius.circular(12.0),
      applyBlurEffect: false,
    );
  }
}
