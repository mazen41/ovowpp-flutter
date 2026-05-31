import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/my_color.dart';

class BottomSheetLabelText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;

  const BottomSheetLabelText({super.key, required this.text, this.textAlign});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Text(
      text.tr,
      textAlign: textAlign,
      style: theme.textTheme.bodySmall?.copyWith(color: MyColor.getBodyTextColor(), fontWeight: FontWeight.w500),
    );
  }
}
