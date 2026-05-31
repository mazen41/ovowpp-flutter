import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/divider/custom_divider.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/text_style.dart';

import '../../../core/utils/my_color.dart';
import '../buttons/custom_circle_animated_button.dart';
import '../text/default_text.dart';

class BottomSheetTopRow extends StatelessWidget {
  final String header;
  final double bottomSpace;
  final Color bgColor;

  const BottomSheetTopRow({
    super.key,
    required this.header,
    this.bottomSpace = 10,
    this.bgColor = MyColor.lightBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DefaultText(text: header.tr, textStyle: MyTextStyle.heading14W600()),
            CustomCircleAnimatedButton(
              onTap: () {
                Get.back();
              },
              height: 30,
              width: 30,
              backgroundColor: bgColor,
              child: Icon(Icons.clear, color: MyColor.black, size: 15),
            ),
          ],
        ),
        const CustomDivider(),
      ],
    );
  }
}
