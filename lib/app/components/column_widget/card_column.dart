import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../core/utils/dimensions.dart';

import '../../../core/utils/my_color.dart';

import '../../../core/utils/text_style.dart';

class CardColumn extends StatelessWidget {
  final String header;
  final String body;
  final bool alignmentEnd;
  final bool alignmentCenter;
  final bool isDate;
  final Color? textColor;
  final String? subBody;
  final TextStyle? headerTextStyle;
  final TextStyle? bodyTextStyle;
  final TextStyle? subBodyTextStyle;
  final bool isOnlyHeader;
  final bool? isOnlyBody;
  final int bodyMaxLine;
  final double? space;

  const CardColumn({
    super.key,
    this.bodyMaxLine = 1,
    this.alignmentEnd = false,
    this.alignmentCenter = false,
    required this.header,
    this.isDate = false,
    this.textColor,
    this.headerTextStyle,
    this.bodyTextStyle,
    required this.body,
    this.subBody,
    this.isOnlyHeader = false,
    this.isOnlyBody = false,
    this.space = 5,
    this.subBodyTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: alignmentCenter
          ? CrossAxisAlignment.center
          : alignmentEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          header.tr,
          style: alignmentEnd
              ? MyTextStyle.subHeading15W500FieldTitleColor.copyWith(fontSize: 13.sp)
              : MyTextStyle.subHeading16W400().copyWith(color: MyColor.ovoTextColor, fontSize: 16.sp),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: space),
        isOnlyHeader
            ? const SizedBox.shrink()
            : Text(
                body.tr,
                maxLines: bodyMaxLine,
                style: MyTextStyle.subHeading15W500FieldTitleColor.copyWith(fontSize: 10.sp),

                overflow: TextOverflow.ellipsis,
              ),
        SizedBox(height: space),
        subBody != null
            ? Text(
                subBody!.tr,
                maxLines: bodyMaxLine,
                style: isDate
                    ? theme.textTheme.labelMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: textColor ?? MyColor.getBodyTextColor(),
                        fontSize: Dimensions.fontSmall,
                      )
                    : subBodyTextStyle ??
                          theme.textTheme.bodySmall?.copyWith(
                            color: textColor ?? MyColor.getBodyTextColor().withValues(alpha: 0.5),
                            fontWeight: FontWeight.w500,
                          ),
                overflow: TextOverflow.ellipsis,
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
