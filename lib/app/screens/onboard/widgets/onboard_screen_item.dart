import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ovowpp/app/components/text/default_text.dart';
import 'package:ovowpp/data/controller/onboard/onboard_controller.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/utils/util_exporter.dart';

class OnboardScreenItem extends StatelessWidget {
  final OnBoardItemModel item;
  final int index;

  const OnboardScreenItem({super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space18),
      child: Column(
        children: [
          SvgPicture.asset(item.image),
          spaceDown(Dimensions.space24),
          DefaultText(text: item.title, textStyle: MyTextStyle.heading20W700()),
          spaceDown(Dimensions.space12.h),
          DefaultText(text: item.description, textStyle: MyTextStyle.subHeading16W400(), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
