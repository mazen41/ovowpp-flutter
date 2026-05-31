import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '../../../../../core/utils/text_style.dart';
import '../../../../../core/utils/util_exporter.dart';

class PrivacyPolicyTermsOfServices extends StatelessWidget {
  final VoidCallback privacyPolicyTap;
  final VoidCallback termsOfServiceTap;

  const PrivacyPolicyTermsOfServices({super.key, required this.privacyPolicyTap, required this.termsOfServiceTap});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: ' '),
          TextSpan(
            text: MyStrings.privacyAndPolicy.tr,
            style: MyTextStyle.subHeading16W400(
              fontFamily: 'Nunito',
              isUnderline: true,
            ).copyWith(color: MyColor.regularHederColor, fontSize: 14.sp),
            recognizer: TapGestureRecognizer()..onTap = privacyPolicyTap,
          ),
          TextSpan(
            text: ' , ',
            style: TextStyle(color: MyColor.regularHederColor, fontSize: 14.sp),
          ),
          TextSpan(
            text: MyStrings.termsOfService.tr,
            style: MyTextStyle.subHeading16W400(
              fontFamily: 'Nunito',
              isUnderline: true,
            ).copyWith(color: MyColor.regularHederColor, fontSize: 14.sp),
            recognizer: TapGestureRecognizer()..onTap = termsOfServiceTap,
          ),
        ],
      ),
    );
  }
}
