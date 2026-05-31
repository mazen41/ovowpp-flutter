import 'package:flutter/material.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/util.dart';

class LoadingIndicator extends StatelessWidget {
  final double strokeWidth;
  final double size;

  const LoadingIndicator({super.key, this.strokeWidth = 1, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(shape: BoxShape.circle, color: MyColor.white, boxShadow: MyUtils.getCardShadow()),
      child: CircularProgressIndicator(color: MyColor.getPrimaryColor(), strokeWidth: 3),
    );
  }
}
