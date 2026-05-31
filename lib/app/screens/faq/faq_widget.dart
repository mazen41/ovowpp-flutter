import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/animated_widget/expanded_widget.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/text/default_text.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';

class FaqListItem extends StatelessWidget {
  final String question;
  final String answer;
  final int index;
  final int selectedIndex;
  final VoidCallback press;

  const FaqListItem({
    super.key,
    required this.answer,
    required this.question,
    required this.index,
    required this.press,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15, vertical: Dimensions.space15),
        decoration: BoxDecoration(
          color: MyColor.searchFieldColor,
          border: Border.all(color: MyColor.dashboardCardBorder),
          borderRadius: BorderRadius.circular(Dimensions.space8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: DefaultText(
                    text: question.tr,
                    textStyle: MyTextStyle.heading20W700().copyWith(fontSize: 16.sp),
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: Icon(
                    index == selectedIndex ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: MyColor.btnArrowColor,
                    size: 20,
                  ),
                ),
              ],
            ),
            ExpandedSection(
              expand: index == selectedIndex,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Dimensions.space10),
                  DefaultText(text: answer.tr, textStyle: MyTextStyle.subHeading15W500FieldTitleColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
