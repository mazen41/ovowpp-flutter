import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';

class BottomSheetCloseButton extends StatelessWidget {
  final Color? iconColor;
  final double size;
  final Color? bgColor;
  const BottomSheetCloseButton({super.key, this.iconColor, this.size = 30, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: size.h,
        width: size.w,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(Dimensions.space5),
        decoration: BoxDecoration(
          color: bgColor ?? MyColor.getWarningColor().withValues(alpha: .1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.clear, color: iconColor ?? MyColor.getWarningColor(), size: 15),
      ),
    );
  }
}
