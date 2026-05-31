import 'package:flutter/material.dart';
import 'package:ovowpp/core/utils/dimensions.dart';

class CustomDivider extends StatelessWidget {
  final double space;
  final double? thickness;
  final double? height;
  final Color? color;

  const CustomDivider({super.key, this.space = Dimensions.space20, this.color, this.thickness, this.height});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: space),
        Divider(
          color: color?.withValues(alpha: 0.2) ?? theme.dividerColor,
          height: height ?? 0.5,
          thickness: thickness ?? 0.5,
        ),
        SizedBox(height: space),
      ],
    );
  }
}
