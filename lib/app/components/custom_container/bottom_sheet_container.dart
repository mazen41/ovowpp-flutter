import 'package:flutter/material.dart';
import '../../../core/utils/my_color.dart';

class BottomSheetContainer extends StatelessWidget {
  final Widget child;
  final bool showBorder;

  const BottomSheetContainer({super.key, required this.child, this.showBorder = false});

  @override
  Widget build(BuildContext context) {
    return showBorder
        ? Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: MyColor.white,
              border: Border.all(color: MyColor.getBorderColor()),
            ),
            child: child,
          )
        : Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: MyColor.white,
              border: Border.all(color: MyColor.getTransparentColor()),
            ),
            child: child,
          );
  }
}
