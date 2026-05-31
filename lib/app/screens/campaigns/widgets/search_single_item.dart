import 'package:flutter/material.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import '../../../../core/utils/util_exporter.dart';
import '../../../components/text/default_text.dart';

class SearchSingleItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isSelected;
  const SearchSingleItem({super.key, required this.title, required this.onTap, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: Dimensions.space6.w),
      padding: EdgeInsets.only(top: Dimensions.space6.w, bottom: Dimensions.space6.w),
      width: double.infinity,

      decoration: BoxDecoration(
        color: isSelected ? MyColor.selectedSearchItemBgColor : MyColor.searchItemBgColor,
        borderRadius: BorderRadius.circular(Dimensions.space50.r),
      ),
      child: Center(
        //
        child: DefaultText(
          text: title,
          textStyle: MyTextStyle.subHeading14W600().copyWith(
            color: isSelected ? MyColor.selectedSearchItemTextColor : MyColor.lightBodyText,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
