import 'package:flutter/material.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';

class CustomAlertDialog {
  bool isHorizontalPadding;
  final double verticalPadding;
  final Widget child;

  CustomAlertDialog({this.isHorizontalPadding = false, this.verticalPadding = 15, required this.child});

  void customAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.space40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            padding: isHorizontalPadding
                ? const EdgeInsets.symmetric(horizontal: Dimensions.space8, vertical: Dimensions.space12)
                : EdgeInsets.symmetric(vertical: verticalPadding),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: MyColor.white, borderRadius: BorderRadius.circular(8)),
            child: child,
          ),
        ),
      ),
    );
  }
}
