import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ovowpp/app/components/text/default_text.dart';
import 'package:ovowpp/app/screens/withdraw/widget/status_widget.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/text_style.dart';

import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';
import '../divider/custom_divider.dart';

class CustomRow extends StatelessWidget {
  final String firstText, lastText;
  final bool isStatus, isAbout, showDivider;
  final Color? statusTextColor;
  final bool hasChild;
  final Widget? child;

  const CustomRow({
    super.key,
    this.child,
    this.hasChild = false,
    this.statusTextColor,
    required this.firstText,
    required this.lastText,
    this.isStatus = false,
    this.isAbout = false,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return hasChild
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: DefaultText(text: firstText.tr, textStyle: MyTextStyle.heading16W600(), maxLines: 1),
                  ),
                  child ?? const SizedBox(),
                ],
              ),
              const SizedBox(height: 5),
              showDivider ? Divider(color: MyColor.getBorderColor()) : const SizedBox(),
              showDivider ? const SizedBox(height: 5) : const SizedBox(),
            ],
          )
        : isAbout
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultText(text: firstText.tr, textStyle: MyTextStyle.heading16W600()),

              spaceDown(Dimensions.space4.h),
              DefaultText(text: lastText.tr, textStyle: MyTextStyle.subHeading12W600()),
              const SizedBox(height: 5),
            ],
          )
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: DefaultText(text: firstText.tr, textStyle: MyTextStyle.heading16W600()),
                  ),
                  isStatus
                      ? StatusWidget(status: lastText, color: MyColor.getBodyTextColor())
                      : Flexible(
                          child: DefaultText(
                            text: lastText.tr,
                            maxLines: 2,
                            textStyle: MyTextStyle.subHeading12W600(),
                            textAlign: TextAlign.end,
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 5),
              showDivider ? const CustomDivider() : const SizedBox(),
              showDivider ? const SizedBox(height: 5) : const SizedBox(),
            ],
          );
  }
}
