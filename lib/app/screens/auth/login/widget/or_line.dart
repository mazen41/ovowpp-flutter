import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../../../../core/utils/dimensions.dart';
import '../../../../../core/utils/my_color.dart';
import '../../../../../core/utils/my_strings.dart';
import '../../../../../core/utils/text_style.dart';

class OrLine extends StatelessWidget {
  const OrLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(width: double.infinity, height: 2, color: MyColor.orLineColor),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space7),
          child: Text(
            MyStrings.or.toLowerCase().tr,
            style: MyTextStyle.subHeading16W400().copyWith(color: MyColor.regularHederColor),
          ),
        ),
        Expanded(
          child: Container(width: double.infinity, height: 2, color: MyColor.orLineColor),
        ),
      ],
    );
  }
}
