import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ovowpp/core/utils/my_color.dart';

class Line extends StatelessWidget {
  final double width;
  final double left, right, top, button;
  final Color? lineColor;

  const Line({
    super.key,
    this.width = double.infinity,
    this.lineColor,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.button = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: left.w, right: right.w, top: top.h, bottom: button.h),
      child: Container(width: width, height: 1, color: lineColor ?? MyColor.dashboardCardBorder),
    );
  }
}
