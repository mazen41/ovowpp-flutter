import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ovowpp/app/components/text-field/field_shadow.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import '../../../components/text/default_text.dart';

class PersonalInformationItem extends StatelessWidget {
  final String? title, value;
  final bool isRequired;
  const PersonalInformationItem({super.key, this.title, this.value, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.space20.w, vertical: Dimensions.space10.h),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: MyColor.dashboardCardBorder),
        borderRadius: BorderRadius.circular(Dimensions.space12.r),
        color: MyColor.campaignFieldFillColor,
        boxShadow: [fieldShadow],
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          DefaultText(
            text: "$title${isRequired ? ' *' : ''}",
            textStyle: MyTextStyle.subHeading14W600FieldTitleColor(),
          ),
          DefaultText(text: value ?? '', textStyle: MyTextStyle.heading16W600()),
        ],
      ),
    );
  }
}
