import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'my_color.dart';

class MyTextStyle {
  /// === Font ===
  /// Heading - Archivo
  /// Description - Nunito

  static TextStyle heading16W600({String fontFamily = 'Archivo'}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: MyColor.regularHederColor,
    );
  }

  // static TextStyle heading16W500({String fontFamily = 'Archivo'}) {
  //   return TextStyle(
  //       fontFamily: fontFamily,
  //       fontSize: 16.sp,
  //       fontWeight: FontWeight.w500,
  //       color: MyColor.regularHederColor
  //   );
  // }

  static TextStyle heading16W600UseTextColor({String fontFamily = 'Archivo'}) {
    return TextStyle(fontFamily: fontFamily, fontSize: 16.sp, fontWeight: FontWeight.w600, color: MyColor.usdTextColor);
  }

  static TextStyle heading16W500UseTextColor({String fontFamily = 'Archivo'}) {
    return TextStyle(fontFamily: fontFamily, fontSize: 16.sp, fontWeight: FontWeight.w500, color: MyColor.usdTextColor);
  }

  static TextStyle heading14W600({String fontFamily = 'Archivo'}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: MyColor.regularHederColor,
    );
  }

  static TextStyle heading12W600({String fontFamily = 'Archivo'}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      color: MyColor.regularHederColor,
    );
  }

  static TextStyle heading16W400({String fontFamily = 'Archivo'}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: MyColor.regularHederColor,
    );
  }

  static TextStyle heading15W600({String fontFamily = 'Archivo'}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 15.sp,
      fontWeight: FontWeight.w600,
      color: MyColor.regularHederColor,
    );
  }

  static TextStyle heading15W500({String fontFamily = 'Archivo'}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 15.sp,
      fontWeight: FontWeight.w500,
      color: MyColor.regularHederColor,
    );
  }

  static TextStyle heading20W700({String fontFamily = 'Archivo'}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
      color: MyColor.regularHederColor,
    );
  }

  static TextStyle subHeading16W400({String fontFamily = 'Nunito', bool isUnderline = false}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: MyColor.splashTextColor,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
  }

  static TextStyle subHeading15W500({String fontFamily = 'Nunito', bool isUnderline = false}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: MyColor.splashTextColor,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
  }

  static TextStyle subHeading15W400({String fontFamily = 'Nunito', bool isUnderline = false}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 15.sp,
      fontWeight: FontWeight.w400,
      color: MyColor.splashTextColor,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
  }

  static TextStyle subHeading14W400({String fontFamily = 'Nunito', bool isUnderline = false}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: MyColor.splashTextColor,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
  }

  static TextStyle subHeading14W500({String fontFamily = 'Nunito', bool isUnderline = false}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: MyColor.splashTextColor,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
  }

  static TextStyle subHeading14W600({String fontFamily = 'Nunito', bool isUnderline = false}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: MyColor.splashTextColor,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
  }

  static TextStyle subHeading12W600({String fontFamily = 'Nunito', bool isUnderline = false}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      color: MyColor.splashTextColor,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
  }

  static TextStyle subHeading12W400({String fontFamily = 'Nunito'}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: MyColor.fieldTitleTextColor,
    );
  }

  static TextStyle subHeading15W500FieldTitleColor = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
    color: MyColor.fieldTitleTextColor,
  );

  static TextStyle subHeading14W600FieldTitleColor({String fontFamily = 'Nunito'}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: MyColor.fieldTitleTextColor,
    );
  }

  static TextStyle sectionSubTitle1 = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 13.sp, // Size in pixels
    fontWeight: FontWeight.w400, // Bold
    height: 18 / 13.sp, // Line height ratio
    letterSpacing: -0.078, // Letter spacing
    // color: MyColor.getHeaderTextColor(), // Hex color for --Heading-Text
    fontFamilyFallback: ['Nunito'],
  );

  static TextStyle sectionBodyTextStyle = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
    height: 20 / 15.sp,
    letterSpacing: -0.24,
  );
}
