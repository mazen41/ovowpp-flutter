import 'package:flutter/material.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';

class CustomAppCard extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color backgroundColor;
  final Color borderColor;
  final double radius;
  final VoidCallback? onPressed;
  final Widget child;
  final BoxBorder? boxBorder;
  final bool showBorder;

  const CustomAppCard({
    super.key,
    this.width,
    this.height,
    this.backgroundColor = MyColor.white,
    this.borderColor = MyColor.lightBorder,
    this.radius = Dimensions.cardExtraRadius,
    this.onPressed,
    required this.child,
    this.padding,
    this.margin,
    this.boxBorder,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding ?? EdgeInsets.all(16.w),
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(radius),
          border: showBorder ? Border.all(color: borderColor, width: 1) : null,
        ),
        child: child,
      ),
    );
  }
}
