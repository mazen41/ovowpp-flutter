import 'package:flutter/material.dart';
import 'package:ovowpp/core/utils/text_style.dart';

import '../../../core/utils/my_color.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final TextStyle? style;
  final double padding;
  final Color textColor;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onTap,
    this.style,
    this.padding = 0,
    this.textColor = MyColor.lightPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        elevation: 0,
        splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
        // splashFactory: InkRipple.splashFactory,
        // surfaceTintColor: textColor,
        shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
        padding: EdgeInsets.all(padding),
        enableFeedback: false,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
      ),
      onPressed: onTap,
      child: Text(text, maxLines: 2, overflow: TextOverflow.ellipsis, style: style ?? MyTextStyle.subHeading14W600()),
    );
  }
}
