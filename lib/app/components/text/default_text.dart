import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/text_style.dart';

class DefaultText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final int maxLines;
  final Color? textColor;
  final double fontSize;
  final bool isOnTap;
  final TextOverflow? textOverFlow;
  final VoidCallback? onTap;
  const DefaultText({
    super.key,
    required this.text,
    this.textAlign,
    this.textStyle,
    this.maxLines = 3,
    this.textColor,
    this.fontSize = Dimensions.fontDefault,
    this.isOnTap = false,
    this.onTap,
    this.textOverFlow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    return isOnTap ? GestureDetector(onTap: onTap, child: customText()) : customText();
  }

  Text customText() {
    return Text(
      text.tr,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      style: textStyle ?? MyTextStyle.subHeading16W400().copyWith(overflow: textOverFlow, color: textColor),
      maxLines: maxLines,
    );
  }
}
