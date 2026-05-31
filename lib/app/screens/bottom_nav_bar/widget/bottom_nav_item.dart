import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/text/default_text.dart';
import 'package:ovowpp/core/utils/text_style.dart';

import '../../../../core/utils/util_exporter.dart';
import '../../../components/image/custom_svg_picture.dart';

class BottomNavItem extends StatelessWidget {
  final String selectedIcon;
  final String unSelectedIcon;
  final String title;
  final double iconSize;
  final bool isSelected;
  final VoidCallback onTap;

  const BottomNavItem({
    super.key,
    required this.selectedIcon,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.iconSize = 24,
    required this.unSelectedIcon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          spaceDown(12),
          Stack(
            children: [CustomSvgPicture(image: isSelected ? selectedIcon : unSelectedIcon, height: 25.h, width: 25.w)],
          ),
          DefaultText(text: title, textStyle: MyTextStyle.subHeading12W600()),
          spaceDown(14),
        ],
      ),
    );
  }
}
