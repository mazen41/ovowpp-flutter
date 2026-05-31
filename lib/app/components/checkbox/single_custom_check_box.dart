import 'package:flutter/material.dart';
import '../../../core/utils/text_style.dart';
import '../../../core/utils/util_exporter.dart';

class SingleCustomCheckbox extends StatelessWidget {
  final bool value;
  final VoidCallback onChanged;
  final bool isRememberMeTextShow;
  final String checkText;
  final TextStyle? textStyle;

  const SingleCustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.isRememberMeTextShow = false,
    this.checkText = MyStrings.rememberMe,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          radius: Dimensions.space8,

          onTap: () {
            onChanged();
          },
          child: Container(
            padding: EdgeInsets.all(2.r),
            height: 22.h,
            width: 22.h,
            decoration: BoxDecoration(
              color: value ? MyColor.fieldTitleTextColor : null,
              border: Border.all(color: value ? MyColor.fieldTitleTextColor : MyColor.getBorderColor()),
              borderRadius: BorderRadius.circular(Dimensions.space4.r),
            ),
            child: value
                ? FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(Icons.check_rounded, color: MyColor.white),
                  )
                : null,
          ),
        ),
        spaceSide(Dimensions.space8.w),

        isRememberMeTextShow
            ? Text(
                checkText,
                style:
                    textStyle ??
                    MyTextStyle.subHeading14W400().copyWith(color: MyColor.regularHederColor, fontSize: 14.sp),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
