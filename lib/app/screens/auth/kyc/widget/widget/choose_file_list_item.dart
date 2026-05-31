import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_strings.dart';

class ChooseFileItem extends StatelessWidget {
  final String fileName;
  const ChooseFileItem({super.key, required this.fileName});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15, vertical: 8),
      decoration: BoxDecoration(
        color: MyColor.getBodyTextColor().withValues(alpha: .08),
        border: Border.all(color: MyColor.getBorderColor(), width: 0.5),
        borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(Dimensions.space5),
            decoration: BoxDecoration(
              color: MyColor.black.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(5),
            ),
            alignment: Alignment.center,
            child: Text(
              MyStrings.chooseFile,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(color: MyColor.getPrimaryColor()),
            ),
          ),
          const SizedBox(width: Dimensions.space15),
          Expanded(
            flex: 5,
            child: Text(fileName.tr, style: theme.textTheme.labelMedium?.copyWith(color: MyColor.black)),
          ),
        ],
      ),
    );
  }
}
