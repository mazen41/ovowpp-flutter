import 'package:flutter/material.dart';
import 'package:ovowpp/data/controller/campaigns/campaigns_controller.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/utils/util_exporter.dart';
import '../../../components/advance_switch/custom_switch.dart';
import '../../../components/text/default_text.dart';

class SwitchWithLeadText extends StatelessWidget {
  final CampaignsController controller;
  final VoidCallback switchTap;
  final String title, description;
  final bool isBorder;
  final bool value;
  const SwitchWithLeadText({
    super.key,
    required this.controller,
    required this.switchTap,
    required this.title,
    required this.description,
    this.isBorder = false,
    this.value = false,
  });

  @override
  Widget build(BuildContext context) {
    return isBorder
        ? Container(
            padding: EdgeInsets.all(Dimensions.space17.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.space16.r),
              color: MyColor.white,
              border: Border.all(color: MyColor.dashboardCardBorder),
            ),
            child: switchWithLeadText(),
          )
        : switchWithLeadText();
  }

  Row switchWithLeadText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultText(
              text: title,
              textStyle: MyTextStyle.subHeading12W400().copyWith(fontSize: 14.sp, color: MyColor.usdTextColor),
            ),
            DefaultText(
              text: description,
              textStyle: MyTextStyle.subHeading12W400().copyWith(fontSize: 14.sp),
            ),
          ],
        ),
        CustomSwitch(
          value: value,
          onChanged: (bool value) {
            switchTap();
          },
        ),
      ],
    );
  }
}
