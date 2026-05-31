import 'package:flutter/material.dart';
import 'package:ovowpp/core/utils/text_style.dart';

import '../../../core/utils/util_exporter.dart';

class CustomElevatedBtn extends StatelessWidget {
  final String text;
  final void Function() onTap;
  final double radius;
  final double elevation;
  final Color bgColor;
  final Color? textColor;
  final Color borderColor;
  final Color shadowColor;
  final Color loaderColor;
  final double width;
  final double height;
  final Widget? icon;
  final bool isLoading;
  final bool isArrowRight;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingButton;

  const CustomElevatedBtn({
    super.key,
    required this.text,
    required this.onTap,
    this.radius = Dimensions.mediumRadius,
    this.elevation = 0,
    this.bgColor = MyColor.lightPrimary,
    this.shadowColor = MyColor.lightPrimary,
    this.width = double.infinity,
    this.height = Dimensions.defaultButtonH,
    this.icon,
    this.isLoading = false,
    this.textColor = MyColor.lightHeadingText,
    this.borderColor = MyColor.lightButtonBorderBorder,
    this.loaderColor = MyColor.black,
    this.isArrowRight = false,
    this.paddingLeft = 0,
    this.paddingRight = 0,
    this.paddingTop = 0,
    this.paddingButton = 0,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return icon != null
        ? ElevatedButton.icon(
            icon: isLoading ? const SizedBox.shrink() : icon ?? const SizedBox.shrink(),
            onPressed: () {
              if (isLoading == false) {
                FocusScope.of(context).unfocus();
                onTap();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor,
              elevation: elevation,
              surfaceTintColor: bgColor.withValues(alpha: 0.5),
              overlayColor: bgColor.withValues(alpha: 0.1), // Set your splash color h
              shadowColor: shadowColor.withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: MyColor.transparent, width: 1),
                borderRadius: BorderRadius.circular(radius),
              ),
              maximumSize: Size.fromHeight(height),
              minimumSize: Size(width, height),
              splashFactory: InkRipple.splashFactory,
            ),
            label: isLoading
                ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: loaderColor))
                : Text(
                    text, //
                    style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
                  ),
          )
        : Padding(
            padding: EdgeInsets.fromLTRB(paddingLeft.w, paddingTop, paddingRight, paddingButton),
            child: ElevatedButton(
              onPressed: () {
                if (isLoading == false) {
                  FocusScope.of(context).unfocus();
                  onTap();
                }
              }, //
              style: ElevatedButton.styleFrom(
                backgroundColor: bgColor, //
                elevation: elevation, //
                shadowColor: shadowColor.withValues(alpha: .5),
                overlayColor: bgColor.withValues(alpha: 0.1), // Set your splash color h
                splashFactory: InkRipple.splashFactory,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: MyColor.transparent, width: 1),
                  borderRadius: BorderRadius.circular(radius),
                ),
                maximumSize: Size.fromHeight(48),
                minimumSize: Size(width, 48),
              ),
              child: isLoading
                  ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: loaderColor))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(text, style: MyTextStyle.heading16W600()),
                        isArrowRight
                            ? Icon(Icons.keyboard_arrow_right, size: 20, color: MyColor.btnArrowColor)
                            : SizedBox.shrink(),
                      ],
                    ),
            ),
          );
  }
}
