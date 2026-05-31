import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/image/custom_svg_picture.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_images.dart';
import 'package:ovowpp/core/utils/my_strings.dart';

class AlreadyVerifiedWidget extends StatefulWidget {
  final bool isPending;

  const AlreadyVerifiedWidget({super.key, this.isPending = false});

  @override
  State<AlreadyVerifiedWidget> createState() => _AlreadyVerifiedWidgetState();
}

class _AlreadyVerifiedWidgetState extends State<AlreadyVerifiedWidget> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(Dimensions.space20),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: MyUtils.getCardShadow()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomSvgPicture(
            image: widget.isPending ? MyImages.pendingIcon : MyImages.verifiedIcon,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 25),
          Text(
            widget.isPending ? MyStrings.kycUnderReviewMsg.tr : MyStrings.kycAlreadyVerifiedMsg.tr,
            style: theme.textTheme.labelMedium?.copyWith(color: MyColor.black),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
