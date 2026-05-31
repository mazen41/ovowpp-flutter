import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/utils/my_color.dart';

class BottomSheetColumn extends StatelessWidget {
  final bool isCharge;
  final String header;
  final String body;
  final bool alignmentEnd;

  const BottomSheetColumn({
    super.key,
    this.isCharge = false,
    this.alignmentEnd = false,
    required this.header,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: alignmentEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          header.tr,
          style: theme.textTheme.labelMedium?.copyWith(color: MyColor.getBodyTextColor(), fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 5),
        Text(
          body.tr,
          style: isCharge
              ? theme.textTheme.labelMedium?.copyWith(color: MyColor.getErrorColor())
              : theme.textTheme.labelMedium,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
