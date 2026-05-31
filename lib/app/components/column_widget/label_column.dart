import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/text_style.dart';

import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';
import '../text/default_text.dart';

class LabelColumn extends StatelessWidget {
  final String header;
  final String body;
  final bool alignmentEnd;
  final bool lastTextRed;
  final bool isSmallFont;

  const LabelColumn({
    super.key,
    this.isSmallFont = false,
    this.lastTextRed = false,
    this.alignmentEnd = false,
    required this.header,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignmentEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        DefaultText(
          text: header.tr,
          textStyle: MyTextStyle.heading14W600().copyWith(
            fontSize: isSmallFont ? Dimensions.fontSmall : Dimensions.fontDefault,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        DefaultText(
          text: body.tr,
          textStyle: lastTextRed
              ? MyTextStyle.subHeading12W400().copyWith(
                  fontSize: isSmallFont ? Dimensions.fontSmall : Dimensions.fontDefault,
                  color: MyColor.getErrorColor(),
                )
              : MyTextStyle.subHeading12W400().copyWith(
                  fontSize: isSmallFont ? Dimensions.fontSmall : Dimensions.fontDefault,
                ),
        ),
      ],
    );
  }
}
