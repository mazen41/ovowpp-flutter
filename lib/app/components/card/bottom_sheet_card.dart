import 'package:flutter/material.dart';
import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';
import '../../../core/utils/util.dart';

class BottomSheetCard extends StatelessWidget {
  final Widget child;
  final double bottomSpace;
  final double padding;
  final Color? bgColor;
  final List<BoxShadow>? boxShadow;
  const BottomSheetCard({
    super.key,
    required this.child,
    this.bottomSpace = Dimensions.space7,
    this.padding = Dimensions.space15,
    this.bgColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      margin: EdgeInsets.only(top: bottomSpace),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
        color: bgColor ?? MyColor.white,
        border: Border.all(width: .5, color: MyColor.getPrimaryColor().withValues(alpha: .1)),
        boxShadow: boxShadow ?? MyUtils.getBottomSheetShadow(),
      ),
      child: child,
    );
  }
}
