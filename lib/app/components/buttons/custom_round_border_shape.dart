import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';

class RoundedBorderContainer extends StatelessWidget {
  const RoundedBorderContainer({
    super.key,
    required this.text,
    this.borderColor = MyColor.black,
    this.bgColor = MyColor.black,
    this.horizontalPadding = 12,
    this.verticalPadding = 5,
    this.textColor = MyColor.black,
  });

  final Color bgColor, textColor, borderColor;
  final double horizontalPadding, verticalPadding;
  final String text;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Text(
        text.tr,
        style: theme.textTheme.titleSmall?.copyWith(color: textColor, fontSize: Dimensions.fontSmall),
      ),
    );
  }
}
